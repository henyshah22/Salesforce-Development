public class ResetPasswordController {
    public String newPassword { get; set; }
    public String confirmPassword { get; set; }
    public String token { get; set; }

    public ResetPasswordController() {
        token = ApexPages.currentPage().getParameters().get('token');
    }

    public PageReference resetPassword() {
        try {
            if (String.isBlank(newPassword) || String.isBlank(confirmPassword)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Both password fields are required.'));
                return null;
            }

            if (newPassword != confirmPassword) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Passwords do not match.'));
                return null;
            }

            List<Password_Reset_Token__c> tokens = [SELECT User__c, Expires_At__c FROM Password_Reset_Token__c WHERE Token__c = :token AND Expires_At__c > :Datetime.now() LIMIT 1];
            if (tokens.isEmpty()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid or expired reset token.'));
                return null;
            }

            User user = [SELECT Id, ContactId FROM User WHERE Id = :tokens[0].User__c LIMIT 1];
            System.setPassword(user.Id, newPassword);

            delete tokens[0];

            Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
            EmailTemplate template = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'CommunityResetPasswordEmail' LIMIT 1];
            emailMsg.setTemplateId(template.Id);
            emailMsg.setTargetObjectId(user.ContactId);
            emailMsg.setWhatId(user.Id);
            emailMsg.setSaveAsActivity(false);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { emailMsg });

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Password reset successfully. You can now log in with your new password.'));
            return new PageReference('/apex/LoginPage');
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error resetting password: ' + e.getMessage()));
            return null;
        }
    }
}