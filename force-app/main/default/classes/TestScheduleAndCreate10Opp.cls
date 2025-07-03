@isTest
private class TestScheduleAndCreate10Opp {
    @isTest
    static void testScheduleAndCreate10Opp() {
        Test.startTest();
        System.schedule('TestCreateOpportunities', '0 30 11 1/1 * ? *', new ScheduleAndCreate10Opp());
        Test.stopTest();
        List<Opportunity> opps = [SELECT Id, Name, StageName FROM Opportunity WHERE Name LIKE 'Scheduled Opportunity%'];
        System.assertEquals(10, opps.size());
    }
}
