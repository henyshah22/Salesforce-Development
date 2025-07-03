@isTest
private class TestRecordShare {
    @isTest
    static void testRecordShare() {
        Profile prof = [SELECT Id FROM Profile WHERE Name = 'Standard User'];

        User testuser = new User(
            Alias = 'shahy',
            Email = 'shahheny' + System.currentTimeMillis() + '@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'HENY',   
            FirstName = 'SHAH',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = prof.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'shahheny' + System.currentTimeMillis() + '@testorg.com'
        );
        insert testuser;

        Account acc = new Account(Name = 'Test Record Share', Rating = 'Warm');
        insert acc;

        acc.Rating = 'Hot';
        update acc;

        List<AccountShare> shares = [SELECT Id, UserOrGroupId, AccountAccessLevel, RowCause FROM AccountShare WHERE AccountId = :acc.Id AND RowCause = :Schema.AccountShare.RowCause.Manual];
        System.Assert.areEqual(1, shares.size());

    }
}
