# Assignment 7 — Static Website Deployment on AWS EC2
### Host a website on a cloud server | AWS + Apache

> **LP-II Assignment | Problem Statement 7**  
> Deploy a static website on a cloud VM. Configure server and networking so it's publicly accessible and can be updated remotely.

---

## 📌 What You Will Build

A real website hosted on a cloud server (AWS) that:
- Anyone in the world can visit using your server's IP address in their browser
- You can update remotely from your laptop without physically touching the server

---

## 🧠 Concepts Explained Simply

| Term | What it means |
|------|--------------|
| **AWS** | Amazon Web Services — Amazon rents you computers in their datacenters. You access them over the internet |
| **EC2 Instance** | One virtual computer rented from AWS. Like a laptop but it lives on Amazon's servers |
| **Ubuntu** | A Linux operating system. Your EC2 runs this — like Windows but text-based |
| **Apache** | Software that turns your server into a web server — it "serves" HTML files to browsers |
| **SSH** | A way to connect to a remote computer and type commands in it from your own laptop |
| **SCP** | A way to copy files from your laptop to a remote computer, over SSH |
| **Security Group** | AWS firewall — controls what traffic can reach your server |
| **Public IP** | The address people use to visit your website (like `http://52.14.X.X`) |
| **.pem file** | A key file — like a physical key to your server. You need it every time you SSH in |

---

## ⚠️ STEP 0 — Create a Free AWS Account

> AWS has a Free Tier — you get certain services free for 12 months. EC2 t2.micro is free.

1. Open: **https://aws.amazon.com/free**
2. Click **"Create a Free Account"**
3. Enter your email → set a password → set an account name (e.g. `myname-aws`)
4. Choose **"Personal"** account type → fill in your details
5. Enter a **credit/debit card** — AWS requires one for verification but won't charge you for Free Tier usage
6. Verify your phone number via OTP
7. Choose the **"Basic Support - Free"** plan
8. ✅ Account created! You'll get a confirmation email.
9. Sign in at **https://console.aws.amazon.com**

> 💡 When signing in, choose **"Root user"** and use the email you registered with

---

## ⚠️ STEP 0.5 — Install a Terminal on Windows

> Mac and Linux users already have a terminal. **Windows users** need to install one.

1. Download **Git for Windows**: https://git-scm.com/download/win
2. Run the installer → click Next through all steps → Install
3. After install, right-click on your Desktop → click **"Git Bash Here"**
4. A black terminal window opens — this is your terminal for all commands in this assignment

---

## 📁 Files in This Repo

```
G1-Static-Website-AWS/
├── website/
│   └── index.html    ← Your website (replace with your own HTML file)
├── deploy.sh         ← Script to update the site remotely in one command
└── README.md
```

---

## ✅ STEP 1 — Launch an EC2 Instance (Your Cloud Server)

1. Sign in to **https://console.aws.amazon.com**
2. In the search bar at the top, type **`EC2`** → click **"EC2"** in the results
3. On the EC2 Dashboard, click the orange **"Launch Instance"** button
4. Fill in the settings:

**Name and OS:**
- **Name** → type `static-website-server`
- **Application and OS Images** → make sure **"Ubuntu"** is selected
- Under Ubuntu, select **"Ubuntu Server 22.04 LTS"**
- Make sure it says **"Free tier eligible"** below it

**Instance type:**
- Should already say **`t2.micro`** — make sure it says **"Free tier eligible"**

**Key pair:**
- Click **"Create new key pair"**
- **Key pair name** → type `website-key`
- **Key pair type** → RSA
- **Private key file format** → `.pem`
- Click **"Create key pair"**
- ⚠️ A file called `website-key.pem` **automatically downloads** — save this safely. You cannot download it again!

**Network settings:**
- Click the **"Edit"** button next to Network settings
- **Auto-assign public IP** → make sure it says **"Enable"**
- You'll see a rule for SSH already there (Port 22) — leave it
- Click **"Add security group rule"** button to add a second rule:
  - **Type** → select **"HTTP"** from the dropdown
  - **Source type** → "Anywhere"
  - *(Port 80 fills automatically)*

5. Leave everything else as default
6. Click the orange **"Launch Instance"** button at the bottom right
7. Click **"View all instances"**
8. Wait about 1-2 minutes until the **"Instance state"** column shows **"Running"** ✅

---

## ✅ STEP 2 — Find Your Server's Public IP

1. In the EC2 instances list, click on your instance name `static-website-server`
2. In the details panel that appears, find **"Public IPv4 address"**
3. Copy that IP — it looks like `52.14.123.45`
4. Save it somewhere — you'll use it many times

---

## ✅ STEP 3 — Connect to Your Server (SSH)

> SSH = Secure Shell. It lets you type commands on your cloud server from your own laptop.

