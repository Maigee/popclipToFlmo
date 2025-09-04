#!/bin/bash

# PopClip extension for flomo
# Save selected text to flomo via incoming webhook API

API_URL="$POPCLIP_OPTION_API_URL"
CONTENT="$POPCLIP_TEXT"

# Validate API URL
if [ -z "$API_URL" ]; then
    echo "Error: API URL not configured"
    exit 1
fi

# Validate content
if [ -z "$CONTENT" ]; then
    echo "Error: No text selected"
    exit 1
fi

# Prepare JSON payload
ESCAPED_CONTENT=$(printf '%s' "$CONTENT" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g' | sed ':a;N;$!ba;s/\n/\\n/g')
JSON_DATA="{\"content\":\"$ESCAPED_CONTENT\"}"

# Send request
curl -s -w "%{http_code}" \
    -X POST \
    -H "Content-Type: application/json" \
    -d "$JSON_DATA" \
    "$API_URL" > /dev/null

echo "Saved to flomo successfully"