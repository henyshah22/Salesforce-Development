public class RegistrationController {
    public String firstName { get; set; }
    public String lastName { get; set; }
    public String email { get; set; }
    public String password { get; set; }
    public String userType { get; set; }
    public String grade { get; set; }
    public String subject { get; set; }

    public PageReference register() {
        try {
            if (String.isBlank(firstName) || String.isBlank(lastName) || String.isBlank(email) || String.isBlank(password) || String.isBlank(userType)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'All required fields must be filled.'));
                return null;
            }

            Account commAccount = [SELECT Id FROM Account WHERE Name = 'Community Account' LIMIT 1];
            if (commAccount == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Community Account not found.'));
                return null;
            }

            String profileName = userType == 'Teacher' ? 'Teacher Community User' : 'Student Community User';
            Profile selectedProfile = [SELECT Id FROM Profile WHERE Name = :profileName LIMIT 1];
            if (selectedProfile == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Profile not found for ' + userType));
                return null;
            }

            Contact con = new Contact(
                FirstName = firstName,
                LastName = lastName,
                Email = email,
                AccountId = commAccount.Id,
                User_Type__c = userType,
                Subject__c = userType == 'Teacher' ? subject : null,
                Grade__c = userType == 'Student' ? grade : null
            );
            insert con;

            User newUser = new User(
                Username = email,
                Email = email,
                FirstName = firstName,
                LastName = lastName,
                Alias = firstName.length() > 8 ? firstName.substring(0, 8) : firstName,
                ProfileId = selectedProfile.Id,
                TimeZoneSidKey = 'Asia/Kolkata',
                LocaleSidKey = 'en_US',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                ContactId = con.Id,
                CommunityNickname = firstName + lastName + String.valueOf(Crypto.getRandomInteger()).right(4)
            );

            insert newUser;
            System.setPassword(newUser.Id, password);

            Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
            EmailTemplate welcomeTemplate = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'TeacherStudentWelcomeEmail' LIMIT 1];
            emailMsg.setTemplateId(welcomeTemplate.Id);
            emailMsg.setTargetObjectId(con.Id);
            emailMsg.setWhatId(newUser.Id);
            emailMsg.setSaveAsActivity(false);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { emailMsg });

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Registration successful! Please check your email for a welcome message.'));
            return new PageReference('/apex/LoginPage');
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Registration failed: ' + ex.getMessage()));
            return null;
        }
    }
}