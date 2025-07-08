// ReactNativeAxaMobileSdkModule.java

package com.ca.axa.react;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReadableMap;

import com.ca.integration.CaMDOCallback;
import com.ca.android.app.CaMDOIntegration;

import android.location.Location;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import javax.annotation.Nullable;

import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.Arguments;

import java.util.*;

/**
 * Android Native module bridge, that provides AXA Custom metrics APIs.
 * <p>
 * Created by sugsh04 on 07/13/2021.
 */
public class ReactNativeAxaMobileSdkModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;

    public static final String TAG = ReactNativeAxaMobileSdkModule.class.getCanonicalName();

    public static final String CAMAA_SCREENSHOT_QUALITY_HIGH = "HIGH";
    public static final String CAMAA_SCREENSHOT_QUALITY_MEDIUM = "MEDIUM";
    public static final String CAMAA_SCREENSHOT_QUALITY_LOW = "LOW";

    public ReactNativeAxaMobileSdkModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "ReactNativeAxaMobileSdk";
    }

    @Nullable
    @Override
    public Map<String, Object> getConstants() {
        final Map<String, Object> constants = new HashMap<>();
        constants.put(CAMAA_SCREENSHOT_QUALITY_HIGH, CaMDOIntegration.CAMAA_SCREENSHOT_QUALITY_HIGH);
        constants.put(CAMAA_SCREENSHOT_QUALITY_MEDIUM, CaMDOIntegration.CAMAA_SCREENSHOT_QUALITY_MEDIUM);
        constants.put(CAMAA_SCREENSHOT_QUALITY_LOW, CaMDOIntegration.CAMAA_SCREENSHOT_QUALITY_LOW);
        return constants;
    }

    /** APIS  **/

    /***
     * Set the location of device
     * @param zipCode
     * @param countryCode
     */
    @ReactMethod
    public static void setCustomerLocation(String postalCode, String countryCode) {
        Log.d(TAG, "@ setCustomerLocation with (zipCode,countryCode): (" + postalCode + "," + countryCode + ")");
        CaMDOIntegration.setCustomerLocation(postalCode, countryCode);
    }

    /***
     * Set the location of device
     * @param location
     */
    @ReactMethod
    public static void setLocation(Location location) {
        Log.d(TAG, "@ setCustomerLocation with (location): " + location);
        CaMDOIntegration.setCustomerLocation(location);
    }

    /**
     * Set session attribute with the value.
     *
     * @param name  event name
     * @param value value to use for the attribute
     */
    @ReactMethod
    public static void setSessionAttribute(String name, String value, Callback callback) {
        Log.d(TAG, "@ setSessionAttribute with (name,value): (" + name + "," + value + ")");
        CaMDOIntegration.setSessionAttribute(name, value);
        if (callback != null) {
            callback.invoke(true);
        }
    }

    /**
     * Starts a new application transaction that bounds all the subsequent events
     *
     * @param transactionName name of the transaction
     * @param serviceName     name of the service
     * @param func            The callback to the application, in case of an error/success. if null
     *                        is passed in, the app receives no callbacks.
     */
    @ReactMethod
    public static void startApplicationTransaction(String transactionName, String serviceName, final Callback callback) {
        Log.d(TAG, "@ startApplicationTransaction");
        CaMDOCallback callbackLocal = new CaMDOCallback(new Handler()) {
            @Override
            public void onError(int errorCode, Exception exception) {
                Log.d(TAG, "@ startApplicationTransaction onError: errorCode " + errorCode + ", exception: " + exception);
                if (callback != null) {
                    callback.invoke(false, getErrorJson(errorCode, exception));
                }

            }

            @Override
            public void onSuccess(Bundle data) {
                Log.d(TAG, "@ startApplicationTransaction onSuccess: ( " + data);
                if (callback != null) {
                    callback.invoke(true, getBundleData(data));
                }
            }
        };
        if (serviceName == null || serviceName.trim().length() == 0) {
            Log.d(TAG, "@ startApplicationTransaction no serviceName: ");
            CaMDOIntegration.startApplicationTransaction(transactionName, callbackLocal);
        } else {
            Log.d(TAG, "@ startApplicationTransaction with serviceName: ");
            CaMDOIntegration.startApplicationTransaction(transactionName, serviceName, callbackLocal);
        }
    }

    /**
     * Stops the application transaction.  Subsequent events will be part of the previous transaction
     * if there is one
     *
     * @param transactionName name of the transaction
     * @param failure         pass <code>null</code> for a successful transaction.  If it is a failed transaction
     *                        pass a brief description about the failure
     * @param callback        The callback to the application, in case of an error/success. if null is passed
     *                        in, the app receives no callbacks.
     */
    @ReactMethod
    public static void stopApplicationTransaction(String transactionName, String failure, final Callback callback) {
        CaMDOCallback callbackInternal = new CaMDOCallback(new Handler()) {
            @Override
            public void onError(int errorCode, Exception exception) {
                if (callback != null) {
                    callback.invoke(getErrorJson(errorCode, exception));
                }

            }

            @Override
            public void onSuccess(Bundle data) {
                if (callback != null) {
                    callback.invoke(getBundleData(data));
                }
            }
        };
        if (failure == null || failure.trim().length() == 0) {
            CaMDOIntegration.stopApplicationTransaction(transactionName, callbackInternal);
        } else {
            CaMDOIntegration.stopApplicationTransaction(transactionName, failure, callbackInternal);
        }

    }


    /**
     * Sets the feedback from the user about a crash
     *
     * @param feedback
     */
    @ReactMethod
    public static void setCrashFeedback(String feedback) {
        CaMDOIntegration.setCrashFeedback(feedback);
    }

    /**
     * Sets general feedback from the user. The feedback is tagged to the
     * current session
     *
     * @param feedback
     */
    @ReactMethod
    public static void setUserFeedback(String feedback) {
        CaMDOIntegration.setUserFeedback(feedback);
    }


    /***
     * Enable SDK if its not enabled.
     *
     * When SDK is enabled, sdk will collect data for analytics.
     */
    @ReactMethod
    public static void enableSDK() {
        CaMDOIntegration.enableSDK();
    }

    /**
     * Disables SDK if its enabled.
     * When SDK is disabled, SDK will not intercept any calls and wont collect any data from App.
     */
    @ReactMethod
    public static void disableSDK() {
        CaMDOIntegration.disableSDK();
    }

    /**
     * Checks if SDK is enabled or not
     */
    @ReactMethod
    public static void isSDKEnabled(Callback callback) {
        Boolean val = new Boolean(CaMDOIntegration.isSDKEnabled());
        if (callback != null) {
            callback.invoke(val);
        }
    }

    /***
     * In Private Zone screenshots and other sensitive information will not be recorded
     */
    @ReactMethod
    public static void enterPrivateZone() {
        CaMDOIntegration.enterPrivateZone();

    }

    /***
     * Exiting private zone
     */
    @ReactMethod
    public static void exitPrivateZone() {
        CaMDOIntegration.exitPrivateZone();

    }

    /***
     * Checks if app is in private zone state.
     *
     * @return
     */
    @ReactMethod
    public static void isInPrivateZone(Callback callback) {
        Boolean val = new Boolean(CaMDOIntegration.isInPrivateZone());
        if (callback != null) {
            callback.invoke(val);
        }
    }


    /***
     * Takes screenshot of current screen and adds an event to analytics.
     *
     * @param screenName name of screenshot
     * @param imageQuality quality CaMDOIntegration.CAMAA_SCREENSHOT_QUALITY_HIGH,CaMDOIntegration.CAMAA_SCREENSHOT_QUALITY_MEDIUM , CaMDOIntegration.CAMAA_SCREENSHOT_QUALITY_LOW
     * @param callback The callback to the application, in case of an error/success. if null is passed
     *                      in, the app receives no callbacks.
     */
    @ReactMethod
    public static void sendScreenShot(String screenName, int imageQuality, final Callback callback) {
        Log.d(TAG, "@ sendScreenShot with name: " + screenName + " , quality: " + imageQuality);
        CaMDOCallback callbackInternal = new CaMDOCallback(new Handler()) {
            @Override
            public void onError(int errorCode, Exception exception) {
                if (callback != null) {
                    callback.invoke(getErrorJson(errorCode, exception));
                }

            }

            @Override
            public void onSuccess(Bundle data) {
                if (callback != null) {
                    callback.invoke(getBundleData(data));
                }
            }
        };
        CaMDOIntegration.sendScreenShot(screenName, imageQuality, callbackInternal);
    }

    /**
     * Checks whether screenshot is enabled in Policy
     *
     * @return true or false.
     */
    @ReactMethod
    public static void isScreenshotPolicyEnabled(Callback callback) {
        Boolean val = new Boolean(CaMDOIntegration.isScreenshotPolicyEnabled());
        if (callback != null) {
            callback.invoke(val);
        }
    }


    /**
     * Use this method to stop the current session.  No data will be logged until startSession
     * API is called again
     */
    @ReactMethod
    public static void stopCurrentSession() {
        CaMDOIntegration.stopCurrentSession();
    }

    /**
     * Use this method to start a new session.  If a session is already in progress, it will
     * be ended and new session is started
     */
    @ReactMethod
    public static void startNewSession() {
        CaMDOIntegration.startNewSession();
    }


    /**
     * Use this method to start a new session.  If a session is already in progress, it will
     * be ended and new session is started
     */
    @ReactMethod
    public static void stopCurrentAndStartNewSession() {
        CaMDOIntegration.stopCurrentAndStartNewSession();
    }


    /**
     * When a page or view is fully loaded take screen shot.
     *
     * @param viewName
     * @param loadTime
     * @param func     The callback to the application, in case of an error/success. if null is passed
     *                 in, the app receives no callbacks.
     */
    @ReactMethod
    public static void viewLoaded(String viewName, int loadTime, final Callback func) {
        CaMDOCallback callback = new CaMDOCallback(new Handler()) {
            @Override
            public void onError(int errorCode, Exception exception) {
                if (func != null) {
                    func.invoke(getErrorJson(errorCode, exception));
                }

            }

            @Override
            public void onSuccess(Bundle data) {
                if (func != null) {
                    func.invoke(getBundleData(data));
                }
            }
        };
        CaMDOIntegration.viewLoaded(viewName, loadTime, callback);

    }

    /**
     * API to log a network event to AXA SDK.
     *
     * @param url          URL request
     * @param status       status code of the request  ex: 200,401 etc
     * @param responseTime time taken to execute the request
     * @param inBytes      bytes received as part of request.
     * @param outBytes     bytes sent as part of request.
     * @param callback     The callback to the application, in case of an error/success. if null is passed
     *                     in, the app receives no callbacks.
     */
    @ReactMethod
    public static void logNetworkEvent(String url, int status, int responseTime, int inBytes, int outBytes, final Callback callback) {
        CaMDOCallback callbackInternal = new CaMDOCallback(new Handler()) {
            @Override
            public void onError(int errorCode, Exception exception) {
                if (callback != null) {
                    callback.invoke(getErrorJson(errorCode, exception));
                }

            }

            @Override
            public void onSuccess(Bundle data) {
                if (callback != null) {
                    callback.invoke(getBundleData(data));
                }
            }
        };
        CaMDOIntegration.logNetworkEvent(url, status, responseTime, inBytes, outBytes, callbackInternal);

    }


    /**
     * API to log a network event to MAA SDK.
     *
     * @param url          URL request
     * @param statusCode   status code of the request  ex: 200,401 etc
     * @param responseTime time taken to execute the request
     * @param inBytes      bytes received as part of request.
     * @param outBytes     bytes sent as part of request.
     */
    @ReactMethod
    public static void logNetworkEvent(String url, int statusCode, int responseTime, int inBytes, int outBytes) {
        CaMDOIntegration.logNetworkEvent(url, statusCode, responseTime, inBytes, outBytes);

    }

    /**
     * Force an upload of the aggregated event(s).This is an expensive operation and should be
     * used with caution.
     * <p>
     * To get the number of events that were uploaded, use the key
     * {@link CaMDOCallback#UPLOAD_EVENT_COUNT} on the Bundle returned by
     * {@link CaMDOCallback#onSuccess(android.os.Bundle)}
     *
     * @param callback The callback to the application, in case of an error/success. if null is passed
     *                 in, the app receives no callbacks.
     */
    @ReactMethod
    public static void uploadEvents(final Callback callback) {
        CaMDOCallback callbackInternal = new CaMDOCallback(new Handler()) {
            @Override
            public void onError(int errorCode, Exception exception) {
                if (callback != null) {
                    callback.invoke(getErrorJson(errorCode, exception));
                }

            }

            @Override
            public void onSuccess(Bundle data) {
                if (callback != null) {
                    callback.invoke(getBundleData(data));
                }
            }
        };
        CaMDOIntegration.uploadEvents(callbackInternal);
    }

    /**
     * Logs Numeric Metric.
     *
     * @param metricName
     * @param metricValue
     * @param attributes  (optional)
     * @param callback    The callback to the application, in case of an error/success. if null is passed
     *                    in, the app receives no callbacks.
     */
    @ReactMethod
    public static void logNumericMetric(String metricName, Double metricValue, ReadableMap attributes, final Callback callback) {
        Log.d(TAG, "@ logNumericMetrics with name: " + metricName + ", value: " + metricValue + ", attribs:" + attributes);
        CaMDOCallback callbackInternal = new CaMDOCallback(new Handler()) {
            @Override
            public void onError(int errorCode, Exception exception) {
                if (callback != null) {
                    callback.invoke(getErrorJson(errorCode, exception));
                }

            }

            @Override
            public void onSuccess(Bundle data) {
                if (callback != null) {
                    callback.invoke(getBundleData(data));
                }
            }
        };

        try {
            Map<String, String> newMap = transformJSMap(attributes);
            CaMDOIntegration.logNumericMetric(metricName, metricValue, newMap, callbackInternal);
        } catch (NumberFormatException e) {
            if (callback != null) {
                callback.invoke(getErrorJson(1, e));
            } else {
                Log.e(TAG, "Error in logNumericMetrics " + e);
            }

        }

    }

    /**
     * Logs Text Metric.
     *
     * @param metricName
     * @param metricValue
     * @param attributes  (optional)
     * @param callback    The callback to the application, in case of an error/success. if null is passed
     *                    in, the app receives no callbacks.
     */
    @ReactMethod
    public static void logTextMetric(String metricName, String metricValue, ReadableMap attributes, final Callback callback) {
        Log.d(TAG, "@ logTextMetrics with name: " + metricName + ", value: " + metricValue + ", attribs:" + attributes);
        CaMDOCallback callbackInternal = new CaMDOCallback(new Handler()) {
            @Override
            public void onError(int errorCode, Exception exception) {
                if (callback != null) {
                    callback.invoke(getErrorJson(errorCode, exception));
                }

            }

            @Override
            public void onSuccess(Bundle data) {
                if (callback != null) {
                    callback.invoke(getBundleData(data));
                }
            }
        };
        Map<String, String> newMap = transformJSMap(attributes);
        CaMDOIntegration.logTextMetric(metricName, metricValue, newMap, callbackInternal);

    }

    /**
     * Returns Headers for tracking Network calls in APM, via the callback-function.
     *
     * @param callback Callback function, that returns a Map containing keys (header name)
     *                 values ( value of header )
     */
    @ReactMethod
    public static void getAPMHeaders(Callback callback) {

        if (callback != null) {
            callback.invoke(toWritableMap(CaMDOIntegration.getAPMHeaders()));
        }
    }

    /**
     * Add values to APM header
     *
     * @param headerString
     */
    @ReactMethod
    public static void addToApmHeader(String headerString) {
        CaMDOIntegration.addToApmHeader(headerString);

    }

    /**
     * Get the CustomerId.
     *
     * @param func Callback function, that returns the customerId as a String.
     */
    @ReactMethod
    public static void getCustomerId(Callback func) {
        if (func != null) {
            func.invoke(CaMDOIntegration.getCustomerId());
        }

    }

    /**
     * Set the CustomerID
     */
    @ReactMethod
    public static void setCustomerId(String customerId, Callback callback) {
        Log.d(TAG, "@ setCustomerId with value " + customerId + ", callback " + callback);
        CaMDOIntegration.setCustomerId(customerId);
        if (callback != null) {
            callback.invoke(true);
        }
    }

    /**
     * Gets the DeviceId
     *
     * @param func Callback function, that returns the deviceId as a String.
     */
    @ReactMethod
    public static void getDeviceId(Callback func) {
        String deviceID = CaMDOIntegration.getDeviceId();
        if (func != null) {
            func.invoke(deviceID);
        }
    }

    @ReactMethod
    public static void ignoreView(String viewName) {
        CaMDOIntegration.ignoreView(viewName);

    }

    @ReactMethod
    public static void ignoreViews(HashSet<String> viewNames) {
        CaMDOIntegration.ignoreViews(viewNames);

    }


    /**
     * Use this API to set the ssl pinning mode and array of pinned values.
     *
     * @param pinningMode
     * @param pinnedValues
     */
    public static void setSSLPinningMode(String pinningMode, ArrayList<byte[]> pinnedValues) {
        CaMDOIntegration.setSSLPinningMode(null, pinningMode, pinnedValues);
    }

    /**
     * Use this API to log handled exception captured in try-catch blocks
     * @param name is a string to indicate a error name 
     * @param message is a string to indicate a error message
     * @param stacktrace is a string to indicate a stacktrace
     * 
     * Expected input from JavaScript:
     * try {
     * 
     * } catch (e) {
     *      NativeModules.ReactNativeAxaMobileSdk.logHandledException(e.name, e.message, e.stack);
     * }
     * 
     */
    @ReactMethod
    public void logHandledException(String name, String message, String stacktrace) {
        CaMDOIntegration.logHandledExceptionFromJS(name != null ? name : "Error", message != null ? message : "Unknown message", stacktrace);
    }

    /***
     * Throw an exception
     * @deprecated Dev Only
     */
    @ReactMethod
    public static void throwException(int type) {
        Log.d(TAG, "@ throwException of type:" + type);
        switch (type) {
            case 0:
                throw new NullPointerException("induced NPE ");

            case 1:
                throw new IllegalArgumentException("induced ArgumentException ");

            case 2:
                throw new UnknownError("induced UnknownError ");

            default:
                break;
        }
    }

    // Utility functions

    private static String getErrorJson(int errorCode, Exception e) {
        JSONObject obj = new JSONObject();
        try {
            obj.put("status", "error");
            obj.put("code", "" + errorCode);
            obj.put("reason", e.toString());
        } catch (JSONException e1) {
        }
        return obj.toString();

    }

    private static String getBundleData(Bundle data) {
        Log.d(TAG, "@ getBundleData of data:" + data);
        JSONArray returnValue = new JSONArray();
        if (data != null) {
            Set<String> keys = data.keySet();
            for (String key : keys) {
                //returnValue.put(key, data.get(key));
                JSONObject entry = new JSONObject();
                try {
                    entry.put(key, "" + data.get(key));
                } catch (JSONException e) {
                }
                returnValue.put(entry);
            }
        }
        return returnValue.toString();
    }

    private static Map<String, String> transformJSMap(ReadableMap data) {
        Map<String, String> newMap = new HashMap<>();
        if (data != null) {
            data.toHashMap();
            for (Map.Entry<String, Object> entry : data.toHashMap().entrySet()) {
                newMap.put(entry.getKey(), "" + entry.getValue());
            }
        }
        return newMap;
    }

    private static WritableMap toWritableMap(Map<String, String> map) {
        WritableMap writableMap = Arguments.createMap();
        if (map != null) {
            Iterator iterator = map.entrySet().iterator();

            while (iterator.hasNext()) {
                Map.Entry pair = (Map.Entry) iterator.next();
                Object value = pair.getValue();
                writableMap.putString((String) pair.getKey(), (String) value);
                iterator.remove();
            }
        }
        return writableMap;
    }
}
