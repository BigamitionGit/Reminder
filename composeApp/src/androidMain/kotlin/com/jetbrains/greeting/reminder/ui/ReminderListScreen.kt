package com.jetbrains.greeting.reminder.ui

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import com.jetbrains.greeting.Res // Import Res object
import org.jetbrains.compose.resources.stringResource // Import stringResource
import com.jetbrains.greeting.reminder.ui.components.ReminderRow
import com.jetbrains.greeting.reminder.viewmodel.ReminderListViewModel

@Composable
fun ReminderListScreen(
    viewModel: ReminderListViewModel = hiltViewModel(),
    onNavigateBack: () -> Unit,
    onNavigateToDetail: (listIdForNewReminder: String, reminderId: String?) -> Unit
) {
    val uiState by viewModel.uiState.collectAsState()

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(uiState.title) }, // Title is dynamic from ViewModel
                navigationIcon = {
                    IconButton(onClick = onNavigateBack) {
                        Icon(Icons.Filled.ArrowBack, contentDescription = stringResource(Res.string.reminder_detail_back_action))
                    }
                }
            )
        },
        floatingActionButton = {
            if (uiState.currentListId != null) { // Ensure there's a list context for new reminders
                FloatingActionButton(onClick = {
                    uiState.currentListId?.let { listId ->
                        onNavigateToDetail(listId, null)
                    }
                }) {
                    Icon(Icons.Filled.Add, contentDescription = stringResource(Res.string.reminder_list_add_fab_description))
                }
            } else if (uiState.currentGroup == null) {
                // Allow adding to "All" if it's not a specific group like "Completed" or "Scheduled"
                // This part is tricky as "All" doesn't have a default list ID.
                // For now, let's only allow adding if currentListId is not null.
                // A more sophisticated solution might involve a default list or prompting the user.
            }
        }
    ) { paddingValues ->
        if (uiState.isLoading) {
            Box(modifier = Modifier.fillMaxSize().padding(paddingValues), contentAlignment = Alignment.Center) {
                CircularProgressIndicator()
            }
        } else if (uiState.reminders.isEmpty()) {
            Box(modifier = Modifier.fillMaxSize().padding(paddingValues), contentAlignment = Alignment.Center) {
                Text(stringResource(Res.string.reminder_list_screen_no_reminders))
            }
        } else {
            LazyColumn(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(paddingValues)
                    .padding(top = 8.dp, bottom = 8.dp) // Add some padding around the list itself
            ) {
                items(uiState.reminders, key = { it.id }) { reminder ->
                    ReminderRow(
                        reminder = reminder,
                        onReminderClick = { onNavigateToDetail(reminder.myListId, reminder.id) },
                        onToggleComplete = { viewModel.toggleReminderCompletion(it) }
                    )
                }
            }
        }
    }
}
