import org.jetbrains.compose.desktop.application.dsl.TargetFormat
import org.jetbrains.kotlin.gradle.ExperimentalKotlinGradlePluginApi
import org.jetbrains.kotlin.gradle.dsl.JvmTarget
import org.jetbrains.kotlin.gradle.plugin.mpp.apple.XCFramework

plugins {
    alias(libs.plugins.kotlinMultiplatform)
    alias(libs.plugins.androidApplication)
    alias(libs.plugins.jetbrainsCompose)
    alias(libs.plugins.compose.compiler)
    alias(libs.plugins.hilt)
    alias(libs.plugins.sqlDelight)
    alias(libs.plugins.kotlinxSerialization)
    alias(libs.plugins.ksp)
}

kotlin {
    androidTarget {
        @OptIn(ExperimentalKotlinGradlePluginApi::class)
        compilerOptions {
            jvmTarget.set(JvmTarget.JVM_11)
        }
    }

    iosX64()
    iosArm64()
    iosSimulatorArm64()
    
    sourceSets {
        
        androidMain.dependencies {
            implementation(compose.preview)
            implementation(libs.androidx.activity.compose)
            implementation(libs.kotlinx.coroutines.android)
            implementation(libs.androidx.lifecycle.viewmodel.compose)
            implementation(libs.androidx.navigation.compose)
            implementation(libs.hilt.android)
            ksp(libs.hilt.compiler)
            implementation(libs.hilt.navigation.compose)
            implementation(libs.sqldelight.android.driver)
        }
        commonMain.dependencies {
            implementation(compose.runtime)
            implementation(compose.foundation)
            implementation(compose.material)
            implementation(compose.ui)
            implementation(compose.components.resources)
            implementation(compose.components.uiToolingPreview)
            implementation(libs.kotlinx.coroutines.core)
            implementation(libs.kotlinx.serialization.json)
            implementation(libs.sqldelight.coroutines.extensions)
            implementation(libs.kotlinx.datetime)
        }
        val commonTest by getting {
            dependencies {
                implementation(kotlin("test"))
                implementation(libs.kotlinx.coroutines.test)
                implementation(libs.turbine)
                implementation(libs.sqldelight.sqlite.driver)
            }
        }
        val androidMain by getting
        // androidUnitTest is not standard, using 'test' for android unit tests
        // This assumes tests are in src/test/kotlin for the androidApp module
        val test by creating { // This refers to src/test for androidMain usually
            dependsOn(commonTest)
            dependencies {
                implementation(kotlin("test-junit"))
                implementation(libs.junit)
                implementation(libs.mockito.core)
                implementation(libs.androidx.arch.core.testing)
                // kotlinx.coroutines.test and turbine are inherited from commonTest
                // If specific versions or additional test utils for Android JVM are needed, add here.
            }
        }
        val androidTest by getting { // This is the standard sourceSet for Android instrumented tests
            dependencies {
                implementation(kotlin("test-junit")) // Or could be libs.kotlin.test.junit
                implementation(libs.androidx.test.junit) // This is androidx-test-ext-junit
                implementation(libs.androidx.compose.ui.test.junit4)
                debugImplementation(libs.androidx.compose.ui.test.manifest) // For debug manifest
                implementation(libs.hilt.android.testing)
                kspAndroidTest(libs.hilt.compiler) // Using ksp as per main app
            }
        }
    }
}

compose.resources {
    publicResClass = true
    generateResClass = always
}

android {
    namespace = "com.jetbrains.greeting"
    compileSdk = libs.versions.android.compileSdk.get().toInt()

    sourceSets["main"].manifest.srcFile("src/androidMain/AndroidManifest.xml")
    sourceSets["main"].res.srcDirs("src/androidMain/res")
    sourceSets["main"].resources.srcDirs("src/commonMain/resources")

    defaultConfig {
        applicationId = "com.jetbrains.greeting"
        minSdk = libs.versions.android.minSdk.get().toInt()
        targetSdk = libs.versions.android.targetSdk.get().toInt()
        versionCode = 1
        versionName = "1.0"
    }
    packaging {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
        }
    }
    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    buildFeatures {
        compose = true
    }
    dependencies {
        debugImplementation(compose.uiTooling)
        debugImplementation(libs.androidx.compose.ui.test.manifest) // Also for debug builds of app
    }
    defaultConfig {
        testInstrumentationRunner = "com.jetbrains.greeting.CustomTestRunner"
    }
}

sqldelight {
  databases {
    create("AppDatabase") {
      packageName.set("com.example.reminder.db") // Changed to reminder specific
      // srcDirs.setFrom("src/commonMain/sqldelight") // Default, verify or set if different
    }
  }
}

