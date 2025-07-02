public class AddRandomFile {
    @future(callout=true)
    public static void attachRandomImage(Id oppId) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.unsplash.com/photos/random');
        req.setMethod('GET');
        req.setHeader('Authorization', 'Client-ID CGrWbOvkGxFtL00EiAA4eHtU35RBv_UclgvHaFaH6bw');

        try {
            HttpResponse res = http.send(req);
            if (res.getStatusCode() == 200) {
                Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                System.debug('result' + result);
                Map<String, Object> urls = (Map<String, Object>) result.get('urls');
                System.debug('urls' + urls);
                String imageUrl = (String) urls.get('regular');
                System.debug('imageUrl' + imageUrl);

                HttpRequest imgReq = new HttpRequest();
                imgReq.setEndpoint(imageUrl);
                imgReq.setMethod('GET');
                System.debug('imageUrl' + imageUrl);
                HttpResponse imgRes = http.send(imgReq);
                System.debug('image res' + imgRes.getStatusCode());

                if (imgRes.getStatusCode() == 200) {
                    Blob imgBlob = imgRes.getBodyAsBlob();
                    System.debug('imgBlob' + imgBlob.size());

                    ContentVersion cv = new ContentVersion();
                    cv.Title = 'RandomImage';
                    cv.PathOnClient = 'RandomImage.jpg';
                    cv.VersionData = imgBlob;
                    insert cv;
                    System.debug('cv.Id' + cv.Id);

                    cv = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
                    System.debug('cv.ContentDocumentId' + cv.ContentDocumentId);

                    ContentDocumentLink cdl = new ContentDocumentLink();
                    cdl.ContentDocumentId = cv.ContentDocumentId;
                    cdl.LinkedEntityId = oppId;
                    cdl.ShareType = 'V';
                    cdl.Visibility = 'AllUsers';
                    insert cdl;
                    System.debug('cdl.LinkedEntityId' + cdl.LinkedEntityId);
                }
            }
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
        }
    }
}