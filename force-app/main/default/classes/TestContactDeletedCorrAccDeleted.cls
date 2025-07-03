@isTest
private class TestContactDeletedCorrAccDeleted {
    @isTest
    static void testContactDeletedCorrAccDeleted() {
        Account acc = new Account(Name = 'TestContactDeletedCorrAccDeleted');
        insert acc;

        Contact con = new Contact(LastName = 'TestContactDeletedCorrAccDeleted', AccountId = acc.Id);
        insert con;

        delete con;

        List<Account> accList = [SELECT Id FROM Account WHERE Id = :acc.Id];
        System.assertEquals(0, accList.size());
    }
}
