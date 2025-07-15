@isTest
public class AttachmentControllerTest {
    @isTest
    static void testAttachmentController() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        
        ContentVersion CV = new ContentVersion();
        CV.Title = 'Test Document';
        CV.PathOnClient = 'TestDocument.pdf';
        CV.VersionData = Blob.valueOf('Test Content');
        insert CV;
        
        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: CV.Id].ContentDocumentId;

        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = conDocId;
        cdl.LinkedEntityId = acc.Id;
        cdl.ShareType = 'V';
        insert cdl;

        List<ContentVersion> list1 = AttachmentController.retrieveFilesPaginated(acc.Id, 5, 0);
        System.assertEquals(1, list1.size());

        Integer count = AttachmentController.getTotalFileCount(acc.Id);
        System.assertEquals(1, count);

        List<ContentVersion> list2 = AttachmentController.retrieveFiles(acc.Id);
        System.assertEquals(1, list2.size());
    }
}