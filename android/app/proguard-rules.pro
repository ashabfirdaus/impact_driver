# Flutter ProGuard rules for 16KB memory optimization

# Keep Flutter classes
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**

# Keep Google Play Core (required for deferred components)
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# Keep plugin classes
-keep class com.impactapp.driver.** { *; }

# Keep HTTP classes for network requests
-keepclassmembers class * {
    @retrofit2.http.* <methods>;
}
-keep class okhttp3.** { *; }
-dontwarn okhttp3.**

# Image picker and related classes
-keep class androidx.** { *; }
-dontwarn androidx.**

# Secure storage
-keep class com.it_nomads.fluttersecurestorage.** { *; }

# Keep serialization classes
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes InnerClasses
-keepattributes Exceptions

# General optimizations
-dontobfuscate
-allowaccessmodification

# Remove debug logging
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
}

# Disable deferred components since we're not using Play Core
-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }