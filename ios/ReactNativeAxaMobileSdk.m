/*
 *
 * Copyright (c) 2013-2021 CA Technologies (A Broadcom Company)
 * All rights reserved.
 *
 */

/**
 * iOS Native module bridge, that routes the calls to {@link CAMDOReporter} APIs.
 *
 * The React Native app (from its js files) will call this native module,
 * to use the AXA Custom metrics APIs.
 *
 */

#import "ReactNativeAxaMobileSdk.h"
#import <UIKit/UIKit.h>
#import "CAMDOReporter.h"
#import <CoreLocation/CoreLocation.h>
#import <React/RCTConvert.h>

// For custom application version string to be read from bundle (info.plist) use "AXAAppShortVersionString"  as key in info.plist.

/*
 Custom Keys to override AXA SDK behavior , placed in App's Info.plist.
 Key : "AXAAppShortVersionString";   ex : 7.7.2
 Key : "AXACLLocationLevel";   String - one of the values :     "BestForNavigation" ,"NearestTenMeters" , "HundredMeters" ,"Kilometer" ,"ThreeKilometers"
 Key : "AXACollectIp";  Boolean : True/False
 Key : "AXAMaxUploadNetworkCallsLimit";  String  : 1 - 10
 Key : "AXADisabledInterceptors";  Array : NSURLConnection ,NSURLSession ,UIActivityIndicatorView ,UIApplication , WKWebView , Gestures , Touch ; Note : Including UIApplication disables SDK.
 Key : "AXANavigationThrottle" ; String - 1000 , time in milliseconds to throttle navigation collection;
 Key : "AXAActiveSessionTimeOut" ; String, time in milliseconds to stop and start the new session when your app is a continuously active state
 */

#pragma mark - Enum Values

// Enums for SDK Errors
@implementation RCTConvert (SDKErrorExtension)
RCT_ENUM_CONVERTER(SDKError,
    (@{ @"ErrorNone"                        : @(ErrorNone),
        @"ErrorNoTransactionName"           : @(ErrorNoTransactionName),
        @"ErrorTransactionInProgress"       : @(ErrorTransactionInProgress),
        @"ErrorFailedToTakeScreenshot"      : @(ErrorFailedToTakeScreenshot),
        @"ErrorInvalidValuesPassed"         : @(ErrorInvalidValuesPassed)
     }),
    ErrorNone, integerValue)
@end

//Enums for the pinningMode during the SSL handshake
@implementation RCTConvert (CAMDOSSLPinningModeExtension)
RCT_ENUM_CONVERTER(CAMDOSSLPinningMode,
    (@{ @"CAMDOSSLPinningModeNone"                      : @(CAMDOSSLPinningModeNone),
        @"CAMDOSSLPinningModePublicKey"                 : @(CAMDOSSLPinningModePublicKey),
        @"CAMDOSSLPinningModeCertificate"               : @(CAMDOSSLPinningModeCertificate),
        @"CAMDOSSLPinningModeFingerPrintSHA1Signature"  : @(CAMDOSSLPinningModeFingerPrintSHA1Signature),
        @"CAMDOSSLPinningModePublicKeyHash"             : @(CAMDOSSLPinningModePublicKeyHash)
     }),
    CAMDOSSLPinningModeNone, integerValue)
@end


@implementation ReactNativeAxaMobileSdk

RCT_EXPORT_MODULE()

/* Note: For native iOS all callbacks return an RCTResponseSenderBlock,
 * which is effectively an array of values.
 * Please reference the README.md file for further details.
 *
 */

#pragma mark - React Exports

- (NSDictionary *)constantsToExport
{
  return @{
    @"ErrorNone"                                    : @(ErrorNone),
    @"ErrorNoTransactionName"                       : @(ErrorNoTransactionName),
    @"ErrorTransactionInProgress"                   : @(ErrorTransactionInProgress),
    @"ErrorFailedToTakeScreenshot"                  : @(ErrorFailedToTakeScreenshot),
    @"ErrorInvalidValuesPassed"                     : @(ErrorInvalidValuesPassed),

    @"CAMDOSSLPinningModeNone"                      : @(CAMDOSSLPinningModeNone),
    @"CAMDOSSLPinningModePublicKey"                 : @(CAMDOSSLPinningModePublicKey),
    @"CAMDOSSLPinningModeCertificate"               : @(CAMDOSSLPinningModeCertificate),
    @"CAMDOSSLPinningModeFingerPrintSHA1Signature"  : @(CAMDOSSLPinningModeFingerPrintSHA1Signature),
    @"CAMDOSSLPinningModePublicKeyHash"             : @(CAMDOSSLPinningModePublicKeyHash),

    @"CAMAA_SCREENSHOT_QUALITY_HIGH"                : @(CAMAA_SCREENSHOT_QUALITY_HIGH),
    @"CAMAA_SCREENSHOT_QUALITY_MEDIUM"              : @(CAMAA_SCREENSHOT_QUALITY_MEDIUM),
    @"CAMAA_SCREENSHOT_QUALITY_LOW"                 : @(CAMAA_SCREENSHOT_QUALITY_LOW),
    @"CAMAA_SCREENSHOT_QUALITY_DEFAULT"             : @(CAMAA_SCREENSHOT_QUALITY_DEFAULT),

    @"CAMAA_CRASH_OCCURRED"                         : @"CAMAA_CRASH_OCCURRED",
    @"CAMAA_UPLOAD_INITIATED"                       : @"CAMAA_UPLOAD_INITIATED"
  }; //Register for SDK data upload notification. The receiver is notified when SDK uploads the data to the Collector.
};

/**
 * We should also implement + requiresMainQueueSetup to let React Native know
 * if our module needs to be initialized on the main thread.
 * Otherwise we will see a warning that in the future our module may be initialized
 *  on a background thread unless we explicitly opt out with + requiresMainQueueSetup:
 *
 */
+ (BOOL)requiresMainQueueSetup
{
  return YES;  // only do this if our module initialization relies on calling UIKit!
}


#pragma mark - Sample Method Call

RCT_EXPORT_METHOD(sampleMethod:(NSString *)stringArgument numberParameter:(nonnull NSNumber *)numberArgument callback:(RCTResponseSenderBlock)callback)
{
    // TODO: Implement some actually useful functionality
    callback(@[[NSString stringWithFormat: @"numberArgument: %@ stringArgument: %@", numberArgument, stringArgument]]);
}


#pragma mark - Internal Functions

/**
 * This function is internal and only for passing NSError * items to JS as a string
 */
NSString * CAMAAErrorString(NSError *error) {
  if (!error) {
    return [NSString string].copy;
  }
  return [NSString stringWithFormat:@"%@: %ld %@",
          error.domain, (long)error.code, error.userInfo[@"NSLocalizedDescription"]].copy;
}


#pragma mark - APIs

/**
 * Use this API to disable the SDK.
 * When disabled, the SDK no longer does any tracking of the application,
 * or user interaction.
 *
 */
RCT_EXPORT_METHOD(disableSDK)
{
  [CAMDOReporter disableSDK];
}

/**
 * Use this API to enable SDK.
 * The SDK is enabled by default. You need to call this API
 * only if you called disableSDK earlier.
 *
 */
RCT_EXPORT_METHOD(enableSDK)
{
  [CAMDOReporter enableSDK];
}

/**
 * Use this API to determine if the SDK is enabled or not.
 *
 * @param callback is a function which expects a boolean value
 *
 */
RCT_EXPORT_METHOD(isSDKEnabled:(RCTResponseSenderBlock)callback)
{
    BOOL isEnabled = [CAMDOReporter isSDKEnabled];
    callback(@[@(isEnabled)]);
}

/**
 * Use this API to get the unique device ID generated by the SDK
 *
 * @param callback is a function which expects an string value
 *
 */
RCT_EXPORT_METHOD(getDeviceId:(RCTResponseSenderBlock)callback)
{
    NSString *deviceId = [CAMDOReporter deviceId];
    callback(@[deviceId]);
}

/**
 * Use this API to get the customer ID for this session.
 * @param callback is a function which expects an string value
 *
 * If the customer ID is not set, this API returns a null value.
 *
 */
RCT_EXPORT_METHOD(getCustomerId:(RCTResponseSenderBlock)callback)
{
    NSString *customerID = [CAMDOReporter customerId];
    callback(@[RCTNullIfNil(customerID)]);
}

/**
 * Use this API to set the customer ID for this session.
 *
 * @param customerId is a string containing the customer ID
 * @param callback is a function which expects an (SDKError value)
 *
 * If an empty string is passed, the customer iD is reset.
 *
 */
