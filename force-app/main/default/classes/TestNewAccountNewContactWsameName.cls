@isTest
private class TestNewAccountNewContactWsameName {
    @isTest
    static void testNewAccountNewContactWsameName() {
        Account acc = new Account(Name = 'Test NewAccountNewContactWsameName');
        insert acc;

        List<Contact> contacts = [SELECT Id, LastName, AccountId FROM Contact WHERE AccountId = :acc.Id];

        System.Assert.areEqual(1, contacts.size());
    }    
}