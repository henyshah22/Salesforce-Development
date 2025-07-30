@RestResource(urlMapping='/api/Account/*')
global with sharing class MyFirstRestAPIClass {

    @HttpGet
    global static Account doGet() {
        RestRequest req = RestContext.request;
        String recordId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);
        List<Account> result = [SELECT Id, Name, Phone, Website FROM Account WHERE Id = :recordId LIMIT 1];
        if (!result.isEmpty()) {
            return result[0];
        } else {
            RestContext.response.statusCode = 404;
            RestContext.response.responseBody = Blob.valueOf('Account not found');
            return null;
        }
    }

    @HttpDelete
    global static void doDelete() {
        RestRequest req = RestContext.request;
        String recordId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);
        List<Account> result = [SELECT Id FROM Account WHERE Id = :recordId LIMIT 1];
        if (!result.isEmpty()) {
            delete result[0];
            RestContext.response.statusCode = 204; 
        } else {
            RestContext.response.statusCode = 404;
            RestContext.response.responseBody = Blob.valueOf('Account not found');
        }
    }

    @HttpPost
    global static String doPost(String name, String phone, String AccountNumber) {
        Account acc = new Account(
            Name = name,
            Phone = phone,
            AccountNumber = AccountNumber
        );
        insert acc;
        return acc.Id;
    }

    @HttpPut
    global static String doPut() {
        RestRequest req = RestContext.request;
        String body = req.requestBody.toString();
        Account acc = (Account) JSON.deserialize(body, Account.class);
        Account existing = [SELECT Id FROM Account WHERE AccountNumber = :acc.AccountNumber LIMIT 1];
        if (existing != null) {
            acc.Id = existing.Id;
        }
        upsert acc;
        return acc.Id;
    }

    @HttpPatch
    global static String doPatch() {
        RestRequest req = RestContext.request;
        String accNumber = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);
        String body = req.requestBody.toString();
        Account updates = (Account) JSON.deserialize(body, Account.class);
        Account accToUpdate = [SELECT Id, Name, Phone, Website FROM Account WHERE AccountNumber = :accNumber LIMIT 1];
        if (updates.Name != null) accToUpdate.Name = updates.Name;
        if (updates.Phone != null) accToUpdate.Phone = updates.Phone;
        if (updates.Website != null) accToUpdate.Website = updates.Website;
        update accToUpdate;
        return accToUpdate.Id;
    }
}
