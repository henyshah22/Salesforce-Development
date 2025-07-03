@isTest
private class TestScheduleWeekly2dUpdateRatingWarm {

    @isTest
    static void testScheduledUpdate() {
        List<Account> testAccounts = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            testAccounts.add(new Account(Name = 'Test Account ' + i, Rating = 'Hot'));
        }
        insert testAccounts;

        for (Account acc : [SELECT Rating FROM Account WHERE Id IN :testAccounts]) {
            System.assertEquals('Hot', acc.Rating);
        }

        Test.startTest();
        String jobId = System.schedule('Test ScheduleWeekly2dUpdateRatingWarm', '0 0 12 ? * MON,FRI *',new ScheduleWeekly2dUpdateRatingWarm());
        Test.stopTest();

        List<Account> updatedAccounts = [SELECT Rating FROM Account WHERE Id IN :testAccounts];
        for (Account acc : updatedAccounts) {
            System.assertEquals('Warm', acc.Rating);
        }
    }
}