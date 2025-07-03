@isTest
private class TestStageProspectingCloseDate15d {
    @isTest
    static void testStageProspectingCloseDate15d() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Opportunity opp = new Opportunity();
        opp.Name = 'TestStageProspectingCloseDate15d';
        opp.CloseDate = Date.today();
        opp.StageName = 'Qualification';
        opp.AccountId = acc.Id;
        insert opp;

        Opportunity oppAfterInsert = [SELECT StageName, CloseDate FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals('Prospecting', oppAfterInsert.StageName);
        System.assertEquals(Date.today().addDays(15), oppAfterInsert.CloseDate);

        oppAfterInsert.Name = 'Updated Opportunity';
        update oppAfterInsert;

        Opportunity oppAfterUpdate = [SELECT StageName, CloseDate FROM Opportunity WHERE Id = :oppAfterInsert.Id];
        System.assertEquals('Prospecting', oppAfterUpdate.StageName);
        System.assertEquals(Date.today().addDays(15), oppAfterUpdate.CloseDate);
    }
}
