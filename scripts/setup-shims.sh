#!/bin/bash
IMAGE=$1
SHIM_DIR=$2

if [ -z "$IMAGE" ] || [ -z "$SHIM_DIR" ]; then
  echo "Usage: $0 <image> <shim_dir>"
  exit 1
fi

mkdir -p "$SHIM_DIR"

# List of binutils tools to shim
TOOLS=("as" "ld" "nm" "objcopy" "objdump" "readelf" "size" "strip" "ar" "ranlib")

for TOOL in "${TOOLS[@]}"; do
  cat <<EOF > "$SHIM_DIR/$TOOL"
#!/bin/bash
# Automatically generated shim for $TOOL to run inside Docker
docker run --rm -i \\
  -v "\$(pwd):\$(pwd)" \\
  -w "\$(pwd)" \\
  -u "\$(id -u):\$(id -g)" \\
  "$IMAGE" \\
  $TOOL "\$@"
EOF
  chmod +x "$SHIM_DIR/$TOOL"
done

echo "Shims created in $SHIM_DIR"
