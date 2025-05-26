# xprinter_sdk

xprinter的flutter版本sdk

## Getting Started

### For Android

需要将这些内容添加到项目中
```
allprojects {
    repositories {
        google()
        mavenCentral()
+       maven {
+           url "${project(':aar').projectDir}/build"  // for build.gradle
+           url = uri(project(":xprinter_sdk").projectDir.resolve("mvn")) // for build.gradle.kts
+       }
+       maven { url 'https://jitpack.io' }
    }
}
```

