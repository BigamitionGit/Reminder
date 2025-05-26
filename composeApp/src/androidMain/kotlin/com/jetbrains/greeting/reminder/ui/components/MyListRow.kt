package com.jetbrains.greeting.reminder.ui.components

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.material.Card
import androidx.compose.material.Icon
import androidx.compose.material.Text
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.List // Placeholder icon
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.reminder.model.ReminderMyList

@Composable
fun MyListRow(
    myList: ReminderMyList,
    onListClick: (String) -> Unit // Pass ID
) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 8.dp, vertical = 4.dp)
            .clickable { onListClick(myList.id) },
        elevation = 1.dp
    ) {
        Row(
            modifier = Modifier
                .padding(16.dp)
                .fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Icon(
                    imageVector = Icons.Filled.List, // Placeholder, use myList.icon later
                    contentDescription = myList.name,
                    modifier = Modifier.size(24.dp)
                )
                Spacer(modifier = Modifier.width(16.dp))
                Text(text = myList.name, fontSize = 18.sp)
            }
            // Potentially show reminder count for this list if available and desired
            // Text(text = myList.reminders.count { !it.isCompleted }.toString(), fontSize = 18.sp)
        }
    }
}
