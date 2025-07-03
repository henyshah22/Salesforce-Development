@isTest
private class TestSendEmailAccountNameChanged {
    @isTest
    static void testSendEmailAccountNameChanged() {
        Account acc = new Account();
    	acc.Name = 'testForAcc';
    	insert acc;
        contact con = new contact();
        con.LastName = 'TestContact';
        con.Email = 'test@test.com';
        con.AccountId = acc.Id;
        insert con;
        Test.startTest();
        acc.Name = 'testForAccUpdate';
        update acc;
        Test.stopTest();
        System.Assert.areEqual(1, Limits.getEmailInvocations());
    }
}