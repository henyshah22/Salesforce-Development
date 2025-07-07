@isTest
public class TestTheGreatProblem {
    @isTest
    static void testTheGreatProblem() {
        Account acc = new Account(Name = 'TestAccount', Max_Amount__c = 100);     
        insert acc;

        Contact c1 = new Contact(LastName = 'TestContact1', AccountId = acc.Id, Great_Problem_Amount__c = 50);
        insert c1;
        Contact insertedContact = [SELECT Great_Problem_Amount__c FROM Contact WHERE Id = :c1.Id];
        System.assertEquals(50, insertedContact.Great_Problem_Amount__c);

        Contact c2 = new Contact(LastName = 'TestContact2', AccountId = acc.Id, Great_Problem_Amount__c = 250);
        insert c2;
        List<Contact> cList = [SELECT Id FROM Contact WHERE AccountId = :acc.Id];
        System.AssertEquals(4, cList.size());

        c1.Great_Problem_Amount__c = 300;
        update c1;
        
        List<Contact> ContactUpdated = [SELECT Id FROM Contact WHERE AccountId = :acc.Id];
        System.AssertEquals(6, ContactUpdated.size()); 
    }
}