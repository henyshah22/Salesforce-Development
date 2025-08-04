public with sharing class dragAndDrop {
    @AuraEnabled
    public static Map<String, Object> getContactsForAccount(String accountName) {
        Map<String, Object> result = new Map<String, Object>();

        if (String.isBlank(accountName)) {
            result.put('contacts', new List<Contact>());
            result.put('count', 0);
            return result;
        }

        List<Account> accounts = [SELECT Id FROM Account WHERE Name = :accountName LIMIT 1];
        if (!accounts.isEmpty()) {
            Id accountId = accounts[0].Id;

            List<Contact> contacts = [SELECT Id, Name FROM Contact WHERE AccountId = :accountId];

            AggregateResult[] countResult = [SELECT COUNT(Id) contactCount FROM Contact WHERE AccountId = :accountId];
            Integer count = (Integer) countResult[0].get('contactCount');

            result.put('contacts', contacts);
            result.put('count', count);
        } else {
            result.put('contacts', new List<Contact>());
            result.put('count', 0);
        }
        return result;
    }
    
    @AuraEnabled
    public static void updateContactAccount(Id contactId, String newAccountName) {
        Account targetAccount = [SELECT Id FROM Account WHERE Name = :newAccountName LIMIT 1];
        Contact contact = [SELECT Id, AccountId FROM Contact WHERE Id = :contactId];
        contact.AccountId = targetAccount.Id;
        update contact;
    }
}