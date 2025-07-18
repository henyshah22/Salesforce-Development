@isTest
private class sendEmailActionMockTest {
    @isTest
    static void testSendEmail() {
        Test.setMock(HttpCalloutMock.class, new GmailMock());

        String toEmail = 'test@example.com';
        String subject = 'Test Subject';
        String body = 'This is a test email.';
        List<Map<String, String>> attachments = new List<Map<String, String>>{
            new Map<String, String>{
                'name' => 'test.txt',
                'content' => EncodingUtil.base64Encode(Blob.valueOf('Test content'))
            }
        };

        Test.startTest();
        String result = sendEmailAction.sendEmail(toEmail, subject, body, attachments);
        Test.stopTest();

        System.Assert.areEqual('success', result);
    }

    class GmailMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"id": "12345", "threadId": "67890"}');
            res.setStatusCode(200);
            return res;
        }
    }
}