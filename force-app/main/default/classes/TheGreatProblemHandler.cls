public with sharing class TheGreatProblemHandler {

    private List<Contact> newList;
    private List<Contact> oldList;
    private Map<Id, Contact> newMap;
    private Map<Id, Contact> oldMap;
    private Boolean isInsert;
    private Boolean isUpdate;
    private Boolean isDelete;
    private Boolean isAfter;
    private Boolean isBefore;

    public TheGreatProblemHandler(List<Contact> newList, List<Contact> oldList, Map<Id, Contact> newMap, Map<Id, Contact> oldMap, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isAfter, Boolean isBefore) {
        this.newList = newList;
        this.oldList = oldList;
        this.newMap = newMap;
        this.oldMap = oldMap;
        this.isInsert = isInsert;
        this.isUpdate = isUpdate;
        this.isDelete = isDelete;
        this.isAfter = isAfter;
        this.isBefore = isBefore;
    }

    public void handleBeforeInsertOrUpdate() {
        List<Contact> newContacts = new List<Contact>();

        Set<Id> accountIds = new Set<Id>();
        for (Contact c : newList) {
            if (c.AccountId != null && c.Great_Problem_Amount__c != null) {
                accountIds.add(c.AccountId);
            }
        }

        Map<Id, Account> accMap = new Map<Id, Account>(
            [SELECT Id, Max_Amount__c FROM Account WHERE Id IN :accountIds]
        );

        for (Contact c : newList) {
            if (c.AccountId != null && c.Great_Problem_Amount__c != null) {
                Account acc = accMap.get(c.AccountId);
                if (acc != null && acc.Max_Amount__c != null) {
                    Decimal maxAllowed = acc.Max_Amount__c;
                    Decimal enteredAmount = c.Great_Problem_Amount__c;
                    if (enteredAmount > maxAllowed) {
                        c.Great_Problem_Amount__c = maxAllowed;
                        Decimal remainingAmount = enteredAmount - maxAllowed;
                        for (Integer i = 0; i < 100; i++) {
                            if (remainingAmount <= 0) break;
                            Contact con = new Contact();
                            con.LastName = c.LastName + '_Contact' + (i + 1);
                            con.AccountId = c.AccountId;
                            if (remainingAmount > maxAllowed) {
                                con.Great_Problem_Amount__c = maxAllowed;
                                remainingAmount -= maxAllowed;
                            } else {
                                con.Great_Problem_Amount__c = remainingAmount;
                                remainingAmount = 0;
                            }
                            newContacts.add(con);
                        }
                    }
                }
            }
        }
            insert newContacts;
    }
}
