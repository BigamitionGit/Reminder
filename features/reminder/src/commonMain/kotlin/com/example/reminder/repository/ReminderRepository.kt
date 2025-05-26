package com.example.reminder.repository

import com.example.reminder.model.Reminder
import com.example.reminder.model.ReminderMyList
import kotlinx.coroutines.flow.Flow

interface ReminderRepository {
    fun getAllMyLists(): Flow<List<ReminderMyList>>
    suspend fun addMyList(myList: ReminderMyList)
    suspend fun updateMyList(myList: ReminderMyList) // Name, icon
    suspend fun deleteMyList(myListId: String) // Also deletes its reminders

    fun getRemindersForMyList(myListId: String): Flow<List<Reminder>>
    fun getReminderById(reminderId: String): Flow<Reminder?>
    suspend fun addReminder(reminder: Reminder)
    suspend fun updateReminder(reminder: Reminder) // Title, due date, completion
    suspend fun deleteReminder(reminderId: String)

    // More complex queries for groups can be added later or handled by combining above.
    // For example, getTodayReminders, getScheduledReminders, etc.

    fun getTodayReminders(): Flow<List<Reminder>>
    fun getScheduledReminders(): Flow<List<Reminder>> // Reminders with a due date, not completed
    fun getAllIncompleteReminders(): Flow<List<Reminder>>
    fun getCompletedReminders(): Flow<List<Reminder>>
}
