package com.jetbrains.greeting.di

import android.content.Context
import app.cash.sqldelight.db.SqlDriver
import com.example.reminder.db.AppDatabase
import com.example.reminder.db.DatabaseDriverFactory
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
object DatabaseModule {

    @Provides
    @Singleton
    fun provideSqlDriver(@ApplicationContext context: Context): SqlDriver {
        return DatabaseDriverFactory(context).createDriver()
    }

    @Provides
    @Singleton
    fun provideAppDatabase(driver: SqlDriver): AppDatabase {
        // TODO: If SQLDelight needs adapters for custom column types (e.g. Instant),
        // they need to be passed to the AppDatabase constructor here.
        // For now, assuming default adapters or types that don't need custom ones (like Long for timestamp).
        // ReminderEntity.sq uses INTEGER for timestamp and boolean, which are fine.
        return AppDatabase(driver)
    }
}
