public with sharing class FileUploaderPreviewInChildComp {
    @AuraEnabled
    public static String uploadFile(String base64, String filename, String recordId) {
        ContentVersion cv = createContentVersion(base64, filename);
        if (cv == null) {
        return 'Error: ContentVersion insert failed';
    }

    ContentDocumentLink cdl = createContentLink(cv.Id, recordId);
    if (cdl == null) {
        return 'Error: ContentDocumentLink insert failed';
    }

    return cdl.Id;
}

    private static ContentVersion createContentVersion(String base64, String filename) {
        ContentVersion cv = new ContentVersion();
        cv.VersionData = EncodingUtil.base64Decode(base64);
        cv.Title = filename;
        cv.PathOnClient = filename;
        try {
            insert cv;
            return cv;
        } catch (DmlException e) {
            System.debug(e);
            return null;
        }
    }
    private static ContentDocumentLink createContentLink(Id contentVersionId, Id recordId) {
        Id contentDocumentId = [
            SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersionId LIMIT 1
        ].ContentDocumentId;

        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = contentDocumentId;
        cdl.LinkedEntityId = recordId;
        cdl.ShareType = 'V';
        cdl.Visibility = 'AllUsers';

        try {
            insert cdl;
            return cdl;
        } catch (DmlException e) {
            System.debug('CDL Error: ' + e.getMessage());
            return null;
        }
    }
}

