# Assignment 20 — Employee Management Lightning Web Component
### Salesforce | LWC + Apex + Validation

> **LP-II Assignment | Problem Statement 20**  
> Build an Employee Management form in Salesforce using LWC with 6 validation rules before saving.

---

## 📌 What You Will Build

A form inside Salesforce where you can:
- Add employee records (Name, ID, Salary, Email, Department, Joining Date)
- See all saved employees in a table below the form
- Get inline error messages if any field is filled incorrectly

---

## ⚠️ Before You Start — Create a Free Salesforce Account

> Salesforce runs entirely in your browser. No installation needed.

1. Open: **https://developer.salesforce.com/signup**
2. Fill the form:
   - First Name, Last Name → your real name
   - Email → your real email *(you'll get a verification link)*
   - Role → select **Developer**
   - Company → your college name
   - Country → **India** | Postal Code → your PIN code
   - Username → type something like `yourname123.lp2@myorg.dev`  
     *(This is just a unique ID — NOT your login email)*
3. Click **Sign Me Up** → check inbox → click **Verify Account** → set password
4. ✅ You're in! You'll land on the Salesforce homepage in your browser.

---

## 🗺️ Understanding the Salesforce Screen

```
┌──────────────────────────────────────────────────────────────┐
│  [⬛ 9 dots]   Salesforce    [Search bar]     [⚙️]  [👤]    │
├──────────────────────────────────────────────────────────────┤
│                        Home Page                             │
└──────────────────────────────────────────────────────────────┘
```

- **⚙️ gear icon** (top right) → Setup, Developer Console, Edit Page
- **Setup** → where you create database tables, write backend code
- **Developer Console** → where you build the UI component

---

## 📁 Files in This Repo

```
G5-A20-Employee-LWC-Salesforce/
├── force-app/main/default/
│   ├── lwc/employeeManager/
│   │   ├── employeeManager.html         ← UI form + table (copy-paste)
│   │   ├── employeeManager.js           ← All 6 validations (copy-paste)
│   │   ├── employeeManager.css          ← Styles (copy-paste)
│   │   └── employeeManager.js-meta.xml  ← Config (copy-paste)
│   └── classes/
│       └── EmployeeLWCController.cls    ← Backend (copy-paste)
└── README.md
```

You will copy-paste each file into Salesforce. No coding from scratch.

---

## ✅ STEP 1 — Open Setup

1. Click the **⚙️ gear icon** (top-right corner of Salesforce)
2. Click **"Setup"**
3. A new page loads — Setup Home
4. On the left side you'll see a **"Quick Find"** search bar — use this to navigate

---

## ✅ STEP 2 — Create the Custom Object (Employee_LWC__c)

> This is the database table that stores employee records.

1. In Quick Find, type **`Object Manager`** → click it
2. Click the **"Create"** button at the **top right** of the page
3. In the dropdown, click **"Custom Object"**
4. Fill in:
   - **Label** → `Employee LWC`
   - **Plural Label** → `Employee LWCs` *(auto-fills, leave it)*
   - **Object Name** → auto-fills as `Employee_LWC` *(leave it)*
5. Scroll down → check ✅ **"Allow Reports"** → click **"Save"**
6. ✅ You're now on the Employee LWC object page

---

## ✅ STEP 3 — Add Fields to the Object

Click **"Fields & Relationships"** in the left sidebar → click **"New"**

### Field 1 — Employee ID

1. Select **"Number"** → click **"Next"**
2. Fill in:
   - **Field Label** → `Employee ID`
   - **Field Name** → auto-fills as `Employee_ID` *(leave it)*
   - **Length** → `18` | **Decimal Places** → `0`
3. Click **"Next"** → **"Next"** → **"Save & New"**

### Field 2 — Salary

1. Select **"Currency"** → **"Next"**
2. **Field Label** → `Salary` | **Length** → `16` | **Decimal Places** → `2`
3. **"Next"** → **"Next"** → **"Save & New"**

### Field 3 — Email

1. Select **"Email"** → **"Next"**
2. **Field Label** → `Email` | **Field Name** → auto-fills as `Email` *(leave it)*
3. **"Next"** → **"Next"** → **"Save & New"**

### Field 4 — Department

1. Select **"Text"** → **"Next"**
2. **Field Label** → `Department` | **Length** → `100`
3. **"Next"** → **"Next"** → **"Save & New"**

### Field 5 — Joining Date

1. Select **"Date"** → **"Next"**
2. **Field Label** → `Joining Date`
3. **"Next"** → **"Next"** → **"Save"** *(just Save — we're done)*

✅ Object now has: **Name** (default = Employee Name) + **Employee_ID__c** + **Salary__c** + **Email__c** + **Department__c** + **Joining_Date__c**

---

## ✅ STEP 4 — Create the Apex Class

1. In Quick Find, type **`Apex Classes`** → click it
2. Click **"New"**
3. A code editor appears with default text → **Ctrl+A → Delete** to clear it
4. Open `force-app/main/default/classes/EmployeeLWCController.cls` from this repo
5. Copy all the text → paste into the editor
6. Click **"Save"**

✅ No red error = saved! If there's an error, check that all 5 fields in Step 3 exist.

---

## ✅ STEP 5 — Open Developer Console

1. Click the **⚙️ gear icon** (top right)
2. Click **"Developer Console"** — a new browser window opens
3. You'll see a menu bar at the top: **File | Edit | Debug | Test | Workspace | Help**

> ⚠️ If nothing opens, your browser is blocking popups.  
> Click the popup-blocked icon in the address bar → allow popups for salesforce.com → try again

---

## ✅ STEP 6 — Create the LWC Component

### Create the bundle:

1. In Developer Console, click **"File"** (top menu bar)
2. Click **"New"** → **"Lightning Component"**
3. A small popup appears:
   - **Name** → `employeeManager` *(exact spelling, no spaces, lowercase e)*
   - **Bundle Type** → select **"Lightning Web Component"** *(NOT Aura Component)*
4. Click **"Submit"**

You now see a screen with file tabs at the top.

### Paste the HTML:

1. Click the tab **`employeeManager.html`**
2. **Ctrl+A → Delete** all existing text
3. Copy everything from `employeeManager.html` in this repo → paste → **Ctrl+S**

### Paste the JS:

1. Click the tab **`employeeManager.js`**
2. **Ctrl+A → Delete**
3. Copy from `employeeManager.js` → paste → **Ctrl+S**

### Paste the META XML:

1. Click the tab **`employeeManager.js-meta.xml`**
2. **Ctrl+A → Delete**
3. Copy from `employeeManager.js-meta.xml` → paste → **Ctrl+S**

### Add the CSS:

The CSS tab doesn't exist by default — create it:

1. Click **"File"** (top menu) → **"New"** → **"Lightning Component Resource"**
2. A popup appears:
   - First dropdown → find and select **`employeeManager`**
   - **Resource Type** → select **"CSS"**
3. Click **"Submit"**
4. New CSS tab opens → paste contents of `employeeManager.css` → **Ctrl+S**

### Save everything:

Click **"File"** → **"Save All"** (Ctrl+Shift+S)

✅ No errors = component is ready!

---

## ✅ STEP 7 — Add the Component to Your Home Page

1. Go back to the **main Salesforce tab** (not Developer Console)
2. Make sure you're on the **Home page** — click the home icon in top navigation if needed
3. Click **⚙️ gear icon** → click **"Edit Page"**
4. The **Lightning App Builder** opens — a visual drag-and-drop page editor
5. In the **left panel**, scroll down to the **"Custom"** section
6. You'll see **`employeeManager`** listed there
7. **Click and drag** it onto the page canvas on the right
8. Click **"Save"** (top right of App Builder)
9. Popup appears → click **"Activate"**
10. Next popup → click **"Assign as Org Default"** → **"Save"** → **"Save"**
11. Click the **← back arrow** (top left) to return to home page

✅ **Press F5 to refresh** — the Employee Management form now appears on the page!

---

## 🧪 Testing All 6 Validations

Try each test to confirm the validations work:

| What to do | Expected error message |
|------------|----------------------|
| Leave Name empty → click Save | "Employee Name cannot be empty" |
| Enter Name as `AB` (only 2 chars) | "Must contain at least 3 characters" |
| Enter Employee ID as `0` | "Employee ID must be greater than 0" |
| Save with same Employee ID twice | "Employee ID already exists" |
| Enter Salary as `5000` | "Salary must be greater than ₹10,000" |
| Enter Salary as `600000` | "Salary must be less than ₹5,00,000" |
| Enter Email as `name.gmail.com` | "Please enter a valid email address" |
| Don't select Department → Save | "Please select a department" |
| Pick tomorrow's date as Joining Date | "Joining Date cannot be a future date" |
| Fill everything correctly → Save | ✅ Record appears in the table below |

---

## 🧯 If Something Goes Wrong

| Problem | Fix |
|---------|-----|
| Red error when saving Apex class | Fields missing — complete Step 3 fully first |
| `Variable does not exist: Employee_ID__c` | Field not created or name mismatch — check Object Manager |
| Component not visible in App Builder | Check `<isExposed>true</isExposed>` is in the meta XML file |
| "Edit Page" not in ⚙️ menu | Go to the Home page first, then try ⚙️ |
| Developer Console doesn't open | Allow popups for salesforce.com in browser settings |
| Table is empty after saving | Refresh the page (F5) — the `getEmployees` call needs a fresh load |
| Uniqueness check not working | Make sure `isEmpIdUnique` method exists in the saved Apex class |

---

## 🎓 Viva Points

| Question | Answer |
|----------|--------|
| What is LWC? | Lightning Web Component — Salesforce's modern UI framework using HTML, JS, CSS |
| What is a Custom Object? | A database table you create in Salesforce — `Employee_LWC__c` here |
| What does `__c` mean? | Salesforce adds this suffix to all custom objects and fields |
| What is `@track`? | LWC decorator that makes a JS variable reactive — UI re-renders when it changes |
| What is `@AuraEnabled`? | Apex annotation that lets LWC call that method |
| Where is Employee ID uniqueness checked? | Server-side in Apex — `isEmpIdUnique()` queries the database |
| What is `connectedCallback()`? | LWC lifecycle hook that runs when the component loads — used to fetch existing records |
| How many validations are there? | 6 — Name, Employee ID (value + uniqueness), Salary, Email, Department, Joining Date |
