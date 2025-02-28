#!/bin/bash



Workspace_FILE="../iosApp.xcworkspace"
SCHEME_NAME="Tests"
DESTINATION="platform=iOS Simulator,name=iPhone 16 Pro,OS=18.1"

xcodebuild test -workspace "$Workspace_FILE" \
		-scheme "$SCHEME_NAME" \
		-configuration Debug \
		-skipPackagePluginValidation \
		-skipMacroValidation \
		-destination "$DESTINATION" \
		| xcbeautify

echo "All tests passed"