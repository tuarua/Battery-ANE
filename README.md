# Battery-ANE

Battery Adobe Air Native Extension for iOS 9.0+ and Android 19+.    

-------------

## Android

#### The ANE + Dependencies

cd into /example and run:
- OSX (Terminal)
```shell
bash get_android_dependencies.sh
```
- Windows Powershell
```shell
PS get_android_dependencies.ps1
```

```xml
<extensions>
<extensionID>com.tuarua.frekotlin</extensionID>
<extensionID>com.google.code.gson.gson</extensionID>
<extensionID>com.tuarua.BatteryANE</extensionID>
...
</extensions>
```

-------------

## iOS

#### The ANE + Dependencies

N.B. You must use a Mac to build an iOS app using this ANE. Windows is NOT supported.

From the command line cd into /example and run:

```shell
bash get_ios_dependencies.sh
```

This folder, ios_dependencies/device/Frameworks, must be packaged as part of your app when creating the ipa. How this is done will depend on the IDE you are using.
After the ipa is created unzip it and confirm there is a "Frameworks" folder in the root of the .app package.   

### Modifications to AIR SDK

We need to patch some files in AIR SDK. 

1. Delete ld64 in your AIR SDK from `/lib/aot/bin/ld64/ld64`
2. Copy `/lib/aot/bin/ld64/ld64` from **AIRSDK_patch** into the corresponding folder in your AIR SDK.
3. Copy `/lib/adt.jar` from **AIRSDK_patch** into the corresponding folder in your AIR SDK.

### Prerequisites

You will need:

- IntelliJ IDEA / Flash Builder
- AIR 32
- Android Studio 3 if you wish to edit the Android source
- Xcode 10.1
- wget on OSX
- Powershell on Windows

### References
* [https://developer.android.com/training/monitoring-device-state/battery-monitoring.html]
* [https://kotlinlang.org/docs/reference/android-overview.html] 
* [https://developer.apple.com/documentation/uikit/uidevice/1620051-batterystate]
