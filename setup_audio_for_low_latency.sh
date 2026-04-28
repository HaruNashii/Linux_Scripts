#!/usr/bin/env bash
# setup-pipewire-cachy.sh — Low-latency PipeWire for CachyOS (idempotent)

set -euo pipefail

CHANGED=0

patch_setting() {
    local file="$1"
    local match_pattern="$2"
    local sed_pattern="$3"
    local description="$4"

    if grep -qP "$match_pattern" "$file" 2>/dev/null; then
        echo "  [skip] $description — already set"
    else
        sed -i "$sed_pattern" "$file"
        echo "  [set]  $description"
        CHANGED=1
    fi
}

# ── PipeWire user config ───────────────────────────────────────────────────────

echo "==> Ensuring PipeWire user config exists..."
mkdir -p ~/.config/pipewire

if [ ! -f "$HOME/.config/pipewire/pipewire.conf" ]; then
    cp -rv /usr/share/pipewire/* ~/.config/pipewire/
    CHANGED=1
    echo "  [copy] /usr/share/pipewire → ~/.config/pipewire/"
else
    echo "  [skip] Config files already exist"
fi

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

patch_setting "$PW_CONF" \
    "^\s*mem\.allow-mlock\s*=\s*true" \
    's/#\?\s*mem\.allow-mlock\s*=.*/    mem.allow-mlock = true/' \
    "mem.allow-mlock = true"

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

# ── rtkit (CachyOS preferred RT method) ───────────────────────────────────────

echo ""
echo "==> Checking rtkit-daemon..."

if systemctl is-enabled --quiet rtkit-daemon 2>/dev/null; then
    echo "  [skip] rtkit-daemon already enabled"
else
    echo "  [set]  Enabling rtkit-daemon"
    sudo systemctl enable --now rtkit-daemon
    CHANGED=1
fi

# ── audio group ───────────────────────────────────────────────────────────────

echo ""
echo "==> Checking audio group membership..."

if groups "$USER" | grep -q '\baudio\b'; then
    echo "  [skip] $USER already in audio group"
else
    echo "  [set]  Adding $USER to audio group"
    sudo usermod -aG audio "$USER"
    echo "  [!]    Log out and back in for group changes to take effect"
    CHANGED=1
fi

# ── Kernel / sysctl tuning ────────────────────────────────────────────────────

echo ""
echo "==> Checking sysctl tuning..."
SYSCTL_CONF="/etc/sysctl.d/99-audio.conf"

if [ -f "$SYSCTL_CONF" ] && grep -q "vm.swappiness" "$SYSCTL_CONF"; then
    echo "  [skip] sysctl audio tuning already set"
else
    echo "  [set]  Writing $SYSCTL_CONF"
    sudo tee "$SYSCTL_CONF" > /dev/null <<'EOF'
vm.swappiness = 10
kernel.sched_autogroup_enabled = 1
EOF
    sudo sysctl -p "$SYSCTL_CONF" > /dev/null
    CHANGED=1
fi

# ── CPU governor ──────────────────────────────────────────────────────────────

echo ""
echo "==> Checking CPU governor..."
CURRENT_GOV=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null || echo "unknown")

if [ "$CURRENT_GOV" = "performance" ]; then
    echo "  [skip] CPU governor already set to performance"
else
    echo "  [set]  Setting CPU governor to performance"
    sudo cpupower frequency-set -g performance > /dev/null
    CHANGED=1
fi

# ── WirePlumber quantum forcing ────────────────────────────────────────────────

echo ""
echo "==> Checking WirePlumber config..."
WP_DIR="$HOME/.config/wireplumber/main.lua.d"
WP_CONF="$WP_DIR/51-quantum.lua"
mkdir -p "$WP_DIR"

if [ -f "$WP_CONF" ]; then
    echo "  [skip] WirePlumber quantum rule already exists"
else
    echo "  [set]  Writing WirePlumber quantum forcing rule"
    cat > "$WP_CONF" <<'EOF'
rule = {
  matches = { { { "media.role", "matches", "Game" } } },
  apply_properties = {
    ["audio.rate"]    = 48000,
    ["audio.quantum"] = 64,
  }
}
EOF
    CHANGED=1
fi

# ── Restart services ──────────────────────────────────────────────────────────

echo ""
if [ "$CHANGED" -eq 1 ]; then
    echo "==> Changes detected — restarting PipeWire services..."
    systemctl --user restart pipewire wireplumber pipewire-pulse
    echo ""
    echo "✓ Done! CachyOS low-latency setup applied."
    echo "  Tip: verify with 'pw-top' and watch for xruns (marked with X)."
else
    echo "✓ Nothing to do — all settings already applied."
fi
