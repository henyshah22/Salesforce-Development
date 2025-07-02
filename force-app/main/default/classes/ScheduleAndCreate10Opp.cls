global class ScheduleAndCreate10Opp implements Schedulable{
    global void execute(SchedulableContext sc){
        List<Opportunity> oppList = new List<Opportunity>();
        for(Integer i=0;i<10;i++){
            Opportunity opp = new Opportunity(
            Name ='Scheduled Opportunity ' + (i+1),
            CloseDate = Date.today().addDays(30),
            StageName = 'Prospecting'
            );
            oppList.add(opp);
        }
        insert oppList;
    }
    public static void scheduleJob(){
        System.schedule('Create Opportunity', '0 30 11 1/1 * ? *', new ScheduleAndCreate10Opp());
    }
}