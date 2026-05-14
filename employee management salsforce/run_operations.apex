// ============================================================
//  ANONYMOUS APEX SCRIPTS — Employee Management System
//  How to use:
//  1. Open Salesforce → Developer Console (top right gear icon)
//  2. Click  Debug → Open Execute Anonymous Window
//  3. Copy ONE block at a time → paste → click Execute
//  4. View output in the Logs panel at the bottom
// ============================================================


// ──────────────────────────────────────────────────────────
//  SCRIPT 1 — Show Menu (Intro / Demo)
// ──────────────────────────────────────────────────────────
EmployeeManager.runDemo();


// ──────────────────────────────────────────────────────────
//  SCRIPT 2 — Add a New Employee
//  Parameters: Name, Email, BirthDate, Department
// ──────────────────────────────────────────────────────────
EmployeeManager.addEmployee(
    'Raj Sharma',
    'raj.sharma@company.com',
    Date.newInstance(1997, 6, 20),
    'Engineering'
);


// ──────────────────────────────────────────────────────────
//  SCRIPT 3 — View All Employees
// ──────────────────────────────────────────────────────────
EmployeeManager.viewAllEmployees();


// ──────────────────────────────────────────────────────────
//  SCRIPT 4 — Search Employee by Name
// ──────────────────────────────────────────────────────────
EmployeeManager.searchEmployee('Raj');


// ──────────────────────────────────────────────────────────
//  SCRIPT 5 — Update Employee
//  Step 1: Run SCRIPT 3 first to get the Record ID
//  Step 2: Copy the ID (starts with 'a0B...' or similar)
//  Step 3: Paste it below and run
// ──────────────────────────────────────────────────────────
EmployeeManager.updateEmployee(
    'PASTE_RECORD_ID_HERE',   // e.g. 'a0B5g00000AbCdEAF'
    'Raj Kumar',
    'raj.kumar@company.com',
    'Sales'
);


// ──────────────────────────────────────────────────────────
//  SCRIPT 6 — Delete Employee
//  Step 1: Run SCRIPT 3 to get the Record ID
//  Step 2: Paste it below
// ──────────────────────────────────────────────────────────
EmployeeManager.deleteEmployee(
    'PASTE_RECORD_ID_HERE'    // e.g. 'a0B5g00000AbCdEAF'
);
