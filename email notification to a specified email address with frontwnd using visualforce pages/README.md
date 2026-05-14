# Assignment 21 — Salesforce Email Service (Console-based Apex)
### Salesforce | Apex + Messaging Class

> **LP-II Assignment | Problem Statement 21**  
> Write an Apex program that sends email notifications using Salesforce's built-in email service — with and without attachments.

---

## 📌 What You Will Build

An Apex program that can:
- Send a plain email to any address
- Send an email with a text file attached
- Send one email to multiple recipients

All run from the **Developer Console** — Salesforce's browser-based code runner.

> 💡 This assignment has **no custom objects** and **no UI** to build.  
> You just create one Apex class and run scripts — it's the simplest Salesforce assignment.

---

## ⚠️ Before You Start — Create a Free Salesforce Account

> Salesforce runs entirely in your browser. Nothing to install.

1. Open: **https://developer.salesforce.com/signup**
2. Fill the form:
   - First Name, Last Name → your real name
   - Email → your real email *(you'll get a verification link here)*
   - Role → select **Developer**
   - Company → your college name
   - Country → **India** | Postal Code → your PIN code
   - Username → something like `yourname123.lp2@myorg.dev`  
     *(Just a unique ID — NOT your login email)*
3. Click **Sign Me Up** → check inbox → click **Verify Account** → set password
4. ✅ You're logged in to Salesforce!

---

## 🗺️ Two Things You Need to Know

### Thing 1 — How to reach Setup
1. Click the **⚙️ gear icon** (top right corner)
2. Click **"Setup"**
3. On the left, you'll see the **"Quick Find"** search bar

### Thing 2 — How to open Developer Console
1. Click the **⚙️ gear icon** (top right corner)
2. Click **"Developer Console"**
3. A new browser window opens with a menu bar: **File | Edit | Debug | Test...**

> ⚠️ If the Developer Console window doesn't open:  
> Look for a popup-blocked icon in your browser's address bar → click it → allow popups for salesforce.com → try again

---

## 📁 Files in This Repo

```
A21-Salesforce-Email/
├── apex/
│   └── EmailService.cls              ← Apex class (copy-paste into Salesforce)
├── anonymous-scripts/
│   └── run_operations.apex           ← Scripts to run one at a time
└── README.md
```

---

## ✅ STEP 1 — Create the Apex Class

1. Click ⚙️ → **"Setup"**
2. In the Quick Find search bar on the left, type **`Apex Classes`** → click it when it appears
3. Click the **"New"** button (top right of the page)
4. A code editor opens with some default text like `public class ApexClass { }`
5. **Click inside the editor → Ctrl+A → Delete** — clear everything
6. Open `apex/EmailService.cls` from this repo → copy all the text
7. Paste it into the editor
8. Click **"Save"**

✅ No red error banner = class saved successfully!

> If you see a red error, it usually says something like "unexpected token". This means the code wasn't fully copied — try copying again from scratch.

---

## ✅ STEP 2 — Open Execute Anonymous Window

This is where you'll run your scripts. Think of it like a terminal where you paste and run code.

1. Click ⚙️ → **"Developer Console"** → new window opens
2. In the Developer Console, click **"Debug"** in the top menu bar
3. Click **"Open Execute Anonymous Window"**
4. A text box appears at the bottom of the screen — this is where you paste scripts

---

## ✅ STEP 3 — Run the Scripts

Open `anonymous-scripts/run_operations.apex` from this repo — you'll see 4 scripts separated by comments.

**⚠️ Important — replace the email address first!**  
In each script you'll see `'your-email@gmail.com'` — replace this with your actual email address so you can receive and verify the emails.

### How to run a script:
1. Copy ONE script block from `run_operations.apex`
2. Paste it into the Execute Anonymous window
3. Click the **"Execute"** button

### How to see the output:
1. Look at the **"Logs"** panel at the bottom of the Developer Console
2. A new row appears → **double-click it** to open it
3. In the log viewer that opens, look for a checkbox labeled **"Debug Only"** at the top right → check it ✅
4. You'll now see only your `System.debug()` output lines, like:
   ```
   ✅ Email sent successfully!
      To      : yourname@gmail.com
      Subject : Hello from Salesforce Apex!
   ```

---

## 🎮 The 4 Scripts — What Each Does

### Script 1 — Full Demo (best for viva — runs all 3 options)

```apex
EmailService.runDemo();
```

Paste this → Execute → check logs. Shows the menu, then sends 3 types of emails.

---

### Script 2 — Send Email WITHOUT Attachment

```apex
EmailService.sendEmail(
    'your-email@gmail.com',
    'Hello from Salesforce Apex!',
    'This notification was sent using Salesforce Messaging class.'
);
```

Replace `your-email@gmail.com` with your real email → Execute → check your inbox!

---

### Script 3 — Send Email WITH Attachment

```apex
EmailService.sendEmailWithAttachment(
    'your-email@gmail.com',
    'Your Report is Ready!',
    'Please find the attached report.',
    'student_report.txt',
    'Student Report\n==============\nName: John Doe\nRoll No: 101\nResult: Pass'
);
```

Replace email → Execute → check inbox — you should get an email with a `.txt` file attached!

---

### Script 4 — Send to Multiple Recipients

```apex
EmailService.sendEmailToMultiple(
    new List<String>{ 'first@gmail.com', 'second@gmail.com' },
    'Group Notification',
    'This is a group email via Salesforce Apex.'
);
```

Replace both email addresses → Execute.

---

## 🧪 Verifying It Worked

After running a script:

1. **Check the logs** — you should see `✅ Email sent successfully!`
2. **Check your actual email inbox** — the email should arrive within a minute
3. Check your **spam/junk folder** if you don't see it in inbox

> 📧 Emails come from a Salesforce no-reply address — that's normal.

---

## ⚠️ Important Limits

| Limit | Detail |
|-------|--------|
| **15 emails per day** | Free Developer Org can only send 15 emails in 24 hours |
| **Real email required** | Use a real email address — Salesforce verifies the domain |
| **Attachment size** | Maximum 25MB per email |
| **From address** | Emails come from Salesforce's no-reply address by default |

> If you get an error saying "Daily limit exceeded", just wait 24 hours and try again.

---

## 🔍 Understanding the Code (For Viva)

### How a basic email is sent in Apex:

```apex
// Step 1: Create the email object
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

// Step 2: Set who receives it
mail.setToAddresses(new List<String>{ 'someone@gmail.com' });

// Step 3: Set subject
mail.setSubject('Hello!');

// Step 4: Set the message
mail.setPlainTextBody('This is the message body.');

// Step 5: Send it
Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
```

Think of it like filling an envelope:
- `setToAddresses` = write the address on the envelope
- `setSubject` = write the subject on the envelope
- `setPlainTextBody` = put the letter inside
- `sendEmail` = drop it in the postbox

### How an attachment is added:

```apex
Messaging.EmailFileAttachment att = new Messaging.EmailFileAttachment();
att.setFileName('report.txt');              // name of the file
att.setBody(Blob.valueOf('file content'));  // content of the file
att.setContentType('text/plain');          // type of file
mail.setFileAttachments(new List<Messaging.EmailFileAttachment>{ att });
```

> `Blob.valueOf()` converts a String into binary data — Salesforce requires binary format for attachments.

### How the result is checked:

```apex
Messaging.SendEmailResult[] results = Messaging.sendEmail(...);
if (results[0].isSuccess()) {
    System.debug('✅ Sent!');
} else {
    System.debug('❌ Failed: ' + results[0].getErrors()[0].getMessage());
}
```

---

## 🧯 If Something Goes Wrong

| Problem | Fix |
|---------|-----|
| Red error when saving class | Code wasn't fully copied — Ctrl+A, delete, copy-paste again from scratch |
| `EmailService` not found when running script | Class wasn't saved — go back to Step 1 |
| Log shows `❌ Email failed` | Check the error message in the log — usually a bad email address |
| "Daily limit exceeded" error | Sent 15+ emails today — wait 24 hours |
| Email not in inbox | Check spam/junk folder; make sure you used a real email address |
| Execute button not visible | The Execute Anonymous window might be too small — drag it taller |
| Can't see `System.debug` output | In the log viewer, check ✅ the "Debug Only" checkbox |

---

## 🎓 Viva Points

| Question | Answer |
|----------|--------|
| What class is used to send email? | `Messaging.SingleEmailMessage` |
| What method actually sends the email? | `Messaging.sendEmail()` — takes a List of email messages |
| How do you add an attachment? | Create `Messaging.EmailFileAttachment`, set file name, body (as Blob), content type — attach via `setFileAttachments()` |
| What is `Blob.valueOf()`? | Converts a String to binary Blob format — required because attachments must be binary |
| What is `SendEmailResult`? | Object returned after sending — use `isSuccess()` to check if email was sent |
| What is Execute Anonymous? | Developer Console feature to run Apex code on the fly without saving it as a class |
| How is this "console-based"? | Runs in Developer Console — output via `System.debug()` visible in Logs panel |
| Daily email limit in free Developer Org? | 15 emails per day |