RCT_EXPORT_METHOD(setCustomerId:(NSString *) customerId callback:(RCTResponseSenderBlock)callback)
{
  SDKError error = [CAMDOReporter setCustomerId:customerId];
  callback(@[@(error)]);
}

/**
 * Use this API to set a custom session attribute.
 *
 * @param name is a string containing the attribute name
 * @param value is string containing the attribute value
 * @param callback is a function which expects an (SDKError value)
 *
 * If an empty string is passed, the customer id is reset.
 * An SDKError value is returned.
 *
 */
RCT_EXPORT_METHOD(setSessionAttribute:(NSString *) name withValue:(NSString *)value  callback:(RCTResponseSenderBlock)callback)
{
  SDKError error = [CAMDOReporter setSessionAttribute:name withValue:value];
  callback(@[@(error)]);
}

/**
 * Use this API to stop collecting potentially sensitive data.
 *
 * The following data is not collected when the app enters a private zone
 *    - Screenshots
 *    - Location information including GPS and IP addresses
 *    - Value in the text entry fields
 *
 */
RCT_EXPORT_METHOD(enterPrivateZone)
{
  [CAMDOReporter enterPrivateZone];
}

/**
 * Use this API to start collecting all data again
 */
RCT_EXPORT_METHOD(exitPrivateZone)
{
  [CAMDOReporter exitPrivateZone];
}

/**
 * Use this API to determine if the SDK is in a private zone.
 *
 * @param callback is a function which expects a boolean value
 *
 */
RCT_EXPORT_METHOD(isInPrivateZone:(RCTResponseSenderBlock)callback)
{
    BOOL isInPrivateZone = [CAMDOReporter isInPrivateZone];
    callback(@[@(isInPrivateZone)]);
}

/**
 * Use this API to get the SDK computed APM header in key value format.
 * @param callback is a function which expects dictionary or map of key, value pairs
 * Returns an empty string if apm header cannot be computed
 *
 */
RCT_EXPORT_METHOD(getAPMHeader:(RCTResponseSenderBlock)callback)
{
    NSDictionary *apmHeader = [CAMDOReporter apmHeader];
    callback(@[RCTNullIfNil(apmHeader)]);
}

/**
 * Use this API to add custom data to the SDK computed APM header.
 * @param data is a non-empty string in the form of "key=value".
 * data will be appended to the APM header separated by a semicolon (;).
 *
 */
RCT_EXPORT_METHOD(addToAPMHeader:(NSString *)data)
{
  [CAMDOReporter addToApmHeader:data];
}

/**
 * Use this API to set the ssl pinning mode and array of pinned values.
 * This method expects array of values depending on the pinningMode
 *
 * @param pinningMode is one of the CAMDOSSLPinning modes described below
 * @param pinnedValues is an array as required by the pinning mode
 *
 * Supported pinning modes:
 * CAMDOSSLPinningModePublicKey OR CAMDOSSLPinningModeCertificate
 *          - array of certificate data (NSData from SeccertificateRef)
 *          - or, certificate files(.cer) to be present in the resource bundle
 *
 * CAMDOSSLPinningModeFingerPrintSHA1Signature
 *          - array of SHA1 fingerprint values
 *
 * CAMDOSSLPinningModePublicKeyHash
 *          - array of PublicKeyHashValues
 */
RCT_EXPORT_METHOD(setSSLPinningMode:(CAMDOSSLPinningMode) pinningMode withValues:(NSArray*)pinnedValues)
{
  [CAMDOReporter setSSLPinningMode:pinningMode withValues:pinnedValues];
}

/**
 * Use this API to stop the current session.
 * No data will be logged until the startSession API is called
 *
 */
RCT_EXPORT_METHOD(stopCurrentSession)
{
    [CAMDOReporter stopCurrentSession];
}

/**
 * Use this API to start a new session.
 * If a session is already in progress, it will be stopped and new session is started
 *
 */
RCT_EXPORT_METHOD(startNewSession)
{
    [CAMDOReporter startNewSession];
}

/**
 * Convenience API to stop the current session in progress and start a new session
 * Equivalent to calling stopCurrentSession() and startNewSession()
 */
RCT_EXPORT_METHOD(stopCurrentAndStartNewSession)
{
    [CAMDOReporter stopCurrentAndStartNewSession];
}

