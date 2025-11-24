#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
    echo "Please run as root (use sudo)"
    exit 1
fi

SUDOERS_FILE="/etc/sudoers"

if grep -Eq "Defaults.*pwfeedback" "$SUDOERS_FILE"; then
    echo "✅ pwfeedback is already enabled."
else
    echo "🔧 pwfeedback not found, enabling..."
    echo "" >> "$SUDOERS_FILE"
    echo "Defaults pwfeedback" >> "$SUDOERS_FILE"

    # Validate sudoers syntax before applying
    if visudo -c >/dev/null 2>&1; then
        echo "✅ pwfeedback successfully added and sudoers syntax is valid."
    else
        echo "❌ Warning: sudoers syntax error detected! Reverting changes..."
        # Remove the last added line if invalid
        sed -i '$d' "$SUDOERS_FILE"
        exit 1
    fi
fi
