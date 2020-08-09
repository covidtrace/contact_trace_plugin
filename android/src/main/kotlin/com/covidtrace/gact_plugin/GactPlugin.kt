package com.covidtrace.gact_plugin

import com.google.gson.Gson
import com.google.android.gms.common.api.ApiException
import com.google.android.gms.nearby.Nearby
import com.google.android.gms.nearby.exposurenotification.ExposureConfiguration
import com.google.android.gms.nearby.exposurenotification.ExposureInformation
import com.google.android.gms.nearby.exposurenotification.ExposureNotificationClient
import com.google.android.gms.nearby.exposurenotification.ExposureSummary
import com.google.android.gms.nearby.exposurenotification.TemporaryExposureKey

import android.app.Activity;
import android.content.Context;
import android.content.Intent
import android.os.Build
import android.util.Base64
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
import java.io.File


const val REQUEST_CODE_START_EXPOSURE_NOTIFICATION = 1111
const val REQUEST_CODE_GET_TEMP_EXPOSURE_KEY_HISTORY = 2222

/** GactPlugin */
public class GactPlugin: FlutterPlugin, MethodCallHandler, ActivityAware, ActivityResultListener {
  lateinit var configuration: ExposureConfiguration;
  lateinit var activity: Activity;
  lateinit var applicationContext: Context;
  lateinit var exposureNotification: ExposureNotificationClient;
  lateinit var result: Result;

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    this.onAttached(flutterPluginBinding.getApplicationContext(), flutterPluginBinding.getFlutterEngine().getDartExecutor())
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    this.activity = binding.activity
    binding.addActivityResultListener { requestCode, resultCode, data ->
      this.onActivityResult(requestCode, resultCode, data)
    }
  }

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val instance = GactPlugin()
      instance.onAttached(registrar.context(), registrar.messenger())
      instance.activity = registrar.activity()
    }

    lateinit var channel: MethodChannel;
  }

  fun onAttached(context: Context, messenger: BinaryMessenger) {
    this.applicationContext = context
    this.exposureNotification = Nearby.getExposureNotificationClient(this.applicationContext)
    GactPlugin.channel = MethodChannel(messenger, "com.covidtrace/gact_plugin")
    GactPlugin.channel.setMethodCallHandler(this)
  }

  private fun enableExposureNotification(@NonNull result: Result) {
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

  private fun getExposureKeys(@NonNull result: Result) {
    this.exposureNotification.getTemporaryExposureKeyHistory().addOnSuccessListener {
      result.success(Gson().toJson(it.map { mapOf(
        "keyData" to Base64.encodeToString(it.keyData, Base64.NO_WRAP),
        "rollingPeriod" to it.rollingPeriod,
        "rollingStartNumber" to it.rollingStartIntervalNumber,
        "transmissionRiskLevel" to it.transmissionRiskLevel) }))
    }.addOnFailureListener {
      val ex = it as ApiException
      if (ex.statusCode == 6) {
        this.result = result
        ex.status.startResolutionForResult(this.activity, REQUEST_CODE_GET_TEMP_EXPOSURE_KEY_HISTORY)
      } else {
        result.error(ex.statusCode.toString(), ex.statusMessage, null)
      }
    }
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "getPlatformVersion" -> result.success("Android ${Build.VERSION.RELEASE}")
      "getAuthorizationStatus" -> {
        this.exposureNotification.isEnabled().addOnSuccessListener {
          result.success(if (it) 3 else 2)
        }.addOnFailureListener {
          val ex = it as ApiException
          result.error(ex.statusCode.toString(), ex.statusMessage, null)
        }
      }
      "enableExposureNotification" -> {
        this.enableExposureNotification(result)
      }
      "setExposureConfiguration" -> {
        val config = call.arguments as Map<String, Any>

        this.configuration = ExposureConfiguration.ExposureConfigurationBuilder()
          .setAttenuationWeight(config["attenuationWeight"] as Int)
          .setAttenuationScores(*(config["attenuationLevelValues"] as ArrayList<Int>).toIntArray())
          .setDurationWeight(config["durationWeight"] as Int)
          .setDurationScores(*(config["durationLevelValues"] as ArrayList<Int>).toIntArray())
          .setTransmissionRiskWeight(config["transmissionRiskWeight"] as Int)
          .setTransmissionRiskScores(*(config["transmissionRiskLevelValues"] as ArrayList<Int>).toIntArray())
          .setDaysSinceLastExposureWeight(config["daysSinceLastExposureWeight"] as Int)
          .setDaysSinceLastExposureScores(*(config["daysSinceLastExposureLevelValues"] as ArrayList<Int>).toIntArray())
          .setMinimumRiskScore(config["minimumRiskScore"] as Int)
          .build()

        result.success(null)
      }
      "getExposureKeys" -> {
        this.getExposureKeys(result)
      }
      "getExposureSummary" -> {
        this.exposureNotification.getExposureSummary(ExposureNotificationClient.EXTRA_TOKEN).addOnSuccessListener {
          result.success(Gson().toJson(mapOf(
            "daysSinceLastExposure" to it.daysSinceLastExposure,
            "matchedKeyCount" to it.matchedKeyCount,
            "maximumRiskScore" to it.maximumRiskScore,
            "attenuationDurations" to it.attenuationDurationsInMinutes)))
        }.addOnFailureListener {
          val ex = it as ApiException
          result.error(ex.statusCode.toString(), ex.statusMessage, null)
        }
      }
      "getExposureInfo" -> {
        this.exposureNotification.getExposureInformation(ExposureNotificationClient.EXTRA_TOKEN).addOnSuccessListener {
          result.success(Gson().toJson(it.map {
            mapOf(
              "date" to it.dateMillisSinceEpoch,
              "duration" to it.durationMinutes,
              "transmissionRiskLevel" to it.transmissionRiskLevel,
              "totalRiskScore" to it.totalRiskScore)
          }))
        }.addOnFailureListener {
          val ex = it as ApiException
          result.error(ex.statusCode.toString(), ex.statusMessage, null)
        }
      }
      "detectExposures" -> {
        val filePaths = call.arguments as List<String>
        val localUrls = filePaths.map { File(it) }

        this.exposureNotification.provideDiagnosisKeys(localUrls, this.configuration, ExposureNotificationClient.EXTRA_TOKEN).addOnSuccessListener {
          this.result = result
        }.addOnFailureListener {
          val ex = it as ApiException
          result.error(ex.statusCode.toString(), ex.statusMessage, null)
        }
      }
      "setUserExplanation" -> {
        result.success(null)
      }
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    GactPlugin.channel.setMethodCallHandler(null)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    // TODO("Not yet implemented")
  }

  override fun onDetachedFromActivity() {
    // TODO("Not yet implemented")
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    this.onAttachedToActivity(binding)
  }

  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
    return when (requestCode) {
        REQUEST_CODE_START_EXPOSURE_NOTIFICATION -> {
          if (resultCode == Activity.RESULT_OK) this.enableExposureNotification(this.result) else this.result.success(null)
          true
        }
        REQUEST_CODE_GET_TEMP_EXPOSURE_KEY_HISTORY -> {
          if (resultCode == Activity.RESULT_OK) this.getExposureKeys(this.result) else this.result.success(null)
          true
        }
        else -> {
          this.result.notImplemented()
          false
        }
    }
  }
}
