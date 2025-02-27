package com.nearform.calendar;

import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.icu.util.TimeZone;
import android.provider.CalendarContract;

import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;

import com.nearform.calendar.CalendarActivityHandler;

public class CalendarManagerModule extends ReactContextBaseJavaModule {
    private static final int ADD_EVENT_REQUEST_CODE = 1;
    private final CalendarActivityHandler activityEventListener = new CalendarActivityHandler();

    public CalendarManagerModule(ReactApplicationContext reactContext) {
        super(reactContext);
        reactContext.addActivityEventListener(this.activityEventListener);
    }

    @Override
    public String getName() {
        return "CalendarManager";
    }

    private TimeZone getTimeZone(ReadableMap eventDetails) {
        return eventDetails.hasKey("timeZone") ? TimeZone.getTimeZone(eventDetails.getString("timeZone")) : TimeZone.getDefault();
    }

    private Intent createCalendarIntent(ReadableMap eventDetails) {
        final Double startTime = eventDetails.getDouble("startTime");
        final Double endTime = eventDetails.getDouble("endTime");

        return new Intent(Intent.ACTION_INSERT)
            .setData(CalendarContract.Events.CONTENT_URI)
            .putExtra(CalendarContract.EXTRA_EVENT_BEGIN_TIME, startTime.longValue())
            .putExtra(CalendarContract.EXTRA_EVENT_END_TIME, endTime.longValue())
            .putExtra(CalendarContract.Events.TITLE, eventDetails.getString("name"))
            .putExtra(CalendarContract.Events.EVENT_LOCATION, eventDetails.getString("location"))
            .putExtra(CalendarContract.Events.EVENT_TIMEZONE, this.getTimeZone(eventDetails).getID());
    }

    @ReactMethod
    public void addEvent(ReadableMap eventDetails, Promise promise) {
        final Intent calendarIntent = this.createCalendarIntent(eventDetails);
        this.activityEventListener.setPromise(promise);

        try {
            getCurrentActivity().startActivityForResult(calendarIntent, ADD_EVENT_REQUEST_CODE);
        } catch (ActivityNotFoundException e) {
            promise.reject("ERR_NO_CALENDAR", e);
        }
    }
}
