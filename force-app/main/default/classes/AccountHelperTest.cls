@isTest
public class AccountHelperTest {
    @isTest
    static void AccountHelpertest() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Contact con = new Contact(FirstName = 'Test', LastName = 'TestContact', AccountId = acc.Id);
        insert con;

        Opportunity opp = new Opportunity(Name = 'TestOpportunity', StageName = 'Prospecting', CloseDate = Date.today().addDays(30), AccountId = acc.Id);
        insert opp;

        List<Account> accList = AccountHelper.getAccounts();

        Map<String, Object> result = AccountHelper.getRelatedData(acc.Id);
        List<Contact> contactList = (List<Contact>) result.get('contacts');
        List<Opportunity> oppList = (List<Opportunity>) result.get('opportunities');

        System.Assert.areEqual(1, contactList.size());
        System.Assert.areEqual(1, oppList.size());  
    }
}