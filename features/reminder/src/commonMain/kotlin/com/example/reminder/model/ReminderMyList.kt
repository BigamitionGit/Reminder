package com.example.reminder.model

import kotlinx.serialization.Serializable

// This was ReminderMyListsModel in iOS, acting as a container.
// For KMP, we might not need this exact top-level wrapper if storing lists individually
// or as a simple List<ReminderMyList>.
// Let's define ReminderMyList first.

@Serializable
data class ReminderMyList(
    val id: String, // Consider KMP UUID library later
    var name: String,
    var icon: String, // Represent SFSymbol name as String for now
    var reminders: List<Reminder> = emptyList() // Or MutableList
)
