package com.nearform.calendar;

import android.icu.util.TimeZone;

import com.facebook.react.bridge.ReadableMap;

public class CalendarEvent {
    public String name;
    public String location;
    public long startTime;
    public long endTime;
    public TimeZone timeZone;

    private CalendarEvent(final String name, final String location, final long startTime, final long endTime, final TimeZone timeZone) {
        this.name = name;
        this.location = location;
        this.startTime = startTime;
        this.endTime = endTime;
        this.timeZone = timeZone;
    }

    public static CalendarEvent fromReadableMap(final ReadableMap eventDetails) {
        final Double startTime = eventDetails.getDouble("startTime");
        final Double endTime = eventDetails.getDouble("endTime");

        return new CalendarEvent(
            eventDetails.getString("name"),
            eventDetails.getString("location"),
            startTime.longValue(),
            endTime.longValue(),
            getTimeZone(eventDetails)
        );
    }

    private static TimeZone getTimeZone(final ReadableMap eventDetails) {
        return eventDetails.hasKey("timeZone") ? TimeZone.getTimeZone(eventDetails.getString("timeZone")) : TimeZone.getDefault();
    }
}
