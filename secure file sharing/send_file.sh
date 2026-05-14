#!/bin/bash

# ============================================================
#  send_file.sh — Securely send a file from Instance A to B
#  Run this script ON INSTANCE A
#  Usage: bash send_file.sh
# ============================================================

INSTANCE_B_PRIVATE_IP="INSTANCE_B_PRIVATE_IP"   # Replace with Instance B's Private IP
KEY_PATH="/home/ubuntu/instance-b-key.pem"       # Key must be uploaded to Instance A
FILE_TO_SEND="/home/ubuntu/transfer_demo.txt"    # File you want to send
DEST_PATH="/home/ubuntu/"                         # Destination on Instance B

echo "📤 Sending file to Instance B..."
echo "   From : $FILE_TO_SEND"
echo "   To   : ubuntu@$INSTANCE_B_PRIVATE_IP:$DEST_PATH"
echo ""

# Transfer file securely using SCP
scp -i "$KEY_PATH" -o StrictHostKeyChecking=no "$FILE_TO_SEND" "ubuntu@$INSTANCE_B_PRIVATE_IP:$DEST_PATH"

if [ $? -eq 0 ]; then
    echo "✅ File transferred successfully!"
    echo ""
    echo "📋 Verifying on Instance B..."
    ssh -i "$KEY_PATH" -o StrictHostKeyChecking=no "ubuntu@$INSTANCE_B_PRIVATE_IP" "ls -lh $DEST_PATH"
else
    echo "❌ Transfer failed. Check IP, key, and security group rules."
fi
