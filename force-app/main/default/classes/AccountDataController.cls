public class AccountDataController {

    public class AccountWrapper {
        @AuraEnabled public Account acc { get; set; }
        @AuraEnabled public List<Contact> contacts { get; set; }
        @AuraEnabled public List<Opportunity> opportunities { get; set; }
    }

    @AuraEnabled(cacheable=true)
    public static List<AccountWrapper> getAccountData() {
        List<AccountWrapper> wrapperList = new List<AccountWrapper>();

        List<Account> accList = [SELECT Id, Name FROM Account LIMIT 100];

        for (Account acc : accList) {
            AccountWrapper wrap = new AccountWrapper();
            wrap.acc = acc;

            wrap.contacts = [SELECT Id, Name, Email, Phone FROM Contact WHERE AccountId = :acc.Id];

            wrap.opportunities = [SELECT Id, Name, StageName, Amount FROM Opportunity WHERE AccountId = :acc.Id];

            wrapperList.add(wrap);
        }

        return wrapperList;
    }
}