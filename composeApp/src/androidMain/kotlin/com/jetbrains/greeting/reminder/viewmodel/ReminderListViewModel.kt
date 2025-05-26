package com.jetbrains.greeting.reminder.viewmodel

import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.reminder.model.Reminder
import com.example.reminder.model.ReminderGroup
import com.example.reminder.repository.ReminderRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch
import javax.inject.Inject

data class ReminderListScreenState(
    val title: String = "",
    val reminders: List<Reminder> = emptyList(),
    val isLoading: Boolean = true,
    val currentListId: String? = null, // To know where to add new reminders
    val currentGroup: ReminderGroup? = null
)

@HiltViewModel
class ReminderListViewModel @Inject constructor(
    private val reminderRepository: ReminderRepository,
    private val savedStateHandle: SavedStateHandle // For navigation arguments
) : ViewModel() {

    private val _uiState = MutableStateFlow(ReminderListScreenState())
    val uiState: StateFlow<ReminderListScreenState> = _uiState.asStateFlow()

    // Argument keys (to be used by Navigation)
    companion object {
        const val ARG_LIST_ID = "listId"
        const val ARG_GROUP_TYPE = "groupType" // String representation of ReminderGroup enum name
    }

    init {
        viewModelScope.launch { // Use launch for initial data loading
            _uiState.value = _uiState.value.copy(isLoading = true)
            val listId: String? = savedStateHandle[ARG_LIST_ID]
            val groupTypeString: String? = savedStateHandle[ARG_GROUP_TYPE]

            val targetFlow: Flow<List<Reminder>>
            var screenTitle = ""

            if (listId != null) {
                _uiState.value = _uiState.value.copy(currentListId = listId)
                // Fetch list details to get its name for the title (optional, could pass name via nav)
                // For now, use a generic title or assume list name is passed.
                // Let's assume we'll get the list from repo to find its name.
                // This is a bit inefficient if we only need the name.
                reminderRepository.getAllMyLists().map { lists -> lists.find { it.id == listId }?.name ?: "List" }
                    .take(1) // take the first emission
                    .collect { name -> screenTitle = name }
                targetFlow = reminderRepository.getRemindersForMyList(listId)
            } else if (groupTypeString != null) {
                val group = ReminderGroup.valueOf(groupTypeString)
                 _uiState.value = _uiState.value.copy(currentGroup = group)
                screenTitle = group.name // Simple name for now
                targetFlow = when (group) {
                    ReminderGroup.TODAY -> reminderRepository.getTodayReminders()
                    ReminderGroup.SCHEDULED -> reminderRepository.getScheduledReminders()
                    ReminderGroup.ALL -> reminderRepository.getAllIncompleteReminders()
                    ReminderGroup.COMPLETED -> reminderRepository.getCompletedReminders()
                }
            } else {
                // No valid argument, emit empty state or error
                _uiState.value = ReminderListScreenState(title = "Error", reminders = emptyList(), isLoading = false)
                return@launch
            }

            targetFlow.onEach { reminders ->
                _uiState.value = _uiState.value.copy(
                    title = screenTitle,
                    reminders = reminders,
                    isLoading = false
                )
            }.launchIn(viewModelScope)
        }
    }

    fun toggleReminderCompletion(reminder: Reminder) {
        viewModelScope.launch {
            val updatedReminder = reminder.copy(isCompleted = !reminder.isCompleted)
            // Optimistically update UI if needed, or rely on flow to refresh
            reminderRepository.updateReminder(updatedReminder)
        }
    }
}
