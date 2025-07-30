public with sharing class CreateContactController {
    @AuraEnabled
    public static void insertContact(String contactName, String mobileNumber) {
        if (String.isBlank(contactName)) {
            throw new AuraHandledException('Contact Name is required.');
        }

        try {
            Contact con = new Contact();
            con.LastName = contactName;
            con.MobilePhone = mobileNumber;
            insert con;
        } catch (Exception e) {
            throw new AuraHandledException('Error creating contact: ' + e.getMessage());
        }
    }
}
