private class TestScheduleAndCreate10Opp{
    @isTest
    static void testScheduleAndCreate10Opp(){
        Test.startTest();
        System.schedule('ScheduleWeekly2dUpdateRatingWarmMonday', '0 30 11 1/1 * ? *', new ScheduleWeekly2dUpdateRatingWarm());
        Test.stopTest();
        List<Opportunity> opps = [SELECT Id, Name, StageName FROM Opportunity WHERE Name LIKE 'Scheduled Opportunity%'];
        System.Assert.areEqual(10, oppList.size());
    }
}