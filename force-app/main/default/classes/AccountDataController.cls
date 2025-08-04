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
        Set<Id> accIds = new Set<Id>();
        for (Account acc : accList) {
            accIds.add(acc.Id);
        }
        Map<Id, List<Contact>> accContactsMap = new Map<Id, List<Contact>>();
        List<Contact> contactList = [SELECT Id, Name, Email, Phone, AccountId FROM Contact WHERE AccountId IN :accIds];
        for (Contact con : contactList) {
            if (!accContactsMap.containsKey(con.AccountId)) {
                accContactsMap.put(con.AccountId, new List<Contact>());
            }
            accContactsMap.get(con.AccountId).add(con);
        }
        Map<Id, List<Opportunity>> accOppsMap = new Map<Id, List<Opportunity>>();
        List<Opportunity> oppList = [SELECT Id, Name, StageName, Amount, AccountId FROM Opportunity WHERE AccountId IN :accIds];
        for (Opportunity opp : oppList) {
            if (!accOppsMap.containsKey(opp.AccountId)) {
                accOppsMap.put(opp.AccountId, new List<Opportunity>());
            }
            accOppsMap.get(opp.AccountId).add(opp);
        }
        for (Account acc : accList) {
            AccountWrapper wrap = new AccountWrapper();
            wrap.acc = acc;
            wrap.contacts = accContactsMap.containsKey(acc.Id) ? accContactsMap.get(acc.Id) : new List<Contact>();
            wrap.opportunities = accOppsMap.containsKey(acc.Id) ? accOppsMap.get(acc.Id) : new List<Opportunity>();
            wrapperList.add(wrap);
        }
        return wrapperList;
    }
}