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

import com.nearform.calendar.CalendarActivityHandler;
import com.nearform.calendar.CalendarEvent;

public class CalendarManagerModule extends ReactContextBaseJavaModule {
    private static final int ADD_EVENT_REQUEST_CODE = 1;
    private final CalendarActivityHandler activityEventListener = new CalendarActivityHandler();

    public CalendarManagerModule(final ReactApplicationContext reactContext) {
        super(reactContext);
        reactContext.addActivityEventListener(this.activityEventListener);
    }

    @Override
    public String getName() {
        return "CalendarManager";
    }

    private Intent createCalendarIntent(final CalendarEvent calendarEvent) {
        return new Intent(Intent.ACTION_INSERT)
            .setData(CalendarContract.Events.CONTENT_URI)
            .putExtra(CalendarContract.EXTRA_EVENT_BEGIN_TIME, calendarEvent.startTime)
            .putExtra(CalendarContract.EXTRA_EVENT_END_TIME, calendarEvent.endTime)
            .putExtra(CalendarContract.Events.TITLE, calendarEvent.name)
            .putExtra(CalendarContract.Events.EVENT_LOCATION, calendarEvent.location)
            .putExtra(CalendarContract.Events.EVENT_TIMEZONE, calendarEvent.timeZone.getID());
    }

    @ReactMethod
    public void addEvent(final ReadableMap eventDetails, final Promise promise) {
        final CalendarEvent calendarEvent = CalendarEvent.fromReadableMap(eventDetails);
        final Intent calendarIntent = this.createCalendarIntent(calendarEvent);
        this.activityEventListener.init(calendarEvent, promise);

        try {
            getCurrentActivity().startActivityForResult(calendarIntent, ADD_EVENT_REQUEST_CODE);
        } catch (ActivityNotFoundException e) {
            promise.reject("ERR_NO_CALENDAR", e);
        }
    }
}
