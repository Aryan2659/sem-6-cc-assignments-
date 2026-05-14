# Assignment 17 — Employee Management System
### Salesforce | Console-based Apex (Developer Console)

> **LP-II Assignment | Problem Statement 17**  
> Menu-driven Employee Management System for records (Emp ID, Emp Name, Email, Birth Date, Department) using Salesforce console.

---

## 📌 What You Will Build

An Apex program you run from Salesforce's Developer Console that can:
- Add new employee records
- View all employees
- Search employees by name
- Update employee details
- Delete an employee

All output appears in the **Logs panel** — this is the "console" for Salesforce.

---

## 🧠 Concepts Explained Simply

| Term | What it means |
|------|--------------|
| **Salesforce** | Cloud platform — runs in your browser, nothing to install |
| **Apex** | Salesforce's programming language — looks like Java |
| **Custom Object** | A database table you create — `Employee__c` is your table |
| **Developer Console** | Salesforce's browser-based IDE — opens in a new window |
| **Execute Anonymous** | A window in Developer Console where you paste and run Apex code |
| **System.debug()** | Apex's print statement — output shows up in the Logs panel |
| **SOQL** | Salesforce's version of SQL — used to query records |
| **Static method** | Method called directly on the class: `EmployeeManager.addEmployee(...)` |

---

## ⚠️ STEP 0 — Create a Free Salesforce Account

> If you already created one for Assignment 16, skip this — use the same account.

1. Open: **https://developer.salesforce.com/signup**
2. Fill the form:
   - First Name, Last Name → your name
   - Email → your real email
   - Role → **Developer** | Company → college name | Country → India
   - Username → e.g. `yourname123.lp2@myorg.dev` *(unique ID, not real email)*
3. Click **"Sign Me Up"** → check inbox → **"Verify Account"** → set password
4. ✅ Log in at your Salesforce URL

---

## 🗺️ Getting to Setup

1. Click **⚙️ gear icon** (top right) → click **"Setup"**
2. On the left you'll see a **"Quick Find"** search bar

---

## 📁 Files in This Repo

```
G4-A17-Employee-Management-Salesforce/
├── apex/
│   └── EmployeeManager.cls           ← Apex class with all operations
├── anonymous-scripts/
│   └── run_operations.apex           ← Scripts to copy-paste and run
└── README.md
```

---

## ✅ STEP 1 — Create the Custom Object (Employee__c)

1. In Quick Find, type **`Object Manager`** → click it
2. Click **"Create"** (top right) → **"Custom Object"**
3. Fill in:
   - **Label** → `Employee`
   - **Plural Label** → `Employees`
   - **Object Name** → auto-fills as `Employee` *(leave it)*
4. Check ✅ **"Allow Reports"** → click **"Save"**

---

## ✅ STEP 2 — Add Fields to Employee Object

Click **"Fields & Relationships"** in the left sidebar → **"New"**

### Field 1 — Email

1. Select **"Email"** → **"Next"**
2. **Field Label** → `Email` | **Field Name** → auto-fills as `Email` *(leave it)*
3. **"Next"** → **"Next"** → **"Save & New"**

### Field 2 — Birth Date

1. Select **"Date"** → **"Next"**
2. **Field Label** → `Birth Date` | **Field Name** → auto-fills as `Birth_Date` *(leave it)*
3. **"Next"** → **"Next"** → **"Save & New"**

### Field 3 — Department

1. Select **"Text"** → **"Next"**
2. **Field Label** → `Department` | **Length** → `100`
3. **"Next"** → **"Next"** → **"Save"**

✅ Employee object now has: **Name** (default = Emp Name) + **Email__c** + **Birth_Date__c** + **Department__c**

---

## ✅ STEP 3 — Create the Apex Class

1. In Quick Find, type **`Apex Classes`** → click it
2. Click **"New"**
3. **Ctrl+A → Delete** all default text in the editor
4. Open `apex/EmployeeManager.cls` from this repo → copy all → paste
5. Click **"Save"**

✅ No red error = saved!

---

## ✅ STEP 4 — Open Developer Console

1. Click **⚙️ gear icon** (top right)
2. Click **"Developer Console"**
3. A new browser window opens with menu bar: **File | Edit | Debug | Test...**