/**
 * Use this API to start a transaction with a specific name (and a service name)
 *
 * @param transactionName is a string to indicate the transaction being processed
 * @param serviceName is a string to indicate the service or application being applied
 * @param callback is a function expecting a boolean completed, a string errorString
 *
 * If successful, completed = YES and errorString = an empty string.
 * In case of failure, completed = NO and errorString = an error message.
 * Error message will contain the error domain, a code, and a localized description.
 *
 */
RCT_EXPORT_METHOD(startApplicationTransaction:(NSString *) transactionName  service:(NSString *)serviceName completionHandler:(RCTResponseSenderBlock) callback)
{
  void (^completion)(BOOL completed, NSError *error) =  ^(BOOL completed, NSError *error) {
      callback(@[@(completed), CAMAAErrorString(error)]);
  };
  if (serviceName) {
    [CAMDOReporter startApplicationTransactionWithName: transactionName service: serviceName completionHandler:completion];
  }
  else {
    [CAMDOReporter startApplicationTransactionWithName: transactionName completionHandler: completion];
  }
}

/**
 * Use this API to stop a transaction with a specific name and an optional failure string
 *
 * @param transactionName is a string to indicate the transaction being processed
 * @param failureString is a string to indicate the failure name, message or type
 * @param callback is a function expecting a boolean completed, a string errorString
 *
 * If successful, completed = YES and errorString = an empty string.
 * In case of failure, completed = NO and errorString = an error message.
 * Error message will contain the error domain, a code, and a localized description.
 *
 */
RCT_EXPORT_METHOD(stopApplicationTransaction:(NSString *) transactionName failure:(NSString *) failureString completionHandler:(RCTResponseSenderBlock) callback)
{
    void (^completion)(BOOL completed, NSError *error) =  ^(BOOL completed, NSError *error) {
        callback(@[@(completed), CAMAAErrorString(error)]);
    };
    if (failureString) {
        [CAMDOReporter stopApplicationTransactionWithName: transactionName failure:failureString completionHandler:completion];
    }
    else {
        [CAMDOReporter stopApplicationTransactionWithName: transactionName completionHandler: completion];
    }
}

/**
 * Use this API to provide feedback from the user after a crash
 *
 * @param feedback is a string containing any customer feedback for the crash
 *
 * The App has to register for CAMAA_CRASH_OCCURRED notification
 * and collect the feedback from the user while handling the notification
 *
 */
RCT_EXPORT_METHOD(setCustomerFeedback:(NSString *) feedback)
{
    [CAMDOReporter setCustomerFeedback: feedback];
}

/**
 * Use this API to set Location of the Customer/User
 * using postalCode and countryCode.
 *
 * @param postalCode is the country's postal code, e.g. zip code in the US
 * @param countryCode is the two letter international code for the country
 *
 */
RCT_EXPORT_METHOD(setCustomerLocation:(NSString *) postalCode andCountry:(NSString *) countryCode)
{
  [CAMDOReporter setCustomerLocation:postalCode andCountry:countryCode];
}

/**
 * Use this API to send a screen shot of the current screen
 *
 * @param screenName is a string to indicate the desired name for the screen
 * @param imageQuality is number indicating the quality of the image between 0.0 and 1.0
 * @param callback is a function expecting a boolean completed, a string errorString
 *
 * The following values for imageQuality are defined:
 * - CAMAA_SCREENSHOT_QUALITY_HIGH
 * - CAMAA_SCREENSHOT_QUALITY_MEDIUM
 * - CAMAA_SCREENSHOT_QUALITY_LOW
 * - CAMAA_SCREENSHOT_QUALITY_DEFAULT
 *
 * The default value is CAMAA_SCREENSHOT_QUALITY_LOW.
 *
 * If successful, completed = YES and errorString = an empty string.
 * In case of failure, completed = NO and errorString = an error message.
 * Error message will contain the error domain, a code, and a localized description.
 *
 */
RCT_EXPORT_METHOD(sendScreenShot:(NSString *) name withQuality:(CGFloat) quality completionHandler:(RCTResponseSenderBlock) callback)
{
    [CAMDOReporter sendScreenShot: name withQuality: quality completionHandler: ^(BOOL completed, NSError *error) {
      callback(@[@(completed), CAMAAErrorString(error)]);
    }];
}

