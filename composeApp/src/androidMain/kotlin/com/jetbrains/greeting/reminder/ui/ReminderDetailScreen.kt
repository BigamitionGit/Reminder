package com.jetbrains.greeting.reminder.ui

import android.app.DatePickerDialog
import android.app.TimePickerDialog
import android.widget.Toast
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.material.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.Event
import androidx.compose.material.icons.filled.Schedule
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import com.jetbrains.greeting.Res // Import Res object
import org.jetbrains.compose.resources.stringResource // Import stringResource
import com.jetbrains.greeting.reminder.viewmodel.ReminderDetailViewModel
import com.example.reminder.model.DueDate // Common model
import kotlinx.datetime.*
import java.util.Calendar

@Composable
fun ReminderDetailScreen(
    viewModel: ReminderDetailViewModel = hiltViewModel(),
    onNavigateBack: () -> Unit
) {
    val uiState by viewModel.uiState.collectAsState()
    val context = LocalContext.current

    // Effect to handle navigation when navigateBack is true
    LaunchedEffect(uiState?.navigateBack) {
        if (uiState?.navigateBack == true) {
            onNavigateBack()
        }
    }

    LaunchedEffect(uiState?.error) {
        uiState?.error?.let {
            Toast.makeText(context, it, Toast.LENGTH_LONG).show()
            viewModel.clearError()
        }
    }


    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(if (uiState?.isNewReminder == false) stringResource(Res.string.reminder_detail_screen_edit_title) else stringResource(Res.string.reminder_detail_screen_new_title)) },
                navigationIcon = {
                    IconButton(onClick = onNavigateBack) {
                        Icon(Icons.Filled.ArrowBack, contentDescription = stringResource(Res.string.reminder_detail_back_action))
                    }
                },
                actions = {
                    if (uiState?.isNewReminder == false) {
                        IconButton(onClick = { viewModel.deleteReminder() }) {
                            Icon(Icons.Filled.Delete, contentDescription = stringResource(Res.string.reminder_detail_delete_action))
                        }
                    }
                }
            )
        }
    ) { paddingValues ->
        val currentUiState = uiState
        if (currentUiState == null || currentUiState.isLoading) {
            Box(modifier = Modifier.fillMaxSize().padding(paddingValues), contentAlignment = Alignment.Center) {
                CircularProgressIndicator()
            }
        } else {
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(paddingValues)
                    .padding(16.dp)
            ) {
                OutlinedTextField(
                    value = currentUiState.title,
                    onValueChange = { viewModel.onTitleChange(it) },
                    label = { Text(stringResource(Res.string.reminder_detail_title_label)) },
                    modifier = Modifier.fillMaxWidth(),
                    singleLine = true
                )

                Spacer(modifier = Modifier.height(16.dp))

                // Due Date Section
                DueDateSelector(
                    dueDate = currentUiState.dueDate,
                    onDueDateChange = { viewModel.onDueDateChange(it) }
                )

                Spacer(modifier = Modifier.height(16.dp))

                Row(verticalAlignment = Alignment.CenterVertically) {
                    Checkbox(
                        checked = currentUiState.isCompleted,
                        onCheckedChange = { viewModel.onCompletionChange(it) }
                    )
                    Text(stringResource(Res.string.reminder_detail_completed_checkbox))
                }

                Spacer(modifier = Modifier.height(24.dp))

                Button(
                    onClick = { viewModel.saveReminder() },
                    modifier = Modifier.fillMaxWidth(),
                    enabled = !currentUiState.isLoading
                ) {
                    Text(stringResource(Res.string.reminder_detail_save_button))
                }
            }
        }
    }
}

