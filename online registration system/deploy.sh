#!/bin/bash

# ============================================================
#  deploy.sh — Pull latest code & restart app on EC2
#  Run this INSIDE your EC2 instance after first-time setup
#  Usage: bash deploy.sh
# ============================================================

APP_DIR="/home/ubuntu/EventRegistration"

echo "🚀 Deploying latest code..."

cd $APP_DIR

# Pull latest from GitHub
git pull origin main

# Install any new dependencies
echo "📦 Installing server dependencies..."
cd server && npm install

echo "📦 Installing client dependencies..."
cd ../client && npm install

# Rebuild React frontend
echo "⚛️  Building React app..."
npm run build

# Copy build to server's public folder
cp -r build ../server/public

# Restart the backend with PM2
echo "🔄 Restarting backend..."
cd ../server
pm2 restart event-app || pm2 start index.js --name event-app

echo "✅ Deployment complete!"
echo "   Visit: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)"
