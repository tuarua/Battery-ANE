/* Copyright 2018 Tua Rua Ltd.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import Foundation
import FreSwift

public class SwiftController: NSObject {
    public static var TAG = "SwiftController"
    public var context: FreContextSwift!
    public var functionsToSet: FREFunctionMap = [:]
    private var asListeners: [String] = []
    private var currentLevel: Float = 1.0
    
    func initController(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        return true.toFREObject()
    }
    
    @objc func batteryStateDidChange(_ notification: Notification) {
        guard let device = notification.object as? UIDevice else { return }
        let state = device.batteryState
        var props: [String: Any] = Dictionary()
        switch state {
        case .charging, .full:
            props["state"] = 1
        case .unknown:
            props["state"] = 0
        case .unplugged:
            props["state"] = 3
        }
        self.dispatchEvent(name: StateEvent.ON_CHANGE, value: JSON(props).description)
    }
    
    @objc func batteryLevelDidChange(_ notification: Notification) {
        guard let device = notification.object as? UIDevice,
        currentLevel < 0.17,
        device.batteryLevel != currentLevel
        else { return }
        
        let lastLevel = currentLevel
        currentLevel = device.batteryLevel
        let isDecreasing = lastLevel > currentLevel
        
        var props: [String: Any] = Dictionary()
        if currentLevel == 0.15 && isDecreasing {
            props["isLow"] = true
            self.dispatchEvent(name: BatteryEvent.ON_CHANGE, value: JSON(props).description)
        } else if currentLevel == 0.16 && !isDecreasing {
            props["isLow"] = false
            self.dispatchEvent(name: BatteryEvent.ON_CHANGE, value: JSON(props).description)
        }
        
    }
    
    func addEventListener(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let type = String(argv[0]) else {
                return FreArgError(message: "addEventListener").getError(#file, #line, #column)
        }
        if asListeners.contains(type) {
            return nil
        }
        asListeners.append(type)
        
        switch type {
        case BatteryEvent.ON_CHANGE:
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(batteryLevelDidChange),
                                                   name: UIDevice.batteryLevelDidChangeNotification,
                                                   object: nil)
        case StateEvent.ON_CHANGE:
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(batteryStateDidChange),
                                                   name: UIDevice.batteryStateDidChangeNotification,
                                                   object: nil)
        default:
             break
        }
        
        return nil
    }
    
    func removeEventListener(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let type = String(argv[0]) else {
                return FreArgError(message: "removeEventListener").getError(#file, #line, #column)
        }
        if !asListeners.contains(type) {
            return nil
        }
        asListeners = asListeners.filter({ $0 != type })
        switch type {
        case BatteryEvent.ON_CHANGE:
            NotificationCenter.default.removeObserver(self,
                                                      name: UIDevice.batteryLevelDidChangeNotification,
                                                      object: nil)
        case StateEvent.ON_CHANGE:
             NotificationCenter.default.removeObserver(self,
                                                       name: UIDevice.batteryStateDidChangeNotification,
                                                       object: nil)
        default:
            break
        }
        return nil
    }
    
    func getState(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        let state = UIDevice.current.batteryState
        var ret = 0
        switch state {
        case .charging:
            ret = 1
        case .unknown:
            ret = 0
        case .unplugged:
            ret = 3
        case .full:
            ret = 2
        }
        return ret.toFREObject()
    }
    
    func getLevel(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return UIDevice.current.batteryLevel.toFREObject()
    }
    
}
