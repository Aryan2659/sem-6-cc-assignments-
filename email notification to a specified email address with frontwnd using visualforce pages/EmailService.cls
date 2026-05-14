/**
 * EmailService.cls
 * Console-based Apex program to send email notifications
 * using Salesforce built-in Messaging class.
 * Supports: with attachment / without attachment
 * Run via: Developer Console → Execute Anonymous Window
 */
public class EmailService {

    // ─────────────────────────────────────────────────
    //  SEND EMAIL — Without Attachment
    // ─────────────────────────────────────────────────
    public static void sendEmail(
        String toAddress,
        String subject,
        String messageBody
    ) {
        try {
            // Step 1: Create the email message object
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            // Step 2: Set recipient
            mail.setToAddresses(new List<String>{ toAddress });

            // Step 3: Set subject
            mail.setSubject(subject);

            // Step 4: Set body (plain text)
            mail.setPlainTextBody(messageBody);

            // Step 5: Set HTML body (optional, richer formatting)
            mail.setHtmlBody(
                '<html><body>' +
                '<h2 style="color:#0070d2;">📧 Notification from Salesforce</h2>' +
                '<p>' + messageBody + '</p>' +
                '<hr/><small>Sent via Salesforce Email Services</small>' +
                '</body></html>'
            );

            // Step 6: Send the email
            Messaging.SendEmailResult[] results = Messaging.sendEmail(
                new List<Messaging.SingleEmailMessage>{ mail }
            );

            // Step 7: Check result
            if (results[0].isSuccess()) {
                System.debug('✅ Email sent successfully!');
                System.debug('   To      : ' + toAddress);
                System.debug('   Subject : ' + subject);
            } else {
                System.debug('❌ Email failed: ' + results[0].getErrors()[0].getMessage());
            }

        } catch (Exception e) {
            System.debug('❌ Exception: ' + e.getMessage());
        }
    }

    // ─────────────────────────────────────────────────
    //  SEND EMAIL — With Attachment (text content)
    // ─────────────────────────────────────────────────
    public static void sendEmailWithAttachment(
        String toAddress,
        String subject,
        String messageBody,
        String attachmentFileName,
        String attachmentContent
    ) {
        try {
            // Step 1: Create email message
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new List<String>{ toAddress });
            mail.setSubject(subject);
            mail.setPlainTextBody(messageBody);
            mail.setHtmlBody(
                '<html><body>' +
                '<h2 style="color:#0070d2;">📧 Notification from Salesforce</h2>' +
                '<p>' + messageBody + '</p>' +
                '<p><b>📎 Please find the attached file: ' + attachmentFileName + '</b></p>' +
                '<hr/><small>Sent via Salesforce Email Services</small>' +
                '</body></html>'
            );

            // Step 2: Create the attachment
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            attachment.setFileName(attachmentFileName);
            attachment.setBody(Blob.valueOf(attachmentContent)); // Convert text to Blob
            attachment.setContentType('text/plain');

            // Step 3: Attach to email
            mail.setFileAttachments(
                new List<Messaging.EmailFileAttachment>{ attachment }
            );

            // Step 4: Send
            Messaging.SendEmailResult[] results = Messaging.sendEmail(
                new List<Messaging.SingleEmailMessage>{ mail }
            );

            // Step 5: Check result
            if (results[0].isSuccess()) {
                System.debug('✅ Email with attachment sent successfully!');
                System.debug('   To         : ' + toAddress);
                System.debug('   Subject    : ' + subject);
                System.debug('   Attachment : ' + attachmentFileName);
            } else {
                System.debug('❌ Email failed: ' + results[0].getErrors()[0].getMessage());
            }

        } catch (Exception e) {
            System.debug('❌ Exception: ' + e.getMessage());
        }
    }

    // ─────────────────────────────────────────────────
    //  SEND EMAIL — To Multiple Recipients
    // ─────────────────────────────────────────────────
    public static void sendEmailToMultiple(
        List<String> toAddresses,
        String subject,
        String messageBody
    ) {
        try {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddresses);
            mail.setSubject(subject);
            mail.setPlainTextBody(messageBody);

            Messaging.SendEmailResult[] results = Messaging.sendEmail(
                new List<Messaging.SingleEmailMessage>{ mail }
            );

            if (results[0].isSuccess()) {
                System.debug('✅ Email sent to ' + toAddresses.size() + ' recipient(s)!');
                for (String addr : toAddresses) {
                    System.debug('   → ' + addr);
                }
            } else {
                System.debug('❌ Failed: ' + results[0].getErrors()[0].getMessage());
            }

        } catch (Exception e) {
            System.debug('❌ Exception: ' + e.getMessage());
        }
    }

    // ─────────────────────────────────────────────────
    //  DEMO — Run all operations (best for viva)
    // ─────────────────────────────────────────────────
    public static void runDemo() {
        System.debug('');
        System.debug('╔══════════════════════════════════════════╗');
        System.debug('║    SALESFORCE EMAIL SERVICE - DEMO       ║');
        System.debug('╚══════════════════════════════════════════╝');
        System.debug('');
        System.debug('── MENU ──────────────────────────────────');
        System.debug('1. Send Email (No Attachment)');
        System.debug('2. Send Email (With Attachment)');
        System.debug('3. Send Email (Multiple Recipients)');
        System.debug('─────────────────────────────────────────');

        String demoEmail = 'demo@example.com'; // Replace with your email

        // Option 1
        System.debug('');
        System.debug('[ OPTION 1 ] Sending email without attachment...');
        EmailService.sendEmail(
            demoEmail,
            'Test Notification from Salesforce',
            'Hello! This is a test notification sent from Salesforce using Apex Email Services.'
        );

        // Option 2
        System.debug('');
        System.debug('[ OPTION 2 ] Sending email with attachment...');
        EmailService.sendEmailWithAttachment(
            demoEmail,
            'Report Attached - Salesforce Notification',
            'Please find your monthly report attached.',
            'report.txt',
            'Monthly Report\n==============\nTotal Records: 150\nNew This Month: 23\nGenerated by Salesforce Apex'
        );

        // Option 3
        System.debug('');
        System.debug('[ OPTION 3 ] Sending to multiple recipients...');
        EmailService.sendEmailToMultiple(
            new List<String>{ demoEmail, 'another@example.com' },
            'Group Notification',
            'This email was sent to multiple recipients via Salesforce Apex.'
        );

        System.debug('');
        System.debug('✅ Demo complete!');
    }
}
