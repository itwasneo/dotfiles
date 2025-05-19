#!/usr/bin/bash

set -e

read -p "Enter your username: " USERNAME

HOME_DIR=/home/$USERNAME

# Get the paths to the currently used applications
JMC_BIN="$(readlink -f $HOME_DIR/.sdkman/candidates/jmc/current/bin/jmc)"

if [[ ! -x "$JMC_BIN" ]]; then
    echo "JMC is not installed"
    exit 1
fi

JMC_DESKTOP_FILE="$HOME_DIR/.local/share/applications/jmc.desktop"

mkdir -p "$(dirname "$JMC_DESKTOP_FILE")"

cat > "$JMC_DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=Java Mission Control
Comment=Java Flight Recorder UI Tool
Exec="$JMC_BIN"
Icon=java
Terminal=false
Type=Application
Categories=Development;Java;
StartupWMClass=org-eclipse-ui-IDE
EOF

chmod +x "$JMC_DESKTOP_FILE"

echo "JMC is added as desktop app"
