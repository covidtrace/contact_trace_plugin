package com.covidtrace.gact_plugin

import com.google.android.gms.common.api.ApiException
import com.google.android.gms.nearby.Nearby
import com.google.android.gms.nearby.exposurenotification.ExposureConfiguration;
import com.google.android.gms.nearby.exposurenotification.ExposureInformation;
import com.google.android.gms.nearby.exposurenotification.ExposureNotificationClient;
import com.google.android.gms.nearby.exposurenotification.ExposureSummary;
import com.google.android.gms.nearby.exposurenotification.TemporaryExposureKey;
import com.google.android.gms.tasks.Task;
import com.google.android.gms.tasks.Tasks;

import android.content.Context;
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

/** GactPlugin */
public class GactPlugin: FlutterPlugin, MethodCallHandler {
  lateinit var applicationContext: Context;
  lateinit var exposureNotification: ExposureNotificationClient;
  lateinit var channel: MethodChannel;

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    this.onAttached(flutterPluginBinding.getApplicationContext(), flutterPluginBinding.getFlutterEngine().getDartExecutor())
  }

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val instance = GactPlugin()
      instance.onAttached(registrar.context(), registrar.messenger())
    }
  }

  fun onAttached(context: Context, messenger: BinaryMessenger) {
    this.applicationContext = context
    this.exposureNotification = Nearby.getExposureNotificationClient(this.applicationContext)
    this.channel = MethodChannel(messenger, "com.covidtrace/gact_plugin")
    this.channel.setMethodCallHandler(this);
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
      "getAuthorizationStatus" -> {
        this.exposureNotification.isEnabled().addOnSuccessListener {
          result.success(if (it) 3 else 2)
        }.addOnFailureListener {
          val ex = it as ApiException
          result.error(ex.statusCode.toString(), ex.statusMessage, null)
        }
      }
      "enableExposureNotification" -> {
        this.exposureNotification.start().addOnSuccessListener {
          result.success(null)
        }.addOnFailureListener {
          val ex = it as ApiException
          result.error(ex.statusCode.toString(), ex.statusMessage, null)
        }
      }
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    this.channel.setMethodCallHandler(null);
  }
}
