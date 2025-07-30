public class ForgotPasswordControllerr {
    public String email { get; set; }

    public PageReference sendResetLink() {
        try {
            if (String.isBlank(email)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Email address is required.'));
                return null;
            }

            List<User> users = [SELECT Id, ContactId, Contact.FirstName, Contact.LastName FROM User WHERE Username = :email AND IsActive = true LIMIT 1];
            if (users.isEmpty()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No active user found with this email address.'));
                return null;
            }

            User user = users[0];

            String resetToken = EncodingUtil.base64Encode(Crypto.generateAesKey(128)).replace('/', '_').replace('+', '-');
            String userId = user.Id;

            String resetUrl = 'https://orgfarm-e44c475971-dev-ed.develop.my.site.com/apex/ResetPasswordPage?token=' + resetToken;

            Password_Reset_Token__c token = new Password_Reset_Token__c(
                User__c = userId,
                Token__c = resetToken,
                Reset_URL__c = resetUrl,
                Expires_At__c = Datetime.now().addHours(24)
            );
            insert token;

            Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
            EmailTemplate template = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'CommunityForgotPasswordEmail' LIMIT 1];
            emailMsg.setTemplateId(template.Id);
            emailMsg.setTargetObjectId(user.ContactId);
            emailMsg.setWhatId(token.Id);
            emailMsg.setSaveAsActivity(false);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { emailMsg });

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'A password reset link has been sent to your email.'));
            return null;
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error sending reset link: ' + e.getMessage()));
            return null;
        }
    }
}