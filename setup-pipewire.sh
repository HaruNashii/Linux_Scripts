#!/usr/bin/env bash
# setup-pipewire.sh — Low-latency PipeWire configuration script (idempotent)

set -euo pipefail

CHANGED=0

# ── Helpers ────────────────────────────────────────────────────────────────────

# patch_setting FILE PATTERN REPLACEMENT DESCRIPTION
# Applies sed replacement only if the current value doesn't already match.
patch_setting() {
    local file="$1"
    local match_pattern="$2"   # grep pattern to check if value already correct
    local sed_pattern="$3"     # sed expression to apply if not already correct
    local description="$4"

    if grep -qP "$match_pattern" "$file" 2>/dev/null; then
        echo "  [skip] $description — already set"
    else
        sed -i "$sed_pattern" "$file"
        echo "  [set]  $description"
        CHANGED=1
    fi
}

# ── Config copy ────────────────────────────────────────────────────────────────

echo "==> Ensuring PipeWire user config exists..."
mkdir -p ~/.config/pipewire

if [ ! -f "$HOME/.config/pipewire/pipewire.conf" ]; then
    echo "  [copy] /usr/share/pipewire → ~/.config/pipewire/"
    cp -rv /usr/share/pipewire/* ~/.config/pipewire/
    CHANGED=1
else
    echo "  [skip] Config files already exist"
fi

# ── pipewire.conf ──────────────────────────────────────────────────────────────

echo ""
echo "==> Checking pipewire.conf..."
PW_CONF="$HOME/.config/pipewire/pipewire.conf"

patch_setting "$PW_CONF" \
    "^\s*default\.clock\.rate\s*=\s*48000" \
    's/#\?\s*default\.clock\.rate\s*=.*/    default.clock.rate = 48000/' \
    "default.clock.rate = 48000"

patch_setting "$PW_CONF" \
    "^\s*default\.clock\.quantum\s*=\s*64$" \
    's/#\?\s*default\.clock\.quantum\s*=.*/    default.clock.quantum = 64/' \
    "default.clock.quantum = 64"

patch_setting "$PW_CONF" \
    "^\s*default\.clock\.min-quantum\s*=\s*32$" \
    's/#\?\s*default\.clock\.min-quantum\s*=.*/    default.clock.min-quantum = 32/' \
    "default.clock.min-quantum = 32"

patch_setting "$PW_CONF" \
    "^\s*default\.clock\.max-quantum\s*=\s*256$" \
    's/#\?\s*default\.clock\.max-quantum\s*=.*/    default.clock.max-quantum = 256/' \
    "default.clock.max-quantum = 256"

# ── pipewire-pulse.conf ────────────────────────────────────────────────────────

echo ""
echo "==> Checking pipewire-pulse.conf..."
PULSE_CONF="$HOME/.config/pipewire/pipewire-pulse.conf"

patch_setting "$PULSE_CONF" \
    "^\s*pulse\.min\.req\s*=\s*64/48000$" \
    's/#\?\s*pulse\.min\.req\s*=.*/    pulse.min.req = 64\/48000/' \
    "pulse.min.req = 64/48000"

patch_setting "$PULSE_CONF" \
    "^\s*pulse\.min\.quantum\s*=\s*64/48000$" \
    's/#\?\s*pulse\.min\.quantum\s*=.*/    pulse.min.quantum = 64\/48000/' \
    "pulse.min.quantum = 64/48000"

# ── Restart only if something changed ─────────────────────────────────────────

echo ""
if [ "$CHANGED" -eq 1 ]; then
    echo "==> Changes detected — restarting PipeWire services..."
    systemctl --user restart pipewire wireplumber pipewire-pulse
    echo ""
    echo "✓ Done! PipeWire is running with low-latency settings."
else
    echo "✓ Nothing to do — all settings already applied."
fi
