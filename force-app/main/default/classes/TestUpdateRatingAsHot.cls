@isTest
private class TestUpdateRatingAsHot {
    @isTest
    static void testsUpdateRatingAsHot() {
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company'
        );
        insert testLead;
        Lead actualLead = [SELECT Rating FROM Lead WHERE Id =: testLead.Id];
        System.Assert.areEqual('Hot', actualLead.Rating);
    }
}