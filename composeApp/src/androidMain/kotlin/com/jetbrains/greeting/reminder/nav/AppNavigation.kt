package com.jetbrains.greeting.reminder.nav

import androidx.compose.runtime.Composable
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import com.jetbrains.greeting.reminder.ui.ReminderDetailScreen
import com.jetbrains.greeting.reminder.ui.ReminderListScreen
import com.jetbrains.greeting.reminder.ui.ReminderTopScreen
import com.jetbrains.greeting.reminder.viewmodel.ReminderDetailViewModel
import com.jetbrains.greeting.reminder.viewmodel.ReminderListViewModel


@Composable
fun AppNavigation() {
    val navController = rememberNavController()
    NavHost(navController = navController, startDestination = Screen.ReminderTop.route) {
        composable(Screen.ReminderTop.route) {
            ReminderTopScreen(
                // viewModel is hiltViewModel() by default in the screen
                onNavigateToList = { listId, groupTypeString ->
                    navController.navigate(Screen.ReminderList.createRoute(listId, groupTypeString))
                }
            )
        }
        composable(
            route = Screen.ReminderList.route,
            arguments = listOf(
                navArgument(ReminderListViewModel.ARG_LIST_ID) { nullable = true; type = NavType.StringType },
                navArgument(ReminderListViewModel.ARG_GROUP_TYPE) { nullable = true; type = NavType.StringType }
            )
        ) {
            ReminderListScreen(
                // viewModel is hiltViewModel() by default in the screen
                onNavigateBack = { navController.popBackStack() },
                onNavigateToDetail = { listId, reminderId -> // listId is context for new reminder
                    navController.navigate(Screen.ReminderDetail.createRoute(listId, reminderId))
                }
            )
        }
        composable(
            route = Screen.ReminderDetail.route,
            arguments = listOf(
                navArgument(ReminderDetailViewModel.ARG_MY_LIST_ID) { type = NavType.StringType }, // Non-nullable as per Screen.kt
                navArgument(ReminderDetailViewModel.ARG_REMINDER_ID) { nullable = true; type = NavType.StringType }
            )
        ) {
            ReminderDetailScreen(
                // viewModel is hiltViewModel() by default in the screen
                onNavigateBack = { navController.popBackStack() }
            )
        }
    }
}
