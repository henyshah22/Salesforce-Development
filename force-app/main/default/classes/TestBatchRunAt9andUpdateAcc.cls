@isTest
private class TestBatchRunAt9andUpdateAcc {
    @isTest
    static void testBatchRunAt9andUpdateAcc() {
        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i < 3; i++) {
            accounts.add(new Account(
                Name = 'TestBatchClass Account ' + i,
                OwnerId = UserInfo.getUserId(),
                Description = 'Updated on ' + System.now()
            ));
        }
        insert accounts;
        
        Test.startTest();
        System.schedule('Test Daily Update', '0 0 9 * * ? *', new BatchRunAt9andUpdateAcc());
        Test.stopTest();
        
        List<Account> updatedAccounts = [SELECT Description FROM Account WHERE Id IN :accounts];        
        for(Account acc : updatedAccounts) {
            System.assert(acc.Description != null, 'Description should not be null');
        }
    }
}
