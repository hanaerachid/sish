
#!/bin/sh
set -eu

DATA_DIR=/data
PUBKEY_DIR="$DATA_DIR/pubkeys"
KEY_DIR="$DATA_DIR/keys"

mkdir -p "$PUBKEY_DIR" "$KEY_DIR"

# Load the authorized public key from a Railway variable.
if [ -n "${SSH_PUBLIC_KEY:-}" ]; then
    printf '%s\n' "$SSH_PUBLIC_KEY" > "$PUBKEY_DIR/admin.pub"
fi

if [ ! -f "$PUBKEY_DIR/admin.pub" ]; then
    echo "ERROR: Set the SSH_PUBLIC_KEY Railway variable."
    exit 1
fi

exec /sish/sish \
    --ssh-address=:2222 \
    --http-address=:8080 \
    --https=false \
    --authentication=true \
    --authentication-password="${SSH_PASSWORD:-}" \
    --authentication-keys-directory="$PUBKEY_DIR" \
    --private-key-location="$KEY_DIR/ssh_key" \
    --bind-random-ports=false
