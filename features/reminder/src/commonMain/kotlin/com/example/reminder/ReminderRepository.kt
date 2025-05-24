package com.example.reminder

import com.apollographql.apollo.ApolloClient

class ReminderRepository {
    private val apolloClient = ApolloClient.Builder()
        .serverUrl("http://localhost:4000/")
        .build()

    suspend fun fetchMyLists(): MyListsQuery.Data {
        val response = apolloClient.query(MyListsQuery()).execute()
        val data = response.data
        requireNotNull(data) { "Response data is null" }
        return data
    }
}