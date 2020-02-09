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
import com.tuarua.fre.ANEError;

import flash.events.EventDispatcher;

public class Battery extends EventDispatcher {
    private static var _shared:Battery;

    /** @private */
    public function Battery() {
        if (_shared) {
            throw new Error(BatteryANEContext.NAME + " is a singleton, use .shared()");
        }
        if (BatteryANEContext.context) {
            var ret:* = BatteryANEContext.context.call("init");
            if (ret is ANEError) throw ret as ANEError;
        }
        _shared = this;
    }

    public static function shared():Battery {
        if (_shared == null) {
            new Battery();
        }
        return _shared;
    }

    /**
     *
     * @param type
     * @param listener
     * @param useCapture
     * @param priority
     * @param useWeakReference
     *
     */
    override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0,
                                              useWeakReference:Boolean = false):void {
        super.addEventListener(type, listener, useCapture, priority, useWeakReference);
        BatteryANEContext.context.call("addEventListener", type);
    }

    /**
     *
     * @param type
     * @param listener
     * @param useCapture
     *
     */
    override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
        super.removeEventListener(type, listener, useCapture);
        BatteryANEContext.context.call("removeEventListener", type);
    }

    public function get state():int {
        var ret:* = BatteryANEContext.context.call("getState");
        if (ret is ANEError) throw ret as ANEError;
        return ret as int;
    }

    public function get level():Number {
        var ret:* = BatteryANEContext.context.call("getLevel");
        if (ret is ANEError) throw ret as ANEError;
        return ret as Number;
    }

    public static function dispose():void {
        if (BatteryANEContext.context) {
            BatteryANEContext.dispose();
        }
    }

}
}