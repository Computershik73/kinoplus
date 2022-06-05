#!/bin/bash
export PATH=$PATH:/Users/rf0x3d/flutter/bin/

cd /Users/rf0x3d/Documents/GitHub/QTranslate/ios

cd .. && flutter build ipa --release

cd build/ios/archive

xcodebuild -exportArchive -archivePath Runner.xcarchive -exportPath ~/Desktop/app.ipa -exportOptionsPlist ../../../ios/IPAExport.plist
