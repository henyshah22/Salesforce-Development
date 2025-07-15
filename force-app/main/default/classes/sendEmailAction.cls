public with sharing class sendEmailAction {
    @AuraEnabled
    public static String sendEmail(String toEmail, String subject, String body, List<Map<String, String>> attachments) {
        if (String.isBlank(toEmail)) throw new AuraHandledException('To Email is required.');

        String boundary = 'boundary_' + DateTime.now().getTime();
        String message = 'To: ' + toEmail + '\r\n' +
                         'Subject: ' + subject + '\r\n' +
                         'MIME-Version: 1.0\r\n' +
                         'Content-Type: multipart/mixed; boundary="' + boundary + '"\r\n\r\n' +
                         '--' + boundary + '\r\n' +
                         'Content-Type: text/html; charset="UTF-8"\r\n\r\n' +
                         body + '\r\n';

        if (attachments != null && !attachments.isEmpty()) {
            for (Map<String, String> file : attachments) {
                String name = file.get('name');
                String content = file.get('content');
                message += '--' + boundary + '\r\n' +
                           'Content-Type: application/octet-stream; name="' + name + '"\r\n' +
                           'Content-Transfer-Encoding: base64\r\n' +
                           'Content-Disposition: attachment; filename="' + name + '"\r\n\r\n' +
                           content + '\r\n';
            }
        }

        message += '--' + boundary + '--';

        String base64Message = EncodingUtil.base64Encode(Blob.valueOf(message));
        base64Message = base64Message.replace('+', '-').replace('/', '_');
        while (base64Message.endsWith('=')) {
            base64Message = base64Message.substring(0, base64Message.length() - 1);
        }

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Gmail_NC/gmail/v1/users/me/messages/send');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(JSON.serialize(new Map<String, String>{ 'raw' => base64Message }));

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() != 200) {
            throw new AuraHandledException('Gmail API error: ' + res.getBody());
        }

        return 'Email sent';
    }
}
