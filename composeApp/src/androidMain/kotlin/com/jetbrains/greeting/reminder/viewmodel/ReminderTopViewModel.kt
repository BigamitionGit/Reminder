package com.jetbrains.greeting.reminder.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.reminder.model.ReminderGroup // Common model
import com.example.reminder.model.ReminderMyList // Common model
import com.example.reminder.repository.ReminderRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.combine // Now used
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.launch
import javax.inject.Inject

data class ReminderTopScreenState(
    val reminderGroupsWithCounts: List<Pair<ReminderGroup, Int>> = emptyList(),
    val myLists: List<ReminderMyList> = emptyList(),
    val isLoading: Boolean = true
)

@HiltViewModel
class ReminderTopViewModel @Inject constructor(
    private val reminderRepository: ReminderRepository
) : ViewModel() {

    private val _uiState = MutableStateFlow(ReminderTopScreenState())
    val uiState: StateFlow<ReminderTopScreenState> = _uiState.asStateFlow()

    init {
        loadData()
    }

    private fun loadData() {
        viewModelScope.launch { // Changed from .launch to a direct launch
            _uiState.value = _uiState.value.copy(isLoading = true)

            val listsFlow = reminderRepository.getAllMyLists()
            val todayFlow = reminderRepository.getTodayReminders()
            val scheduledFlow = reminderRepository.getScheduledReminders()
            val allIncompleteFlow = reminderRepository.getAllIncompleteReminders()
            val completedFlow = reminderRepository.getCompletedReminders()

            combine(
                listsFlow,
                todayFlow,
                scheduledFlow,
                allIncompleteFlow,
                completedFlow
            ) { lists, today, scheduled, allIncomplete, completed ->
                val groupCounts = listOf(
                    ReminderGroup.TODAY to today.size,
                    ReminderGroup.SCHEDULED to scheduled.size,
                    ReminderGroup.ALL to allIncomplete.size,
                    ReminderGroup.COMPLETED to completed.size
                )
                ReminderTopScreenState(
                    reminderGroupsWithCounts = groupCounts,
                    myLists = lists, // These lists still won't have their reminders populated here
                    isLoading = false
                )
            }.onEach { newState ->
                _uiState.value = newState
            }.launchIn(viewModelScope)
        }
    }
    // Actions like onGroupTapped, onMyListTapped will be added later
}
