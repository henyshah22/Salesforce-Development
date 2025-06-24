trigger ContactDeletedCorrAccDeleted on Contact (after delete) {
    List<Id> accId = new List<Id>();
    for(Contact c : Trigger.old){
        accId.add(c.AccountId);
    }
    List<Account> accdelete = [select Id from Account where Id IN :accId];
    if(accdelete.size() > 0){
        delete accdelete;
    }
}