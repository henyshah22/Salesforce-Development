@isTest
private class TestNewCustomer {
    @isTest
    static void testNewCustomer() {
       Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            CloseDate = Date.today().addDays(30),
            StageName = 'Prospecting'
        );
        insert opp;
        Opportunity oppAfterInsert = [SELECT Id, Type FROM Opportunity WHERE Id = :opp.Id];
        System.AssertEquals('New Customer', oppAfterInsert.Type);
    }
}    