trigger SendEmailAccountNameChanged on Account (after update) {
    if (Trigger.isAfter && Trigger.isUpdate) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        Set<Id> accountIds = new Set<Id>();

        for (Account acc : Trigger.new) {
            if (acc.Name != Trigger.oldMap.get(acc.Id).Name) {
                accountIds.add(acc.Id);
            }
        }

        if (!accountIds.isEmpty()) {
            List<Contact> contacts = [SELECT Id, Email, Account.Name FROM Contact WHERE AccountId IN :accountIds];

            for (Contact con : contacts) {
                if (con.Email != null) {
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setSubject('Account Name Changed - ' + con.Account.Name);
                    mail.setPlainTextBody('The name of your related account, ' + con.Account.Name + ', has been changed.');
                    mail.setToAddresses(new List<String>{con.Email});
                    emails.add(mail);
                }
            }

            if (!emails.isEmpty()) {
                Messaging.sendEmail(emails);
            }
        }
    }
}