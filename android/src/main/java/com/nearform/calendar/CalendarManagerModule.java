package com.nearform.calendar;

import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.provider.CalendarContract;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;

public class CalendarManagerModule extends ReactContextBaseJavaModule {
    public CalendarManagerModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "CalendarManager";
    }

    @ReactMethod
    public void addEvent(ReadableMap details, Promise promise) {
        final String name = details.getString("name");
        final String location = details.getString("location");
        // Double is used since int is not big enough to fit all values of a JavaScript Number
        final Double startTime = details.getDouble("startTime"); // millis since Unix epoch
        final Double endTime = details.getDouble("endTime"); // millis since Unix epoch

        final Intent intent = new Intent(Intent.ACTION_INSERT)
                .setData(CalendarContract.Events.CONTENT_URI)
                .putExtra(CalendarContract.EXTRA_EVENT_BEGIN_TIME, startTime.longValue())
                .putExtra(CalendarContract.EXTRA_EVENT_END_TIME, endTime.longValue())
                .putExtra(CalendarContract.Events.TITLE, name)
                .putExtra(CalendarContract.Events.EVENT_LOCATION, location);

        try {
            getCurrentActivity().startActivity(intent);
            promise.resolve(null);
        } catch (ActivityNotFoundException e) {
            promise.reject("ERR_NO_CALENDAR", e);
        }
    }
}
