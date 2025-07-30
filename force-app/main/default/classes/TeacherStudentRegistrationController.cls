public class TeacherStudentRegistrationController {
    public String userType { get; set; }
    public String fullName { get; set; }
    public String email { get; set; }
    public String password { get; set; }
    public String subject { get; set; }
    public String grade { get; set; }

    public PageReference register() {
        try {
            if (String.isBlank(fullName) || String.isBlank(email) || String.isBlank(password) || String.isBlank(userType)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'All required fields must be filled.'));
                return null;
            }
            if (!Pattern.matches('^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$', email)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid email format.'));
                return null;
            }

            Account defaultAccount = [SELECT Id FROM Account WHERE Name = 'Teacher Student Org' LIMIT 1];

            Contact c = new Contact();
            c.LastName = fullName;
            c.Email = email;
            c.User_Type__c = userType;

            if (userType == 'Teacher') {
                c.Subject__c = subject;
            } else if (userType == 'Student') {
                c.Grade__c = grade;
            }

            c.AccountId = defaultAccount.Id;
            insert c;

            String profileName = userType + ' Community User';
            Profile userProfile = [SELECT Id FROM Profile WHERE Name = :profileName LIMIT 1];

            User u = new User();
            u.Username = email;
            u.Email = email;
            u.Alias = fullName.length() >= 8 ? fullName.substring(0, 8) : fullName;
            u.LastName = fullName;
            u.CommunityNickname = email.split('@')[0];
            u.TimeZoneSidKey = 'Asia/Kolkata';
            u.LocaleSidKey = 'en_US';
            u.EmailEncodingKey = 'UTF-8';
            u.LanguageLocaleKey = 'en_US';
            u.ProfileId = userProfile.Id;
            u.ContactId = c.Id;

            insert u;

            System.setPassword(u.Id, password);

            EmailTemplate et = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'TeacherStudentWelcomeEmail' LIMIT 1];
            Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate(et.Id, u.Id, c.Id);
            mail.setToAddresses(new String[] { email });
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'User registered successfully!'));
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Registration failed: ' + e.getMessage()));
        }
        return null;
    }
}