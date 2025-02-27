package com.nearform.calendar;

import android.app.Activity;
import android.content.Intent;
import android.content.ContentResolver;
import android.database.Cursor;
import android.net.Uri;
import android.provider.CalendarContract;

import com.facebook.react.bridge.BaseActivityEventListener;
import com.facebook.react.bridge.Promise;

import java.lang.RuntimeException;

import com.nearform.calendar.CalendarEvent;

public class CalendarActivityHandler extends BaseActivityEventListener {
    public static final int ADD_EVENT_REQUEST_CODE = 1;
    private Promise promise;
    private CalendarEvent calendarEvent;

    public void init(final CalendarEvent calendarEvent, final Promise promise) {
        this.calendarEvent = calendarEvent;
        this.promise = promise;
    }

    @Override
    public void onActivityResult(final Activity activity, final int requestCode, final int resultCode, final Intent data) {
        if (requestCode == ADD_EVENT_REQUEST_CODE) {
            if (resultCode == Activity.RESULT_OK || (resultCode == Activity.RESULT_CANCELED && this.isEventAdded(activity))) {
                this.promise.resolve("EVENT_SAVED");
            } else if (resultCode == Activity.RESULT_CANCELED) {
                this.promise.resolve("EVENT_CANCELLED");
            } else {
                this.promise.reject("ERR_UNKNOWN", new RuntimeException(Integer.toString(resultCode)));
            }
        }
    }

    private boolean isEventAdded(final Activity activity) {
        final ContentResolver cr = activity.getContentResolver();
        final Uri uri = CalendarContract.Events.CONTENT_URI;
        final String selection = "((? = ?) AND (? = ?))";
        final String[] selectionArgs = new String[]{CalendarContract.Events.TITLE, this.calendarEvent.name, CalendarContract.Events.DTSTART, String.valueOf(this.calendarEvent.startTime)};

        final Cursor cur = cr.query(uri, null, selection, selectionArgs, null);
        final int count = cur.getCount();
        cur.close();

        return count > 0;
    }
}
