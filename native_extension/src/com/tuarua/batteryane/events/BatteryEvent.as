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
package com.tuarua.batteryane.events {
import flash.events.Event;

public class BatteryEvent extends Event {
    public static const ON_CHANGE:String = "BatteryEvent.OnChange";
    public var isLow:Boolean;

    /** @private */
    public function BatteryEvent(type:String, isLow:Boolean,
                                 bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        this.isLow = isLow;
    }

    /** @private */
    public override function clone():Event {
        return new BatteryEvent(type, bubbles, this.isLow, cancelable);
    }

    /** @private */
    public override function toString():String {
        return formatToString("BatteryEvent", "type", "isLow", "bubbles", "cancelable");
    }
}
}
