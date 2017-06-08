rm -rf build/
xcodebuild archive -workspace iosu.xcworkspace -scheme iosu -destination generic/platform=iOS -archivePath build/iosu.xcarchive
xcodebuild -exportArchive -archivePath build/iosu.xcarchive -exportPath build -exportOptionsPlist ipa.plist
mv build/iosu.ipa build/iosu_$(git tag|tail -1).ipa
