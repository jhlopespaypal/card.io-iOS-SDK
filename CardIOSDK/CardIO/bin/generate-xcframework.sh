#!/bin/bash

PROJNAME="CardIO"

cd $PROJNAME

xcodebuild -scheme $PROJNAME -sdk iphoneos -configuration Release ARCHS="arm64" -destination 'generic/platform=iOS' BUILD_DIR="../../Build"

xcodebuild -scheme $PROJNAME -sdk iphoneos -configuration Release ARCHS="x86_64 arm64" -destination 'platform=iOS Simulator,name=iPod touch (7th generation)' BUILD_DIR="../../Build"

cd ../../Build

xcodebuild -create-xcframework -framework Release-iphonesimulator/$PROJNAME.framework/ -framework Release-iphoneos/$PROJNAME.framework/ -allow-internal-distribution -output $PROJNAME.xcframework
