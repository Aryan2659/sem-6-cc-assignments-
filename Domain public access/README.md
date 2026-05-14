# Assignment 12 — Static Website with Domain & Public Access
### Host a website accessible via IP address or Domain Name | AWS + Apache

> **LP-II Assignment | Problem Statement 12**  
> Deploy a static website and configure network settings so it's accessible through a public IP or domain name.

---

## 📌 What You Will Build

Same as Assignment 7 (static website on AWS), but with two extra things:
1. A **permanent IP address** (Elastic IP) that never changes even if you restart the server
2. A **domain name** pointing to your server (so people can visit `yoursite.com` instead of a raw IP)

---

## 🧠 Concepts Explained Simply

| Term | What it means |
|------|--------------|
| **AWS** | Amazon Web Services — rent computers from Amazon's datacenters |
| **EC2 Instance** | One virtual computer on AWS — your cloud server |
| **Apache** | Web server software that serves your HTML files to browsers |
| **SSH** | Connect to a remote computer and type commands in it |
| **SCP** | Copy files from your laptop to a remote server |
| **Elastic IP** | A permanent public IP address from AWS — doesn't change when you restart your server |
| **Domain Name** | A human-readable address like `mysite.com` instead of `52.14.123.45` |
| **DNS A Record** | A setting that links a domain name to an IP address |
| **Security Group** | AWS firewall that controls what traffic reaches your server |

---

## ⚠️ STEP 0 — Accounts You Need

