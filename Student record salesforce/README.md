# Assignment 16 — Student Record Management System
### Salesforce | Apex + Visualforce Page

> **LP-II Assignment | Problem Statement 16**  
> Build an app in Salesforce to manage student records (Name, Roll No, Class, Mobile No) using Apex and a Visualforce page.

---

## 📌 What You Will Build

A web page inside Salesforce with:
- A form to add new students
- A table showing all existing student records
- Edit and Delete buttons on each row

---

## 🧠 Concepts Explained Simply

| Term | What it means |
|------|--------------|
| **Salesforce** | A cloud platform — everything runs in your browser, nothing to install |
| **Apex** | Salesforce's programming language — looks like Java. Handles the backend (saving/fetching data) |
| **Visualforce** | Salesforce's way to build web pages — like HTML but with special `<apex:>` tags |
| **Custom Object** | A database table you create — `Student__c` is your student table |
| **`__c`** | Salesforce adds this to ALL custom objects and fields you create |
| **Setup** | The admin panel in Salesforce where you configure everything |
| **Developer Console** | Salesforce's built-in code editor — opens in a new browser window |

---

## ⚠️ STEP 0 — Create a Free Salesforce Developer Account

> Salesforce runs entirely in your browser. Nothing to install.

1. Open: **https://developer.salesforce.com/signup**
2. Fill the form:
   - First Name, Last Name → your real name
   - Email → your real email *(you'll get a verification link)*
   - Role → select **Developer**
   - Company → your college name
   - Country → **India** | Postal Code → your PIN code
   - Username → something like `yourname123.lp2@myorg.dev`  
     *(Just a unique ID — NOT your login email. Must look like an email but doesn't need to be real.)*
3. Click **"Sign Me Up"**
4. Check your inbox → open the Salesforce email → click **"Verify Account"**
5. Set your password on the page that opens
6. ✅ You're logged in! You'll see the Salesforce homepage.

---

## 🗺️ Finding Your Way Around Salesforce

```
┌──────────────────────────────────────────────────────────────┐
│  [⬛ 9 dots]   Salesforce    [Search bar]     [⚙️]  [👤]    │
└──────────────────────────────────────────────────────────────┘
```

- Click **⚙️ gear icon** (top right) → **"Setup"** to reach the admin panel
- In Setup, use the **"Quick Find"** search bar on the left to navigate
- Click **⚙️** → **"Developer Console"** to open the code editor

---

## 📁 Files in This Repo

```
G4-A16-Student-Record-Salesforce/
├── apex/
│   └── StudentController.cls    ← Backend code (copy-paste into Salesforce)
├── visualforce/
│   └── StudentPage.vfp          ← Web page UI (copy-paste into Salesforce)
└── README.md
```

---

## ✅ STEP 1 — Open Setup

1. Click the **⚙️ gear icon** (top right)
2. Click **"Setup"**
3. A new page loads — you'll see a **"Quick Find"** search bar on the left side

---

## ✅ STEP 2 — Create the Student Custom Object

> This creates your database table to store student records.

1. In Quick Find, type **`Object Manager`** → click it
2. Click the **"Create"** button at the **top right** of the page
3. In the dropdown, click **"Custom Object"**
4. Fill in:
   - **Label** → `Student`
   - **Plural Label** → `Students` *(auto-fills)*
   - **Object Name** → auto-fills as `Student` *(leave it)*
5. Scroll down → check ✅ **"Allow Reports"** → click **"Save"**
6. ✅ You're now on the Student object page

---

## ✅ STEP 3 — Add Fields to Student Object

Click **"Fields & Relationships"** in the left sidebar → click **"New"**

### Field 1 — Roll No

1. Select **"Number"** → click **"Next"**
2. **Field Label** → `Roll No` | **Length** → `18` | **Decimal Places** → `0`
3. Click **"Next"** → **"Next"** → **"Save & New"**

### Field 2 — Class

1. Select **"Text"** → click **"Next"**
2. **Field Label** → `Class` | **Length** → `50`
3. Click **"Next"** → **"Next"** → **"Save & New"**

### Field 3 — Mobile No

1. Select **"Phone"** → click **"Next"**
2. **Field Label** → `Mobile No`
3. Click **"Next"** → **"Next"** → **"Save"**

✅ Student object now has: **Name** (default) + **Roll_No__c** + **Class__c** + **Mobile_No__c**

---

## ✅ STEP 4 — Create the Apex Class

1. In Quick Find, type **`Apex Classes`** → click it
2. Click **"New"**
3. A code editor opens → **Ctrl+A → Delete** all default text
4. Open `apex/StudentController.cls` from this repo → copy all → paste
5. Click **"Save"**

✅ No red error = saved! If there's an error, check all fields in Step 3 are created.

---

## ✅ STEP 5 — Create the Visualforce Page

1. In Quick Find, type **`Visualforce Pages`** → click it
2. Click **"New"**
3. Fill in:
   - **Label** → `StudentPage`
   - **Name** → auto-fills as `StudentPage` *(leave it)*
4. Delete all default text in the editor → **Ctrl+A → Delete**
5. Open `visualforce/StudentPage.vfp` from this repo → copy all → paste
6. Check ✅ **"Available for Salesforce mobile apps and Lightning pages"**
7. Click **"Save"**

---

## ✅ STEP 6 — View Your App

In your browser's address bar, type:

```
https://YOUR-ORG-DOMAIN.lightning.force.com/apex/StudentPage
```

To find your org domain:
- Look at your browser URL when you're logged into Salesforce
- It looks like `https://yourcompany.lightning.force.com/...`
- Copy just the `yourcompany.lightning.force.com` part

✅ You should see the Student Record Management System with a form and a table!

---

## 🧪 Testing the App

| Action | Steps |
|--------|-------|
| Add a student | Fill Name, Roll No, Class, Mobile No → click "Save Student" → record appears in table |
| Edit a student | Click "✏ Edit" → change fields → click "Update" |
| Delete a student | Click "🗑 Delete" → confirm popup → record is removed |

---

## 🧯 If Something Goes Wrong

| Problem | Fix |
|---------|-----|
| Red error when saving Apex class | Fields not created yet — complete Step 3 first |
| `Variable does not exist: Roll_No__c` | Field API name mismatch — check exact names in Object Manager |
| Blank page when opening URL | Check controller name in VF page matches exactly: `StudentController` |
| "Page not found" error | Make sure the Visualforce page was saved with name `StudentPage` |
| Edit not loading the right record | Make sure the Apex class was saved without errors |

---

## 🎓 Viva Points

| Question | Answer |
|----------|--------|
| What is Apex? | Salesforce's object-oriented programming language — like Java, runs on Salesforce servers |
| What is Visualforce? | Salesforce's page markup language — like HTML with `<apex:>` tags for Salesforce integration |
| What is a Custom Object? | A user-created database table in Salesforce — `Student__c` here |
| What does `__c` mean? | Suffix Salesforce adds to all custom objects and fields |
| What is SOQL? | Salesforce Object Query Language — like SQL, used to query Salesforce records |
| What are CRUD operations in Apex? | `insert` (Create), SOQL SELECT (Read), `update` (Update), `delete` (Delete) |
| What is `get; set;`? | Apex property syntax — makes a variable readable/writable by the Visualforce page |
| What does `{! }` do in Visualforce? | Expression syntax — binds a UI element to a variable or method in the Apex controller |
