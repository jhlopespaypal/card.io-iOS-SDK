#!/bin/bash

# VARs
PROJNAME="CardIO"
OUTPUTPATH="../../Build"
BUILDPATH="CardIOKit/Build"

mkdir $BUILDPATH

# Create CardIO XCFramework

cd "CardIOKit/CardIO/$PROJNAME"

xcodebuild -scheme $PROJNAME -sdk iphoneos -configuration Release ARCHS="arm64" OTHER_CFLAGS="-fembed-bitcode" BITCODE_GENERATION_MODE="bitcode" -destination 'generic/platform=iOS' BUILD_DIR=$OUTPUTPATH

xcodebuild -scheme $PROJNAME -sdk iphoneos -configuration Release ARCHS="x86_64 arm64" OTHER_CFLAGS="-fembed-bitcode" BITCODE_GENERATION_MODE="bitcode" -destination 'platform=iOS Simulator,name=iPod touch (7th generation)' BUILD_DIR=$OUTPUTPATH

cd $OUTPUTPATH

xcodebuild -create-xcframework -framework Release-iphonesimulator/$PROJNAME.framework/ -framework Release-iphoneos/$PROJNAME.framework/ -allow-internal-distribution -output $PROJNAME.xcframework

rm -rf Release-iphonesimulator
rm -rf Release-iphoneos

# Create Libs XCFramework

cd "../CardIO/CardIOLibs"

LIBSLIST=('libCardIO' 'libopencv_core' 'libopencv_imgproc')

for I in ${LIBSLIST[*]}
do     
    lipo "$I.a" -thin arm64 -output "$OUTPUTPATH/$I-arm.a"
    lipo "$I.a" -thin x86_64 -output "$OUTPUTPATH/$I-x86.a"
    xcodebuild -create-xcframework -library "$OUTPUTPATH/$I-arm.a" -library "$OUTPUTPATH/$I-x86.a" -allow-internal-distribution -output "$OUTPUTPATH/$I.xcframework"
    rm "$OUTPUTPATH/$I-arm.a"
    rm "$OUTPUTPATH/$I-x86.a"
    echo "$I.xcframework created"
done

cd "../../../"

mv ./CardIOKit/Build ./Sources