default:
	# Set default make action here
	# xcodebuild -target Tests -configuration MyMainTarget -sdk iphonesimulator build	

clean:
	-rm -rf build/*

test:
	GHUNIT_CLI=1 CFFIXED_USER_HOME=. xcodebuild -project i-meeting.xcodeproj -sdk iphonesimulator5.0 -target i-meeting-tests -configuration Debug build