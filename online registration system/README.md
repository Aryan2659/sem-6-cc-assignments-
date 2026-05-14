# Assignment 15 — Online Event Registration System
### Full Stack MERN App Deployment on AWS EC2

> **LP-II Assignment | Problem Statement 15**  
> Deploy a web application where users can register for an event by submitting their details,  
> which are stored in a cloud-hosted database.

---

## 📌 What You Will Build

A live event registration website hosted on AWS where:
- Users visit your website and fill in a registration form (Name, Email, etc.)
- Their data gets saved in a cloud database (MongoDB Atlas)
- The site runs on an AWS EC2 server accessible by anyone via a browser

**App Source Code:** https://github.com/ErAdilrasheed/EventRegistration

---

## 🧠 Concepts Explained Simply

| Term | What it means |
|------|--------------|
| **MERN Stack** | MongoDB + Express + React + Node.js — four technologies that together make a full web app |
| **React** | JavaScript library for building the frontend (what users see in the browser) |
| **Node.js** | JavaScript runtime that runs on the server — powers the backend |
| **Express.js** | A framework for Node.js — makes building APIs easy |
| **MongoDB** | A database that stores data as JSON-like documents |
| **MongoDB Atlas** | Cloud-hosted MongoDB — free tier available, no server needed |
| **EC2** | AWS virtual computer — your cloud server |
| **PM2** | A tool that keeps your Node.js app running 24/7 even after you close SSH |
| **Nginx** | A web server that handles incoming traffic and forwards it to your Node app |
| **SSH** | Connect to a remote server and type commands in it from your laptop |

---

## ⚠️ STEP 0 — Accounts You Need (All Free)

### Account 1 — AWS (for the server)

