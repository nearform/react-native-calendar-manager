package com.nearform.calendar;

import android.app.Activity;
import android.content.Intent;

import com.facebook.react.bridge.BaseActivityEventListener;
import com.facebook.react.bridge.Promise;

import java.lang.RuntimeException;

public class CalendarActivityHandler extends BaseActivityEventListener {
    public static final int ADD_EVENT_REQUEST_CODE = 1;
    private Promise promise;

    public void setPromise(Promise promise) {
        this.promise = promise;
    }

    @Override
    public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {
        if (requestCode == ADD_EVENT_REQUEST_CODE) {
            if (resultCode == Activity.RESULT_OK) {
                this.promise.resolve("EVENT_SAVED");
            } else if (resultCode == Activity.RESULT_CANCELED) {
                this.promise.resolve("EVENT_CANCELLED");
            } else {
                this.promise.reject("ERR_UNKNOWN", new RuntimeException(Integer.toString(resultCode)));
            }
        }
    }
}
