public with sharing class UpdateContactsWithAccountNameHandler {

    private List<Contact> newList;
    private List<Contact> oldList;
    private Map<Id, Contact> newMap;
    private Map<Id, Contact> oldMap;
    private Boolean isInsert;
    private Boolean isUpdate;
    private Boolean isDelete;

    private static Boolean hasAlreadyRun = false;

    public UpdateContactsWithAccountNameHandler(List<Contact> newList, List<Contact> oldList, Map<Id, Contact> newMap, Map<Id, Contact> oldMap,Boolean isInsert, Boolean isUpdate, Boolean isDelete) {
        this.newList = newList;
        this.oldList = oldList;
        this.newMap = newMap;
        this.oldMap = oldMap;
        this.isInsert = isInsert;
        this.isUpdate = isUpdate;
        this.isDelete = isDelete;
    }

    public void handleAfterUpdate() {
        if (hasAlreadyRun) {
            return;
        }
        hasAlreadyRun = true;

        Map<Id, Id> oldAccountMap = new Map<Id, Id>();

        for (Integer i = 0; i < newList.size(); i++) {
            Contact newCon = newList[i];
            Contact oldCon = oldList[i];

            if (newCon.AccountId != oldCon.AccountId) {
                oldAccountMap.put(newCon.Id, oldCon.AccountId);
            }
        }

        if (oldAccountMap.isEmpty()) {
            return;
        }

        List<Contact> contactsToUpdate = new List<Contact>();

        for (Contact con : newList) {
            Id oldAccId = oldAccountMap.get(con.Id);

            if (oldAccId == null) {
                continue;
            }

            List<Contact> otherContacts = [
                SELECT Id, AccountId
                FROM Contact
                WHERE AccountId = :oldAccId AND Id != :con.Id
            ];

            for (Contact otherCon : otherContacts) {
                otherCon.AccountId = con.AccountId;
                contactsToUpdate.add(otherCon);
            }
        }
            update contactsToUpdate;
    }
}
