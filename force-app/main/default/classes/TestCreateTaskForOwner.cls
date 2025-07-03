@isTest
private class TestCreateTaskForOwner {
    @isTest
    static void testCreateTaskForOwner() {
        Account acc = new Account(Name = 'CreateTaskForOwnerAcc');
        insert acc;

        Opportunity opp = new Opportunity(
            Name = 'CreateTaskForOwnerOpp',
            CloseDate = Date.today().addDays(30),
            StageName = 'Prospecting',
            AccountId = acc.Id,
            OwnerId = UserInfo.getUserId()
        );
        insert opp;
        opp.Name = 'New Opp';
        update opp;

        Task taskRelatedToOpp = [SELECT Subject, Description, WhatId, OwnerId FROM Task WHERE WhatId = :opp.Id];
        System.assertEquals('Opportunity Name Changed', taskRelatedToOpp.Subject);
        System.assertEquals('This Opportunity\'s name has changed to ' + opp.Name, taskRelatedToOpp.Description);
        System.Assert.areEqual(opp.Id, taskRelatedToOpp.WhatId);
        System.Assert.areEqual(opp.OwnerId, taskRelatedToOpp.OwnerId);
    }
}