### AWS Account (required)
1. Go to **https://aws.amazon.com/free** → click **"Create a Free Account"**
2. Enter email, password, account name → choose **Personal** account
3. Enter credit/debit card for verification (Free Tier won't charge you)
4. Verify phone → choose **"Basic Support - Free"**
5. Sign in at **https://console.aws.amazon.com** using **"Root user"**

### Terminal (Windows users only)
1. Download **Git for Windows**: https://git-scm.com/download/win
2. Install it → right-click Desktop → **"Git Bash Here"** to open a terminal

---

## 📁 Files in This Repo

```
G1-Assignment2-Domain-Public-Access/
├── website/
│   └── index.html    ← Your website (replace with your own HTML)
├── deploy.sh         ← Script to update site remotely
└── README.md
```

---

## ✅ STEP 1 — Launch an EC2 Instance

1. Sign in → go to **https://console.aws.amazon.com**
2. Search for **`EC2`** in the top search bar → click it
3. Click orange **"Launch Instance"** button
4. Fill in settings:
   - **Name** → `static-site-domain`
   - **OS** → Ubuntu → **"Ubuntu Server 22.04 LTS"** (Free tier eligible)
   - **Instance type** → `t2.micro` (Free tier eligible)
5. **Key pair** → click **"Create new key pair"**
   - Name: `website-key` | Type: RSA | Format: `.pem`
   - Click **"Create key pair"** → file downloads automatically → save it safely
6. **Network settings** → click **"Edit"**
   - Auto-assign public IP → **Enable**
   - Keep the SSH rule (Port 22) that's already there
   - Click **"Add security group rule"** → Type: **HTTP** → Source: Anywhere
7. Click **"Launch Instance"** → wait until status shows **"Running"**

---

## ✅ STEP 2 — Allocate an Elastic IP (Permanent IP)

> Without this, your IP changes every time you restart the server — which breaks domain pointing.  
> Elastic IP gives you a fixed permanent IP address.

1. In the EC2 left sidebar, scroll down and click **"Elastic IPs"**  
   *(Under the section called "Network & Security")*
2. Click the orange **"Allocate Elastic IP address"** button
3. Leave all settings as default → click **"Allocate"**
4. You now have a new IP address in the list — click on it to select it
5. Click **"Actions"** button (top right) → click **"Associate Elastic IP address"**
6. In the form that appears:
   - **Instance** → click the dropdown → select your `static-site-domain` instance
   - **Private IP address** → select the IP that appears
7. Click **"Associate"**

✅ Your instance now has a permanent IP. Note it down — this is your server's address from now on.

---

## ✅ STEP 3 — Connect to Your Server via SSH

Open your terminal (Git Bash on Windows, Terminal on Mac):

```bash
# Go to where your .pem file was downloaded
cd ~/Downloads

# Fix key permissions
chmod 400 website-key.pem

# Connect (use your Elastic IP)
ssh -i "website-key.pem" ubuntu@YOUR_ELASTIC_IP
```

When asked `Are you sure you want to continue? (yes/no)` → type `yes`

✅ Your prompt changes to `ubuntu@ip-...` — you're now inside the server.

---

## ✅ STEP 4 — Install Apache Web Server

Run these inside the SSH session, one by one:

```bash
sudo apt update
sudo apt install apache2 -y
sudo systemctl start apache2
sudo systemctl enable apache2
sudo systemctl status apache2
```

Look for `Active: active (running)` ✅

Test: open browser → go to `http://YOUR_ELASTIC_IP` → you should see the Apache default page.

---

## ✅ STEP 5 — Upload Your Website

Open a **new terminal on your laptop** (not the SSH session):

```bash
# Upload your HTML file to the server
scp -i "website-key.pem" ./website/index.html ubuntu@YOUR_ELASTIC_IP:/home/ubuntu/
```

Go back to the SSH terminal and run:

```bash
# Move it to Apache's web folder
sudo cp /home/ubuntu/index.html /var/www/html/index.html
```

Test: browser → `http://YOUR_ELASTIC_IP` → your website appears ✅

---

## ✅ STEP 6 — Point a Domain Name to Your Server

> This makes `http://yourdomain.com` work instead of just the IP.  
> You need to get a domain name first.

### Option A — Free Domain (no cost, good for assignment)

1. Go to **https://afraid.org** → click "Sign Up" → create a free account
2. After login, click **"Add a subdomain"**
3. Fill in:
   - **Type** → A
   - **Subdomain** → type anything you want (e.g. `mywebsite`)
   - **Domain** → pick any free domain from the list (e.g. `.mooo.com`)
   - **Destination** → type your **Elastic IP**
4. Click **"Save"**
5. Wait 5–15 minutes for DNS to update

After waiting, open browser → go to `http://mywebsite.mooo.com` → your site loads ✅

### Option B — Skip Domain, Use IP Only (quickest for submission)

> For the assignment viva, you can demo using just the Elastic IP.  
> Explain that "a DNS A Record would point a domain name to this Elastic IP — I've demonstrated the IP access which is the core requirement."

---

## ✅ STEP 7 — Remote Updates

Edit `deploy.sh` — replace `YOUR_PUBLIC_IP` with your Elastic IP → run:

```bash
bash deploy.sh
```

---

## 🔑 Difference from Assignment 7

| Assignment 7 | Assignment 12 |
|-------------|--------------|
| Regular Public IP (changes on restart) | **Elastic IP** (permanent) |
| Accessible by IP only | Accessible by **IP or domain name** |
| No domain setup | DNS A Record → Elastic IP |

---

## 🧯 If Something Goes Wrong

| Problem | Fix |
|---------|-----|
| Browser can't reach the site via IP | Check Security Group has HTTP port 80 open |
| SSH says "Permission denied" | Run `chmod 400 website-key.pem` |
| Domain not working after 15 min | DNS takes up to an hour sometimes — wait longer |
| IP changed after restart | You forgot to do the Elastic IP step — do Step 2 |
| Apache not running | SSH in and run `sudo systemctl restart apache2` |

---

## 🎓 Viva Points

| Question | Answer |
|----------|--------|
| What is an Elastic IP? | A permanent static public IP from AWS — doesn't change when instance restarts |
| Why do we need Elastic IP for domain setup? | Domain A Records point to a fixed IP — if IP changes, the domain breaks |
| What is a DNS A Record? | A DNS setting that maps a domain name to an IP address |
| What is Apache? | Open-source web server software — serves HTML files to browsers over HTTP |
| What port does HTTP use? | Port 80 |
| What is a Security Group? | AWS virtual firewall controlling inbound/outbound traffic |
| How is this different from Assignment 7? | Adds Elastic IP (fixed address) and DNS domain name configuration |
