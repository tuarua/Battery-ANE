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
package com.tuarua {
import com.tuarua.battery.events.BatteryEvent;
import com.tuarua.battery.events.StateEvent;

import flash.events.StatusEvent;
import flash.external.ExtensionContext;

/** @private */
public class BatteryANEContext {
    internal static const NAME:String = "BatteryANE";
    internal static const TRACE:String = "TRACE";
    private static var _context:ExtensionContext;
    private static var _isDisposed:Boolean;
    private static var argsAsJSON:Object;

    public function BatteryANEContext() {
    }

    public static function get context():ExtensionContext {
        if (_context == null) {
            try {
                _context = ExtensionContext.createExtensionContext("com.tuarua." + NAME, null);
                _context.addEventListener(StatusEvent.STATUS, gotEvent);
                _isDisposed = false;
            } catch (e:Error) {
                throw new Error("ANE " + NAME + " not created properly.  Future calls will fail.");
            }
        }
        return _context;
    }

    private static function gotEvent(event:StatusEvent):void {
        switch (event.level) {
            case TRACE:
                trace("[" + NAME + "]", event.code);
                break;
            case BatteryEvent.ON_CHANGE:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    BatteryANE.battery.dispatchEvent(new BatteryEvent(event.level, argsAsJSON.isLow));
                } catch (e:Error) {
                    trace(e.message);
                }
                break;
            case StateEvent.ON_CHANGE:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    BatteryANE.battery.dispatchEvent(new StateEvent(event.level, argsAsJSON.state));
                } catch (e:Error) {
                    trace(e.message);
                }
                break;
        }
    }

    public static function dispose():void {
        if (_context == null) return;
        _isDisposed = true;
        trace("[" + NAME + "] Unloading ANE...");
        _context.removeEventListener(StatusEvent.STATUS, gotEvent);
        _context.dispose();
        _context = null;
    }

    public static function get isDisposed():Boolean {
        return _isDisposed;
    }
}
}
