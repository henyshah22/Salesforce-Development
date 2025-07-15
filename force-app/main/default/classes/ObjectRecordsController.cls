public with sharing class ObjectRecordsController {
    @AuraEnabled(cacheable=true)
    public static List<SObject> getRecords(String objectName) {
        if (objectName == 'Lead') {
            return [SELECT Id, Name, Email__c FROM Lead LIMIT 100];
        } else if (objectName == 'Account') {
            return [SELECT Id, Name, Email__c FROM Account LIMIT 100];
        } else if (objectName == 'Contact') {
            return [SELECT Id, Name, Email FROM Contact LIMIT 100];
        }
        return new List<SObject>();
    }
    
    @AuraEnabled
    public static void sendEmail(List<String> emailAddresses, String subject, String body) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        for (String emailAddr : emailAddresses) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new List<String>{emailAddr});
            mail.setSubject(subject);
            mail.setHtmlBody(body);
            emails.add(mail);
        }
        Messaging.sendEmail(emails);
    }
}