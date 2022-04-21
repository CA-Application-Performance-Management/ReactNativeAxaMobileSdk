# ReactNativeAxaMobileSdk
**React Native Axa Mobile Sdk** is a modern, well-supported, and cross-platform sdk for App Experience Analytics that provides deep insights into the performance, user experience, crash, and log analytics of apps.

## Platforms Supported

-  iOS
-  Android

## Getting started
[DX App Experience Analytics](https://www.broadcom.com/info/aiops/app-analytics)

Check out our [documentation](https://techdocs.broadcom.com/content/broadcom/techdocs/us/en/ca-enterprise-software/it-operations-management/app-experience-analytics-saas/SaaS/reference/data-collected-by-ca-app-experience-analytics-sdk.html) for more information about the features that the App Experience Analytics SDK collects from your app.


## Requirements
-  iOS
    1. Xcode 12 or higher
    2. iOS 9.0 or higher
-  Android

## Installation

Follow these steps to integrate the `react native axa mobile sdk` which has ios xcframework support in your project

### Automatic installation
1. Run the following command from your React Native project directory

    `$ yarn add react-native-axa-mobile-sdk-xcframework`
    
    or
    
    `$ npm install react-native-axa-mobile-sdk-xcframework --save`
2. Run the following command for automatic linking

    `$ react-native link react-native-axa-mobile-sdk-xcframework`
3. <details>
    <summary> Setup </summary>
    
    <blockquote>
    <details>
    <summary> iOS </summary>
    
    1. Podfile update<br> If you're already using Cocoapods, goto `ios` folder from your project and specify the pod below on a single line inside your target block in a Podfile
        ```sh
        pod 'react-native-axa-mobile-sdk-xcframework', path: '../node_modules/react-native-axa-mobile-sdk-xcframework'
        ```
        Then, run the following command using the command prompt from the `ios` folder of your project
        ```sh
        pod install
        ```
    2. Download the `xxx_camdo.plist`  file and add it to your project target
    
    </details>
    </blockquote>
    
    <blockquote>
    <details>
    <summary> Android </summary>
    
    Follow these steps to integrate the Gradle App Bundle Plugin with your Android Project.
    1. Create <project>/cadxapmsdk folder. This is the SDK root folder.
    2. Download the CAAppBundle_SDK.zip file and extract the contents to the SDK root.
    3. Download the <app>.plist. Prefer it to be copied to the SDK root folder.
    4. Import and add the 'ca-maa-android-sdk-release.aar' file as a dependency.
    5. Update the build.gradle file(s).
        - Project Level
            - Add maven url 'https://packages.broadcom.com/apm-agents' under repositories and classpath 'com.ca.dxapm:sdk-gradle-plugin:<version number>' under dependencies of the project level build.gradle file.
        - App Level
            - Add apply plugin: com.ca.dxapm.sdk.gradle.plugin at the top of the app build.gradle file.
            - Add cadxapmsdk configuration block, specifying the absolute path to the downloaded plist.
            - Add dependency to SDK.
    6. Update AndroidManifest.xml file. Add the following permissions, if not already present.
        ```sh
        <uses-permission android:name='android.permission.INTERNET' />
        <uses-permission android:name='android.permission.ACCESS_NETWORK_STATE' />
        <uses-permission android:name='android.permission.ACCESS_WIFI_STATE' />
        <uses-permission android:name='android.permission.ACCESS_COARSE_LOCATION' />
        ```
    For more information, see https://techdocs.broadcom.com/us/en/ca-enterprise-software/it-operations-management/app-experience-analytics-saas/SaaS/configuring/collect-data-from-android-applications/Native-Android-Wrapping.html
    
    </details>
    </blockquote>
    
</details>

### Manual installation


<details>
<summary>iOS</summary>

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-axa-mobile-sdk-xcframework` and add `ReactNativeAxaMobileSdk.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libReactNativeAxaMobileSdk.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

5. Podfile update

    If you're already using Cocoapods, goto `ios` folder from your project and specify the below pod on a single line inside your target block in a Podfile
   
   ```
   pod 'react-native-axa-mobile-sdk-xcframework', path: '../node_modules/react-native-axa-mobile-sdk-xcframework'
   ```
    
    Then, run the following command using the command prompt from the `ios` folder of your project

    ```
    pod install
    ```

6. Drag & Drop the downloaded `xxx_camdo.plist` file into the Supporting files
</details>


<details>
<summary>Android</summary>

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
    - Add `import com.reactlibrary.ReactNativeAxaMobileSdkPackage;` to the imports at the top of the file
    - Add `new ReactNativeAxaMobileSdkPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
      ```
      include ':react-native-axa-mobile-sdk-xcframework'
      project(':react-native-axa-mobile-sdk-xcframework').projectDir = new File(rootProject.projectDir,     '../node_modules/react-native-axa-mobile-sdk-xcframework/android')
      ```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
      ```
      compile project(':react-native-test-sdk')
      ```
</details>


## Initialising the SDK in your Source code
<details>
<summary> Code Changes </summary>
    
<blockquote>
<details>
<summary> iOS </summary>
<blockquote>    
<details>
<summary> Objective C </summary>

1. Add the import header `#import "CAMDOReporter.h"` to your AppDelegate.m file
2. Initialize the CAMobileAppAnalytics sdk in `didFinishLaunchingWithOptions:` method 
    ```sh
    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
        [CAMDOReporter initializeSDKWithOptions:SDKLogLevelVerbose  completionHandler:nil];
        return YES;
    }
    ```
3. Save and re-build your project
</details>
</blockquote>
    
<blockquote>
<details>
<summary> Swift </summary>

1. Add a header file with the file name format as `<app_name>-Bridging-header.h`.
        
2. Add the import header `#import "CAMDOReporter.h"` to your `<app_name>-Bridging-header.h` file. 
        
3. Add the `<app_name>-Bridging-header.h` file to Swift Compiler - Code Generation section in the Build Settings.
        `<name of the project>/<app_name>-Bridging-header.h`
        
4. Initialize the CAMobileAppAnalytics sdk in `didFinishLaunchingWithOptions` method
    ```sh
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //Initialize CA App Experience Analytics SDK
        CAMDOReporter.initializeSDK(options: SDKOptions.SDKLogLevelVerbose) { (completed, error) in

        }
        return true
    }
    ```
5. Save and re-build your project
</details>
</blockquote>

</details>
</blockquote>
</details>

## Updation

Follow these steps to updgrade the `react native axa mobile sdk` which has ios xcframework support in your project

1. Run the following command from your React Native project directory

    `$ yarn upgrade react-native-axa-mobile-sdk-xcframework`
    
    or
    
    `$ npm update react-native-axa-mobile-sdk-xcframework --save`

2. Run `$ pod update` command from the `ios` folder.


## Usage
```javascript
import { NativeModules } from 'react-native';

const AXASDK = NativeModules.ReactNativeAxaMobileSdk;
```
  
## APIs
Individual APIs interact with the SDK to perform specific tasks, reading, or setting information.  All APIs are asynchronous and returning information is achieved using a callback function or block.  The specifics can be found in the React Native documentation for [Android](https://reactnative.dev/docs/native-modules-android#callbacks) or [iOS](https://reactnative.dev/docs/native-modules-ios#callbacks) callbacks.

A callback returns one or more values.

Once you have assigned a variable or constant to the ReactNativeAxaMobileSdk module as shown in ["Usage"](#usage), calling individual APIs is as simple as:

```javascript
AXASDK.individualAPI();
AXASDK.individualAPI(argument1, argument2, ...);
AXASDK.individualAPI(argument1, ..., callback);
AXASDK.individualAPI(argument1, argument2, ..., callback);
```

Follow the examples in the API descriptions below for how to use the callbacks.  The examples presented use a block with parameters instead of a function.  Either format will work in practice.


### disableSDK()
<details><summary>Use this API to disable the SDK.</summary>

When disabled, the SDK no longer does any tracking of the application, or user interaction.

```javascript
AXASDK.disableSDK();
```
</details>


### enableSDK()
<details><summary>Use this API to enable the SDK.</summary>

The SDK is enabled by default.  You need to call this API only if you called disableSDK earlier.

```javascript
AXASDK.enableSDK();
```
</details>


### isSDKEnabled( callback )
<details><summary>Use this API to determine if the SDK is enabled or not.</summary>

Parameters:
-  callback is a function which expects a boolean value

```javascript
AXASDK.isSDKEnabled((isEnabled) => {
    if (isEnabled) {
        // enabled action
    } else {
        // non-enabled action
    }
    console.log(`SDK is enabled: ${isEnabled}`);
})
```
</details>


### getDeviceId( callback )
<details><summary>Use this API to get the unique device ID generated by the SDK.</summary>

Parameters:
-  callback is a function which expects a string value.

```javascript
AXASDK.getDeviceId((deviceId) => {
    if (deviceId) {
        console.log(`received device id: ${deviceId}`);
    }
})
```
</details>


### getCustomerId( callback )
<details><summary>Use this API to get the customer ID for this session.</summary>

Parameters:
-  callback is a function which expects a string value

If the customer ID is not set, this API returns a null value.

```javascript
AXASDK.getCustomerId((customerId) => {
    if (customerId) {
        console.log(`received customer id: ${customerId}`);
    }
})
```
</details>


### setCustomerId( customerId, callback )
<details><summary>Use this API to set the customer ID for this session.</summary>

Parameters:
- customerId is a string containing the customer ID
- callback is a function which expects an (SDKError value)

If an empty string is passed, the customer ID is reset. An SDKError value is returned.

```javascript
var customerId = "New Customer"

AXASDK.setCustomerId(customerId, (SDKError) => {
    switch (SDKError) {
      case ErrorNone:
        console.log(`CustomerId set successfully.`);
        break;
      case ErrorNoTransactionName:
      case ErrorTransactionInProgress:
      case ErrorFailedToTakeScreenshot:
      case ErrorInvalidValuesPassed:
      default:
        console.log(`Error setting customer Id: ${SDKError}`);
    }
})
```

#### SDKError Values
-   ErrorNone
-   ErrorNoTransactionName
-   ErrorTransactionInProgress
-   ErrorFailedToTakeScreenshot
-   ErrorInvalidValuesPassed

To retrieve these constants include the following code prior to use:
```javascript
const AXASDK = NativeModules.ReactNativeAxaMobileSdk;

// Set constants for SDKError
const { ErrorNone }                        = AXASDK.getConstants();
const { ErrorNoTransactionName }           = AXASDK.getConstants();
const { ErrorTransactionInProgress }       = AXASDK.getConstants();
const { ErrorFailedToTakeScreenshot }      = AXASDK.getConstants();
const { ErrorInvalidValuesPassed }         = AXASDK.getConstants();
```

</details>


### setSessionAttribute( name, value, callback )
<details><summary>Use this API to set a custom session attribute.</summary>

Parameters:
-  name is a string containing the name of the attribute
- value is a string containing the value for the attribute
- callback is a function which expects an (SDKError value)

If an empty string is passed, the customer id is reset. An SDKError value is returned.

```javascript
var attributeName = "ClientDemo";
var attributeValue = "NewFeatures";

AXASDK.setSessionAttribute(attributeName, attributeValue, (SDKError) => {
    switch (SDKError) {
      case ErrorNone:
        console.log(`Session attribute ${attributeName}=${attributeValue} set successfully.`);
        break;
      case ErrorNoTransactionName:
      case ErrorTransactionInProgress:
      case ErrorFailedToTakeScreenshot:
      case ErrorInvalidValuesPassed:
      default:
        console.log(`Error setting session attribute: SDKError:${SDKError}`);
    }
})
```

#### SDKError Values
-   ErrorNone
-   ErrorNoTransactionName
-   ErrorTransactionInProgress
-   ErrorFailedToTakeScreenshot
-   ErrorInvalidValuesPassed

To retrieve these constants include the following code prior to use:
```javascript
const AXASDK = NativeModules.ReactNativeAxaMobileSdk;

// Set constants for SDKError
const { ErrorNone }                        = AXASDK.getConstants();
const { ErrorNoTransactionName }           = AXASDK.getConstants();
const { ErrorTransactionInProgress }       = AXASDK.getConstants();
const { ErrorFailedToTakeScreenshot }      = AXASDK.getConstants();
const { ErrorInvalidValuesPassed }         = AXASDK.getConstants();
```

</details>


### enterPrivateZone()
<details><summary>Use this API to stop collecting potentially sensitive data.</summary>

The following data is not collected when the app enters a private zone:
- Screenshots
- Location information including GPS and IP addresses
- Values in any text entry fields

The SDK is enabled by default.  You need to call this API only if you called disableSDK earlier.

```javascript
AXASDK.enterPrivateZone();
```
</details>


### exitPrivateZone()
<details>
<summary>Use this API to start collecting all data again.</summary>

```javascript
AXASDK.exitPrivateZone();
```
</details>


### isInPrivateZone( callback )
<details>
<summary>Use this API to determine if the SDK is in a private zone.</summary>

Parameters:
- callback is a function which expects a boolean value

```javascript
AXASDK.isInPrivateZone((inPrivateZone) => {
    if (inPrivateZone) {
        // private zone action
    } else {
        // non-private zone action
    }
    console.log(`SDK is in private zone: ${inPrivateZone}`);
})
```
</details>


### getAPMHeader( callback )
<details>
<summary>Use this API to get the SDK computed APM header in key value format.</summary>

Parameters:
-  callback is a function which expects a dictionary or map of key, value pairs

```javascript
AXASDK.getAPMHeader((headers) => {
    if (headers) {
        console.log(`received apm headers: ${headers}`);
        // TOTO: show how to access values in this dictionary
        // using values, keys, or entries
        //
        for (const [key, value] of Object.entries(headers)) {
            console.log(`${key}: ${value}`);
        }

    }
})
```
</details>


### addToAPMHeader( data )
<details>
<summary>Use this API to add custom data to the SDK computed APM header.</summary>

Parameters:
-  data is a non-empty string in the form of "key=value".

data will be appended to the APM header separated by a semicolon (;).

```javascript
var newAPMData = "PrivateKey=PrivateInfo";

AXASDK.addToAPMHeader(newAPMData);
```
</details>


### setSSLPinningMode( pinningMode, pinnedValues )
<details>
<summary>Use this API to set the ssl pinning mode and array of pinned values.</summary>

Parameters:
- pinningMode is one of the CAMDOSSLPinning modes described below
- pinnedValues is an array as required by the pinning mode

```javascript
var pinningMode = CAMDOSSLPinningModeFingerPrintSHA1Signature;
var pinnedValues = [--array of SHA1 fingerprint values--];

AXASDK.setSSLPinningMode(pinningMode, pinnedValues);       
```

####Supported pinning modes:
```javascript
- CAMDOSSLPinningModePublicKey OR CAMDOSSLPinningModeCertificate
        - array of certificate data (NSData from SeccertificateRef)
        - or, certificate files(.cer) to be present in the resource bundle
- CAMDOSSLPinningModeFingerPrintSHA1Signature
        - array of SHA1 fingerprint values
- CAMDOSSLPinningModePublicKeyHash
        - array of PublicKeyHashValues
```
</details>


### stopCurrentSession()
<details>
<summary>Use this API to stop the current session.</summary>

No data will be logged until the startSession API is called.

```javascript
AXASDK.stopCurrentSession();
```
</details>


### startNewSession()
<details>
<summary>Use this API to start a new session.</summary>

If a session is already in progress, it will be stopped and new session is started.

```javascript
AXASDK.startNewSession();
```
</details>


### stopCurrentAndStartNewSession()
<details>
<summary>Convenience API to stop the current session in progress and start a new session.</summary>

Equivalent to calling stopCurrentSession() followed by startNewSession()

```javascript
AXASDK.stopCurrentAndStartNewSession();
```
</details>


### startApplicationTransaction( transactionName, serviceName, callback )
<details>
<summary>Use this API to start a transaction with a specific name and an optional serviceName.</summary>

Parameters:
- transactionName is a string to indicate the transaction being processed
- serviceName is a string to indicate the service or application being applied
- callback is a function expecting a boolean completed, and a string errorString

If successful, completed = YES and errorString = an empty string.
In case of failure, completed = NO and errorString = an error message.
Error message will contain the error domain, a code, and a localized description.

```javascript
var transactionName = "subscription";
var serviceName = "MyApp"";
// serviceName may also be null

AXASDK.startApplicationTransaction(transactionName, serviceName, (completed, errorString) => {
    if (completed) {
        // everything is fine
        console.log(`***transaction ${transactionName} started (${completed}) ${errorString}`);
    } else {
        if (errorString) {
            // process error message
            console.log(`***transaction error: ${errorString}`)
        }
    }
})
```
</details>


### stopApplicationTransaction( transactionName, failureString, callback )
<details>
<summary>Use this API to stop a transaction with a specific name and an optional failure string.</summary>

Parameters:
- transactionName is a string to indicate the transaction being processed
- failureString is a string to indicate the failure name, message or type
- callback is a function expecting a boolean completed, and a string errorString

If successful, completed = YES and errorString = an empty string.
In case of failure, completed = NO and errorString = an error message.
Error message will contain the error domain, a code, and a localized description.

```javascript
var transactionName = "subscription";
var failureString = "Mismatched Arguments";
// failureString may also be null

AXASDK.stopApplicationTransaction(transactionName, failureString, (completed, errorString) => {
    if (completed) {
        // everything is fine
        console.log(`***transaction ${transactionName} stopped (${completed}) ${errorString}`);
    } else {
        if (errorString) {
            // process error message
            console.log(`error stopping transaction: ${errorString}`)
        }
    }
})
```
</details>



### setCustomerFeedback( feedback )
<details>
<summary>Use this API to provide feedback from the customer after a crash.</summary>

Parameters:
-  feedback is a string containing any customer feedback for the crash.

The App has to register for CAMAA_CRASH_OCCURRED notification
and collect the feedback from the user while handling the notification.
See the [Getting Started](#getting-started) documentation for more details.

```javascript
var feedback = "something interesting happened";
AXASDK.setCustomerFeedback(feedback);
```
</details>


### setCustomerLocation( postalCode, countryCode )
<details>
<summary>Use this API to set Location of the Customer/User
using postalCode and countryCode.</summary>

Parameters:
- postalCode is a string with the postal code, e.g. zip code in the US.
- countryCode is a string with the two letter international code for the country

```javascript
var postalCode = "95200";
var countryCode = "US";
AXASDK.setCustomerLocation(postalCode, countryCode);
```
</details>


### sendScreenShot( screenName, imageQuality, callback )
<details>
<summary>Use this API to send a screen shot of the current screen.</summary>

Parameters:
- screenName is a string to indicate the desired name for the screen
- imageQuality is number indicating the quality of the image between 0.0 and 1.0
- callback is a function expecting a boolean completed, and a string errorString

Using raw numbers for  imageQuality may produce unexpected results.
Use the CAMAA_SCREENSHOT_QUALITY values shown below for best results.

If successful, completed = YES and errorString = an empty string.
In case of failure, completed = NO and errorString = an error message.
Error message will contain the error domain, a code, and a localized description.

```javascript
var screenName = "My custom Screen";
var imageQuality = CAMAA_SCREENSHOT_QUALITY_MEDIUM;

AXASDK.sendScreenShot(screenName, imageQuality, (completed, errorString) => {
    if (completed) {
        // everything is fine
        console.log(`***screen shot sent (${completed}) ${errorString}`);
    } else {
        if (errorString) {
            // process error message
            console.log(`error sending screen shot: ${errorString}`)
        }
    }
})
```

#### imageQuality values
The following values for imageQuality are defined:
- CAMAA_SCREENSHOT_QUALITY_HIGH
- CAMAA_SCREENSHOT_QUALITY_MEDIUM
- CAMAA_SCREENSHOT_QUALITY_LOW
- CAMAA_SCREENSHOT_QUALITY_DEFAULT

To retrieve these constants include the following code prior to use:
```javascript
const AXASDK = NativeModules.ReactNativeAxaMobileSdk;

// Set constants for CAMAA_SCREENSHOT_QUALITY
const { CAMAA_SCREENSHOT_QUALITY_HIGH }    = AXASDK.getConstants();
const { CAMAA_SCREENSHOT_QUALITY_MEDIUM }  = AXASDK.getConstants();
const { CAMAA_SCREENSHOT_QUALITY_LOW }     = AXASDK.getConstants();
const { CAMAA_SCREENSHOT_QUALITY_DEFAULT } = AXASDK.getConstants();
```
</details>


### viewLoaded( viewName, loadTime, callback )
<details>
<summary>Use this API to create a custom app flow with dynamic views.</summary>

Parameters:
- viewName is the name of the view that was loaded
- loadTime is the time it took to load the view
- callback is a function expecting a boolean completed, and a string errorString

If successful, completed = YES and errorString = an empty string.
In case of failure, completed = NO and errorString = an error message.
Error message will contain the error domain, a code, and a localized description.

```javascript
var viewName = "my custom view";
var loadTime = 237;

AXASDK.viewLoaded(viewName, loadTime, (completed, errorString) => {
    if (completed) {
        // everything is fine
        console.log(`***view load recorded (${completed}) ${errorString}`);
    } else {
        if (errorString) {
            // process error message
            console.log(`error recording view load: ${errorString}`)
        }
    }
})
```
</details>


### ignoreView( viewName )
<details>
<summary>Use this API to set the name of a view to be ignored</summary>

Parameters:
-  viewName is Name of the view to be ignored.

Screenshots and transitions of the views that are in ignore list are not captured.
If more than one view is to be ignored, [the API call ignoreViews()](#ignoreViews)
may be called with a list.

```javascript
var viewName = "view1";

AXASDK.ignoreView(viewName);
```
</details>


### ignoreViews( viewNames )
<details>
<summary>Use this API to provide a list of view names to be ignored.</summary>

Parameters:
-  viewNames is a list (an Array) of names of the views to be ignored.

Screenshots and transitions of the views that are in ignore list are not captured.
If only a signle view name is to be ignored, [the API call ignoreView()](#ignoreView)
may be called with the view name.

```javascript
var viewNames = ["view1", "view2", ..., "viewN"];

AXASDK.ignoreViews(viewNames);
```
</details>


### isScreenshotPolicyEnabled( callback )
<details>
<summary>Use this API to determine if automatic screenshots are enabled by policy.</summary>

Parameters:
-  callback is a function which expects a boolean value

Returns YES if screenshots are enabled by policy.  Otherwise returns NO.

```javascript
AXASDK.isScreenshotPolicyEnabled((isEnabled) => {
    if (isEnabled) {
         // enabled action
    } else {
        // non-enabled action
    }
    console.log(`Screenshots enabled by policy: ${isEnabled}`);
})
```
</details>


### logNetworkEvent( url, status, responseTime, inBytes, outBytes, callback )
<details>
<summary>Use this API to add a custom network event in the current session.</summary>

Parameters:
- url is a string reprentation of the network URL to be logged
- status is an integer value indicating the status, e.g. 200, 404, etc.
- responseTime is an integer value representing the response time
- inBytes is an integer value representing the number of bytes input
- outBytes is an integer value representing the number of bytes output
- callback is a function expecting a boolean completed, and a string errorString

If successful, completed = YES and errorString = an empty string.
In case of failure, completed = NO and errorString = an error message.
Error message will contain the error domain, a code, and a localized description.

```javascript
var url = "https://myserver/specific_content/";"
var status = "OK";"
var responseTime = 234;
var inBytes = 864200;
var outBytes = 6236;

AXASDK.logNetworkEvent( url, status, responseTime, inBytes, outBytes, (completed, errorString) => {
    if (completed) {
        // everything is fine
        console.log(`***network event logged (${completed}) ${errorString}`);
    } else {
        if (errorString) {
            // process error message
            console.log(`error logging network event: ${errorString}`)
        }
    }
})
```
</details>


### logTextMetric( textMetricName, textMetricValue, attributes, callback )
<details>
<summary>Use this API to add a custom text metric in the current session.</summary>

Parameters:
- textMetricName is a string to indicate a text metric name
- textMetricValue is a string to indicate a text metric value
- attributes is a Map or Dictionary used to send any extra parameters
- callback is a function expecting a boolean completed, and a string errorString

If successful, completed = YES and errorString = an empty string.
In case of failure, completed = NO and errorString = an error message.
Error message will contain the error domain, a code, and a localized description.

```javascript
var textMetricName = "ImageName";
var textMetricValue = "Pretty Picture";
var attributes = null;

AXASDK.logTextMetric( textMetricName, textMetricValue, attributes, (completed, errorString) => {
    if (completed) {
        // everything is fine
        console.log(`***text metric logged (${completed}) ${errorString}`);
    } else {
        if (errorString) {
            // process error message
            console.log(`error logging text metric: ${errorString}`)
        }
    }
})
```
</details>


### logNumericMetric( numericMetricName, numericMetricValue, attributes, callback )
<details>
<summary>Use this API to add a custom numeric metric value in the current session.</summary>

Parameters:
- numericMetricName is a string name for a numeric metric
- numericMetricValue is a numeric value, e.g. 3.14159, 2048.95, or 42, etc.
- attributes is a Map or Dictionary used to send any extra parameters
- callback is a function expecting a boolean completed, and a string errorString

If successful, completed = YES and errorString = an empty string.
In case of failure, completed = NO and errorString = an error message.
Error message will contain the error domain, a code, and a localized description.

```javascript
var numericMetricName = "ImageWidth";
var numericMetricValue = 1080;
// if numericMetricValue is a string, remember to use
//    parseFloat(numericMetricValue) or Number(numericMetricValue)
var attributes = null;

AXASDK.logNumericMetric( numericMetricName, numericMetricValue, attributes, (completed, errorString) => {
    if (completed) {
        // everything is fine
        console.log(`***numeric metric logged(${completed}) ${errorString}`);
    } else {
        if (errorString) {
            // process error message
            console.log(`error logging numeric metric: ${errorString}`)
        }
    }
})
```
</details>


### uploadEvents( callback )
<details>
<summary>Use this API to force an upload event.</summary>

An upload event sends all information collected since any previous upload event to the APM servers.

Parameters:
- callback is a function which expects a response object and an ErrorString.

response is a key,value paired map or dictionary object which contains:
- the Key 'CAMDOResponseKey'  holds any URLResponse information
- the key 'CAMDOTotalUploadedEvents'  holds the total number of events uploaded

errorString is empty if the API call is completed, otherwise is a localized error description
```javascript
AXASDK.uploadEvents((response, errorString) => {
    if (errorString) {
        // process error message
        console.log(`error: ${errorString}`)
    } else {
        var events=response.CAMDOTotalUploadedEvents;
        var key=response.CAMDOResponseKey;
        console.log(`***uploaded ${events} events (key:${key})`);
    }
})
```
</details>


## iOS-only APIs
The iOS version of the SDK implements a few APIs which are not available in the Android version of the SDK.

The best way to handle these APIs is to put them in conditionals for the platform the App is running on rather than creating separate module.ios.js or module.android.js files.  See the example code below.


### setNSURLSessionDelegate( delegate )
<details>
<summary>Use this API to set your delegate instance to handle auth challenges.</summary>

Use it when using SDKUseNetworkProtocolSwizzling option during SDK initialization.

Parameters:
-  delegate is an iOS native object or module which responds to NSURLSessionDelegate protocols.

```javascript
import Platform from react;

if (Platform.OS == "ios") {
    AXASDK.setNSURLSessionDelegate(delegate);
}
```
</details>


### setLocation( latitude, longitude )
<details>
<summary>Use this API to set Geographic or GPS Location of the Customer.</summary>

Parameters:
- latitude is a double with the geographic latitude from -90,0 to 90.0 degrees.
- longitude is a double with the geographic longitude from -180.0 to 180.0 degrees.

```javascript
import Platform from react;

if (Platform.OS == "ios") {
    // use iOS specific location setting call
    var latitude = 34.678;
    var longitude = -122.456;
    AXASDK.setLocation(latitude, longitude);
} else {
    // use Android specific location setting call
}
```
</details>


### enableScreenShots( captureScreen )
<details>
<summary>Use this API to programmatically enable or disable automatic screen captures.</summary>

Parameters:
-  captureScreen is a boolean value to enable/disable automatic screen captures.

Normally the policy determines whether automatic screen captures are performed.
Use this API to override the policy, or the current setting of this flag.

```javascript
import Platform from react;

if (Platform.OS == "ios") {
    AXASDK.enableScreenShots(true);
      // or
    AXASDK.enableScreenShots(false);
}
```
</details>


### viewLoadedWithoutScreenCapture( viewName, loadTime, callback )
<details>
<summary>Use this API to create a custom app flow with dynamic views disabling any screen capture.</summary>

During a loadView call, on iOS only, screen captures are controlled by policy,
or the setting of the enableScreenShots API call.
The iOS SDK allows the calling API to disable automatic screen captures if they are currently enabled.
This API call prevents any screen capture during the loadView call by overriding policy for this invocation.

Parameters:
- viewName is the name of the view that was loaded
- loadTime is the time it took to load the view
- callback is a function expecting a boolean completed, and a string errorString

If successful, completed = YES and errorString = an empty string.
In case of failure, completed = NO and errorString = an error message.
Error message will contain the error domain, a code, and a localized description.

```javascript
import Platform from react;

if (Platform.OS == "ios") {
    var viewName = "my custom view";"
    var loadTime = 237;

    AXASDK.viewLoadedWithoutScreenCapture(viewName, loadTime, (completed, errorString) => {
        if (completed) {
            // everything is fine
            console.log(`***view load recorded (${completed}) ${errorString}`);
        } else {
            if (errorString) {
                // process error message
                console.log(`error recording  view load: ${errorString}`)
            }
        }
    })
}
```
</details>



## Android-only APIs
The Android version of the SDK implements a few APIs which are not available in the iOS version of the SDK.





