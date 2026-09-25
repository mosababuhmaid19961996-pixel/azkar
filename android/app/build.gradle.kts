plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
}

android {
    namespace = "com.athkari.athkar_app"
    compileSdk = 35

    defaultConfig {
        applicationId = "com.athkari.athkar_app"
        minSdk = 21
        targetSdk = 35
        versionCode = 1
        versionName = "1.0.0"
    }
}

flutter {
    source = "../.."
}
