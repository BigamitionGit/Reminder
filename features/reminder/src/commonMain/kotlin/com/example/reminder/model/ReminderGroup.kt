package com.example.reminder.model

// Name, icon, color from iOS can be handled in platform-specific UI mapping or
// by adding them here if they are truly common (e.g. icon name as string).
// For now, focus on the group types.
enum class ReminderGroup {
    TODAY,
    SCHEDULED, // Corresponds to hasDate in iOS
    ALL,
    COMPLETED
}

// If you need to associate data like titles or icons directly in common code:
/*
import kotlinx.serialization.Serializable

@Serializable
sealed class ReminderGroup(val groupType: GroupType, val displayName: String) {
    @Serializable
    data object Today : ReminderGroup(GroupType.TODAY, "Today")
    @Serializable
    data object Scheduled : ReminderGroup(GroupType.SCHEDULED, "Scheduled") // hasDate
    @Serializable
    data object All : ReminderGroup(GroupType.ALL, "All")
    @Serializable
    data object Completed : ReminderGroup(GroupType.COMPLETED, "Completed")

    // This allows for more properties if needed, but enum might be simpler
    // if no extra common properties are required beyond the type itself.
    // The iOS version had names/icons/colors defined.
    // Let's use a simpler enum for now and map UI properties in Android UI layer.
}

enum class GroupType {
    TODAY, SCHEDULED, ALL, COMPLETED
}
*/
