#!/usr/bin/env bash
# setup-pipewire.sh — Low-latency PipeWire configuration script

set -euo pipefail

echo "==> Copying PipeWire config to ~/.config/pipewire..."
mkdir -p ~/.config/pipewire
cp -rv /usr/share/pipewire/* ~/.config/pipewire/

echo ""
echo "==> Patching pipewire-pulse.conf (pulse.min.req and pulse.min.quantum = 32/48000)..."
PULSE_CONF="$HOME/.config/pipewire/pipewire-pulse.conf"

sed -i \
  's/#\?\s*pulse\.min\.req\s*=.*/    pulse.min.req = 32\/48000/' \
  "$PULSE_CONF"

sed -i \
  's/#\?\s*pulse\.min\.quantum\s*=.*/    pulse.min.quantum = 32\/48000/' \
  "$PULSE_CONF"

echo ""
echo "==> Patching pipewire.conf (default.clock.min-quantum = 8)..."
PW_CONF="$HOME/.config/pipewire/pipewire.conf"

sed -i \
  's/#\?\s*default\.clock\.min-quantum\s*=.*/    default.clock.min-quantum = 8/' \
  "$PW_CONF"

echo ""
echo "==> Restarting PipeWire services..."
systemctl --user restart pipewire.service pipewire-pulse.service --now

echo ""
echo "✓ Done! PipeWire is running with low-latency settings."