@Composable
fun DueDateSelector(dueDate: DueDate?, onDueDateChange: (DueDate?) -> Unit) {
    val context = LocalContext.current
    val currentDateTime = dueDate?.timestamp?.toLocalDateTime(TimeZone.currentSystemDefault())
        ?: Clock.System.now().toLocalDateTime(TimeZone.currentSystemDefault())

    var selectedDate by remember(dueDate) { mutableStateOf(currentDateTime.date) }
    var selectedTime by remember(dueDate) { mutableStateOf(Pair(currentDateTime.hour, currentDateTime.minute)) }
    var dateOnly by remember(dueDate) { mutableStateOf(dueDate?.isYearMonthDayOnly ?: true) }


    fun updateDueDate() {
        val newLocalDateTime = LocalDateTime(selectedDate, LocalTime(selectedTime.first, selectedTime.second))
        onDueDateChange(DueDate(newLocalDateTime.toInstant(TimeZone.currentSystemDefault()), dateOnly))
    }

    val datePickerDialog = DatePickerDialog(
        context,
        { _, year, month, dayOfMonth ->
            selectedDate = LocalDate(year, month + 1, dayOfMonth)
            updateDueDate()
        },
        selectedDate.year, selectedDate.monthNumber - 1, selectedDate.dayOfMonth
    )

    val timePickerDialog = TimePickerDialog(
        context,
        { _, hourOfDay, minute ->
            selectedTime = Pair(hourOfDay, minute)
            updateDueDate()
        },
        selectedTime.first, selectedTime.second, !dateOnly // Use 24-hour format if dateOnly is false (i.e. time matters)
    )

    Column {
        Text(stringResource(Res.string.reminder_detail_due_date_header), style = MaterialTheme.typography.subtitle1)
        Spacer(modifier = Modifier.height(8.dp))
        Row(verticalAlignment = Alignment.CenterVertically) {
            OutlinedButton(
                onClick = { datePickerDialog.show() },
                modifier = Modifier.weight(1f)
            ) {
                Icon(Icons.Default.Event, contentDescription = stringResource(Res.string.reminder_detail_select_date_button))
                Spacer(modifier = Modifier.width(8.dp))
                Text(dueDate?.let { formatDisplayDate(it.timestamp, true) } ?: stringResource(Res.string.reminder_detail_select_date_button))
            }
            if (dueDate != null) {
                Spacer(modifier = Modifier.width(8.dp))
                OutlinedButton(
                    onClick = {
                        if (!dateOnly) timePickerDialog.show()
                    },
                    enabled = !dateOnly && dueDate != null
                ) {
                    Icon(Icons.Default.Schedule, contentDescription = stringResource(Res.string.reminder_detail_select_time_button))
                    Spacer(modifier = Modifier.width(8.dp))
                    Text(if (dateOnly) "--:--" else formatDisplayTime(dueDate.timestamp))
                }
            }
        }
        Spacer(modifier = Modifier.height(8.dp))
        Row(verticalAlignment = Alignment.CenterVertically) {
            Checkbox(checked = dueDate == null, onCheckedChange = { if (it) onDueDateChange(null) else updateDueDate() /* re-trigger with current picker state if unchecked */ })
            Text(stringResource(Res.string.reminder_detail_no_due_date_checkbox))
            Spacer(Modifier.width(16.dp))
            if (dueDate != null) {
                Checkbox(checked = dateOnly, onCheckedChange = {
                    dateOnly = it
                    updateDueDate()
                })
                Text(stringResource(Res.string.reminder_detail_all_day_checkbox))
            }
        }
    }
}

fun formatDisplayDate(timestamp: Instant, isYearMonthDayOnly: Boolean): String {
    val dateTime = timestamp.toLocalDateTime(TimeZone.currentSystemDefault())
    return "${dateTime.year}-${dateTime.monthNumber.toString().padStart(2, '0')}-${dateTime.dayOfMonth.toString().padStart(2, '0')}"
}

fun formatDisplayTime(timestamp: Instant): String {
    val dateTime = timestamp.toLocalDateTime(TimeZone.currentSystemDefault())
    return "${dateTime.hour.toString().padStart(2,'0')}:${dateTime.minute.toString().padStart(2,'0')}"
}
