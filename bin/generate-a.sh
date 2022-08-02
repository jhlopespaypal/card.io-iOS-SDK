#!/bin/bash

CURRENTDIR=$(dirname $0)

if [ $CURRENTDIR != "bin" ]; then 
    echo "Please run the script from root folder. Ex: bin/generate-xcframework.sh"
    exit 1
fi

BUILDPATH="CardIOKit/Build"

rm -r $BUILDPATH
mkdir $BUILDPATH

# Generate CardIOLib.a

cd "CardIOKit/CardIO/CardIOStatic"

xcodebuild -scheme CardIOStatic -sdk iphoneos -configuration Release ARCHS="arm64" OTHER_CFLAGS="-fembed-bitcode" BITCODE_GENERATION_MODE="bitcode" SKIP_INSTALL="NO" BUILD_LIBRARY_FOR_DISTRIBUTION="YES" -destination 'generic/platform=iOS' BUILD_DIR="../../Build/"
xcodebuild -scheme CardIOStatic -sdk iphoneos -configuration Release ARCHS="x86_64 arm64" OTHER_CFLAGS="-fembed-bitcode" BITCODE_GENERATION_MODE="bitcode" SKIP_INSTALL="NO" BUILD_LIBRARY_FOR_DISTRIBUTION="YES" -destination 'platform=iOS Simulator,name=iPod touch (7th generation)' BUILD_DIR="../../Build/"

cd "../../Build"

mv Release-iphoneos/usr/local/include ./

# xcodebuild -create-xcframework -library "Release-iphoneos/libCardIOStatic.a" -headers "Release-iphoneos/usr/local/include" -library "Release-iphonesimulator/libCardIOStatic.a" -headers "Release-iphonesimulator/usr/local/include" -allow-internal-distribution -output "CardIO.xcframework"

mv Release-iphoneos/libCardIOStatic.a ../Build/libCardIOStatic-arm.a
rm -r Release-iphoneos
mv Release-iphonesimulator/libCardIOStatic.a ../Build/libCardIOStatic-x86.a
rm -r Release-iphonesimulator

cd "../.."

# Lipo fat libs for Arm and x86_64

cd "CardIOKit/CardIO/CardIOLibs"

LIBSLIST=('libCardIO' 'libopencv_core' 'libopencv_imgproc')

for I in ${LIBSLIST[*]}
do
    lipo "$I.a" -thin arm64 -output "../../Build/$I-arm.a"
    lipo "$I.a" -thin x86_64 -output "../../Build/$I-x86.a"    
    if [ $# == 0 ]; then echo "$I.xcframework created"; fi
done
cd "../../.."

# Libtool archive libs with the same architecture

cd "CardIOKit/Build"
libtool -static -o libCardIOAll-arm.a ./*-arm.a
libtool -static -o libCardIOAll-x86.a ./*-x86.a
xcodebuild -create-xcframework -library "libCardIOAll-arm.a" -headers "./include" -library "libCardIOAll-x86.a" -headers "./include" -allow-internal-distribution -output "CardIO.xcframework"
rm ./*.a
rm -r include
cd "../.."

# Move final archive .xcframework to SPM source folder.

rm -r ./Sources/Build
mv ./CardIOKit/Build ./Sources
