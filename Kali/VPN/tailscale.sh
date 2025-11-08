#!/usr/bin/env bash
# connect-tailscale.sh
# Simple helper to install (if needed) and connect to Tailscale.
# Usage:
#   sudo ./connect-tailscale.sh            # interactive tailscale up (web auth)
#   sudo ./connect-tailscale.sh --authkey tskey-xxxx   # non-interactive auth
# Optional:
#   --hostname NAME      : set machine hostname in tailscale up
#   --accept-routes      : accept routes when using authkey (useful for subnet routes)
#
set -euo pipefail

AUTHKEY=""
HOSTNAME=""
ACCEPT_ROUTES=0

print_help() {
  cat <<EOF
Usage: sudo $0 [options]

Options:
  --authkey <tskey>     : Tailscale auth key (for non-interactive login)
  --hostname <name>     : Specify hostname to show in Tailscale admin
  --accept-routes       : Add --accept-routes when using authkey
  -h, --help            : show this help
Examples:
  sudo $0
  sudo $0 --authkey tskey-xxxx --hostname lab-node --accept-routes
EOF
}

# parse args
while (( "$#" )); do
  case "$1" in
    --authkey) AUTHKEY="$2"; shift 2;;
    --hostname) HOSTNAME="$2"; shift 2;;
    --accept-routes) ACCEPT_ROUTES=1; shift;;
    -h|--help) print_help; exit 0;;
    *) echo "Unknown arg: $1"; print_help; exit 1;;
  esac
done

if [ "$EUID" -ne 0 ]; then
  echo "Please run with sudo: sudo $0"
  exit 1
fi

echo "== Tailscale connect helper =="
echo "Authkey provided: $( [ -z "$AUTHKEY" ] && echo "no" || echo "yes" )"
[ -n "$HOSTNAME" ] && echo "Hostname to set: $HOSTNAME"
[ $ACCEPT_ROUTES -eq 1 ] && echo "Will add --accept-routes when running tailscale up"

# Install Tailscale if not present (Debian/Ubuntu method)
if ! command -v tailscale >/dev/null 2>&1; then
  echo "Tailscale not found. Installing..."
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL https://tailscale.com/install.sh | sh
  else
    echo "curl not installed. Please install curl or install Tailscale manually."
    exit 1
  fi
else
  echo "Tailscale already installed."
fi

# Build tailscale up command
TS_CMD=(tailscale up)
if [ -n "$AUTHKEY" ]; then
  TS_CMD+=(--authkey="$AUTHKEY")
fi
if [ -n "$HOSTNAME" ]; then
  TS_CMD+=(--hostname="$HOSTNAME")
fi
if [ $ACCEPT_ROUTES -eq 1 ]; then
  TS_CMD+=(--accept-routes)
fi

echo "Running: ${TS_CMD[*]}"
# Run tailscale up (interactive if no authkey)
if "${TS_CMD[@]}"; then
  echo "Tailscale up succeeded."
else
  echo "Tailscale up failed. Check output above for errors."
  exit 2
fi

# Show status and IPs
echo
echo "Tailscale status (short):"
tailscale status || true
echo
echo "Tailscale IPv4 addresses:"
tailscale ip -4 || true
echo "Tailscale IPv6 addresses:"
tailscale ip -6 || true

echo
echo "You can now connect to this machine using its Tailscale IP shown above."
echo "If you used interactive auth, complete the web login in your browser if prompted."
