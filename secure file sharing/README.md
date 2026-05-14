# Assignment 8 — Secure File Sharing Between Cloud Instances
### Two AWS EC2 servers talking to each other | SSH + SCP + VPC

> **LP-II Assignment | Problem Statement 8**  
> Create two cloud VMs in the same virtual network. Securely transfer files between them with proper access permissions.

---

## 📌 What You Will Build

Two cloud servers (EC2 instances) that:
- Live in the same private network (VPC) on AWS
- Can securely send files to each other using SCP
- Have proper Linux file permissions set on received files

---

## 🧠 Concepts Explained Simply

| Term | What it means |
|------|--------------|
| **EC2 Instance** | A virtual computer rented from AWS — your cloud server |
| **VPC** | Virtual Private Cloud — a private network inside AWS. Like a private office building where your servers live. By default, ALL your EC2 instances are in the same VPC |
| **Private IP** | The IP address used between servers inside the same VPC — not exposed to the internet. Looks like `172.31.x.x` |
| **Public IP** | The IP your laptop uses to reach the server from outside. Looks like `52.x.x.x` |
| **SSH** | Connect to a remote server and type commands in it |
| **SCP** | Secure Copy — copy a file from one computer to another over SSH |
| **Security Group** | AWS firewall — controls what traffic can reach each server |
| **chmod** | Linux command to set file access permissions (who can read/write a file) |
| **.pem file** | Key file — like a physical key to SSH into a server |

---

## ⚠️ STEP 0 — Create a Free AWS Account

