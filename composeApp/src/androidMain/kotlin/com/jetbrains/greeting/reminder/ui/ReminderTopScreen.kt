package com.jetbrains.greeting.reminder.ui

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import com.jetbrains.greeting.Res // Import Res object
import org.jetbrains.compose.resources.stringResource // Import stringResource
import com.jetbrains.greeting.reminder.ui.components.GroupRow
import com.jetbrains.greeting.reminder.ui.components.MyListRow
import com.jetbrains.greeting.reminder.viewmodel.ReminderTopViewModel
import com.example.reminder.model.ReminderGroup // Import common model

@Composable
fun ReminderTopScreen(
    viewModel: ReminderTopViewModel = hiltViewModel(),
    onNavigateToList: (listId: String?, groupTypeString: String?) -> Unit
) {
    val uiState by viewModel.uiState.collectAsState()

    Scaffold(
        topBar = {
            TopAppBar(title = { Text(stringResource(Res.string.reminder_top_screen_title)) })
        }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .padding(paddingValues)
                .fillMaxSize()
                .padding(8.dp)
        ) {
            if (uiState.isLoading) {
                CircularProgressIndicator(modifier = Modifier.fillMaxWidth().wrapContentWidth())
            } else {
                // Groups Grid (2 columns)
                Text(stringResource(Res.string.reminder_top_groups_header), style = MaterialTheme.typography.h6, modifier = Modifier.padding(8.dp))
                LazyVerticalGrid(
                    columns = GridCells.Fixed(2),
                    contentPadding = PaddingValues(4.dp),
                    verticalArrangement = Arrangement.spacedBy(4.dp),
                    horizontalArrangement = Arrangement.spacedBy(4.dp),
                    modifier = Modifier.heightIn(max = 200.dp) // Example height constraint
                ) {
                    items(uiState.reminderGroupsWithCounts, key = { it.first.ordinal }) { (group, count) ->
                        GroupRow(
                            group = group,
                            count = count,
                            onGroupClick = { groupClicked -> onNavigateToList(null, groupClicked.name) }
                        )
                    }
                }

                Spacer(modifier = Modifier.height(16.dp))

                // My Lists
                Text(stringResource(Res.string.reminder_top_my_lists_header), style = MaterialTheme.typography.h6, modifier = Modifier.padding(8.dp))
                LazyColumn(
                    contentPadding = PaddingValues(4.dp),
                    verticalArrangement = Arrangement.spacedBy(4.dp)
                ) {
                    items(uiState.myLists, key = { it.id }) { myList ->
                        MyListRow(
                            myList = myList,
                            onListClick = { listId -> onNavigateToList(listId, null) }
                        )
                    }
                }
            }
        }
    }
}