/**
 * Use this API to create a custom app flow with dynamic views
 *
 * @param viewName is the name of the view that was loaded
 * @param loadTime is the time it took to load the view
 * @param callback is a function expecting a boolean completed, a string errorString
 *
 * If successful, completed = YES and errorString = an empty string.
 * In case of failure, completed = NO and errorString = an error message.
 * Error message will contain the error domain, a code, and a localized description.
 *
 */
RCT_EXPORT_METHOD(viewLoaded:(NSString *) viewName loadTime:(CGFloat) loadTime completionHandler:(RCTResponseSenderBlock) callback)
{
    [CAMDOReporter viewLoaded: viewName loadTime: loadTime completionHandler: ^(BOOL completed, NSError *error) {
        callback(@[@(completed), CAMAAErrorString(error)]);
    }];
}

/**
 * Use this API to set the name of a view to be ignored
 * @param viewName is Name of the view to be ignored
 * Screenshots and transitions of the views that are in ignore list are not captured
 *
 */
RCT_EXPORT_METHOD(ignoreView:(NSString *) viewName)
{
    [CAMDOReporter ignoreView: viewName];
}

/**
 * Use this API to provide a list of view names to be ignored.
 * @param viewNames is a list (an array) of names of the views to be ignored.
 * Screenshots and transitions of the views that are in the
 * ignore list are not captured
 *
 */
RCT_EXPORT_METHOD(ignoreViews:(NSSet *) viewNames) 
{
    [CAMDOReporter ignoreViews: viewNames];
}


/**
 * Use this API to determine if automatic screenshots are enabled by policy.
 * @param callback is a function which expects a boolean value
 * Returns YES if screenshots are enabled by policy.  Otherwise returns NO
 */
RCT_EXPORT_METHOD(isScreenshotPolicyEnabled:(RCTResponseSenderBlock)callback)
{
    callback(@[@([CAMDOReporter isScreenshotPolicyEnabled])]);
}

/**
 * Use this API to add a custom network event in the current session
 *
 * @param url is a string reprentation of the network URL to be logged
 * @param status is an integer value indicating the status, e.g. 200, 404, etc.
 * @param responseTime is an integer value representing the response time
 * @param inBytes is an integer value representing the number of bytes input
 * @param outBytes is an integer value representing the number of bytes output
 * @param callback is a function expecting a boolean completed, a string errorString
 *
 * If successful, completed = YES and errorString = an empty string.
 * In case of failure, completed = NO and errorString = an error message.
 * Error message will contain the error domain, a code, and a localized description.
 *
 */
RCT_EXPORT_METHOD(logNetworkEvent:(NSString *) url withStatus:(NSInteger) status withResponseTime:(int64_t) responseTime withInBytes:(int64_t) inBytes withOutBytes:(int64_t) outBytes completionHandler:(RCTResponseSenderBlock) callback)
{
    [CAMDOReporter logNetworkEvent: url withStatus: status withResponseTime: responseTime withInBytes: inBytes withOutBytes: outBytes completionHandler: ^(BOOL completed, NSError *error) {
        callback(@[@(completed), CAMAAErrorString(error)]);
    }];
}

/**
 * Use this API to add a custom text metric in the current session
 *
 * @param textMetricName is a string to indicate a text metric name
 * @param textMetricValue is a string to indicate a text metric value
 * @param attributes is a Map or Dictionary used to send any extra parameters
 * @param callback is a function expecting a boolean completed, a string errorString
 *
 * If successful, completed = YES and errorString = an empty string.
 * In case of failure, completed = NO and errorString = an error message.
 * Error message will contain the error domain, a code, and a localized description.
 *
 */
RCT_EXPORT_METHOD(logTextMetric:(NSString *) textMetricName withValue:(NSString *) textMetricValue withAttributes:(nullable NSDictionary *) attributes completionHandler:(RCTResponseSenderBlock) callback)
{
    [CAMDOReporter logTextMetric: textMetricName withValue: textMetricValue withAttributes: (NSMutableDictionary *)attributes completionHandler: ^(BOOL completed, NSError *error) {
      callback(@[@(completed), CAMAAErrorString(error)]);
    }];
}

