@isTest
private class TestCreateEventOnContactCreate{
    @isTest
    static void TestCreateEventOnContactCreate(){
        Contact con = new Contact(FirstName = 'Heny',LastName = 'Shah');
        insert con;
        List<Event> events = [SELECT Subject, WhoId, StartDateTime, EndDateTime FROM Event WHERE WhoId =: con.ID ];
        System.Assert.areEqual(1, events.size());
    }
}