// ============================================================
//  ANONYMOUS APEX SCRIPTS — Salesforce Email Service
//  How to use:
//  1. Salesforce → Developer Console (⚙️ top right)
//  2. Debug → Open Execute Anonymous Window
//  3. Copy ONE script at a time → paste → Execute
//  4. Logs panel → double-click latest log → check "Debug Only"
// ============================================================


// ──────────────────────────────────────────────────────────
//  SCRIPT 1 — Full Demo (run all 3 options at once)
//  ⚠️  Replace 'demo@example.com' with your actual email
// ──────────────────────────────────────────────────────────
EmailService.runDemo();


// ──────────────────────────────────────────────────────────
//  SCRIPT 2 — Send Email WITHOUT Attachment
//  Parameters: toAddress, subject, messageBody
// ──────────────────────────────────────────────────────────
EmailService.sendEmail(
    'your-email@gmail.com',          // ← replace with real email
    'Hello from Salesforce Apex!',
    'Hi there! This notification was sent using Salesforce built-in Messaging class via Apex code.'
);


// ──────────────────────────────────────────────────────────
//  SCRIPT 3 — Send Email WITH Attachment
//  Parameters: toAddress, subject, body, fileName, fileContent
// ──────────────────────────────────────────────────────────
EmailService.sendEmailWithAttachment(
    'your-email@gmail.com',          // ← replace with real email
    'Your Report is Ready!',
    'Please find the attached report file.',
    'student_report.txt',            // attachment file name
    'Student Report\n==============\nName: John Doe\nRoll No: 101\nClass: FY-B.Tech\nResult: Pass'
);


// ──────────────────────────────────────────────────────────
//  SCRIPT 4 — Send Email to Multiple Recipients
// ──────────────────────────────────────────────────────────
EmailService.sendEmailToMultiple(
    new List<String>{
        'first@gmail.com',           // ← replace with real emails
        'second@gmail.com'
    },
    'Group Notification',
    'This is a group email sent via Salesforce Apex Email Services.'
);
