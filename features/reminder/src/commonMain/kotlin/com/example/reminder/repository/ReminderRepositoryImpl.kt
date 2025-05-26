package com.example.reminder.repository

import app.cash.sqldelight.coroutines.asFlow
import app.cash.sqldelight.coroutines.mapToList
import app.cash.sqldelight.coroutines.mapToOneOrNull
import com.example.reminder.db.AppDatabase
import com.example.reminder.model.DueDate
import com.example.reminder.model.Reminder
import com.example.reminder.model.ReminderMyList
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.withContext
import kotlinx.datetime.Instant
import kotlinx.datetime.Clock
import kotlinx.datetime.TimeZone
import kotlinx.datetime.toLocalDateTime // For comparing dates if needed
import kotlinx.datetime.todayIn // For getting today's date


class ReminderRepositoryImpl(
    private val database: AppDatabase,
    private val backgroundDispatcher: CoroutineDispatcher = Dispatchers.Default // Or inject an IO dispatcher
) : ReminderRepository {

    private val listQueries = database.reminderListEntityQueries
    private val reminderQueries = database.reminderEntityQueries

    override fun getAllMyLists(): Flow<List<ReminderMyList>> {
        return listQueries.selectAllLists().asFlow().mapToList(backgroundDispatcher)
            .map { entities ->
                // Note: This doesn't load reminders for each list.
                // That would require N+1 queries or a different DB structure/query.
                // For now, lists are loaded without their reminders.
                entities.map { ReminderMyList(id = it.id, name = it.name, icon = it.icon, reminders = emptyList()) }
            }
    }

    override suspend fun addMyList(myList: ReminderMyList) {
        withContext(backgroundDispatcher) {
            listQueries.insertList(id = myList.id, name = myList.name, icon = myList.icon)
        }
    }

    override suspend fun updateMyList(myList: ReminderMyList) {
         withContext(backgroundDispatcher) { // Same as insertList due to "INSERT OR REPLACE"
            listQueries.insertList(id = myList.id, name = myList.name, icon = myList.icon)
        }
    }

    override suspend fun deleteMyList(myListId: String) {
        withContext(backgroundDispatcher) {
            database.transaction {
                // SQLDelight transactions are thread-confined if not using specific transaction coroutine extensions.
                // Ensure backgroundDispatcher is appropriate or use database.executeAsBlocking() for writes if needed.
                listQueries.deleteListById(myListId)
                reminderQueries.deleteRemindersByListId(myListId)
            }
        }
    }

    override fun getRemindersForMyList(myListId: String): Flow<List<Reminder>> {
        return reminderQueries.selectRemindersByListId(myListId).asFlow().mapToList(backgroundDispatcher)
            .map { entities -> entities.map { it.toDomainModel() } }
    }

    override fun getReminderById(reminderId: String): Flow<Reminder?> {
        return reminderQueries.selectReminderById(reminderId).asFlow().mapToOneOrNull(backgroundDispatcher)
            .map { it?.toDomainModel() }
    }

    override suspend fun addReminder(reminder: Reminder) {
        withContext(backgroundDispatcher) {
            reminderQueries.insertReminder(
                id = reminder.id,
                myListId = reminder.myListId,
                title = reminder.title,
                dueDateTimestamp = reminder.dueDate?.timestamp?.epochSeconds,
                dueDateIsYearMonthDayOnly = reminder.dueDate?.isYearMonthDayOnly?.let { if (it) 1L else 0L },
                isCompleted = if (reminder.isCompleted) 1L else 0L
            )
        }
    }

    override suspend fun updateReminder(reminder: Reminder) {
         withContext(backgroundDispatcher) { // Same as insertReminder due to "INSERT OR REPLACE"
            reminderQueries.insertReminder(
                id = reminder.id,
                myListId = reminder.myListId,
                title = reminder.title,
                dueDateTimestamp = reminder.dueDate?.timestamp?.epochSeconds,
                dueDateIsYearMonthDayOnly = reminder.dueDate?.isYearMonthDayOnly?.let { if (it) 1L else 0L },
                isCompleted = if (reminder.isCompleted) 1L else 0L
            )
        }
    }

    override suspend fun deleteReminder(reminderId: String) {
        withContext(backgroundDispatcher) {
            reminderQueries.deleteReminderById(reminderId)
        }
    }

    // Mapper function from SQLDelight generated ReminderEntity to domain Reminder model
    private fun com.example.reminder.db.ReminderEntity.toDomainModel(): Reminder {
        return Reminder(
            id = this.id,
            myListId = this.myListId,
            title = this.title,
            dueDate = this.dueDateTimestamp?.let { ts ->
                DueDate(
                    timestamp = Instant.fromEpochSeconds(ts),
                    isYearMonthDayOnly = this.dueDateIsYearMonthDayOnly == 1L // SQLDelight converts boolean to Long (0 or 1)
                )
            },
            isCompleted = this.isCompleted == 1L // SQLDelight converts boolean to Long (0 or 1)
        )
    }

    override fun getTodayReminders(): Flow<List<Reminder>> {
        return reminderQueries.selectIncompleteRemindersWithDueDate().asFlow().mapToList(backgroundDispatcher)
            .map { entities ->
                val today = Clock.System.todayIn(TimeZone.currentSystemDefault())
                entities.map { it.toDomainModel() }
                    .filter { reminder ->
                        reminder.dueDate?.let {
                            val reminderDate = Instant.fromEpochSeconds(it.timestamp.epochSeconds)
                                .toLocalDateTime(TimeZone.currentSystemDefault()).date
                            reminderDate == today && !reminder.isCompleted
                        } ?: false
                    }
            }
    }

    override fun getScheduledReminders(): Flow<List<Reminder>> { // All future dated, incomplete
        return reminderQueries.selectIncompleteRemindersWithDueDate().asFlow().mapToList(backgroundDispatcher)
            .map { entities ->
                val now = Clock.System.now()
                entities.map { it.toDomainModel() }
                    .filter { reminder ->
                        reminder.dueDate?.timestamp?.let { it > now && !reminder.isCompleted } ?: false
                    }
            }
    }

    override fun getAllIncompleteReminders(): Flow<List<Reminder>> {
        return reminderQueries.selectAllIncompleteReminders().asFlow().mapToList(backgroundDispatcher)
            .map { entities -> entities.map { it.toDomainModel() } }
    }

    override fun getCompletedReminders(): Flow<List<Reminder>> {
        return reminderQueries.selectCompletedReminders().asFlow().mapToList(backgroundDispatcher)
            .map { entities -> entities.map { it.toDomainModel() } }
    }
}
