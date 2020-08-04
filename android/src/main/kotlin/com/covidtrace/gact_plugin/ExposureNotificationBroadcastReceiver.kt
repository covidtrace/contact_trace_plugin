package com.covidtrace.gact_plugin

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Handler
import android.os.Looper
import com.google.android.gms.nearby.exposurenotification.ExposureNotificationClient;

/**
 * Broadcast receiver for callbacks from exposure notification API.
 */
public class ExposureNotificationBroadcastReceiver: BroadcastReceiver() {

  override fun onReceive(context: Context?, intent: Intent?) {
     var action:String = intent?.action ?: "";
    if (ExposureNotificationClient.ACTION_EXPOSURE_STATE_UPDATED == action
            || ExposureNotificationClient.ACTION_EXPOSURE_NOT_FOUND == action) {
        GactPlugin.channel.invokeMethod("exposuresDetected", action.toString())
    }
  }
}