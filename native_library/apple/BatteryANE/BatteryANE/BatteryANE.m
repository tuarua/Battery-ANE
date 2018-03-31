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

#import "FreMacros.h"
#import "BatteryANE_oc.h"
#import <BatteryANE_FW/BatteryANE_FW.h>

#define FRE_OBJC_BRIDGE TRBAT_FlashRuntimeExtensionsBridge // use unique prefix throughout to prevent clashes with other ANEs
@interface FRE_OBJC_BRIDGE : NSObject<FreSwiftBridgeProtocol>
@end
@implementation FRE_OBJC_BRIDGE {
}
FRE_OBJC_BRIDGE_FUNCS
@end

@implementation BatteryANE_LIB
SWIFT_DECL(TRBAT) // use unique prefix throughout to prevent clashes with other ANEs
CONTEXT_INIT(TRBAT) {
    SWIFT_INITS(TRBAT)
    
    /**************************************************************************/
    /******* MAKE SURE TO ADD FUNCTIONS HERE THE SAME AS SWIFT CONTROLLER *****/
    /**************************************************************************/
    
    static FRENamedFunction extensionFunctions[] =
    {
         MAP_FUNCTION(TRBAT, init)
        ,MAP_FUNCTION(TRBAT, addEventListener)
        ,MAP_FUNCTION(TRBAT, removeEventListener)
        ,MAP_FUNCTION(TRBAT, getState)
        ,MAP_FUNCTION(TRBAT, getLevel)
    };
    
    /**************************************************************************/
    /**************************************************************************/
    
    SET_FUNCTIONS
    
}

CONTEXT_FIN(TRBAT) {
    [TRBAT_swft dispose];
    TRBAT_swft = nil;
    TRBAT_freBridge = nil;
    TRBAT_swftBridge = nil;
    TRBAT_funcArray = nil;
}
EXTENSION_INIT(TRBAT)
EXTENSION_FIN(TRBAT)
@end
