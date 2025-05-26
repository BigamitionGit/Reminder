package com.jetbrains.greeting.di

import com.example.reminder.model.Reminder
import com.example.reminder.model.ReminderMyList
import com.example.reminder.repository.ReminderRepository
import dagger.Module
import dagger.Provides
import dagger.hilt.components.SingletonComponent
import dagger.hilt.testing.TestInstallIn
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flowOf
import javax.inject.Singleton

// Fake repository for UI tests
@Singleton // Ensure the same instance is provided if injected multiple times
class FakeReminderRepository @Inject constructor() : ReminderRepository { // Added @Inject constructor
    private val myLists = mutableListOf<ReminderMyList>()
    private val reminders = mutableListOf<Reminder>()

    // Simplified implementations for testing ReminderTopScreen
    override fun getAllMyLists(): Flow<List<ReminderMyList>> = flowOf(myLists)
    override suspend fun addMyList(myList: ReminderMyList) { myLists.add(myList) }
    override suspend fun updateMyList(myList: ReminderMyList) { /* no-op */ }
    override suspend fun deleteMyList(myListId: String) { /* no-op */ }
    override fun getRemindersForMyList(myListId: String): Flow<List<Reminder>> = flowOf(reminders.filter { it.myListId == myListId })
    override fun getReminderById(reminderId: String): Flow<Reminder?> = flowOf(reminders.find { it.id == reminderId })
    override suspend fun addReminder(reminder: Reminder) { reminders.add(reminder) }
    override suspend fun updateReminder(reminder: Reminder) { /* no-op */ }
    override suspend fun deleteReminder(reminderId: String) { /* no-op */ }

    // For ReminderTopScreen group counts
    override fun getTodayReminders(): Flow<List<Reminder>> = flowOf(emptyList()) // Populate as needed for specific tests
    override fun getScheduledReminders(): Flow<List<Reminder>> = flowOf(emptyList())
    override fun getAllIncompleteReminders(): Flow<List<Reminder>> = flowOf(reminders.filter { !it.isCompleted })
    override fun getCompletedReminders(): Flow<List<Reminder>> = flowOf(reminders.filter { it.isCompleted })

    fun seedData(lists: List<ReminderMyList>, rems: List<Reminder>) {
        myLists.clear()
        myLists.addAll(lists)
        reminders.clear()
        reminders.addAll(rems)
    }
}

@Module
@TestInstallIn( // This annotation tells Hilt to replace the production module with this one in tests
    components = [SingletonComponent::class],
    replaces = [RepositoryModule::class] // The actual module that provides ReminderRepository
)
object TestRepositoryModule {
    @Provides
    @Singleton
    fun provideReminderRepository(): ReminderRepository {
        return FakeReminderRepository() // Provide the fake repository
    }
}
