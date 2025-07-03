// trigger DeleteDuplicateAccounts on Account (before insert) {
//     Set<String> accountNames = new Set<String>();
//     for (Account acc : Trigger.new) {
//         accountNames.add(acc.Name);
//     }
//     List<Account> accountsDelete = [SELECT Id FROM Account WHERE Name IN :accountNames];
//         delete accountsDelete;
// }

trigger DeleteDuplicateAccounts on Account (after delete) {

}