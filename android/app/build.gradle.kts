plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // Ensure Flutter Gradle Plugin is applied
}

android {
    namespace = "com.example.porfolio"
    compileSdk = 34  // Use the latest stable compileSdk version

    ndkVersion = "27.0.12077973"  // Set the required NDK version

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.porfolio"
        minSdk = 21  // Set min SDK (recommended: 21 or higher)
        targetSdk = 34  // Target latest stable SDK
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")  // Keep for testing, change for production
            isMinifyEnabled = false // Set to true in production for optimization
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

flutter {
    source = "../.."
}
