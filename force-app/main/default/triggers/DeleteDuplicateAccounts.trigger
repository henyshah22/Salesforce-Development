trigger DeleteDuplicateAccounts on Account (before insert) {
    Set<String> accountNames = new Set<String>();
    for (Account acc : Trigger.new) {
        accountNames.add(acc.Name);
    }
    List<Account> accountsToDelete = [SELECT Id FROM Account WHERE Name IN :accountNames];
    if (!accountsToDelete.isEmpty()) {
        delete accountsToDelete;
    }
}