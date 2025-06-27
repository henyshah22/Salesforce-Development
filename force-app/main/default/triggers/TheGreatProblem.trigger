trigger TheGreatProblem on Contact (before insert, before update, after delete) {
    List<Contact> newContacts = new List<Contact>();
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
                for (Contact c : Trigger.new) {
            if (c.AccountId != null && c.Great_Problem_Amount__c != null) {
                Account acc = [SELECT Id, Max_Amount__c FROM Account WHERE Id = :c.AccountId];
                if (acc != null && acc.Max_Amount__c != null) {
                    Decimal maxAllowed = acc.Max_Amount__c;
                    Decimal enteredAmount = c.Great_Problem_Amount__c;
                    if (enteredAmount > maxAllowed) {                        
                        Decimal remainingAmount = enteredAmount;
                        Integer i = 1;
                        while (remainingAmount > 0) {
                            Contact con = new Contact();
                            con.LastName = c.LastName + '_Contact' + i;
                            con.AccountId = c.AccountId;
                            if (remainingAmount > maxAllowed) {
                                con.Great_Problem_Amount__c = maxAllowed;
                                remainingAmount = remainingAmount - maxAllowed;
                            } else {
                                con.Great_Problem_Amount__c = remainingAmount;
                                remainingAmount = 0;
                            }
                            newContacts.add(con);
                            i++;
                        }
                    }
                }
            }
        }
    }
    insert newContacts;
}