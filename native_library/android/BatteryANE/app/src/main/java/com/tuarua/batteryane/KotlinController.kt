/*
 *  Copyright 2018 Tua Rua Ltd.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
package com.tuarua.batteryane

import android.content.Intent
import android.content.IntentFilter
import android.content.res.Configuration
import android.os.BatteryManager
import com.adobe.air.AndroidActivityWrapper
import com.adobe.air.AndroidActivityWrapper.ActivityState.PAUSED
import com.adobe.air.AndroidActivityWrapper.ActivityState.RESUMED
import com.adobe.air.FreKotlinActivityResultCallback
import com.adobe.air.FreKotlinStateChangeCallback
import com.adobe.fre.FREContext
import com.adobe.fre.FREObject
import com.tuarua.batteryane.data.BatteryEvent
import com.tuarua.batteryane.data.BatteryState
import com.tuarua.batteryane.data.StateEvent
import com.tuarua.frekotlin.*

@Suppress("unused", "UNUSED_PARAMETER", "UNCHECKED_CAST")
class KotlinController : FreKotlinMainController, FreKotlinStateChangeCallback, FreKotlinActivityResultCallback {

    private var asListeners: MutableList<String> = mutableListOf()
    private var batteryReceiver: BatteryReceiver? = null
    private var powerConnectionReceiver: PowerConnectionReceiver? = null

    private var batteryLowFilter: IntentFilter? = null
    private var batteryOkayFilter: IntentFilter? = null

    private var powerConnectionFilter: IntentFilter? = null
    private var powerDisconnectionFilter: IntentFilter? = null

    fun init(ctx: FREContext, argv: FREArgv): FREObject? {
        return true.toFREObject()
    }

    fun getState(ctx: FREContext, argv: FREArgv): FREObject? {
        val batteryStatus = context?.activity?.applicationContext?.registerReceiver(null,
                IntentFilter(Intent.ACTION_BATTERY_CHANGED))
        val status = batteryStatus?.getIntExtra(BatteryManager.EXTRA_STATUS, -1)
        var state = BatteryState.UNKNOWN
        when (status) {
            BatteryManager.BATTERY_STATUS_CHARGING -> state = BatteryState.CHARGING
            BatteryManager.BATTERY_STATUS_FULL -> state = BatteryState.FULL
            BatteryManager.BATTERY_STATUS_DISCHARGING, BatteryManager.BATTERY_STATUS_NOT_CHARGING -> state = BatteryState.UNPLUGGED
        }
        return state.toFREObject()
    }

    fun getLevel(ctx: FREContext, argv: FREArgv): FREObject? {
        val batteryStatus = context?.activity?.applicationContext?.registerReceiver(null,
                IntentFilter(Intent.ACTION_BATTERY_CHANGED)) ?: return null
        val level = batteryStatus.getIntExtra(BatteryManager.EXTRA_LEVEL, -1)
        val scale = batteryStatus.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
        return (level / scale.toFloat()).toFREObject()
    }

    fun addEventListener(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val type = String(argv[0]) ?: return null
        if (asListeners.contains(type)) return null
        asListeners.add(type)

        when (type) {
            BatteryEvent.ON_CHANGE -> {
                batteryReceiver = BatteryReceiver(context)
                batteryLowFilter = IntentFilter(Intent.ACTION_BATTERY_LOW)
                batteryOkayFilter = IntentFilter(Intent.ACTION_BATTERY_OKAY)
                context?.activity?.applicationContext?.registerReceiver(batteryReceiver, batteryLowFilter)
                context?.activity?.applicationContext?.registerReceiver(batteryReceiver, batteryOkayFilter)
            }
            StateEvent.ON_CHANGE -> {
                powerConnectionReceiver = PowerConnectionReceiver(context)
                powerConnectionFilter = IntentFilter(Intent.ACTION_POWER_CONNECTED)
                powerDisconnectionFilter = IntentFilter(Intent.ACTION_POWER_DISCONNECTED)
                context?.activity?.applicationContext?.registerReceiver(powerConnectionReceiver, powerConnectionFilter)
                context?.activity?.applicationContext?.registerReceiver(powerConnectionReceiver, powerDisconnectionFilter)
            }
        }
        return null
    }

    fun removeEventListener(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val type = String(argv[0]) ?: return null
        if (!asListeners.contains(type)) return null
        asListeners.remove(type)

        when (type) {
            BatteryEvent.ON_CHANGE -> {
                this.context?.activity?.applicationContext?.unregisterReceiver(batteryReceiver)
                batteryLowFilter = null
                batteryOkayFilter = null
                batteryReceiver = null
            }
            StateEvent.ON_CHANGE -> {
                this.context?.activity?.applicationContext?.unregisterReceiver(powerConnectionReceiver)
                powerConnectionFilter = null
                powerDisconnectionFilter = null
                powerConnectionReceiver = null
            }
        }

        return null
    }

    override fun dispose() {
        super.dispose()
        pauseReceivers()
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, intent: Intent?) {
    }

    override fun onConfigurationChanged(configuration: Configuration?) {
    }

    override fun onActivityStateChanged(activityState: AndroidActivityWrapper.ActivityState?) {
        when (activityState) {
            RESUMED -> {
                if (batteryReceiver != null && batteryLowFilter != null && batteryOkayFilter != null) {
                    context?.activity?.applicationContext?.registerReceiver(batteryReceiver, batteryLowFilter)
                    context?.activity?.applicationContext?.registerReceiver(batteryReceiver, batteryOkayFilter)
                }
                if (powerConnectionReceiver != null && powerConnectionFilter != null && powerDisconnectionFilter != null) {
                    context?.activity?.applicationContext?.registerReceiver(powerConnectionReceiver, powerConnectionFilter)
                    context?.activity?.applicationContext?.registerReceiver(powerConnectionReceiver, powerDisconnectionFilter)
                }
            }
            PAUSED -> {
                pauseReceivers()
            }
            else -> return
        }
    }


    private fun pauseReceivers() {
        if (batteryReceiver != null) {
            this.context?.activity?.applicationContext?.unregisterReceiver(batteryReceiver)
        }
        if (powerConnectionReceiver != null) {
            this.context?.activity?.applicationContext?.unregisterReceiver(powerConnectionReceiver)
        }
    }

    override val TAG: String?
        get() = this::class.java.simpleName
    private var _context: FREContext? = null
    override var context: FREContext?
        get() = _context
        set(value) {
            _context = value
            FreKotlinLogger.context = _context
        }
}