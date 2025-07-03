@isTest
private class TestDeleteDuplicateAccounts{
    @isTest
    static void testDeleteDuplicateAccounts(){
        Account acc1 = new Account(Name = 'TestAccount');
        insert acc1;
        Account acc2 = new Account(Name = 'TestAccount');
        insert acc2;
        
        List<Account> accounttoDelete = [SELECT Id, Name FROM Account WHERE Name = 'TestAccount'];
        System.Assert.areEqual(1, accounttoDelete.size());
    }
}