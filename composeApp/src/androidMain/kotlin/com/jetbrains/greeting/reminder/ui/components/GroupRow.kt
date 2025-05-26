package com.jetbrains.greeting.reminder.ui.components

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.material.Card
import androidx.compose.material.Icon
import androidx.compose.material.Text
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.* // For placeholder icons
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.reminder.model.ReminderGroup
import com.jetbrains.greeting.Res // Import Res
import org.jetbrains.compose.resources.stringResource // Import stringResource

@Composable
fun GroupRow(
    group: ReminderGroup,
    count: Int,
    onGroupClick: (ReminderGroup) -> Unit
) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(8.dp)
            .clickable { onGroupClick(group) },
        elevation = 2.dp
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
                    imageVector = group.icon(), // Extension function needed
                    contentDescription = group.displayName(), // Extension function needed
                    modifier = Modifier.size(24.dp)
                )
                Spacer(modifier = Modifier.width(16.dp))
                Text(text = group.displayName(), fontSize = 18.sp)
            }
            Text(text = count.toString(), fontSize = 18.sp)
        }
    }
}

// Placeholder extension functions for icons and names - these should be refined
// ideally with proper resource handling for localization and theming for icons/colors.
@Composable // Make it composable to use stringResource
fun ReminderGroup.displayName(): String = when (this) {
    ReminderGroup.TODAY -> stringResource(Res.string.group_name_today)
    ReminderGroup.SCHEDULED -> stringResource(Res.string.group_name_scheduled)
    ReminderGroup.ALL -> stringResource(Res.string.group_name_all)
    ReminderGroup.COMPLETED -> stringResource(Res.string.group_name_completed)
}

fun ReminderGroup.icon(): ImageVector = when (this) {
    ReminderGroup.TODAY -> Icons.Filled.Today
    ReminderGroup.SCHEDULED -> Icons.Filled.Schedule
    ReminderGroup.ALL -> Icons.Filled.AllInbox
    ReminderGroup.COMPLETED -> Icons.Filled.CheckCircle
}
