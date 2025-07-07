@isTest
public class TestUpdateContactsWithAccountName {

    @isTest
    static void testUpdateContactsWithAccountName() {
        Account account1 = new Account(Name = 'Account1');
        Account account2 = new Account(Name = 'Account2');
        insert new List<Account>{account1, account2};

        Contact contact1 = new Contact(LastName = 'Contact1', AccountId = account1.Id);
        Contact contact2 = new Contact(LastName = 'Contact2', AccountId = account1.Id);
        Contact contact3 = new Contact(LastName = 'Contact3', AccountId = account2.Id);
        insert new List<Contact>{contact1, contact2, contact3};

        contact1.AccountId = account2.Id;
        contact2.AccountId = account2.Id;
        contact3.AccountId = account1.Id;
        update new List<Contact>{contact1, contact2, contact3};

        List<Contact> updatedContacts = [SELECT Id, AccountId FROM Contact WHERE Id IN :new List<Id>{contact1.Id, contact2.Id, contact3.Id}];
        System.assertEquals(3, updatedContacts.size());
        }
}