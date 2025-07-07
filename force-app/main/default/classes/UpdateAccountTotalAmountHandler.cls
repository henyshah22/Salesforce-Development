public with sharing class UpdateAccountTotalAmountHandler {

    private List<Contact> newList;
    private List<Contact> oldList;
    private Map<Id, Contact> newMap;
    private Map<Id, Contact> oldMap;
    private Boolean isInsert;
    private Boolean isUpdate;
    private Boolean isDelete;

    public UpdateAccountTotalAmountHandler(List<Contact> newList, List<Contact> oldList, Map<Id, Contact> newMap, Map<Id, Contact> oldMap,Boolean isInsert, Boolean isUpdate, Boolean isDelete) {
        this.newList = newList;
        this.oldList = oldList;
        this.newMap = newMap;
        this.oldMap = oldMap;
        this.isInsert = isInsert;
        this.isUpdate = isUpdate;
        this.isDelete = isDelete;
    }

    public void handleAfterTrigger() {
        Set<Id> accountIds = new Set<Id>();
        if (isInsert || isUpdate) {
            for (Contact con : newList) {
                if (con.AccountId != null) {
                    accountIds.add(con.AccountId);
                }
            }
        }

        if (isUpdate || isDelete) {
            for (Contact con : oldList) {
                if (con.AccountId != null) {
                    accountIds.add(con.AccountId);
                }
            }
        }

        Map<Id, Decimal> accountTotals = new Map<Id, Decimal>();

        List<Contact> contacts = [
            SELECT Id, AccountId, Amount_Trigger__c
            FROM Contact
            WHERE AccountId IN :accountIds
        ];

        for (Contact con : contacts) {
            Decimal total = accountTotals.get(con.AccountId);
            if (total == null) {
                total = 0;
            }

            if (con.Amount_Trigger__c != null) {
                total += con.Amount_Trigger__c;
            }

            accountTotals.put(con.AccountId, total);
        }
        List<Account> accountsToUpdate = new List<Account>();
        for (Id accId : accountIds) {
            Decimal totalAmount = accountTotals.containsKey(accId) ? accountTotals.get(accId) : 0;
            accountsToUpdate.add(new Account(
                Id = accId,
                Total_Amount_Trigger__c = totalAmount
            ));
        }
            update accountsToUpdate;
    }
}