Open your terminal (Git Bash on Windows, Terminal on Mac/Linux):

```bash
# Step 1: Go to the folder where website-key.pem was downloaded
cd ~/Downloads

# Step 2: Fix the key file permissions (required — SSH refuses to work without this)
chmod 400 website-key.pem

# Step 3: Connect to your server (replace YOUR_PUBLIC_IP with the IP from Step 2)
ssh -i "website-key.pem" ubuntu@YOUR_PUBLIC_IP
```

**Example:** `ssh -i "website-key.pem" ubuntu@52.14.123.45`

You'll see a message like:
```
Are you sure you want to continue connecting (yes/no)?
```
Type `yes` and press Enter.

✅ You're now inside your cloud server! Your terminal prompt changes to something like:
```
ubuntu@ip-172-31-XX-XX:~$
```

Everything you type now runs ON the cloud server, not your laptop.

---

## ✅ STEP 4 — Install Apache Web Server

You're inside the server via SSH. Run these commands **one by one** — wait for each to finish:

```bash
# Update the package list
sudo apt update

# Install Apache web server
sudo apt install apache2 -y

# Start Apache
sudo systemctl start apache2

# Make Apache start automatically if server restarts
sudo systemctl enable apache2

# Check Apache is running
sudo systemctl status apache2
```

When you run the last command, look for the line that says:
```
Active: active (running)
```
That means Apache is working ✅

**Test it:** Open your browser → go to `http://YOUR_PUBLIC_IP`  
You should see the **Apache Ubuntu Default Page** — a page that says "It works!" in big letters.

---

## ✅ STEP 5 — Upload Your Website to the Server

> You'll do this from a **new terminal window on your laptop** (not the SSH one)

Open a new terminal window and run:

```bash
# Go to the folder where your key and website files are
cd ~/Downloads

# Upload your HTML file to the server
# Replace YOUR_PUBLIC_IP with your actual IP
scp -i "website-key.pem" /path/to/your/index.html ubuntu@YOUR_PUBLIC_IP:/home/ubuntu/
```

**Example:** If your index.html is on your Desktop:
```bash
scp -i "website-key.pem" ~/Desktop/index.html ubuntu@52.14.123.45:/home/ubuntu/
```

Now go back to your SSH terminal (the one connected to the server) and run:

```bash
# Move the file to Apache's web folder
sudo cp /home/ubuntu/index.html /var/www/html/index.html
```

**Test it:** Open browser → go to `http://YOUR_PUBLIC_IP`  
Your website should now appear! ✅

---

## ✅ STEP 6 — Update Your Website Remotely (Future Updates)

Whenever you change your HTML and want to update the live website, run this from your laptop:

### Option A — Use the deploy script (easiest)

1. Open `deploy.sh` from this repo in a text editor
2. Replace `YOUR_PUBLIC_IP` with your actual IP
3. Move `deploy.sh` and `website-key.pem` to the same folder
4. Run:

```bash
bash deploy.sh
```

Done — website updated! ✅

### Option B — Manual command

```bash
scp -i "website-key.pem" index.html ubuntu@YOUR_PUBLIC_IP:/home/ubuntu/ && ssh -i "website-key.pem" ubuntu@YOUR_PUBLIC_IP "sudo cp /home/ubuntu/index.html /var/www/html/index.html"
```

---

## 🧯 If Something Goes Wrong

| Problem | Fix |
|---------|-----|
| Browser shows "This site can't be reached" | Security Group is missing port 80 rule — go to EC2 → Security Groups → add HTTP inbound rule |
| SSH says "Permission denied" | Run `chmod 400 website-key.pem` first |
| SSH says "Connection timed out" | Instance is still starting — wait 2 minutes and try again |
| SSH says "WARNING: UNPROTECTED PRIVATE KEY FILE" | Run `chmod 400 website-key.pem` |
| Still seeing Apache default page after upload | Run the `sudo cp` command to move file to `/var/www/html/` |
| Browser shows old page after update | Press **Ctrl+Shift+R** to hard refresh, or open in Incognito mode |

---

## 🎓 Viva Points

| Question | Answer |
|----------|--------|
| What is EC2? | Elastic Compute Cloud — AWS's service for renting virtual computers |
| What is Apache? | Open-source web server software that serves HTML files to browsers over HTTP |
| What port does HTTP use? | Port 80 |
| What port does SSH use? | Port 22 |
| What is a Security Group? | AWS virtual firewall that controls inbound and outbound traffic to an EC2 instance |
| What is SCP? | Secure Copy Protocol — transfers files between computers over SSH |
| Where does Apache serve files from? | `/var/www/html/` is Apache's default document root |
| What is a .pem file? | Private key file used for SSH authentication — must have chmod 400 permissions |
| How do you update the website remotely? | SCP to upload the file + SSH to copy it to Apache's web root |
