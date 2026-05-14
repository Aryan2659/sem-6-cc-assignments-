# 🚀 Getting Started with Salesforce (Complete Beginner Guide)
### Read this FIRST before any Salesforce assignment

---

## What is Salesforce?

Salesforce is a cloud-based platform — think of it like Google Drive but instead of storing files,
it stores business data (like student records, employee info, etc.) and lets you build apps on top of it.

You don't install anything on your laptop. Everything runs in the browser.

---

## STEP 1 — Create a FREE Developer Account

> Salesforce gives developers a completely free account with all features. No credit card needed.

1. Go to 👉 https://developer.salesforce.com/signup
2. Fill in the form:

| Field | What to enter |
|-------|--------------|
| First Name | Your first name |
| Last Name | Your last name |
| Email | Your real email (you'll get a verification link) |
| Role | Select **Developer** |
| Company | Your college name |
| Country | India |
| Postal Code | Your PIN code |
| Username | Must look like an email but doesn't need to be real. Example: `yourname.lp2@myorg.dev` |

3. Click **Sign Me Up**
4. Check your inbox → click **Verify Account**
5. Set a password → you're in!

---

## STEP 2 — Understanding the Salesforce Screen

When you log in, you'll see this:

```
┌─────────────────────────────────────────────────────┐
│  [App Launcher ⬛]  [Search Bar]        [⚙️] [👤]   │  ← Top Bar
├─────────────────────────────────────────────────────┤
│                                                     │
│              Home Page / App Page                   │
│                                                     │
└─────────────────────────────────────────────────────┘
```

| Icon | What it does |
|------|-------------|
| ⬛ App Launcher (9 dots, top left) | Switch between apps |
| ⚙️ Gear icon (top right) | Opens Setup — where you configure everything |
| Developer Console (under ⚙️) | Where you write and run Apex code |

---

## STEP 3 — How to Open Setup

> Setup is where you create objects, fields, Apex classes, and Visualforce pages.

1. Click the **⚙️ gear icon** (top right)
2. Click **"Setup"**
3. A new page opens — this is the Setup home
4. On the LEFT side there's a search bar — use it to find anything

```
Setup Home
├── Search bar (left sidebar) ← type here to find things fast
├── Object Manager            ← create/manage custom objects (database tables)
├── Apex Classes              ← write backend code
├── Visualforce Pages         ← build web UI pages
└── Developer Console         ← run code interactively
```

---

## STEP 4 — How to Open Developer Console

> Developer Console = Salesforce's browser-based IDE for writing and running Apex code.

1. Click **⚙️** → **Developer Console**
2. A new browser window opens
3. For running scripts: **Debug → Open Execute Anonymous Window**
4. For creating classes: **File → New → Apex Class**
5. For creating LWC: **File → New → Lightning Component**

---

## STEP 5 — Key Terms You Must Know

| Term | What it means |
|------|--------------|
| **Object** | A database table. `Student__c` = Student table |
| **Record** | One row in the table. One student = one record |
| **Field** | A column in the table. `Roll_No__c` = Roll No column |
| **`__c`** | Suffix on all custom objects and fields you create |
| **Apex** | Salesforce's programming language (looks like Java) |
| **SOQL** | Salesforce's database query language (like SQL SELECT) |
| **Visualforce** | Old-style UI builder using `<apex:>` HTML tags |
| **LWC** | Lightning Web Component — modern UI framework (like React) |
| **`@AuraEnabled`** | Makes an Apex method callable from LWC |
| **Execute Anonymous** | Run Apex code on the spot without deploying it |
| **`System.debug()`** | Print statement in Apex — output goes to Logs |

---

## STEP 6 — How to View Debug Output

When you run code in Execute Anonymous:

1. Look at the **Logs** panel at the **bottom** of Developer Console
2. Double-click the **latest log entry**
3. In the log viewer, check ✅ **"Debug Only"** (top right checkbox)
4. You'll see all `System.debug()` output lines clearly

---

## STEP 7 — How to Find a Record's ID

After inserting a record you'll often need its ID for update/delete operations:

1. Run `viewAll...()` or equivalent method
2. In the debug log, look for lines like:
   ```
   ID : a0B5g00000AbCdEAF
   ```
3. Copy that 18-character ID and paste it into update/delete scripts

---

## Common Mistakes to Avoid

| Mistake | Fix |
|---------|-----|
| Field name wrong (e.g. `RollNo__c` instead of `Roll_No__c`) | Always copy exact API name from Object Manager |
| Apex class won't save | Check all custom fields are created first |
| Can't see debug output | Check ✅ "Debug Only" in log viewer |
| "No rows for assignment" error | No records exist yet — add one first |
| Can't find Developer Console | It's under ⚙️ gear icon, not in the Setup menu |

---

## Quick Reference — Where is Everything?

| What you need | Where to find it |
|--------------|-----------------|
| Create custom object | Setup → Object Manager → Create → Custom Object |
| Add fields to object | Setup → Object Manager → [Your Object] → Fields & Relationships → New |
| Create Apex class | Setup → Apex Classes → New |
| Create Visualforce page | Setup → Visualforce Pages → New |
| Create LWC component | Developer Console → File → New → Lightning Component |
| Run Apex code | Developer Console → Debug → Open Execute Anonymous Window |
| Add component to page | ⚙️ → Edit Page → drag component → Save → Activate |
