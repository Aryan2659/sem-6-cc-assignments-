#!/bin/bash

# ============================================================
#  set_permissions.sh — Set proper access permissions on received file
#  Run this script ON INSTANCE B after receiving the file
#  Usage: bash set_permissions.sh
# ============================================================

FILE="/home/ubuntu/transfer_demo.txt"

echo "🔒 Setting file permissions..."
echo ""

# Set owner read+write, group read, others no access
chmod 640 "$FILE"

# Set file owner to ubuntu
chown ubuntu:ubuntu "$FILE"

echo "✅ Permissions set!"
echo ""
echo "📋 Current permissions:"
ls -lh "$FILE"
echo ""
echo "📄 File contents:"
cat "$FILE"
echo ""
echo "👤 File owner:"
stat -c "%U %G" "$FILE"
