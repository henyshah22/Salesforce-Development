global class BatchUpdateAccountWithOppName implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, Name, AccountId, Account.Name 
            FROM Opportunity 
            WHERE AccountId != NULL
        ]);
    }
    global void execute(Database.BatchableContext bc, List<Opportunity> oppList) {
        Map<Id, String> accountIdToOppName = new Map<Id, String>();

        for (Opportunity opp : oppList) {
            accountIdToOppName.put(opp.AccountId, opp.Name);
        }
        List<Account> accountsToUpdate = new List<Account>();
        for (Id accId : accountIdToOppName.keySet()) {
            accountsToUpdate.add(new Account(
                Id = accId,
                Name = accountIdToOppName.get(accId)
            ));
        }
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
    global void finish(Database.BatchableContext bc) {
    }
}
