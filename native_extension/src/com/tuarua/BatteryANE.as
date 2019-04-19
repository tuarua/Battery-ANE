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

public class BatteryANE extends EventDispatcher {
    private var _isInited:Boolean;
    private static var _battery:BatteryANE;

    /** @private */
    public function BatteryANE() {
        if (_battery) {
            throw new Error(BatteryANEContext.NAME + " is a singleton, use .battery");
        }
        if (BatteryANEContext.context) {
            var theRet:* = BatteryANEContext.context.call("init");
            if (theRet is ANEError) throw theRet as ANEError;
            _isInited = theRet as Boolean;
        }
        _battery = this;
    }

    public static function get battery():BatteryANE {
        if (_battery == null) {
            new BatteryANE();
        }
        return _battery;
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
        if (!safetyCheck()) return;
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
        if (!safetyCheck()) return;
        BatteryANEContext.context.call("removeEventListener", type);
    }


    public function get state():int {
        var theRet:* = BatteryANEContext.context.call("getState");
        if (theRet is ANEError) throw theRet as ANEError;
        return theRet as int;
    }

    public function get level():Number {
        var theRet:* = BatteryANEContext.context.call("getLevel");
        if (theRet is ANEError) throw theRet as ANEError;
        return theRet as Number;
    }

    public static function dispose():void {
        if (BatteryANEContext.context) {
            BatteryANEContext.dispose();
        }
    }

    /** @return whether we have inited */
    public function get isInited():Boolean {
        return _isInited;
    }

    /** @private */
    private function safetyCheck():Boolean {
        if (!_isInited || BatteryANEContext.isDisposed) {
            trace("You need to init first");
            return false;
        }
        return true;
    }

}
}