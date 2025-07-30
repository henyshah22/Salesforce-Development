public class RelatedContactsController {
    @AuraEnabled
    public static List<Account> fetchAccount() {
        return [SELECT Id, Name FROM Account ORDER BY Name LIMIT 1000];
    }
    
    @AuraEnabled
    public static List<Contact> getContact(Id accid) {
        return [SELECT Id, Name, Phone, Email 
                FROM Contact 
                WHERE AccountId = :accid 
                ORDER BY Name 
                LIMIT 1000];
    }
}