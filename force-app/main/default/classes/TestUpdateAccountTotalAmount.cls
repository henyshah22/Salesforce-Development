@isTest
public class TestUpdateAccountTotalAmount {

    @isTest
    static void testUpdateAccountTotalAmount() {
        Account acc = new Account(Name = 'TestAccount');
        insert acc;
        Contact con1 = new Contact(LastName = 'TestContact1', AccountId = acc.Id, Amount_Trigger__c = 300);
        Contact con2 = new Contact(LastName = 'TestContact2', AccountId = acc.Id, Amount_Trigger__c = 200);
        insert new List<Contact>{con1, con2};
        acc = [SELECT Id, Total_Amount_Trigger__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(con1.Amount_Trigger__c + con2.Amount_Trigger__c, acc.Total_Amount_Trigger__c);

        con1.Amount_Trigger__c = 150;
        update con1;
        acc = [SELECT Id, Total_Amount_Trigger__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(con1.Amount_Trigger__c + con2.Amount_Trigger__c, acc.Total_Amount_Trigger__c);

        delete con2;
        acc = [SELECT Id, Total_Amount_Trigger__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(con1.Amount_Trigger__c, acc.Total_Amount_Trigger__c);

    }
}