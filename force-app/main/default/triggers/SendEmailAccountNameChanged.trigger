trigger SendEmailAccountNameChanged on Account (after update) {
    if(Trigger.isAfter && Trigger.isUpdate){
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Set<Id> setAccountIds = new Set<Id>();
        List<String> sendTo = new List<String>();
        for(Account acc : trigger.New){
            if(acc.Name != trigger.oldmap.get(acc.Id).Name){
                setAccountIds.add(acc.Id);
                System.debug('setAccountIds:' + setAccountIds);
            }
        }
        if(setAccountIds.size() > 0) {
            for(Contact c : [SELECT lastname,Email FROM Contact WHERE AccountId IN:setAccountIds]){
                if(string.IsNotBlank(c.Email)){
                    sendTo.add(c.Email);
                }
            }
        }
        if(sendTo.size() > 0){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSenderDisplayName('Email Alert');
            mail.setSubject('Account Name changed');
            String body = 'Account Name is changed';
            mail.setToAddresses(sendTo);
            mail.setHtmlBody(body);
            mails.add(mail);
            try{
                Messaging.SendEmail(mails);
            }
            catch(Exception e){
                System.debug('-----Exception------' +e);        
            }
        }
    }
}