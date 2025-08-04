public with sharing class dragAndDrop {
    public class AccountWrapper {
        @AuraEnabled public String accountName;
        @AuraEnabled public Id accountId;
        @AuraEnabled public List<Contact> contactList;

        public AccountWrapper(String name, Id accId, List<Contact> contacts) {
            this.accountName = name;
            this.accountId = accId;
            this.contactList = contacts;
        }
    }

    @AuraEnabled
    public static List<AccountWrapper> getContactsForMatchingAccounts(String accountName) {
        List<AccountWrapper> wrapperList = new List<AccountWrapper>();

        if (String.isBlank(accountName)) {
            return wrapperList;
        }

        List<Account> matchedAccounts = [SELECT Id, Name FROM Account WHERE Name LIKE :('%' + accountName + '%') LIMIT 10];
        List<Contact> allContacts = [SELECT Id, Name, AccountId FROM Contact WHERE AccountId IN :matchedAccounts];

        for (Account acc : matchedAccounts) {
            List<Contact> contactsForThisAccount = new List<Contact>();

            for (Contact con : allContacts) {
                if (con.AccountId == acc.Id) {
                    contactsForThisAccount.add(con);
                }
            }

            AccountWrapper wrap = new AccountWrapper(acc.Name, acc.Id, contactsForThisAccount);
            wrapperList.add(wrap);
        }

        return wrapperList;
    }

    @AuraEnabled
    public static void updateContactAccount(Id contactId, Id newAccountId) {
        Contact con = [SELECT Id, AccountId FROM Contact WHERE Id = :contactId LIMIT 1];
        con.AccountId = newAccountId;
        update con;
    }
}