package com.example.client

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import android.util.Log

class MainActivity : FlutterActivity() {

    private val CHANNEL = "sms_receiver"
    private lateinit var smsReceiver: BroadcastReceiver
    private var _methodChannel: MethodChannel? = null // Define _methodChannel here

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Initialize _methodChannel here
        _methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)

        _methodChannel?.setMethodCallHandler { call, result ->
            if (call.method == "startSmsReceiver") {
                Log.d("MethodChannel", "Received startSmsReceiver method call")
                startSmsReceiver()
                //result.success(null)
            } else {
                Log.d("MethodChannel", "Unknown method call: ${call.method}")
                result.notImplemented()
            }
        }
    }

    private fun startSmsReceiver() {
        Log.d("SMSReceiver", "startSmsReceiver");
        smsReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                if (intent?.action == "android.provider.Telephony.SMS_RECEIVED") {
                    val bundle: Bundle? = intent.extras
                    val pdus = bundle?.get("pdus") as? Array<Any>
                    pdus?.let {
                        for (pdu in pdus) {
                            val smsMessage = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                                val format = bundle.getString("format")
                                android.telephony.SmsMessage.createFromPdu(pdu as ByteArray, format)
                            } else {
                                android.telephony.SmsMessage.createFromPdu(pdu as ByteArray)
                            }

                            val sender = smsMessage.originatingAddress
                            val messageBody = smsMessage.messageBody

                            // Log the received SMS content
                            Log.d("SMSReceiver", "Received SMS from: $sender")
                            Log.d("SMSReceiver", "Message Body: $messageBody")

                            val extractedData = mapOf(
                                "sender" to sender,
                                "messageBody" to messageBody
                            )

                            // Send extracted data back to Flutter
                            _methodChannel?.invokeMethod("smsReceived", extractedData)
                        }
                    }
                }
            }
        }

        val intentFilter = IntentFilter("android.provider.Telephony.SMS_RECEIVED")
        registerReceiver(smsReceiver, intentFilter)
    }

    override fun onDestroy() {
        super.onDestroy()
        unregisterReceiver(smsReceiver)
    }
}
