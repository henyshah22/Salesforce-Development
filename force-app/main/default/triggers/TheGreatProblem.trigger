trigger TheGreatProblem on CONTACT (before insert) {
    Set<Id> accountIds = new Set<Id>();
    for (Contact c : Trigger.new) {
        if (c.AccountId != null) {
            accountIds.add(c.AccountId);
        }
    }
    Map<Id, Decimal> maxAmountMap = new Map<Id, Decimal>();
    for (Account acc : [SELECT Id, Max_Amount__c FROM Account WHERE Id IN :accountIds]) {
        maxAmountMap.put(acc.Id, acc.Max_Amount__c);
    }
}