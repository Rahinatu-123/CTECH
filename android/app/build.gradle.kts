plugins {
    id("com.android.application")
    id("kotlin-android")
    // Must be applied after Android + Kotlin
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.flutterproject"
    //compileSdk = 33 // Or flutter.compileSdkVersion if set to 33+
    compileSdk = 35

    ndkVersion = "27.0.12077973" 

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.example.flutterproject"
        //  Set minSdk to 26 explicitly
        minSdk = 26
        targetSdk = 33 // Or flutter.targetSdkVersion

        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("debug") // Replace with actual release signing later
        }
    }
}

flutter {
    source = "../.."
}
