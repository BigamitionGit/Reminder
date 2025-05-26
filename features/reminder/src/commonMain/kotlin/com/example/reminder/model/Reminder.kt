package com.example.reminder.model

import kotlinx.datetime.Instant // Using Instant for dueDate
import kotlinx.serialization.Serializable

@Serializable
data class Reminder(
    val id: String, // Consider KMP UUID library later if needed
    val myListId: String,
    var title: String,
    var dueDate: DueDate? = null,
    var isCompleted: Boolean = false
) {
    // Properties like isToday, isPastDue can be added here or as extension functions
    // if kotlinx-datetime is used for dueDate.
    // For now, keep the model simple.
}

@Serializable
data class DueDate(
    val timestamp: Instant, // Store as Instant (represents a point in time)
    val isYearMonthDayOnly: Boolean // True if only date matters, false if time is also relevant
)
