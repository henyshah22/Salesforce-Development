public with sharing class FilePreviewController {
    @AuraEnabled
    public static String getBase64ContentVersion(Id contentDocumentId) {
        ContentVersion cv = [
            SELECT VersionData
            FROM ContentVersion
            WHERE ContentDocumentId = :contentDocumentId
            ORDER BY CreatedDate DESC
            LIMIT 1
        ];
        return EncodingUtil.base64Encode(cv.VersionData);
    }
}
