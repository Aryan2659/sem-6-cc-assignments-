# Assignment 22 — Salesforce Email Notification with Visualforce Frontend
### Salesforce | Apex + Visualforce Page + Email Validation

> **LP-II Assignment | Problem Statement 22**  
> Develop an Apex program that sends email notifications using Salesforce email services.  
> Define recipient email, subject, and message body. Send with/without attachment.  
> Show appropriate error message on invalid email ID — with Visualforce page frontend.

---

## 📌 What You Will Build

A proper web form inside Salesforce where you can:
- Type a recipient email, subject, and message
- Click a button to send the email
- Optionally attach a text file
- See a **green success message** if it worked
- See a **red error message** if the email ID is invalid or fields are empty

---

## 🔑 Key Difference from Assignment 21

| Assignment 21 | Assignment 22 |
|--------------|--------------|
| Console-based (Developer Console scripts) | **Visualforce page** (actual web form UI) |
| Output in logs | Output on the page (green/red messages) |
| No frontend | Full form with inputs, checkbox, buttons |
| No email validation UI | Shows error if email format is wrong |

---

## 🧠 Concepts Explained Simply

| Term | What it means |
|------|--------------|
| **Salesforce** | Cloud platform — runs in your browser, nothing to install |
| **Apex** | Salesforce's programming language — handles backend logic like sending emails |
| **Visualforce** | Salesforce's way to build web pages — like HTML but with `<apex:>` tags |
| **`Messaging.SingleEmailMessage`** | Salesforce's built-in class to compose and send emails |
| **`Messaging.EmailFileAttachment`** | Adds a file attachment to the email |
| **Validation** | Checking if input is correct before doing anything with it |
| **`get; set;`** | Apex property — makes a variable readable and writable by the Visualforce page |
| **`rendered="{!...}"`** | Visualforce way to show/hide elements based on a condition |

---

## ⚠️ STEP 0 — Create a Free Salesforce Account

> If you already have one from a previous assignment, skip this — use the same account.

