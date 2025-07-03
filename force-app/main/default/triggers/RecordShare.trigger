// trigger RecordShare on Account(after update) {
//     User userrecordshare = [SELECT Id, Name FROM User WHERE Name = 'SHAH HENY'];
//     List<AccountShare> shareList = new List<AccountShare>();
//     for (Account acc : Trigger.new) {
//         Account oldAcc = Trigger.oldMap.get(acc.Id);
//         if (acc.Rating == 'Hot' && oldAcc.Rating != 'Hot') {
//             AccountShare share = new AccountShare();
//             share.UserOrGroupId = userrecordshare.Id;
//             share.AccountId = acc.Id;
//             share.AccountAccessLevel = 'Edit';
//             share.OpportunityAccessLevel = 'None';
//             share.CaseAccessLevel = 'None';
//             share.RowCause = Schema.AccountShare.RowCause.Manual; 
//             shareList.add(share);
//         }
//     }
//     if (!shareList.isEmpty()) {
//         insert shareList;
//     }
// }

trigger RecordShare on Account (after update) { 
    }