package com.jetbrains.greeting.reminder.ui.components

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.material.Card
import androidx.compose.material.Checkbox
import androidx.compose.material.Icon
import androidx.compose.material.Text
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Event // For due date
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.reminder.model.Reminder
import kotlinx.datetime.Instant
import kotlinx.datetime.TimeZone
import kotlinx.datetime.toLocalDateTime

@Composable
fun ReminderRow(
    reminder: Reminder,
    onReminderClick: (String) -> Unit,
    onToggleComplete: (Reminder) -> Unit
) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 8.dp, vertical = 4.dp)
            .clickable { onReminderClick(reminder.id) },
        elevation = 1.dp
    ) {
        Row(
            modifier = Modifier
                .padding(8.dp) // Reduced padding for more compact row
                .fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Checkbox(
                checked = reminder.isCompleted,
                onCheckedChange = { onToggleComplete(reminder) }
            )
            Spacer(modifier = Modifier.width(8.dp))
            Column(modifier = Modifier.weight(1f)) {
                Text(
                    text = reminder.title,
                    fontSize = 16.sp,
                    maxLines = 2,
                    overflow = TextOverflow.Ellipsis
                )
                reminder.dueDate?.let { dueDate ->
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Icon(Icons.Default.Event, contentDescription = "Due date", modifier = Modifier.size(14.dp))
                        Spacer(modifier = Modifier.width(4.dp))
                        Text(
                            text = formatDueDate(dueDate.timestamp, dueDate.isYearMonthDayOnly),
                            fontSize = 12.sp
                        )
                    }
                }
            }
        }
    }
}

private fun formatDueDate(timestamp: Instant, isYearMonthDayOnly: Boolean): String {
    val dateTime = timestamp.toLocalDateTime(TimeZone.currentSystemDefault())
    return if (isYearMonthDayOnly) {
        "${dateTime.year}-${dateTime.monthNumber.toString().padStart(2, '0')}-${dateTime.dayOfMonth.toString().padStart(2, '0')}"
    } else {
        "${dateTime.year}-${dateTime.monthNumber.toString().padStart(2, '0')}-${dateTime.dayOfMonth.toString().padStart(2, '0')} ${dateTime.hour.toString().padStart(2,'0')}:${dateTime.minute.toString().padStart(2,'0')}"
    }
}
