package com.jetbrains.greeting.reminder.ui

import androidx.compose.ui.test.*
import androidx.compose.ui.test.junit4.createAndroidComposeRule // Use this for Hilt tests
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.example.reminder.model.ReminderMyList
import com.jetbrains.greeting.MainActivity // Your Hilt Activity
import com.jetbrains.greeting.di.FakeReminderRepository // Import your fake
// import com.jetbrains.greeting.reminder.nav.AppNavigation // Not directly used here, MainActivity sets it up
import com.example.reminder.repository.ReminderRepository // Import the interface
import dagger.hilt.android.testing.HiltAndroidRule
import dagger.hilt.android.testing.HiltAndroidTest
import org.junit.Before
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import javax.inject.Inject


@RunWith(AndroidJUnit4::class)
@HiltAndroidTest // Marks this as a Hilt test
class ReminderTopScreenTest {

    @get:Rule(order = 0)
    val hiltRule = HiltAndroidRule(this) // Hilt rule must run first

    @get:Rule(order = 1)
    val composeTestRule = createAndroidComposeRule<MainActivity>() // Activity that hosts the NavGraph

    @Inject // Hilt can inject the fake repository here if needed, or access it via ViewModel
    lateinit var fakeRepository: ReminderRepository // This should be FakeReminderRepository type

    @Before
    fun setUp() {
        hiltRule.inject() // Initialize Hilt-injected fields
    }

    @Test
    fun reminderTopScreen_displaysMyListsAndGroups() {
        // Seed data into the fake repository
        val testLists = listOf(
            ReminderMyList("list1", "Groceries", "icon1", emptyList()),
            ReminderMyList("list2", "Work", "icon2", emptyList())
        )
        // Ensure fakeRepository is cast to FakeReminderRepository to access seedData
        (fakeRepository as FakeReminderRepository).seedData(testLists, emptyList())

        // Set content to AppNavigation which starts at ReminderTopScreen
        // composeTestRule.setContent { AppNavigation() } // MainActivity already does this.

        // Check for "Groups" and "My Lists" titles
        composeTestRule.onNodeWithText("Groups").assertIsDisplayed()
        composeTestRule.onNodeWithText("My Lists").assertIsDisplayed()

        // Check if list names are displayed
        composeTestRule.onNodeWithText("Groceries").assertIsDisplayed()
        composeTestRule.onNodeWithText("Work").assertIsDisplayed()

        // Check for group display (e.g., "Today")
        // Note: Group names come from ReminderGroup.displayName() extension
        composeTestRule.onNodeWithText("Today").assertIsDisplayed()
        composeTestRule.onNodeWithText("All").assertIsDisplayed()
        // Check for count (e.g., "0" if no reminders seeded for "All")
        // This requires knowing the exact text formation: "All" and its count node.
        // Example: find the row for "All" and then find the count in its children.
         composeTestRule.onNode(hasParent(hasText("All")) and hasText("0")).assertIsDisplayed()
         composeTestRule.onNode(hasParent(hasText("Today")) and hasText("0")).assertIsDisplayed()
         composeTestRule.onNode(hasParent(hasText("Scheduled")) and hasText("0")).assertIsDisplayed()
         composeTestRule.onNode(hasParent(hasText("Completed")) and hasText("0")).assertIsDisplayed()
    }
}
