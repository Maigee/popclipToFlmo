#!/bin/bash

# Build script for Flomo PopClip Extension
# This script creates a ready-to-use .popclipext package

echo "Building Flomo PopClip Extension..."

# Create build directory
BUILD_DIR="build"
EXT_NAME="Flomo.popclipext"
BUILD_PATH="$BUILD_DIR/$EXT_NAME"

rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_PATH"

# Copy necessary files
cp -r "Flomo.popclipext/logo.png" "$BUILD_PATH/"
cp "Flomo.popclipext/README.md" "$BUILD_PATH/"

# Create the final Config.plist from Config.ts
# For simplicity in this example, we'll create a basic plist version
cat > "$BUILD_PATH/Config.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Name</key>
	<string>Flomo</string>
	<key>Identifier</key>
	<string>com.popclip.extension.popcliptoflomo</string>
	<key>Description</key>
	<string>Save selected text to flomo via incoming webhook API.</string>
	<key>Icon</key>
	<string>logo.png</icon>
	<key>Requirements</key>
	<array>
		<string>text</string>
	</array>
	<key>Options</key>
	<array>
		<dict>
			<key>Identifier</key>
			<string>apiurl</string>
			<key>Label</key>
			<string>Flomo API URL</string>
			<key>Type</key>
			<string>string</string>
			<key>Description</key>
			<string>Your flomo incoming webhook URL (get it from https://flomoapp.com/mine?source=incoming_webhook)</string>
		</dict>
	</array>
	<key>Actions</key>
	<array>
		<dict>
			<key>Title</key>
			<string>Save to Flomo</string>
			<key>Shell Script</key>
			<string>#!/bin/bash
API_URL="\$POPCLIP_OPTION_APIURL"
CONTENT="\$POPCLIP_TEXT"

if [ -z "\$API_URL" ]; then
    echo "Error: API URL not configured"
    exit 1
fi

if [ -z "\$CONTENT" ]; then
    echo "Error: No text selected"
    exit 1
fi

ESCAPED_CONTENT=\$(printf '%s' "\$CONTENT" | sed 's/\\\\/\\\\\\\\/g' | sed 's/"/\\\\"/g' | sed ':a;N;\$!ba;s/\\n/\\\\n/g')
JSON_DATA="{\\"content\\":\\"$ESCAPED_CONTENT\\"}"

curl -s -w "%{http_code}" -X POST -H "Content-Type: application/json" -d "\$JSON_DATA" "\$API_URL" > /dev/null
echo "Saved to flomo successfully"</string>
		</dict>
	</array>
</dict>
</plist>
EOF

echo "Build complete! The extension is ready in $BUILD_PATH"
echo "To install, double-click the Flomo.popclipext folder"