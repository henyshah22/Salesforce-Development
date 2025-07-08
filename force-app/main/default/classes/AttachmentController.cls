public with sharing class AttachmentController {

    @AuraEnabled
    public static List<ContentVersion> retrieveFilesPaginated(String recordId, Integer pageSize, Integer offsetVal) {
        List<ContentDocumentLink> cdlList = [
            SELECT ContentDocumentId  
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :recordId
        ];

        List<Id> cdIds = new List<Id>();
        for (ContentDocumentLink obj : cdlList) {
            cdIds.add(obj.ContentDocumentId);
        }

        if (cdIds.isEmpty()) return new List<ContentVersion>();

        return [
            SELECT Id, ContentDocumentId, ContentUrl, VersionNumber, Title, 
                   PathOnClient, FileType, FileExtension, ContentSize, CreatedDate
            FROM ContentVersion 
            WHERE ContentDocumentId IN :cdIds
            ORDER BY CreatedDate DESC
            LIMIT :pageSize
            OFFSET :offsetVal
        ];
    }

    @AuraEnabled
    public static Integer getTotalFileCount(String recordId) {
        return [
            SELECT COUNT() 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :recordId
        ];
    }

    @AuraEnabled
    public static List<ContentVersion> retrieveFiles(String recordId) {
        List<ContentDocumentLink> cdlList = [
            SELECT ContentDocumentId  
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :recordId
        ];

        List<Id> cdIds = new List<Id>();
        for (ContentDocumentLink obj : cdlList) {
            cdIds.add(obj.ContentDocumentId);
        }

        return [
            SELECT Id, ContentDocumentId, ContentUrl, VersionNumber, Title, 
                   PathOnClient, FileType, FileExtension, ContentSize, CreatedDate
            FROM ContentVersion 
            WHERE ContentDocumentId IN :cdIds
        ];
    }
}
