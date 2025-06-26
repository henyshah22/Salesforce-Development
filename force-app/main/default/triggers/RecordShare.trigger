trigger RecordShare on Account(after update) {
    User userrecordshare = [SELECT Id, Name FROM User WHERE Name = 'SHAH HENY'];
    List<AccountShare> shareList = new List<AccountShare>();
    for (Account acc:trigger.new) {
        Account oldAcc = Trigger.oldMap.get(acc.ID);
        if (acc.Rating == 'Hot' && oldAcc.Rating != 'Hot') {
            AccountShare share = new AccountShare();
             share.UserOrGroupID = userrecordshare.Id;
             share.AccountId = acc.Id;
             share.AccountAccessLevel = 'Read';
             share.RowCause = Schema.AccountShare.RowCause.Manual;
             shareList.add(share);
        }
    }
        insert shareList;
}