1. Go to **https://aws.amazon.com/free** → click **"Create a Free Account"**
2. Enter email, password, account name → choose **Personal** account
3. Enter credit/debit card for verification (Free Tier won't charge you for t2.micro)
4. Verify phone → choose **"Basic Support - Free"**
5. Sign in at **https://console.aws.amazon.com** using **"Root user"**

### Terminal for Windows users:
1. Download **Git for Windows**: https://git-scm.com/download/win
2. Install → right-click Desktop → **"Git Bash Here"** opens a terminal

---

## 📁 Files in This Repo

```
G3-Secure-File-Sharing/
├── sample-files/
│   └── transfer_demo.txt     ← The file we'll transfer between servers
├── scripts/
│   ├── send_file.sh          ← Run on Instance A to send the file to B
│   └── set_permissions.sh    ← Run on Instance B after receiving the file
└── README.md
```

---

## 🏗️ What We're Building

```
Your Laptop
    │
    │ SSH (you control both servers from your laptop)
    │
    ├──────────────────┐         ┌──────────────────┐
    │   Instance A     │  ──SCP──▶   Instance B     │
    │   (Sender)       │         │   (Receiver)     │
    │   Public IP: X   │         │   Public IP: Y   │
    │   Private IP: P  │         │   Private IP: Q  │
    └──────────────────┘         └──────────────────┘
         └─────────────── Same VPC ───────────────┘
```

- You SSH into Instance A from your laptop
- From Instance A, you SCP a file to Instance B using B's **Private IP**
- Both instances are in the **same VPC** so they can reach each other internally

---

## ✅ STEP 1 — Launch Instance A (Sender)

1. Sign in → **https://console.aws.amazon.com** → search **EC2** → click it
2. Click **"Launch Instance"**
3. Fill in:
   - **Name** → `instance-a-sender`
   - **OS** → Ubuntu → **Ubuntu Server 22.04 LTS** (Free tier)
   - **Instance type** → `t2.micro` (Free tier)
4. **Key pair** → click **"Create new key pair"**
   - Name: `instance-a-key` | Type: RSA | Format: `.pem`
   - Click **"Create key pair"** → `instance-a-key.pem` downloads → save it!
5. **Network settings** → click **"Edit"**
   - Auto-assign public IP → **Enable**
   - Keep the SSH rule (Port 22) — Source: Anywhere
6. Click **"Launch Instance"**

---

## ✅ STEP 2 — Launch Instance B (Receiver)

Repeat the exact same steps as above, but:
- **Name** → `instance-b-receiver`
- **Key pair** → click **"Create new key pair"** again
  - Name: `instance-b-key` | Type: RSA | Format: `.pem`
  - `instance-b-key.pem` downloads → save it!

> ⚠️ Make sure Instance B is in the **same region** as Instance A (same region = same VPC automatically)

---

## ✅ STEP 3 — Allow Instance A to Reach Instance B

> Right now, Instance A can't connect to Instance B even in the same VPC.  
> We need to add a security rule that allows servers in the same group to talk to each other.

First, find the Security Group ID:

1. In EC2, click **"Security Groups"** in the left sidebar (under Network & Security)
2. You'll see a security group named something like `launch-wizard-1`
3. Note the **"Security group ID"** — it looks like `sg-0abc123def456`

Now add the rule:

1. Click on the security group name
2. Click the **"Inbound rules"** tab
3. Click **"Edit inbound rules"**
4. Click **"Add rule"**
5. Fill in:
   - **Type** → select **"All traffic"**
   - **Source** → select **"Custom"** → in the search box, paste/type your Security Group ID (`sg-0abc...`)
6. Click **"Save rules"**

✅ Now any server in this security group can freely communicate with other servers in the same group.

> ⚠️ If Instance A and Instance B have different security groups, add this same rule to BOTH groups.  
> To use the same security group: when launching Instance B, under Network settings → select **"Select existing security group"** → pick the same one Instance A uses.

---

## ✅ STEP 4 — Note Down the IPs

Click on each instance to find its IPs:

**Instance A:**
- **Public IPv4 address** → e.g. `52.14.11.22` ← you use this from your laptop
- **Private IPv4 address** → e.g. `172.31.5.10`

**Instance B:**
- **Public IPv4 address** → e.g. `52.14.33.44` ← you use this from your laptop
- **Private IPv4 address** → e.g. `172.31.5.20` ← Instance A uses THIS to send the file

---

## ✅ STEP 5 — Connect to Instance A from Your Laptop

Open your terminal:

```bash
# Go to where your .pem files were downloaded
cd ~/Downloads

# Fix permissions on both keys
chmod 400 instance-a-key.pem
chmod 400 instance-b-key.pem

# SSH into Instance A (use Instance A's PUBLIC IP)
ssh -i "instance-a-key.pem" ubuntu@INSTANCE_A_PUBLIC_IP
```

Type `yes` when prompted. ✅ You're now inside Instance A.

---

## ✅ STEP 6 — Upload Instance B's Key to Instance A

> Instance A needs Instance B's key to SSH/SCP into it.  
> We upload the key from our laptop to Instance A.

Open a **new terminal on your laptop** (keep the SSH session open in the other one):

```bash
# Upload Instance B's key TO Instance A
scp -i "instance-a-key.pem" instance-b-key.pem ubuntu@INSTANCE_A_PUBLIC_IP:/home/ubuntu/
```

Go back to the SSH session (inside Instance A) and fix the key permissions:

```bash
# Inside Instance A
chmod 400 /home/ubuntu/instance-b-key.pem
```

---

## ✅ STEP 7 — Upload the File to Instance A

From your **laptop terminal**:

```bash
# Upload the sample file to Instance A
scp -i "instance-a-key.pem" ./sample-files/transfer_demo.txt ubuntu@INSTANCE_A_PUBLIC_IP:/home/ubuntu/
```

Verify it arrived — in the SSH session (Instance A):

```bash
ls /home/ubuntu/
# You should see transfer_demo.txt listed
```

---

## ✅ STEP 8 — Transfer File from Instance A to Instance B

You are inside Instance A via SSH. Run:

```bash
# Send the file to Instance B using Instance B's PRIVATE IP
scp -i "/home/ubuntu/instance-b-key.pem" /home/ubuntu/transfer_demo.txt ubuntu@INSTANCE_B_PRIVATE_IP:/home/ubuntu/
```

**Example:** `scp -i "/home/ubuntu/instance-b-key.pem" /home/ubuntu/transfer_demo.txt ubuntu@172.31.5.20:/home/ubuntu/`

✅ File is now on Instance B!

---

## ✅ STEP 9 — Verify and Set Permissions on Instance B

Open a new terminal on your laptop and SSH into Instance B directly:

```bash
ssh -i "instance-b-key.pem" ubuntu@INSTANCE_B_PUBLIC_IP
```

Once inside Instance B, check the file arrived:

```bash
ls /home/ubuntu/
cat /home/ubuntu/transfer_demo.txt
```

Now set proper access permissions:

```bash
# Set permissions: owner can read+write, group can read, others have no access
chmod 640 /home/ubuntu/transfer_demo.txt

# Verify permissions were set
ls -lh /home/ubuntu/transfer_demo.txt
```

You should see output like:
```
-rw-r----- 1 ubuntu ubuntu 312 May 14 06:00 transfer_demo.txt
```

This means:
- `-rw-` = owner (ubuntu) can read and write
- `r--` = group can only read
- `---` = others have NO access

---

## ✅ STEP 10 — Using the Scripts (Alternative to Manual Steps)

Instead of running commands manually, you can use the provided scripts:

**Upload and run `send_file.sh` on Instance A:**

1. Edit `scripts/send_file.sh` — replace `INSTANCE_B_PRIVATE_IP` with the actual IP
2. Upload to Instance A:
   ```bash
   scp -i "instance-a-key.pem" ./scripts/send_file.sh ubuntu@INSTANCE_A_PUBLIC_IP:/home/ubuntu/
   ```
3. SSH into Instance A → run:
   ```bash
   bash /home/ubuntu/send_file.sh
   ```

**Upload and run `set_permissions.sh` on Instance B:**

1. Upload:
   ```bash
   scp -i "instance-b-key.pem" ./scripts/set_permissions.sh ubuntu@INSTANCE_B_PUBLIC_IP:/home/ubuntu/
   ```
2. SSH into Instance B → run:
   ```bash
   bash /home/ubuntu/set_permissions.sh
   ```

---

## 🔒 Understanding File Permissions

```
chmod 640 filename

Breaking down: 6  4  0
               │  │  └── Others: no access (0 = ---)
               │  └───── Group: read only (4 = r--)
               └──────── Owner: read + write (6 = rw-)
```

| chmod value | Meaning |
|-------------|---------|
| `chmod 400` | Read-only — used for .pem key files |
| `chmod 600` | Owner read+write only — very secure |
| `chmod 640` | Owner rw, group read, others nothing |
| `chmod 644` | Owner rw, everyone read |
| `chmod 755` | Owner full, everyone read+execute |

---

## 🧯 If Something Goes Wrong

| Problem | Fix |
|---------|-----|
| SCP from Instance A to B times out | Security Group missing "All traffic from same SG" rule — redo Step 3 |
| "Permission denied" on SCP | Run `chmod 400` on the key file being used |
| "No such file" error | Wrong path — check file exists with `ls /home/ubuntu/` |
| SSH works from laptop but not between instances | Instances are in different security groups — add the same-SG rule to both |
| Instance B key not found on Instance A | Re-upload with the SCP command in Step 6 |

---

## 🎓 Viva Points

| Question | Answer |
|----------|--------|
| What is a VPC? | Virtual Private Cloud — isolated private network inside AWS where your instances live |
| Why use Private IP for instance-to-instance transfer? | Private IPs are faster and more secure — they never leave AWS's internal network |
| What is SCP? | Secure Copy Protocol — transfers files encrypted over SSH |
| What does `chmod 640` mean? | Owner: read+write (6), Group: read-only (4), Others: no access (0) |
| What is a Security Group? | AWS virtual firewall — controls allowed inbound and outbound traffic |
| Why upload Instance B's key to Instance A? | Instance A needs the key to authenticate into Instance B when running SCP |
| What does the "All traffic from same SG" rule do? | Allows any instance sharing that security group to freely communicate with others in the same group |
