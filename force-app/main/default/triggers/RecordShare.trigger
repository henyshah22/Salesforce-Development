trigger RecordShare on Account(after update) {
    List<AccountShare> shareList = new List<AccountShare>();
    for (Account acc:trigger.new) {
        Account oldAcc = Trigger.oldMap.get(acc.ID);
        if (acc.Rating == 'Hot' && oldAcc.Rating != 'Hot') {
            AccountShare share = new AccountShare();
             share.UserOrGroupID = '005gK000003ETQDQA4';
             share.AccountId = acc.Id;
             share.AccountAccessLevel = 'Read';
             share.OpportunityAccessLevel = 'Read';
             share.RowCause = Schema.AccountShare.RowCause.Manual;
             shareList.add(share);
        }
    }
    if (!shareList.isEmpty()) {
        insert shareList;
    }
}