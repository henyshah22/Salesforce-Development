global class BatchRunAt9andUpdateAcc implements Database.Batchable<SObject>, Schedulable{
    String query;
    global Database.QueryLocator start(Database.BatchableContext BC){
        query = 'SELECT ID, Name, Description From Account';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Account> scope){
        List<Account> accList = new List<Account>();
         for (Account s : scope) {
            s.Description = 'Updated on ' + System.now();
            accList.add(s);
        }
        update accList;
    }
    global void finish (Database.BatchableContext BC){
    }
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new BatchRunAt9andUpdateAcc(), 200);
    }
    public static void scheduleJob() {
        System.schedule('Daily Updates at 9 AM', '0 0 9 * * ? *', new BatchRunAt9andUpdateAcc());
    }
}