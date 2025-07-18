public with sharing class dropBox {
    @AuraEnabled
    public static void uploadFile(String contactId, String fileName, String base64Body) {
        try {
            String path = '/SalesforceContacts/' + contactId + '/' + fileName;
            Blob fileBlob = EncodingUtil.base64Decode(base64Body);

            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:Dropbox_Content/files/upload'); 
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/octet-stream');
            req.setHeader('Dropbox-API-Arg', JSON.serialize(new Map<String, Object>{
                'path' => path,
                'mode' => 'add',
                'autorename' => true,
                'mute' => false
            }));
            req.setBodyAsBlob(fileBlob);

            Http http = new Http();
            HttpResponse res = http.send(req);
            if (res.getStatusCode() != 200) {
                throw new AuraHandledException('Upload failed: Status ' + res.getStatusCode() + ' - ' + res.getBody());
            }
        } catch (Exception e) {
            throw new AuraHandledException('Upload error: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static void deleteFile(String contactId, String fileName) {
        try {
            String path = '/SalesforceContacts/' + contactId + '/' + fileName;

            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:Dropbox_API/files/delete_v2'); 
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setBody(JSON.serialize(new Map<String, String>{
                'path' => path
            }));

            Http http = new Http();
            HttpResponse res = http.send(req);
            if (res.getStatusCode() != 200) {
                throw new AuraHandledException('Delete failed: Status ' + res.getStatusCode() + ' - ' + res.getBody());
            }
        } catch (Exception e) {
            throw new AuraHandledException('Delete error: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static List<String> listFiles(String contactId) {
        try {
            String path = '/SalesforceContacts/' + contactId;

            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:Dropbox_API/files/list_folder');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setBody(JSON.serialize(new Map<String, Object>{
                'path' => path,
                'recursive' => false
            }));

            Http http = new Http();
            HttpResponse res = http.send(req);
            if (res.getStatusCode() != 200) {
                throw new AuraHandledException('List files failed: Status ' + res.getStatusCode() + ' - ' + res.getBody());
            }

            Map<String, Object> response = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            List<Object> entries = (List<Object>) response.get('entries');
            List<String> fileNames = new List<String>();
            for (Object entry : entries) {
                Map<String, Object> file = (Map<String, Object>) entry;
                if (file.get('.tag') == 'file') {
                    fileNames.add((String) file.get('name'));
                }
            }
            return fileNames;
        } catch (Exception e) {
            throw new AuraHandledException('List files error: ' + e.getMessage());
        }
    }
}