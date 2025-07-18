@isTest
public class dropBoxMockTest {
    public class DropboxMockResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            if (req.getEndpoint().contains('upload')) {
                res.setStatusCode(200);
                res.setBody('{}');
            } else if (req.getEndpoint().contains('delete_v2')) {
                res.setStatusCode(200);
                res.setBody('{}');
            } else if (req.getEndpoint().contains('list_folder')) {
                res.setStatusCode(200);
                res.setBody('{"entries":[{"name":"testFile.txt",".tag":"file"}]}');
            } else {
                res.setStatusCode(400);
                res.setBody('{"error":"Unknown callout"}');
            }
            return res;
        }
    }

    @isTest
    static void testDropbox() {
        Test.setMock(HttpCalloutMock.class, new DropboxMockResponse());

        Contact c = new Contact(FirstName = 'Test', LastName = 'User');
        insert c;

        String contactId = c.Id;
        String fileName = 'testFile.txt';
        String fileBody = EncodingUtil.base64Encode(Blob.valueOf('Sample file'));

        Test.startTest();
        dropBox.uploadFile(contactId, fileName, fileBody);
        dropBox.deleteFile(contactId, fileName);
        List<String> files = dropBox.listFiles(contactId);
        Test.stopTest();

        System.AssertNotEquals(null, files);
        System.AssertEquals(1, files.size());
        System.AssertEquals('testFile.txt', files[0]);
    }
}
