trigger UpdateAccountTotalAmount on Contact (after insert, after update, after delete) { 
    Set<Id> accountIds = new Set<Id>();
    if (Trigger.isInsert || Trigger.isUpdate) {
        for (Contact con : Trigger.new) {
            if (con.AccountId != null) {
                accountIds.add(con.AccountId);
            }
        }
    }

    if (Trigger.isUpdate || Trigger.isDelete) {
        for (Contact con : Trigger.old) {
            if (con.AccountId != null) {
                accountIds.add(con.AccountId);
            }
        }
    }

    Map<Id, Decimal> accountTotals = new Map<Id, Decimal>();

    List<AggregateResult> groupedResults = [
        SELECT AccountId, SUM(Amount_Trigger__c) totalAmount
        FROM Contact
        WHERE AccountId IN :accountIds
        GROUP BY AccountId
    ];

    for (AggregateResult result : groupedResults) {
        Id accId = (Id) result.get('AccountId');
        Decimal total = (Decimal) result.get('totalAmount');
        accountTotals.put(accId, total);
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
