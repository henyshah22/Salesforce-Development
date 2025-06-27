trigger TheGreatProblem on Contact (before insert, before update, after insert, after update, after delete) {
    List<Contact> newContacts = new List<Contact>();
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        for (Contact c : Trigger.new) {
            if (c.AccountId != null && c.Great_Problem_Amount__c != null) {
                Account acc = [SELECT Id, Max_Amount__c FROM Account WHERE Id = :c.AccountId];
                if (acc != null && acc.Max_Amount__c != null) {
                    Decimal maxAllowed = acc.Max_Amount__c;
                    System.debug('maxAllowed: ' + maxAllowed);
                    Decimal enteredAmount = c.Great_Problem_Amount__c;
                    System.debug('enteredAmount: ' + enteredAmount);
                    if (enteredAmount > maxAllowed) {
                        c.Great_Problem_Amount__c = maxAllowed;
                        System.debug('Great_Problem_Amount__c: ' + c.Great_Problem_Amount__c);
                        Decimal remainingAmount = enteredAmount - maxAllowed;
                        System.debug('remainingAmount: ' + remainingAmount);
                        for (Integer i = 0; i < 100; i++) {
                            if (remainingAmount <= 0) break;
                            Contact con = new Contact();
                            con.LastName = c.LastName + '_Contact' + (i + 1);
                            con.AccountId = c.AccountId;
                            if (remainingAmount > maxAllowed) {
                                con.Great_Problem_Amount__c = maxAllowed;
                                System.debug('Great_Problem_Amount__c: ' + con.Great_Problem_Amount__c);
                                remainingAmount -= maxAllowed;
                                System.debug('remainingAmount: ' + remainingAmount);
                            } else {
                                con.Great_Problem_Amount__c = remainingAmount;
                                System.debug('Great_Problem_Amount__c: ' + con.Great_Problem_Amount__c);
                                remainingAmount = 0;
                            }
                            newContacts.add(con);
                        }
                    }
                }
            }
        }
    }
    insert newContacts;
}
