package com.example.reminder.repository

import app.cash.sqldelight.db.SqlDriver
import app.cash.sqldelight.driver.jdbc.sqlite.JdbcSqliteDriver
import com.example.reminder.db.AppDatabase
import com.example.reminder.model.Reminder
import com.example.reminder.model.ReminderMyList
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.test.*
import kotlin.test.*

@OptIn(ExperimentalCoroutinesApi::class)
class ReminderRepositoryImplTest {

    private lateinit var db: AppDatabase
    private lateinit var repository: ReminderRepositoryImpl
    private lateinit var driver: SqlDriver

    private val testDispatcher = StandardTestDispatcher()

    @BeforeTest
    fun setup() {
        Dispatchers.setMain(testDispatcher) // For coroutines launched on Main
        driver = JdbcSqliteDriver(JdbcSqliteDriver.IN_MEMORY)
        AppDatabase.Schema.create(driver)
        db = AppDatabase(driver)
        repository = ReminderRepositoryImpl(db, testDispatcher)
    }

    @AfterTest
    fun tearDown() {
        driver.close()
        Dispatchers.resetMain()
    }

    @Test
    fun `add and get reminder by id`() = runTest(testDispatcher) {
        val list = ReminderMyList("list1", "Test List", "icon", emptyList())
        repository.addMyList(list)

        val reminder = Reminder("id1", "list1", "Test Reminder", null, false)
        repository.addReminder(reminder)

        val fetched = repository.getReminderById("id1").first()
        assertNotNull(fetched)
        assertEquals("Test Reminder", fetched.title)
    }

    @Test
    fun `getRemindersForMyList returns reminders for correct list`() = runTest(testDispatcher) {
        val list1 = ReminderMyList("list1", "List 1", "icon1", emptyList())
        val list2 = ReminderMyList("list2", "List 2", "icon2", emptyList())
        repository.addMyList(list1)
        repository.addMyList(list2)

        val reminder1L1 = Reminder("r1l1", "list1", "R1 L1", null, false)
        val reminder2L1 = Reminder("r2l1", "list1", "R2 L1", null, false)
        val reminder1L2 = Reminder("r1l2", "list2", "R1 L2", null, false)
        repository.addReminder(reminder1L1)
        repository.addReminder(reminder2L1)
        repository.addReminder(reminder1L2)

        val remindersForList1 = repository.getRemindersForMyList("list1").first()
        assertEquals(2, remindersForList1.size)
        assertTrue(remindersForList1.all { it.myListId == "list1" })

        val remindersForList2 = repository.getRemindersForMyList("list2").first()
        assertEquals(1, remindersForList2.size)
        assertTrue(remindersForList2.all { it.myListId == "list2" })
    }
}
