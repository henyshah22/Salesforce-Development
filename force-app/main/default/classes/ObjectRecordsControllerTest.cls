@isTest
public class ObjectRecordsControllerTest {
    
    @isTest
    static void testGetRecordsAndSendEmail() {
        Lead lead = new Lead(LastName = 'Test Lead', Company = 'Test Co', Email__c = 'lead@example.com');
        insert lead;

        Account acc = new Account(Name = 'Test Account', Email__c = 'account@example.com');
        insert acc;

        Contact con = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'contact@example.com');
        insert con;

        Test.startTest();
        List<SObject> leadRecords = ObjectRecordsController.getRecords('Lead');
        List<SObject> accountRecords = ObjectRecordsController.getRecords('Account');
        List<SObject> contactRecords = ObjectRecordsController.getRecords('Contact');
        List<SObject> emptyRecords = ObjectRecordsController.getRecords('InvalidObject');

        List<String> emailList = new List<String>{'test1@example.com', 'test2@example.com'};
        ObjectRecordsController.sendEmail(emailList, 'Test Subject', '<p>Test Body</p>');
        Test.stopTest();

        System.assertNotEquals(0, leadRecords.size());
        System.assertNotEquals(0, accountRecords.size());
        System.assertNotEquals(0, contactRecords.size());
        System.assertEquals(0, emptyRecords.size());
    }
}
