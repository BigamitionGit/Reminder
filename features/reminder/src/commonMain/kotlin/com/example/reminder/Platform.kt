package com.example.reminder

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform