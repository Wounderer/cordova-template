#!/bin/bash
npm config set prefix '~/.npm-global'
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=~/.npm-global/bin:$PATH
export PATH=$PATH:$ANDROID_HOME/tools
npm update
cd cordova && cordova platform rm android
cordova platform add android@8.1.0
cd ..
npm run build-prod-cordova
# keytool -genkey -v -keystore key-name.keystore -alias alias-name -keyalg RSA -keysize 2048 -validity 10000
cd cordova && cordova build android --release
jarsigner -sigalg SHA1withRSA -digestalg SHA1 -keystore ../key-name.keystore -storepass somepass platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk alias-name
[ -f /tmp/output.apk ] && rm -rf  /tmp/output.apk
zipalign 4 platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk /tmp/output.apk
cd ..
cp -f /tmp/output.apk output.apk
