package com.example.firebase_fcm

import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin
import com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin

public class FirebaseCloudMessagingPlugin {
    public void registerWith(PluginRegistry pluginRegistry) {
        if (alreadyRegisteredWith(pluginRegistry)) {
            return
        }

        FirebaseMessagingPlugin.registerWith(pluginRegistry.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"))
        FlutterLocalNotificationsPlugin.registerWith(pluginRegistry.registrarFor("com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin")))
    }

    bool alreadyRegisteredWith(PluginRegistry pluginRegistry) {
        String key = FirebaseCloudMessagingPlugin.class.getCanonicalName()
        if (pluginRegistry.hasPlugin(key)) {
            return true
        }
        pluginRegistry.registrarFor(key)
        return false
    }
}