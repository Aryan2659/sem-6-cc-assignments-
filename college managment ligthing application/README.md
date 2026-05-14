# Assignment 23 — College Management Lightning Application
### Salesforce | LWC + Apex + Validation Rules

> **LP-II Assignment | Problem Statement 23**  
> Develop a College Management Lightning Application to manage student and faculty records with validation.

---

## 📌 What You Will Build

A web app inside Salesforce with **two tabs**:
- **Students tab** — add students with Name, Roll No, Marks, Email
- **Faculty tab** — add faculty with Name, ID, Salary, Department, Joining Date
- Both tabs validate the data before saving and show error messages

---

## ⚠️ Before You Start — Create a Free Salesforce Account

> Salesforce is a cloud platform — like a website. You don't install anything. It all runs in your browser.

1. Open this link: **https://developer.salesforce.com/signup**
2. Fill in the form:
   - First Name, Last Name → your real name
   - Email → your real email (you'll get a verification link)
   - Role → select **Developer** from the dropdown
   - Company → your college name
   - Country → **India**, Postal Code → your PIN code
   - Username → looks like an email but is just a unique ID.  
     Type something like: `yourname123.lp2@myorg.dev`  
     *(NOT your login email — just a unique identifier)*
3. Click **Sign Me Up** → check inbox → click **Verify Account** → set password → done!

---

## 🗺️ Understanding the Salesforce Screen

```
┌──────────────────────────────────────────────────────────────┐
│  [⬛ 9 dots]   Salesforce    [Search bar]     [⚙️]  [👤]    │
├──────────────────────────────────────────────────────────────┤
│                        Home Page                             │
└──────────────────────────────────────────────────────────────┘
```

- **⚙️ gear icon** (top right) → opens Setup and Developer Console
- **Setup** → admin panel where you create objects, write code
- **Developer Console** → where you write Apex and LWC code

---

## 📁 Files in This Repo

```
A23-College-Management-LWC/
├── force-app/main/default/
│   ├── lwc/collegeManagement/
│   │   ├── collegeManagement.html         ← UI (copy-paste into Salesforce)
│   │   ├── collegeManagement.js           ← Logic + validation (copy-paste)
│   │   ├── collegeManagement.css          ← Styling (copy-paste)
│   │   └── collegeManagement.js-meta.xml  ← Config (copy-paste)
│   └── classes/
│       └── CollegeManagementController.cls ← Backend code (copy-paste)
└── README.md
```

You will copy-paste each file into Salesforce. No coding from scratch needed.

---

## ✅ STEP 1 — Open Setup

1. Click the **⚙️ gear icon** (top-right corner)
2. Click **"Setup"** in the menu
3. A new page loads — this is **Setup Home**
4. On the left you'll see a search bar labeled **"Quick Find"** — you'll use this throughout

---

## ✅ STEP 2 — Create the Student Custom Object

> A Custom Object = a database table. We need a `Student` table to store student records.

1. In the Quick Find bar, type **`Object Manager`** → click it when it appears
2. You'll see a list of existing objects. Click the **"Create"** button at the **top right**
3. In the dropdown, click **"Custom Object"**
4. Fill in the form:
   - **Label** → `Student`
   - **Plural Label** → `Students` *(auto-fills, leave it)*
   - **Object Name** → auto-fills as `Student` *(leave it — Salesforce adds `__c` internally)*
5. Scroll down → check ✅ **"Allow Reports"** → scroll to bottom → click **"Save"**
6. ✅ You're now on the Student object detail page

---

## ✅ STEP 3 — Add Fields to the Student Object

> Fields = columns in the table. We add Roll No, Marks, Email.  
> (Name already exists by default — that's the Student Name field)

You should be on the Student object page. Click **"Fields & Relationships"** in the left sidebar.

### Field 1 — Roll No

1. Click **"New"** (top right)
2. A page shows data type options → select **"Number"** → click **"Next"**
3. Fill in:
   - **Field Label** → `Roll No`
   - **Field Name** → auto-fills as `Roll_No` *(leave it)*
   - **Length** → `18`
   - **Decimal Places** → `0`
4. Click **"Next"** → **"Next"** → **"Save & New"** *(saves and opens form for next field)*

### Field 2 — Marks

1. Select **"Number"** → **"Next"**
2. **Field Label** → `Marks` | **Length** → `5` | **Decimal Places** → `2`
3. Click **"Next"** → **"Next"** → **"Save & New"**

### Field 3 — Email

1. Select **"Email"** → **"Next"**
2. **Field Label** → `Email` | **Field Name** → auto-fills as `Email` *(leave it)*
3. Click **"Next"** → **"Next"** → **"Save"** *(just Save — we're done with Student)*

✅ Student now has: **Name** + **Roll_No__c** + **Marks__c** + **Email__c**

---

## ✅ STEP 4 — Create the Faculty Custom Object

1. In Quick Find, type **`Object Manager`** → click it
2. Click **"Create"** (top right) → **"Custom Object"**
3. Fill in:
   - **Label** → `Faculty` | **Plural Label** → `Faculty`
   - **Object Name** → auto-fills as `Faculty` *(leave it)*
4. Scroll down → check ✅ "Allow Reports" → click **"Save"**

### Add Fields to Faculty

Click **"Fields & Relationships"** (left sidebar) → **"New"**

**Field 1 — Faculty ID**
- Select **"Number"** → **"Next"**
- Label: `Faculty ID` | Length: `18` | Decimal: `0`
- **"Next"** → **"Next"** → **"Save & New"**

**Field 2 — Salary**
- Select **"Currency"** → **"Next"**
- Label: `Salary` | Length: `16` | Decimal: `2`
- **"Next"** → **"Next"** → **"Save & New"**

**Field 3 — Department**
- Select **"Text"** → **"Next"**
- Label: `Department` | Length: `100`
- **"Next"** → **"Next"** → **"Save & New"**

**Field 4 — Joining Date**
- Select **"Date"** → **"Next"**
- Label: `Joining Date`
- **"Next"** → **"Next"** → **"Save"**

✅ Faculty now has: **Name** + **Faculty_ID__c** + **Salary__c** + **Department__c** + **Joining_Date__c**

---

## ✅ STEP 5 — Create the Apex Class

1. In Quick Find, type **`Apex Classes`** → click it
2. Click **"New"**
3. A code editor appears with some default text → **select all (Ctrl+A) → delete**
4. Open `force-app/main/default/classes/CollegeManagementController.cls` from this repo
5. Copy all the text → paste into the Salesforce editor
6. Click **"Save"**

✅ No red error = class saved! If there's an error, go back and check that all fields in Steps 3-4 are created correctly.

---

## ✅ STEP 6 — Open Developer Console

1. Click the **⚙️ gear icon** (top right)
2. Click **"Developer Console"** — a new browser window opens
3. You'll see a menu bar: **File | Edit | Debug | Test | Workspace | Help**

> ⚠️ If the window doesn't open, your browser is blocking popups.  
> Click the popup-blocked icon in your browser's address bar → allow popups for salesforce.com

---

## ✅ STEP 7 — Create the LWC Component

> LWC is the actual UI — the form and table you see on screen.

### Create the bundle:

1. In Developer Console, click **"File"** (top menu bar)
2. Click **"New"** → click **"Lightning Component"**
3. A small popup appears:
   - **Name** → type `collegeManagement` *(exact spelling, no spaces)*
   - **Bundle Type** → select **"Lightning Web Component"** *(NOT Aura Component)*
4. Click **"Submit"**

You now see a screen with file tabs across the top.

### Paste the HTML:

1. Click the tab named **`collegeManagement.html`**
2. Select all existing text (Ctrl+A) → delete
3. Copy everything from `collegeManagement.html` in this repo → paste → **Ctrl+S**

### Paste the JS:

1. Click the tab **`collegeManagement.js`**
2. Select all → delete
3. Copy from `collegeManagement.js` → paste → **Ctrl+S**

### Paste the META XML:

1. Click the tab **`collegeManagement.js-meta.xml`**
2. Select all → delete
3. Copy from `collegeManagement.js-meta.xml` → paste → **Ctrl+S**

### Add the CSS file:

The CSS tab doesn't exist yet. Create it:

1. Click **"File"** (top menu) → **"New"** → **"Lightning Component Resource"**
2. A popup appears:
   - First dropdown → find and select **`collegeManagement`**
   - **Resource Type** → select **"CSS"**
3. Click **"Submit"**
4. A new CSS tab opens → paste contents of `collegeManagement.css` → **Ctrl+S**

### Save everything:

Click **"File"** → **"Save All"** (or Ctrl+Shift+S)

✅ No errors = component created!

---

## ✅ STEP 8 — Add the Component to Your Home Page

> The component exists but isn't visible yet — we need to place it on a page.

1. Go back to your **main Salesforce tab** (not Developer Console)
2. Make sure you're on the **Home page** — click the home icon in the top navigation if needed
3. Click the **⚙️ gear icon** (top right)
4. Click **"Edit Page"** — the Lightning App Builder opens (a drag-and-drop editor)
5. On the **left panel**, scroll down to the **"Custom"** section
6. You'll see **`collegeManagement`** listed there
7. **Click and drag** it onto the page on the right side
8. Click **"Save"** (top right of App Builder)
9. A popup appears → click **"Activate"**
10. Another popup → click **"Assign as Org Default"** → **"Save"** → **"Save"**
11. Click the **back arrow** (top left) to return to the home page

✅ **Refresh the page (F5)** — the College Management app now appears with Student and Faculty tabs!

---

## 🧪 Testing the App

### Test Student validations:
| Test | Expected Result |
|------|----------------|
| Click Save with empty name | Error: "Student name cannot be blank" |
| Enter Roll No as `0` | Error: "Roll number must be greater than 0" |
| Enter Marks as `150` | Error: "Marks must be between 0 and 100" |
| Enter email as `abc.com` (no @) | Error: "Email must contain the @ symbol" |
| Fill everything correctly → Save | Record appears in the table below ✅ |

### Test Faculty validations:
| Test | Expected Result |
|------|----------------|
| Enter name as `AB` (2 chars) | Error: "at least 3 characters" |
| Enter Faculty ID as `0` | Error: "must be greater than 0" |
| Enter same Faculty ID twice | Error: "already exists" |
| Enter Salary as `5000` | Error: "greater than ₹10,000" |
| Don't select Department | Error: "Please select a department" |
| Pick tomorrow as Joining Date | Error: "cannot be a future date" |
| Fill everything correctly → Save | Record appears in table ✅ |

---

## 🧯 If Something Goes Wrong

| Problem | Fix |
|---------|-----|
| Red error when saving Apex class | Fields don't exist yet — complete Steps 3 & 4 first |
| `Variable does not exist: Roll_No__c` | Spelling mismatch — check field API names in Object Manager |
| Component not visible in App Builder | Check `<isExposed>true</isExposed>` is in the meta XML |
| "Edit Page" option not visible in ⚙️ | Navigate to the Home page first, then try ⚙️ |
| Developer Console window doesn't open | Allow popups for salesforce.com in browser settings |
| App loads but table is empty | Normal — add a record using the form first |
| Faculty save not working | Make sure all 4 Faculty fields are created in Step 4 |

---

## 🎓 Viva Points

| Question | Answer |
|----------|--------|
| What is an LWC? | Lightning Web Component — Salesforce's framework for building UIs with HTML, JS, CSS |
| What is a Custom Object? | A user-created database table in Salesforce (e.g. `Student__c`) |
| What does `__c` mean? | Suffix Salesforce adds to all custom-created objects and fields |
| What is `@track`? | LWC decorator that makes a variable reactive — UI re-renders when it changes |
| What is `@AuraEnabled`? | Annotation that exposes an Apex method so LWC can call it |
| Where is validation done? | In JS (client-side) for most fields; Apex (server-side) for Faculty ID uniqueness |
| What is SOQL? | Salesforce Object Query Language — like SQL, used to fetch records from Salesforce DB |
| How many custom objects? | Two — `Student__c` and `Faculty__c` |
