@isTest
public class GlobalRecordSearchControllerTest {
    @isTest
    static void testSearchRecords() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Contact con = new Contact(FirstName = 'Test', LastName = 'Contact');
        insert con;

        Opportunity opp = new Opportunity(Name = 'Test Opportunity', StageName = 'Prospecting', CloseDate = Date.today().addDays(10));
        insert opp;

        List<String> objects = new List<String>{'Account', 'Contact', 'Opportunity'};
        List<GlobalRecordSearchController.ObjectWrapper> results = GlobalRecordSearchController.searchRecords('Test', objects);

        System.assert(!results.isEmpty());
    }
}
