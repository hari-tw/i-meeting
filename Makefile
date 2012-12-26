default:
	# Set default make action here
	# xcodebuild -target Tests -configuration MyMainTarget -sdk iphonesimulator build	

clean:
	-rm -rf build/*

test:
	xcodebuild RUN_UNIT_TEST_WITH_IOS_SIM=YES ONLY_ACTIVE_ARCH=NO GHUNIT_CLI=1 CFFIXED_USER_HOME=. -sdk iphonesimulator6.0 -project i-meeting.xcodeproj -target i-meeting-tests -configuration Debug clean build
