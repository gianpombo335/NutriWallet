plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.nutriwallet.nutriwallet"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.nutriwallet.nutriwallet"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    val keystorePath = System.getenv("NUTRIWALLET_KEYSTORE_PATH")
    val keystorePassword = System.getenv("NUTRIWALLET_KEYSTORE_PASSWORD")
    val releaseKeyAlias = System.getenv("NUTRIWALLET_KEY_ALIAS")
    val releaseKeyPassword = System.getenv("NUTRIWALLET_KEY_PASSWORD")
    val productionRelease = System.getenv("NUTRIWALLET_RELEASE_BUILD") == "true"
    val signingValues = listOf(
        keystorePath,
        keystorePassword,
        releaseKeyAlias,
        releaseKeyPassword,
    )
    val hasReleaseSigning = signingValues.all { !it.isNullOrBlank() }
    if (productionRelease && (!hasReleaseSigning || !file(keystorePath!!).exists())) {
        throw GradleException(
            "Production release requires NUTRIWALLET_KEYSTORE_PATH, " +
                "NUTRIWALLET_KEYSTORE_PASSWORD, NUTRIWALLET_KEY_ALIAS, " +
                "and NUTRIWALLET_KEY_PASSWORD.",
        )
    }
    if (hasReleaseSigning) {
        signingConfigs.create("release") {
            storeFile = file(keystorePath!!)
            storePassword = keystorePassword
            this.keyAlias = releaseKeyAlias
            this.keyPassword = releaseKeyPassword
        }
    }

    buildTypes {
        release {
            signingConfig = if (hasReleaseSigning) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
            // Keep optional ML Kit language bindings intact for the demo artifact.
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
