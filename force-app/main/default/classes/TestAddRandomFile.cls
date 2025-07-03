@IsTest
public class TestAddRandomFile {

    public class SimpleCalloutMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            if (req.getEndpoint().contains('api.unsplash.com/photos/random')) {
                res.setStatusCode(200);
                res.setBody('{"urls":{"regular":"https://images.unsplash.com/photo-1234567890abcdef"}}');
            } else if (req.getEndpoint().startsWith('https://images.unsplash.com/photo-1234567890abcdef')) {
                res.setStatusCode(200);
                res.setBodyAsBlob(Blob.valueOf('dummy image data'));
            } else {
                res.setStatusCode(404);
                res.setBody('Not Found');
            }
            return res;
        }
    }

    @IsTest
    static void testFutureMethod() {
        Opportunity opp = new Opportunity(Name='Test Opp', CloseDate=Date.today().addDays(10), StageName='Prospecting');
        insert opp;

        Test.setMock(HttpCalloutMock.class, new SimpleCalloutMock());

        Test.startTest();
        AddRandomFile.attachRandomImage(opp.Id);
        Test.stopTest();

        List<ContentDocumentLink> links = [SELECT Id, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId = :opp.Id];
        System.assert(links.size() > 0, 'ContentDocumentLink should be created and linked to Opportunity');
    }

    @IsTest
    static void testVFExtension() {
        Opportunity opp = new Opportunity(Name='Test Opp VF', CloseDate=Date.today().addDays(10), StageName='Prospecting');
        insert opp;

        Test.setMock(HttpCalloutMock.class, new SimpleCalloutMock());

        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        AddRandomFileVF controller = new AddRandomFileVF(sc);
        controller.addRandomFile();
        Test.stopTest();

        List<ContentDocumentLink> links = [SELECT Id, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId = :opp.Id];
        System.assert(links.size() > 0, 'ContentDocumentLink should be created from VF extension');
    }
}
