@isTest
private class TestPrefixAccountName {
    @isTest
    static void testPrefixAccountName() {
        Account acc = new Account(Name = 'Heny');
        insert acc;
        Account insertedAcc = [SELECT Name FROM Account WHERE Id = :acc.Id];
        System.assert(insertedAcc.Name.startsWith('Mr.'));
    }
}