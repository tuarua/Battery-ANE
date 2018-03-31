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

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.adobe.fre.FREContext
import com.google.gson.Gson
import com.tuarua.batteryane.data.BatteryEvent
import com.tuarua.frekotlin.FreKotlinController

class BatteryReceiver(override var context: FREContext?) : BroadcastReceiver(), FreKotlinController {
    private val gson = Gson()
    override fun onReceive(context: Context?, intent: Intent?) {
        val i = intent ?: return
        sendEvent(BatteryEvent.ON_CHANGE, gson.toJson(BatteryEvent((i.action == Intent.ACTION_BATTERY_LOW))))
    }

    override val TAG: String
        get() = this::class.java.simpleName
}
