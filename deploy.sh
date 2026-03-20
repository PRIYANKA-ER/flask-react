#!/bin/bash
set -e

echo "Pulling latest code..."
git pull origin main

echo "Building frontend..."
cd frontend
npm ci
npm run build
sudo cp -r build/* /var/www/html/
cd ..

echo "Setting up backend..."
cd backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

echo "Restarting backend..."
pkill -f "python app.py" || true
nohup python app.py > backend.log 2>&1 &

cd ..

echo "Reloading Nginx..."
sudo nginx -s reload

echo "✅ Deployment complete!"