> ⚠️ If nothing opens, your browser is blocking popups.  
> Click the popup icon in your address bar → allow popups for salesforce.com → try again.

---

## ✅ STEP 5 — Open the Execute Anonymous Window

> This is your "console" — paste code here and click Execute to run it.

1. In Developer Console, click **"Debug"** in the top menu bar
2. Click **"Open Execute Anonymous Window"**
3. A text box appears — this is where you paste scripts

---

## ✅ STEP 6 — Run the Scripts

Open `anonymous-scripts/run_operations.apex` from this repo. You'll see 6 script blocks separated by comment lines.

**Copy one block at a time → paste into the Execute Anonymous window → click "Execute"**

---

## 🎮 Each Menu Option

### ▶ Option 1 — Full Demo (best for viva)

```apex
EmployeeManager.runDemo();
```

Copies and pastes this → Execute → shows the menu + adds 3 employees + views all + searches.

---

### ▶ Option 2 — Add a New Employee

```apex
EmployeeManager.addEmployee(
    'Raj Sharma',
    'raj@company.com',
    Date.newInstance(1997, 6, 20),
    'Engineering'
);
```

Parameters in order: **Name, Email, Date(year,month,day), Department**

---

### ▶ Option 3 — View All Employees

```apex
EmployeeManager.viewAllEmployees();
```

---

### ▶ Option 4 — Search by Name

```apex
EmployeeManager.searchEmployee('Raj');
```

---

### ▶ Option 5 — Update an Employee

**First** run `viewAllEmployees()` and copy a Record ID from the logs.  
A Record ID looks like `a0B5g00000AbCdEAF` (18 characters, starts with letters).

```apex
EmployeeManager.updateEmployee(
    'PASTE_RECORD_ID_HERE',
    'Raj Kumar',
    'raj.kumar@company.com',
    'Sales'
);
```

---

### ▶ Option 6 — Delete an Employee

```apex
EmployeeManager.deleteEmployee('PASTE_RECORD_ID_HERE');
```

---

## 👁️ How to See Output in Logs

After clicking Execute:

1. Look at the **"Logs"** panel at the very bottom of the Developer Console
2. A new row appears in the list
3. **Double-click** that row to open the log
4. In the log viewer, find the **"Debug Only"** checkbox at the top right → check it ✅
5. You'll now see only your output lines, like:
   ```
   ✅ Employee Added Successfully!
      Name       : Raj Sharma
      Email      : raj@company.com
   ```

---

## 📋 How to Get a Record ID

After running `viewAllEmployees()`:

1. Open the log (double-click latest log entry)
2. Check "Debug Only"
3. Look for lines like:
   ```
   ID         : a0B5g00000AbCdEAF
   ```
4. Copy that 18-character ID → paste into update or delete scripts

---

## 🧯 If Something Goes Wrong

| Problem | Fix |
|---------|-----|
| Red error when saving Apex class | Fields not created — complete Steps 1 & 2 first |
| `Variable does not exist: Email__c` | Field name mismatch — check exact API names in Object Manager |
| `List has no rows for assignment` | No records exist yet — run `addEmployee` first |
| Developer Console won't open | Allow popups for salesforce.com in browser settings |
| Can't see output | In log viewer, check ✅ "Debug Only" checkbox |
| "EmployeeManager does not exist" error | Class wasn't saved — go back to Step 3 |

---

## 🎓 Viva Points

| Question | Answer |
|----------|--------|
| What is Execute Anonymous? | Developer Console feature to run Apex code instantly without saving it as a class |
| What is a static method? | Method that belongs to the class itself, called as `ClassName.method()` without creating an object |
| What is DML in Apex? | Data Manipulation Language — `insert`, `update`, `delete` operations |
| What is SOQL? | Salesforce Object Query Language — like SQL SELECT, queries Salesforce database |
| What is `System.debug()`? | Apex's print statement — output goes to the Logs panel in Developer Console |
| How is this "menu-driven"? | Each method = one menu option, called separately from the Execute Anonymous window |
| What does `__c` mean? | Suffix Salesforce adds to custom objects and fields |
