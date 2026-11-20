#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Restart AeroSpace & Borders
# @raycast.mode silent
# @raycast.packageName Window Management

# Kill existing processes (ignore errors if one isn't running)
killall AeroSpace 2>/dev/null
killall borders 2>/dev/null

# Brief pause to let macOS release accessibility hooks cleanly
sleep 0.5

# Relaunch AeroSpace (which triggers borders via after-startup-command)
open -a AeroSpace

echo "AeroSpace & Borders restarted"
