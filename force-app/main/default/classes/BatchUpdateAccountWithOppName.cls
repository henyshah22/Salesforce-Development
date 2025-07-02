global class BatchUpdateAccountWithOppName implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, Name, AccountId, Account.Name 
            FROM Opportunity 
            WHERE AccountId != NULL
        ]);
    }
    global void execute(Database.BatchableContext bc, List<Opportunity> opportunityList) {
        Map<Id, String> accountToOppName = new Map<Id, String>();
        for (Opportunity opp : opportunityList) {
            accountToOppName.put(opp.AccountId, opp.Name);
        }
        List<Account> accountListToUpdate = new List<Account>();
        for(Id accId : accountToOppName.keySet()) {
            Account acc = new Account();
            acc.Id = accId;
            acc.Name = accountToOppName.get(accId);
            accountListToUpdate.add(acc);
        }
            update accountListToUpdate;
    }
    global void finish(Database.BatchableContext bc) {
    }
}