1. Open: **https://developer.salesforce.com/signup**
2. Fill the form:
   - First Name, Last Name → your name
   - Email → your real email *(you'll get a verification link)*
   - Role → select **Developer**
   - Company → your college name
   - Country → **India** | Postal Code → your PIN code
   - Username → something like `yourname123.lp2@myorg.dev`  
     *(Unique ID — NOT your login email)*
3. Click **"Sign Me Up"** → check inbox → click **"Verify Account"** → set password
4. ✅ You're in!

---

## 🗺️ Getting to Setup

1. Click **⚙️ gear icon** (top right corner)
2. Click **"Setup"**
3. On the left you'll see a **"Quick Find"** search bar — use this to navigate

---

## 📁 Files in This Repo

```
A22-Salesforce-Email-VF/
├── apex/
│   └── EmailServiceController.cls    ← Backend — email sending + validation logic
├── visualforce/
│   └── EmailServicePage.vfp          ← Frontend — the web form UI
└── README.md
```

> **No custom objects needed** for this assignment — just an Apex class and a Visualforce page.

---

## ✅ STEP 1 — Open Setup

1. Click **⚙️ gear icon** (top right) → click **"Setup"**
2. The Setup page opens with a **"Quick Find"** search bar on the left

---

## ✅ STEP 2 — Create the Apex Class

1. In Quick Find, type **`Apex Classes`** → click it when it appears
2. Click the **"New"** button (top right of the page)
3. A code editor opens with some default text
4. **Click inside the editor → Ctrl+A → Delete** — clear everything
5. Open `apex/EmailServiceController.cls` from this repo → copy all → paste
6. Click **"Save"**

✅ No red error = class saved! The class handles:
- Form field values (email, subject, body)
- Email format validation
- Sending email with/without attachment
- Success and error messages

---

## ✅ STEP 3 — Create the Visualforce Page

1. In Quick Find, type **`Visualforce Pages`** → click it
2. Click **"New"** button
3. Fill in:
   - **Label** → `EmailServicePage`
   - **Name** → auto-fills as `EmailServicePage` *(leave it)*
4. Delete all default text in the editor → **Ctrl+A → Delete**
5. Open `visualforce/EmailServicePage.vfp` from this repo → copy all → paste
6. Check ✅ **"Available for Salesforce mobile apps and Lightning pages"**
7. Click **"Save"**

✅ Page saved!

---

## ✅ STEP 4 — Open Your Email Form

In your browser address bar, type:

```
https://YOUR-ORG-DOMAIN.lightning.force.com/apex/EmailServicePage
```

**How to find your org domain:**
- Look at your browser URL when you're logged into Salesforce
- It looks like: `https://companynameXXXXXX.lightning.force.com/...`
- Copy just `companynameXXXXXX.lightning.force.com`

✅ You should see the **Salesforce Email Notification Service** form with fields for email, subject, message, and an attachment checkbox!

---

## 🧪 Testing Everything

### Test 1 — Invalid Email (must show error)

1. In **Recipient Email** → type `invalidemail` *(no @ symbol)*
2. Fill in subject and message
3. Click **📤 Send Email**
4. ✅ Red error message appears:  
   `❌ Invalid Email ID: "invalidemail" is not a valid email address`

### Test 2 — Another invalid email

1. Type `name@` *(has @ but no domain)*
2. Click Send
3. ✅ Error: Invalid email address

### Test 3 — Empty fields (must show error)

1. Leave **Recipient Email** blank → click Send
2. ✅ Error: `❌ Error: Recipient email address cannot be empty`

### Test 4 — Send email WITHOUT attachment (success)

1. **Recipient Email** → your real email (e.g. `yourname@gmail.com`)
2. **Subject** → `Test from Salesforce`
3. **Message** → `Hello! This is a test email sent via Salesforce Apex.`
4. Leave the **Include Attachment** checkbox unchecked
5. Click **📤 Send Email**
6. ✅ Green message: `✅ Email sent successfully to yourname@gmail.com!`
7. Check your email inbox — the email should arrive!

### Test 5 — Send email WITH attachment

1. Fill in recipient, subject, message as above
2. **Check** the ✅ Include Attachment checkbox — extra fields appear
3. **Attachment File Name** → `report.txt`
4. **Attachment Content** → type anything, e.g.:
   ```
   Sample Report
   =============
   Name: John Doe
   Event: Tech Conference 2025
   Status: Registered
   ```
5. Click **📤 Send Email**
6. ✅ Green success message → check inbox → email arrives with `report.txt` attached!

---

## 🔍 Understanding the Code

### Apex Controller

```apex
public String recipientEmail { get; set; }
```
> `get; set;` makes this variable a **property** — the Visualforce page can read it and write to it.  
> When you type in the email field on the page, this variable gets updated.

```apex
private Boolean isValidEmail(String email) {
    if (!email.contains('@')) return false;
    List<String> parts = email.split('@');
    if (parts.size() != 2) return false;
    if (!parts[1].contains('.')) return false;
    ...
}
```
> Checks if the email has exactly one `@`, a domain, and a `.` in the domain.  
> Returns `true` if valid, `false` if not.

```apex
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
mail.setToAddresses(new List<String>{ recipientEmail });
mail.setSubject(emailSubject);
mail.setPlainTextBody(messageBody);
Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
```
> Creates the email object, sets recipient/subject/body, sends it.

```apex
Messaging.EmailFileAttachment att = new Messaging.EmailFileAttachment();
att.setFileName(attachmentName);
att.setBody(Blob.valueOf(attachmentContent));
att.setContentType('text/plain');
mail.setFileAttachments(new List<Messaging.EmailFileAttachment>{ att });
```
> Creates an attachment — `Blob.valueOf()` converts text String to binary format (required by Salesforce).

### Visualforce Page

```xml
<apex:inputText value="{!recipientEmail}" />
```
> Input field bound to `recipientEmail` in the controller — two-way binding.  
> Whatever you type here goes directly into the Apex variable.

```xml
<apex:outputPanel rendered="{!NOT(ISBLANK(errorMessage))}">
    <div class="error-msg">{!errorMessage}</div>
</apex:outputPanel>
```
> Only shows the red error box when `errorMessage` is not empty.  
> `rendered` = show/hide condition in Visualforce.

```xml
<apex:inputCheckbox value="{!includeAttachment}" />
<apex:outputPanel rendered="{!includeAttachment}">
    ...attachment fields...
</apex:outputPanel>
```
> Checkbox controls a boolean. The attachment fields only appear when checkbox is checked.

---

## ⚠️ Important Notes

| Note | Detail |
|------|--------|
| **Email limit** | Free Developer Org can send **15 emails per day** |
| **Real email** | Use a real email address — check your inbox to verify it worked |
| **From address** | Emails come from Salesforce's no-reply address — that's normal |
| **Attachment content** | Only text content supported via this form (not file uploads) |

---

## 🧯 If Something Goes Wrong

| Problem | Fix |
|---------|-----|
| Red error when saving Apex class | Code not fully copied — Ctrl+A, delete, copy-paste again |
| Page shows blank when opening URL | Controller name mismatch — check it says `EmailServiceController` at the top of the class |
| "Page not found" error | Make sure Visualforce page was saved with name `EmailServicePage` |
| Green message but no email received | Check spam/junk folder; verify you used a real email address |
| "Daily limit exceeded" error | Sent 15+ emails today — wait 24 hours |
| Attachment fields not appearing | Click the checkbox — fields only show when checkbox is checked |
| Email sending but no attachment received | Make sure you typed content in the attachment content box |

---

## 🎓 Viva Points

| Question | Answer |
|----------|--------|
| What class is used to send email? | `Messaging.SingleEmailMessage` — Salesforce's built-in email class |
| How is email validation done? | In Apex — checks for `@`, splits on `@`, verifies domain has `.`, no spaces |
| How is the error message shown on page? | The controller sets `errorMessage` string; Visualforce shows it using `rendered="{!NOT(ISBLANK(errorMessage))}"` |
| How does the attachment work? | `Messaging.EmailFileAttachment` — content converted to Blob using `Blob.valueOf()` |
| What is `get; set;`? | Apex property syntax — makes variable readable and writable by the Visualforce page |
| What does `rendered` do in Visualforce? | Conditionally shows or hides an element based on a boolean expression |
| How is this different from Assignment 21? | Assignment 21 is console-based (Execute Anonymous); Assignment 22 has a Visualforce web form with real-time UI feedback |
| What does `Blob.valueOf()` do? | Converts a String to binary Blob data — required for email attachments in Salesforce |
