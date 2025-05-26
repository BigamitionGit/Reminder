package com.jetbrains.greeting.reminder.viewmodel

import androidx.lifecycle.SavedStateHandle
import app.cash.turbine.test
import com.example.reminder.model.Reminder
import com.example.reminder.repository.ReminderRepository
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.flow.flowOf
import kotlinx.coroutines.test.*
import org.junit.After
import org.junit.Assert.*
import org.junit.Before
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.Mockito.*
import org.mockito.junit.MockitoJUnitRunner
import androidx.arch.core.executor.testing.InstantTaskExecutorRule


@ExperimentalCoroutinesApi
@RunWith(MockitoJUnitRunner::class)
class ReminderDetailViewModelTest {

    @get:Rule
    val instantTaskExecutorRule = InstantTaskExecutorRule() // For LiveData if used, good practice for ViewModels

    @Mock
    private lateinit var mockRepository: ReminderRepository

    private val testDispatcher = StandardTestDispatcher()

    @Before
    fun setup() {
        Dispatchers.setMain(testDispatcher)
    }

    @After
    fun tearDown() {
        Dispatchers.resetMain()
    }

    @Test
    fun `loadExistingReminder updates state correctly`() = runTest(testDispatcher) {
        val reminderId = "testId"
        val myListId = "myListId1"
        val existingReminder = Reminder(reminderId, myListId, "Existing", null, false)
        `when`(mockRepository.getReminderById(reminderId)).thenReturn(flowOf(existingReminder))

        val savedStateHandle = SavedStateHandle().apply {
            set(ReminderDetailViewModel.ARG_REMINDER_ID, reminderId)
            set(ReminderDetailViewModel.ARG_MY_LIST_ID, myListId) // Required for context
        }
        val viewModel = ReminderDetailViewModel(mockRepository, savedStateHandle)

        viewModel.uiState.test {
            // Skip initial null state and loading state
            awaitItem() // initial null
            val loadingState = awaitItem()
            assertTrue(loadingState!!.isLoading)
            
            val finalState = awaitItem()
            assertNotNull(finalState)
            assertEquals(reminderId, finalState!!.reminderId)
            assertEquals("Existing", finalState.title)
            assertFalse(finalState.isNewReminder)
            assertFalse(finalState.isLoading)
            cancelAndIgnoreRemainingEvents()
        }
    }

    @Test
    fun `saveReminder new reminder calls addReminder and navigates back`() = runTest(testDispatcher) {
        val myListId = "listId1"
        val savedStateHandle = SavedStateHandle().apply {
            set(ReminderDetailViewModel.ARG_MY_LIST_ID, myListId)
        }
        val viewModel = ReminderDetailViewModel(mockRepository, savedStateHandle)

        // Initial state for new reminder
        viewModel.uiState.test {
            awaitItem() // null state
            val initialState = awaitItem() // Initial state after loading (isNewReminder = true)
            assertTrue(initialState!!.isNewReminder)

            viewModel.onTitleChange("New Reminder")
            awaitItem() // title change

            viewModel.saveReminder()
            // State after save: navigateBack should be true
            // We might get an intermediate state if onTitleChange also emits before saveReminder's effect
            // Let's advance past any state that isn't the navigateBack one.
            var finalState = awaitItem()
            if (!finalState!!.navigateBack) { // if the title change state was emitted
                 finalState = awaitItem() // get the navigateBack state
            }
            assertTrue(finalState!!.navigateBack)

            verify(mockRepository, times(1)).addReminder(any())
            cancelAndIgnoreRemainingEvents()
        }
    }
    
    // Helper for Mockito.any() with null safety
    private fun <T> any(): T = Mockito.any<T>()
}
