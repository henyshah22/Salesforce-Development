@isTest
public class GlobalRecordSearchControllerTest {
    @isTest
    static void testSearchRecords() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Contact con = new Contact(FirstName = 'Test', LastName = 'Contact');
        insert con;

        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(10)
        );
        insert opp;

        List<Id> fixedSearchResults = new List<Id>{acc.Id, con.Id, opp.Id};
        Test.setFixedSearchResults(fixedSearchResults);

        List<String> objects = new List<String>{'Account', 'Contact', 'Opportunity'};

        Test.startTest();
        List<GlobalRecordSearchController.ObjectWrapper> results =
            GlobalRecordSearchController.searchRecords('Test', objects);
        Test.stopTest();

        System.debug('Results size: ' + results.size());
        for (GlobalRecordSearchController.ObjectWrapper wrapper : results) {
        }

        System.assertNotEquals(0, results.size());
        System.assertEquals(3, results.size());
        for (GlobalRecordSearchController.ObjectWrapper wrapper : results) {
            System.assert(wrapper.Name.contains('Test'));
            System.assert(new Set<String>{'Account', 'Contact', 'Opportunity'}.contains(wrapper.Type));
        }
    }
}