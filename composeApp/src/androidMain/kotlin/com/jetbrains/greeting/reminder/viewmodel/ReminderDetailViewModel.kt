package com.jetbrains.greeting.reminder.viewmodel

import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.reminder.model.DueDate
import com.example.reminder.model.Reminder
import com.example.reminder.repository.ReminderRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch
import kotlinx.datetime.*
import java.util.UUID // For generating new reminder IDs
import javax.inject.Inject

data class ReminderDetailScreenState(
    val reminderId: String? = null,
    val myListId: String, // ID of the list this reminder belongs to or will be added to
    val title: String = "",
    val dueDate: DueDate? = null,
    val isCompleted: Boolean = false,
    val isLoading: Boolean = false,
    val isNewReminder: Boolean = true,
    val error: String? = null,
    val navigateBack: Boolean = false // To signal navigation after save/delete
)

@HiltViewModel
class ReminderDetailViewModel @Inject constructor(
    private val reminderRepository: ReminderRepository,
    private val savedStateHandle: SavedStateHandle
) : ViewModel() {

    private val _uiState = MutableStateFlow<ReminderDetailScreenState?>(null) // Null until initialized
    val uiState: StateFlow<ReminderDetailScreenState?> = _uiState.asStateFlow()

    companion object {
        const val ARG_REMINDER_ID = "reminderId" // Optional: for editing
        const val ARG_MY_LIST_ID = "myListId"   // Required: for context, esp. for new reminders
    }

    init {
        viewModelScope.launch {
            val reminderId: String? = savedStateHandle[ARG_REMINDER_ID]
            val myListId: String? = savedStateHandle[ARG_MY_LIST_ID]

            if (myListId == null && reminderId == null) {
                _uiState.value = ReminderDetailScreenState(myListId = "", error = "List ID is required.", navigateBack = true)
                return@launch
            }

            _uiState.value = ReminderDetailScreenState(isLoading = true, myListId = myListId ?: "") // Initial loading state

            if (reminderId != null) {
                reminderRepository.getReminderById(reminderId).collectLatest { reminder ->
                    if (reminder != null) {
                        _uiState.value = ReminderDetailScreenState(
                            reminderId = reminder.id,
                            myListId = reminder.myListId,
                            title = reminder.title,
                            dueDate = reminder.dueDate,
                            isCompleted = reminder.isCompleted,
                            isLoading = false,
                            isNewReminder = false
                        )
                    } else {
                        _uiState.value = _uiState.value?.copy(isLoading = false, error = "Reminder not found", navigateBack = true)
                    }
                }
            } else {
                // New reminder, myListId must be present
                if (myListId == null) {
                     _uiState.value = ReminderDetailScreenState(myListId = "", error = "List ID is required for new reminder.", navigateBack = true)
                     return@launch
                }
                _uiState.value = ReminderDetailScreenState(
                    myListId = myListId,
                    isLoading = false,
                    isNewReminder = true
                )
            }
        }
    }

    fun onTitleChange(newTitle: String) {
        _uiState.value = _uiState.value?.copy(title = newTitle)
    }

    fun onDueDateChange(newDueDate: DueDate?) {
        _uiState.value = _uiState.value?.copy(dueDate = newDueDate)
    }

    fun onCompletionChange(completed: Boolean) {
        _uiState.value = _uiState.value?.copy(isCompleted = completed)
    }

    fun saveReminder() {
        val currentState = _uiState.value ?: return
        if (currentState.title.isBlank()) {
            _uiState.value = currentState.copy(error = "Title cannot be empty.")
            return
        }

        viewModelScope.launch {
            val reminder = Reminder(
                id = currentState.reminderId ?: UUID.randomUUID().toString(),
                myListId = currentState.myListId,
                title = currentState.title,
                dueDate = currentState.dueDate,
                isCompleted = currentState.isCompleted
            )
            if (currentState.isNewReminder) {
                reminderRepository.addReminder(reminder)
            } else {
                reminderRepository.updateReminder(reminder)
            }
            _uiState.value = currentState.copy(navigateBack = true) // Signal navigation
        }
    }

    fun deleteReminder() {
        val currentState = _uiState.value ?: return
        if (!currentState.isNewReminder && currentState.reminderId != null) {
            viewModelScope.launch {
                reminderRepository.deleteReminder(currentState.reminderId)
                _uiState.value = currentState.copy(navigateBack = true) // Signal navigation
            }
        }
    }
    
    fun clearError() {
        _uiState.value = _uiState.value?.copy(error = null)
    }
}
