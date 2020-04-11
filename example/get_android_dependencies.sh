#!/bin/sh

AneVersion="1.4.0"
FreKotlinVersion="1.10.0"
GsonVersion="2.8.6"

wget -O android_dependencies/com.tuarua.frekotlin-$FreKotlinVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/kotlin/com.tuarua.frekotlin-$FreKotlinVersion.ane?raw=true
wget -O android_dependencies/com.google.code.gson.gson-$GsonVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/misc/com.google.code.gson.gson-$GsonVersion.ane?raw=true
wget -O ../native_extension/ane/BatteryANE.ane https://github.com/tuarua/Battery-ANE/releases/download/${AneVersion}/BatteryANE.ane?raw=true