/**
 * Use this API to add a custom numeric metric value in the current session
 *
 * @param numericMetricName is a string to indicate a numeric metric name
 * @param numericMetricValue is a numeric value, e.g. 3.14159, 2048.95, or 42, etc.
 * @param attributes is a Map or Dictionary used to send any extra parameters
 * @param callback is a function expecting a boolean completed, a string errorString
 *
 * If successful, completed = YES and errorString = an empty string.
 * In case of failure, completed = NO and errorString = an error message.
 * Error message will contain the error domain, a code, and a localized description.
 *
 */
RCT_EXPORT_METHOD(logNumericMetric:(NSString *) numericMetricName withValue:(double) numericMetricValue withAttributes:(nullable NSDictionary *) attributes completionHandler:(RCTResponseSenderBlock) callback)
{
    [CAMDOReporter logNumericMetric: numericMetricName withValue: numericMetricValue withAttributes: (NSMutableDictionary *)attributes completionHandler: ^(BOOL completed, NSError *error) {
      callback(@[@(completed), CAMAAErrorString(error)]);
    }];
}

/**
 * Use this API to force an upload event.
 * This is bulk/resource consuming operation and should be used with caution
 *
 * @param callback is a function which expects a response object and an ErrorString
 *
 * Returns:
 * - response is a key,value paired map or dictionary object
 *  the Key 'CAMDOResponseKey' holds any URLResponse information
 *  the key 'CAMDOTotalUploadedEvents' holds the total number of events uploaded
 * - error is empty if the API call is completed, otherwise is a localized error description
 *
 */
RCT_EXPORT_METHOD(uploadEvents:(RCTResponseSenderBlock) callback)
{
    [CAMDOReporter uploadEventsWithCompletionHandler: ^(NSDictionary *response, NSError *error) {
      callback(@[RCTNullIfNil(response), CAMAAErrorString(error)]);
    }];
}


#pragma mark - iOS Only API calls

/**
 * Use this API to set your delegate instance to handle auth challenges.
 * Use it when using SDKUseNetworkProtocolSwizzling option
 *
 * @param delegate is an iOS native object or module which responds to the  NSURLSessionDelegate protocols.
 *
 */
RCT_EXPORT_METHOD(setNSURLSessionDelegate:(id)delegate)
{
    [CAMDOReporter setNSURLSessionDelegate:delegate];
}

/**
 * Use this API to set Geographic or GPS Location of the Customer
 *
 * @param latitude is the geographic latitude from -90.0 to 90.0 degrees
 * @param logitude is the geographic longitude from -180.0 to 180.0 degrees
 *
 */
RCT_EXPORT_METHOD(setLocation:(double) latitude and:(double) longitude)
{
    [CAMDOReporter setCustomerLocation:[[CLLocation alloc] initWithLatitude:latitude longitude:longitude]];
}

/**
 * Use this API to programmatically enable or disable automatic screen captures.
 *
 * @param captureScreen is a boolean value to enable/disable automatic screen captures.
 *
 * Normally the policy determines whether automatic screen captures are performed.
 * Use this API to override the policy, or the current setting of this flag.
 *
 */
RCT_EXPORT_METHOD(enableScreenShots:(BOOL) captureScreen)
{
    [CAMDOReporter enableScreenShots: captureScreen];
}

/**
 * Use this API to create a custom app flow with dynamic views
 *
 * During a loadView call, on iOS only, screen captures are controlled
 * by policy, or the setting of the enableScreenShots API call.
 * The iOS SDK allows the calling API to disable automatic screen
 * captures if they are currently enabled.
 * This API call prevents any screen capture during the loadView call
 * by overriding policy for this invocation.
 *
 * @param viewName is the name of the view that was loaded
 * @param loadTime is the time it took to load the view
 * @param callback is a function expecting a boolean completed, a string errorString
 *
 * If successful, completed = YES and errorString = an empty string.
 * In case of failure, completed = NO and errorString = an error message.
 * Error message will contain the error domain, a code, and a localized description.
 *
 */
RCT_EXPORT_METHOD(viewLoadedWithoutScreenCapture:(NSString *) viewName loadTime:(CGFloat) loadTime completionHandler:(RCTResponseSenderBlock) callback)
{
    [CAMDOReporter viewLoaded: viewName loadTime: loadTime screenShot: NO completionHandler: ^(BOOL completed, NSError *error) {
        callback(@[@(completed), CAMAAErrorString(error)]);
    }];
}


@end
