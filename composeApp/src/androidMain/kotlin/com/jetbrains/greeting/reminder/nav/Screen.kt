package com.jetbrains.greeting.reminder.nav

import com.jetbrains.greeting.reminder.viewmodel.ReminderDetailViewModel
import com.jetbrains.greeting.reminder.viewmodel.ReminderListViewModel

sealed class Screen(val route: String) {
    data object ReminderTop : Screen("reminder_top")
    data object ReminderList : Screen("reminder_list?${ReminderListViewModel.ARG_LIST_ID}={${ReminderListViewModel.ARG_LIST_ID}}&${ReminderListViewModel.ARG_GROUP_TYPE}={${ReminderListViewModel.ARG_GROUP_TYPE}}") {
        fun createRoute(listId: String? = null, groupType: String? = null): String {
            return buildString {
                append("reminder_list")
                var firstArg = true
                if (listId != null) {
                    append("?${ReminderListViewModel.ARG_LIST_ID}=$listId")
                    firstArg = false
                }
                if (groupType != null) {
                    append(if (firstArg) "?" else "&")
                    append("${ReminderListViewModel.ARG_GROUP_TYPE}=$groupType")
                }
            }
        }
    }
    data object ReminderDetail : Screen("reminder_detail?${ReminderDetailViewModel.ARG_MY_LIST_ID}={${ReminderDetailViewModel.ARG_MY_LIST_ID}}&${ReminderDetailViewModel.ARG_REMINDER_ID}={${ReminderDetailViewModel.ARG_REMINDER_ID}}") {
         fun createRoute(myListId: String, reminderId: String? = null): String {
            return buildString {
                append("reminder_detail?${ReminderDetailViewModel.ARG_MY_LIST_ID}=${myListId}")
                reminderId?.let { append("&${ReminderDetailViewModel.ARG_REMINDER_ID}=${it}") }
            }
        }
    }
}
