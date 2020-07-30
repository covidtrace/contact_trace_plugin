package com.covidtrace.gact_plugin

import com.google.android.gms.common.api.ApiException
import com.google.android.gms.nearby.Nearby;
import com.google.android.gms.nearby.exposurenotification.ExposureConfiguration;
import com.google.android.gms.nearby.exposurenotification.ExposureInformation;
import com.google.android.gms.nearby.exposurenotification.ExposureNotificationClient;
import com.google.android.gms.nearby.exposurenotification.ExposureSummary;
import com.google.android.gms.nearby.exposurenotification.ExposureWindow;
import com.google.android.gms.nearby.exposurenotification.TemporaryExposureKey;

import com.google.android.gms.tasks.Task;
import com.google.android.gms.tasks.Tasks;

import android.app.Activity;
import android.content.Context;
import android.content.Intent
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener
import io.flutter.plugin.common.PluginRegistry.Registrar


const val REQUEST_CODE_START_EXPOSURE_NOTIFICATION = 1111
const val REQUEST_CODE_GET_TEMP_EXPOSURE_KEY_HISTORY = 2222

/** GactPlugin */
public class GactPlugin: FlutterPlugin, MethodCallHandler, ActivityAware, ActivityResultListener {
  lateinit var configuration: ExposureConfiguration;
  lateinit var activity: Activity;
  lateinit var applicationContext: Context;
  lateinit var exposureNotification: ExposureNotificationClient;
  lateinit var channel: MethodChannel;
  lateinit var result: Result;

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    this.onAttached(flutterPluginBinding.getApplicationContext(), flutterPluginBinding.getFlutterEngine().getDartExecutor())
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    this.activity = binding.activity
  }

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val instance = GactPlugin()
      instance.onAttached(registrar.context(), registrar.messenger())
      instance.activity = registrar.activity()
    }
  }

  fun onAttached(context: Context, messenger: BinaryMessenger) {
    this.applicationContext = context
    this.exposureNotification = Nearby.getExposureNotificationClient(this.applicationContext)
    this.channel = MethodChannel(messenger, "com.covidtrace/gact_plugin")
    this.channel.setMethodCallHandler(this)
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
          result.success(it)
        }.addOnFailureListener {
          val ex = it as ApiException
          if (ex.statusCode == 6) {
            this.result = result
            ex.status.startResolutionForResult(this.activity, REQUEST_CODE_START_EXPOSURE_NOTIFICATION)
          } else {
            result.error(ex.statusCode.toString(), ex.statusMessage, null)
          }
        }
      }
      "setExposureConfiguration" -> {
        val config = call.arguments as Map<String, Any>

        this.configuration = ExposureConfiguration.ExposureConfigurationBuilder().build()
        result.success(null)
      }
      "getExposureKeys" -> {
        this.exposureNotification.getTemporaryExposureKeyHistory().addOnSuccessListener {
          result.success(it)
        }.addOnFailureListener {
          val ex = it as ApiException
          result.error(ex.statusCode.toString(), ex.statusMessage, null)
        }
      }
      "getExposureSummary" -> {
        result.notImplemented()
      }
      "detectExposures" -> {
        result.notImplemented()
      }
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    this.channel.setMethodCallHandler(null)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    TODO("Not yet implemented")
  }

  override fun onDetachedFromActivity() {
    TODO("Not yet implemented")
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    TODO("Not yet implemented")
  }

  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
    return if (requestCode === REQUEST_CODE_START_EXPOSURE_NOTIFICATION) {
      this.result.success(resultCode == Activity.RESULT_OK)
      true
    } else {
      this.result.notImplemented()
      false
    }
  }
}
