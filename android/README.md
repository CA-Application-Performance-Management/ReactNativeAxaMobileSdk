README
======

If you want to publish the lib as a maven dependency, follow these steps before publishing a new version to npm:

1. Be sure to have the Android [SDK](https://developer.android.com/studio/index.html) and [NDK](https://developer.android.com/ndk/guides/index.html) installed
2. Be sure to have a `local.properties` file in this folder that points to the Android SDK and NDK
```
ndk.dir=/Users/{username}/Library/Android/sdk/ndk-bundle
sdk.dir=/Users/{username}/Library/Android/sdk
```
3. This can publish to local maven repository for testing
4. Run `./gradlew publishToMavenLocal`
5. Once task is completed inside <USER_DIR>/.m2/repository/com/ca/axa/react/react-native-axa-mobile-sdk-xcframework folder with the same version with which react-native-axa-mobile-sdk package is installed.

Note: This version uses below versions and can be used by application using react-native >= 0.71.0
react : 18.2.0
react-native: 0.71.0
AGP: 8.0 