1. Go to **https://aws.amazon.com/free** → click **"Create a Free Account"**
2. Enter email, password, account name → choose **Personal**
3. Enter credit/debit card *(Free Tier won't charge for t2.micro)*
4. Verify phone → choose **"Basic Support - Free"**
5. Sign in at **https://console.aws.amazon.com** → choose **Root user**

### Account 2 — MongoDB Atlas (for the database)

1. Go to **https://www.mongodb.com/cloud/atlas/register**
2. Enter your email → set a password → click **"Create your Atlas account"**
3. Verify your email
4. You'll be taken through a setup wizard:
   - **What is your goal?** → select "Learn MongoDB"
   - **Preferred language?** → select "JavaScript"
   - Click **"Finish"**
5. A page appears to create a cluster — click **"Create"** on the **FREE (M0)** option
6. Choose **AWS** as provider → select region **Mumbai (ap-south-1)** → click **"Create Deployment"**
7. A popup asks to create a database user:
   - **Username** → `adminuser`
   - **Password** → click **"Autogenerate"** → copy the password and save it!
   - Click **"Create Database User"**
8. Next it asks where to connect from → click **"Add My Current IP Address"** → click **"Finish and Close"**

### Account 3 — GitHub (to clone the code)

> You probably already have one, but if not:
1. Go to **https://github.com** → click **Sign up** → create an account

### Terminal for Windows users:
1. Download **Git for Windows**: https://git-scm.com/download/win
2. Install → right-click Desktop → **"Git Bash Here"**

---

## 📁 Files in This Repo

```
A15-Event-Registration-MERN/
├── scripts/
│   ├── deploy.sh      ← Run this on EC2 to update the app after any code changes
│   └── sample.env     ← Template for your .env file (copy and fill in your details)
└── README.md
```

> The actual app code is at: https://github.com/ErAdilrasheed/EventRegistration  
> You will clone that directly onto your EC2 server in Step 5.

---

## ✅ STEP 1 — Get Your MongoDB Connection String

> You need this to connect your app to the database.

1. Log in to **https://cloud.mongodb.com**
2. You'll see your cluster on the dashboard — click **"Connect"** button next to it
3. In the popup, click **"Drivers"**
4. Make sure **Driver: Node.js** and **Version: 5.5 or later** is selected
5. You'll see a connection string like:
   ```
   mongodb+srv://adminuser:<password>@cluster0.xxxxx.mongodb.net/?retryWrites=true&w=majority
   ```
6. Copy this string → replace `<password>` with the password you saved earlier
7. Also add your database name — change `/?retryWrites` to `/eventregistration?retryWrites`

Final string looks like:
```
mongodb+srv://adminuser:MyPassword123@cluster0.abcde.mongodb.net/eventregistration?retryWrites=true&w=majority
```

**Save this — you'll need it in Step 6.**

---

## ✅ STEP 2 — Allow All IPs to Access MongoDB Atlas

> By default Atlas only allows your home IP. We need to allow your EC2 server's IP too.  
> Easiest for assignment: allow ALL IPs.

1. In MongoDB Atlas, click **"Network Access"** in the left sidebar
2. Click **"Add IP Address"**
3. Click **"Allow Access from Anywhere"** → click **"Confirm"**

---

## ✅ STEP 3 — Launch an AWS EC2 Instance

1. Go to **https://console.aws.amazon.com** → search `EC2` → click it
2. Click orange **"Launch Instance"** button
3. Fill in:
   - **Name** → `event-registration-server`
   - **OS** → Ubuntu → **Ubuntu Server 22.04 LTS** (Free tier eligible)
   - **Instance type** → `t2.micro` (Free tier eligible)
4. **Key pair** → click **"Create new key pair"**
   - Name: `event-key` | Type: RSA | Format: `.pem`
   - Click **"Create key pair"** → `event-key.pem` downloads → **save this file!**
5. **Network settings** → click **"Edit"**
   - Auto-assign public IP → **Enable**
   - Keep SSH rule (Port 22) — Anywhere
   - Click **"Add security group rule"** → Type: **HTTP** → Port 80 → Anywhere
   - Click **"Add security group rule"** → Type: **Custom TCP** → Port: `5000` → Anywhere
   - Click **"Add security group rule"** → Type: **Custom TCP** → Port: `3000` → Anywhere
6. Click **"Launch Instance"** → wait until **"Running"** ✅
7. Click your instance → note the **Public IPv4 address** (e.g. `52.14.123.45`)

---

## ✅ STEP 4 — Connect to Your EC2 Server

Open terminal (Git Bash on Windows, Terminal on Mac/Linux):

```bash
cd ~/Downloads
chmod 400 event-key.pem
ssh -i "event-key.pem" ubuntu@YOUR_PUBLIC_IP
```

Type `yes` when asked. ✅ Your prompt changes to `ubuntu@ip-...` — you're inside the server.

---

## ✅ STEP 5 — Install Required Software on EC2

You are now inside the server. Run these commands **one by one**:

### Install Node.js

```bash
# Download and run Node.js installer
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -

# Install Node.js
sudo apt-get install -y nodejs

# Verify installation (should show version numbers)
node --version
npm --version
```

### Install Git

```bash
sudo apt update
sudo apt install git -y
git --version
```

### Install PM2 (keeps app running 24/7)

```bash
sudo npm install -g pm2
```

### Install Nginx (handles web traffic)

```bash
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
```

---

## ✅ STEP 6 — Clone the App and Set Up Environment

Still inside the EC2 SSH session:

```bash
# Clone the app from GitHub
git clone https://github.com/ErAdilrasheed/EventRegistration.git
cd EventRegistration
```

### Set up the backend .env file

```bash
# Go into the server folder
cd server

# Create the .env file
nano .env
```

A text editor opens. Type (or paste) the following — replace with YOUR MongoDB string from Step 1:

```
MONGO_URI=mongodb+srv://adminuser:YourPassword@cluster0.xxxxx.mongodb.net/eventregistration?retryWrites=true&w=majority
PORT=5000
```

To save and exit nano:
- Press **Ctrl+X**
- Press **Y** (yes to save)
- Press **Enter**

### Install backend dependencies

```bash
# Still in /server folder
npm install
```

---

## ✅ STEP 7 — Build the React Frontend

```bash
# Go to client folder
cd /home/ubuntu/EventRegistration/client

# Install frontend dependencies
npm install

# Build the React app for production
npm run build
```

This creates a `build/` folder with the compiled frontend files.

---

## ✅ STEP 8 — Start the Backend Server

```bash
cd /home/ubuntu/EventRegistration/server

# Start with PM2 so it keeps running
pm2 start index.js --name event-app

# Save PM2 config so it restarts on server reboot
pm2 save
pm2 startup
```

The last command (`pm2 startup`) will print a command for you to run — copy it and run it.

---

## ✅ STEP 9 — Configure Nginx (Forward Traffic to Your App)

Nginx listens on port 80 (default HTTP) and forwards to your Node app on port 5000.

```bash
# Open Nginx config
sudo nano /etc/nginx/sites-available/default
```

**Delete all existing content** (Ctrl+K repeatedly or select all) and replace with:

```nginx
server {
    listen 80;
    server_name _;

    # Serve React frontend
    location / {
        root /home/ubuntu/EventRegistration/client/build;
        index index.html;
        try_files $uri $uri/ /index.html;
    }

    # Forward /api requests to Node backend
    location /api {
        proxy_pass http://localhost:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

Save and exit (Ctrl+X → Y → Enter).

Test and restart Nginx:

```bash
sudo nginx -t
sudo systemctl restart nginx
```

---

## ✅ STEP 10 — Test Your Live Website

Open your browser and go to:
```
http://YOUR_EC2_PUBLIC_IP
```

✅ You should see the Event Registration form!

Fill in the form and submit → the data gets saved to MongoDB Atlas.

**To verify data in MongoDB:**
1. Go to **https://cloud.mongodb.com**
2. Click **"Browse Collections"** on your cluster
3. You'll see the `eventregistration` database → `registrations` collection → your submitted records!

---

## 🔄 How to Update the App Later

If the original repo gets updated or you make changes:

```bash
# SSH into your EC2
ssh -i "event-key.pem" ubuntu@YOUR_PUBLIC_IP

# Go to app folder and run deploy script
cd /home/ubuntu/EventRegistration
bash /home/ubuntu/deploy.sh
```

Or upload and run `scripts/deploy.sh` from this repo.

---

## 🧯 If Something Goes Wrong

| Problem | Fix |
|---------|-----|
| Browser shows "This site can't be reached" | Check EC2 Security Group has port 80 open |
| Form submits but data not saving | Check `.env` file has correct MongoDB URI — SSH in and run `cat server/.env` |
| MongoDB connection error in logs | Check Atlas Network Access allows all IPs (Step 2) |
| `npm: command not found` | Node.js install failed — re-run the curl command in Step 5 |
| Nginx shows default page not your app | Check the nginx config path is correct — run `sudo nginx -t` to see errors |
| App crashes after SSH disconnect | You didn't start with PM2 — run `pm2 start index.js --name event-app` |
| Port 5000 not accessible | Add Custom TCP port 5000 rule in EC2 Security Group |
| `npm run build` fails | Run `npm install` first in the client folder |

**Checking PM2 logs if app crashes:**
```bash
pm2 logs event-app
```

**Restarting the app:**
```bash
pm2 restart event-app
```

---

## 🎓 Viva Points

| Question | Answer |
|----------|--------|
| What is the MERN stack? | MongoDB + Express.js + React.js + Node.js — a full-stack JavaScript framework |
| What does each part do? | React = frontend UI, Node/Express = backend API server, MongoDB = database |
| What is MongoDB Atlas? | Cloud-hosted MongoDB database — no need to install MongoDB on your server |
| What is PM2? | Process Manager 2 — keeps Node.js apps running 24/7, auto-restarts on crash |
| What is Nginx? | Web server that handles HTTP traffic on port 80 and forwards API requests to Node on port 5000 |
| What is an .env file? | Environment variables file — stores secrets like DB passwords, not committed to GitHub |
| What port does HTTP use? | Port 80 |
| What port does the Node backend run on? | Port 5000 |
| Why build the React app? | `npm run build` compiles React JSX into plain HTML/JS/CSS that browsers can read directly |
| How is data stored? | User submits form → React sends POST request → Express API → saves to MongoDB Atlas |
