trigger UpdateContactsWithAccountName on Contact (after update) {
    Map<Id, Id> contactToOldAccountMap = new Map<Id, Id>();
    
    for (Integer i = 0; i < Trigger.new.size(); i++) {
        Contact newC = Trigger.new[i];
        Contact oldC = Trigger.old[i];

        if (newC.AccountId != oldC.AccountId) {
            contactToOldAccountMap.put(newC.Id, oldC.AccountId);
        }
    }

    if (contactToOldAccountMap.isEmpty()) return;

    List<Contact> contactsToUpdate = new List<Contact>();

    for (Contact updatedContact : Trigger.new) {
        Id oldAccountId = contactToOldAccountMap.get(updatedContact.Id);
        if (oldAccountId == null) continue;

        List<Contact> relatedContacts = [
            SELECT Id, AccountId
            FROM Contact
            WHERE AccountId = :oldAccountId AND Id != :updatedContact.Id
        ];

        for (Contact related : relatedContacts) {
            related.AccountId = updatedContact.AccountId;
            contactsToUpdate.add(related);
        }
    }
        update contactsToUpdate;
}
