trigger UpdateAccountTotalAmount on Contact (after insert, after update, after delete, after undelete) {
    Set<Id> accountIds = new Set<Id>();

    if (Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete) {
        for (Contact c : Trigger.new) {
            if (c.AccountId != null) {
                accountIds.add(c.AccountId);
            }
        }
    }

    if (Trigger.isDelete || Trigger.isUpdate) {
        for (Contact c : Trigger.old) {
            if (c.AccountId != null) {
                accountIds.add(c.AccountId);
            }
        }
    }

    Map<Id, Decimal> accountTotals = new Map<Id, Decimal>();
    for (AggregateResult ar : [
        SELECT AccountId, SUM(Amount_Trigger__c) totalAmount
        FROM Contact
        WHERE AccountId IN :accountIds
        GROUP BY AccountId
    ]) {
        accountTotals.put((Id)ar.get('AccountId'), (Decimal)ar.get('totalAmount'));
    }

    List<Account> accountsToUpdate = new List<Account>();
    for (Id accId : accountIds) {
        Decimal total = accountTotals.containsKey(accId) ? accountTotals.get(accId) : 0;
        accountsToUpdate.add(new Account(
            Id = accId,
            Total_Amount_Trigger__c = total
        ));
    }

    if (!accountsToUpdate.isEmpty()) {
        update accountsToUpdate;
    }
}