package com.jetbrains.greeting.di

import com.example.reminder.db.AppDatabase
import com.example.reminder.repository.ReminderRepository
import com.example.reminder.repository.ReminderRepositoryImpl
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.Dispatchers
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
object RepositoryModule {

    @Provides
    @Singleton
    fun provideReminderRepository(database: AppDatabase): ReminderRepository {
        return ReminderRepositoryImpl(database = database, backgroundDispatcher = Dispatchers.IO)
    }
}
