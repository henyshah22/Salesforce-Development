public with sharing class AccountHelper {

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        return [SELECT Id, Name FROM Account LIMIT 100];
    }

    @AuraEnabled
    public static Map<String, Object> getRelatedData(Id accountId) {
        Map<String, Object> result = new Map<String, Object>();

        List<Contact> contacts = [SELECT Id, Name, Email FROM Contact WHERE AccountId = :accountId];
        List<Opportunity> opportunities = [SELECT Id, Name, StageName FROM Opportunity WHERE AccountId = :accountId];

        result.put('contacts', contacts);
        result.put('opportunities', opportunities);
        return result;
    }
}
