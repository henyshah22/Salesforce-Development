@isTest
private class TestScheduleWeekly2dUpdateRatingWarm {
    @isTest
    static void testScheduleWeekly2dUpdateRatingWarm() {
        List<Account> testAccounts = new List<Account>();
        for (Integer i = 0; i < 10; i++) {
            testAccounts.add(new Account(Name = 'Test Account' + i, Rating = 'Hot'));
        }
        insert testAccounts;

        Test.startTest();
        String jobId = System.schedule('ScheduleWeekly2dUpdateRatingWarm', '0 30 11 1/1 * ? *', new ScheduleWeekly2dUpdateRatingWarm());
        Test.stopTest();

        List<Account> updatedaccs = [SELECT Id, Name, Rating FROM Account];
        for (Account acc : updatedaccs) {
            System.Assert.areEqual('Warm', acc.Rating);
        }
    }
}