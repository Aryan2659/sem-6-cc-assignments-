#!/bin/bash

# ============================================================
#  deploy.sh — Upload & update static website on AWS EC2
#  Usage: bash deploy.sh
# ============================================================

KEY="website-key.pem"             # Path to your .pem key file
EC2_USER="ubuntu"
EC2_IP="YOUR_PUBLIC_IP"           # Replace with your EC2 Elastic IP or Public IP
LOCAL_FILE="./website/index.html" # Path to your HTML file

echo "🚀 Deploying website..."

scp -i "$KEY" "$LOCAL_FILE" "$EC2_USER@$EC2_IP:/home/ubuntu/"
ssh -i "$KEY" "$EC2_USER@$EC2_IP" "sudo cp /home/ubuntu/index.html /var/www/html/index.html"

echo "✅ Done! Visit: http://$EC2_IP"
