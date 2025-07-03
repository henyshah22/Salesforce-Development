@isTest
private class TestBatchUpdateAccountWithOppName{
    @isTest
    static void testBatchUpdateAccountWithOppName(){
        Account acc = new Account();
        acc.Name = 'TestBatch AccOpp';
        acc.Description = 'Some description';
        insert acc;
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity Name';
        opp.AccountId = acc.Id;
        opp.CloseDate = Date.today().addDays(10);
        opp.StageName = 'Prospecting';
        insert opp;
        
        Test.startTest();
        BatchUpdateAccountWithOppName batchUpdate = new BatchUpdateAccountWithOppName();
        Database.executeBatch(batchUpdate, 200);
        Test.stopTest();

        Account updatedAcc = [SELECT Id, Name FROM Account WHERE Id = :acc.Id];
        System.Assert.areEqual('Test Opportunity Name', updatedAcc.Name);
    }
}