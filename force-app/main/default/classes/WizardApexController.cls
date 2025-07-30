public class WizardApexController {
    @AuraEnabled
    public static String createAccount(Account account) {
        try {
            if (String.isBlank(account.Name)) {
                throw new AuraHandledException('Account Name is required');
            }
            insert account;
            return account.Id;
        } catch (Exception e) {
            throw new AuraHandledException('Error creating account: ' + e.getMessage());
        }
    }
    
    @AuraEnabled
    public static String createContact(Contact contact) {
        try {
            if (String.isBlank(contact.LastName)) {
                throw new AuraHandledException('Last Name is required');
            }
            if (String.isBlank(contact.AccountId)) {
                throw new AuraHandledException('Account ID is required');
            } 
            insert contact;
            return contact.Id;
        } catch (Exception e) {
            throw new AuraHandledException('Error creating contact: ' + e.getMessage());
        }
    }
    
    @AuraEnabled
    public static void createEvent(Event event) {
        try {
            if (event.WhoId == null) {
                throw new AuraHandledException('Contact ID is required');
            }
            if (event.StartDateTime == null || event.EndDateTime == null) {
                throw new AuraHandledException('Start and End Date/Time are required');
            }
            event.Subject = 'Wizard Task'; 
            insert event;
        } catch (Exception e) {
            throw new AuraHandledException('Error creating event: ' + e.getMessage());
        }
    }
}