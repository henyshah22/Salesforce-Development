trigger NewAccountNewContactWsameName on Account (after insert) {
    if(Trigger.isAfter && Trigger.isInsert) {
        List<Contact> contacts = new List<Contact>();
        for(Account account : Trigger.new) {
            Contact newContact = new Contact(LastName=account.Name, AccountId=account.Id);
            contacts.add(newContact);
        }
        insert contacts;
    }
}