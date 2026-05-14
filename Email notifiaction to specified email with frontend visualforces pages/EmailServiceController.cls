/**
 * EmailServiceController.cls
 * Apex controller for sending emails via Visualforce page
 * Supports: with/without attachment, email validation, error messages
 */
public class EmailServiceController {

    // ── Form fields bound to Visualforce page ──
    public String recipientEmail  { get; set; }
    public String emailSubject    { get; set; }
    public String messageBody     { get; set; }
    public String attachmentName  { get; set; }
    public String attachmentContent { get; set; }
    public Boolean includeAttachment { get; set; }

    // ── Status messages shown on the page ──
    public String successMessage  { get; set; }
    public String errorMessage    { get; set; }

    // ── Constructor: runs when page loads ──
    public EmailServiceController() {
        recipientEmail     = '';
        emailSubject       = '';
        messageBody        = '';
        attachmentName     = 'attachment.txt';
        attachmentContent  = '';
        includeAttachment  = false;
        successMessage     = '';
        errorMessage       = '';
    }

    // ═══════════════════════════════════════════════
    //   VALIDATE EMAIL — checks format before sending
    // ═══════════════════════════════════════════════
    private Boolean isValidEmail(String email) {
        if (String.isBlank(email)) return false;

        // Must contain exactly one @ symbol
        if (!email.contains('@')) return false;

        // Split into local and domain parts
        List<String> parts = email.split('@');
        if (parts.size() != 2) return false;

        String localPart  = parts[0];
        String domainPart = parts[1];

        // Local part cannot be empty
        if (String.isBlank(localPart)) return false;

        // Domain must contain a dot
        if (!domainPart.contains('.')) return false;

        // Domain cannot start or end with a dot
        if (domainPart.startsWith('.') || domainPart.endsWith('.')) return false;

        // No spaces allowed anywhere
        if (email.contains(' ')) return false;

        return true;
    }

    // ═══════════════════════════════════════════════
    //   SEND EMAIL — called when Send button clicked
    // ═══════════════════════════════════════════════
    public PageReference sendEmail() {
        // Reset messages
        successMessage = '';
        errorMessage   = '';

        // ── Validate fields ──
        if (String.isBlank(recipientEmail)) {
            errorMessage = '❌ Error: Recipient email address cannot be empty.';
            return null;
        }

        if (!isValidEmail(recipientEmail)) {
            errorMessage = '❌ Invalid Email ID: "' + recipientEmail + '" is not a valid email address. Please enter a valid email (e.g. name@domain.com).';
            return null;
        }

        if (String.isBlank(emailSubject)) {
            errorMessage = '❌ Error: Email subject cannot be empty.';
            return null;
        }

        if (String.isBlank(messageBody)) {
            errorMessage = '❌ Error: Message body cannot be empty.';
            return null;
        }

        try {
            // ── Build the email ──
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new List<String>{ recipientEmail });
            mail.setSubject(emailSubject);
            mail.setPlainTextBody(messageBody);
            mail.setHtmlBody(
                '<html><body style="font-family:Arial,sans-serif;">' +
                '<div style="background:#0070d2;color:white;padding:16px;border-radius:6px 6px 0 0;">' +
                '<h2 style="margin:0;">📧 ' + emailSubject + '</h2>' +
                '</div>' +
                '<div style="padding:20px;border:1px solid #ddd;border-top:none;border-radius:0 0 6px 6px;">' +
                '<p>' + messageBody.replace('\n', '<br/>') + '</p>' +
                '<hr/>' +
                '<small style="color:#888;">Sent via Salesforce Email Services</small>' +
                '</div></body></html>'
            );

            // ── Add attachment if checkbox is checked ──
            if (includeAttachment && !String.isBlank(attachmentContent)) {
                Messaging.EmailFileAttachment att = new Messaging.EmailFileAttachment();
                att.setFileName(String.isBlank(attachmentName) ? 'attachment.txt' : attachmentName);
                att.setBody(Blob.valueOf(attachmentContent));
                att.setContentType('text/plain');
                mail.setFileAttachments(new List<Messaging.EmailFileAttachment>{ att });
            }

            // ── Send the email ──
            Messaging.SendEmailResult[] results = Messaging.sendEmail(
                new List<Messaging.SingleEmailMessage>{ mail }
            );

            // ── Check result ──
            if (results[0].isSuccess()) {
                successMessage = '✅ Email sent successfully to ' + recipientEmail + '!';
                // Clear the form after success
                clearForm();
            } else {
                errorMessage = '❌ Failed to send email: ' + results[0].getErrors()[0].getMessage();
            }

        } catch (Exception e) {
            errorMessage = '❌ Error: ' + e.getMessage();
        }

        return null;
    }

    // ── Clear form fields after successful send ──
    public PageReference clearForm() {
        recipientEmail    = '';
        emailSubject      = '';
        messageBody       = '';
        attachmentName    = 'attachment.txt';
        attachmentContent = '';
        includeAttachment = false;
        return null;
    }
}
