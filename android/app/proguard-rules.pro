# ================= Flutter Specific =================
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.app.** { *; }
-dontwarn io.flutter.embedding.**
-dontwarn io.flutter.plugin.**
-dontwarn io.flutter.app.**

# ================= Tensorflow Lite Specific =================
-keep class org.tensorflow.** { *; }
-dontwarn org.tensorflow.**

# ================= General Android =================
-keep class androidx.lifecycle.** { *; }
-keepclassmembers class androidx.lifecycle.DefaultLifecycleObserver {
    *;
}

# Optional: لمنع مشاكل الترجمة لو فيها reflection
-keepattributes Signature
-keepattributes *Annotation*

# Allow references to missing classes
-dontwarn javax.annotation.**

# Ignore missing classes during shrinking
-dontwarn com.google.**
-dontwarn kotlin.**
-dontwarn okio.**
