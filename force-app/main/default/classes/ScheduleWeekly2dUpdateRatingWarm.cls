global class ScheduleWeekly2dUpdateRatingWarm implements Schedulable{
    global void execute(SchedulableContext sc){
        List<Account> accList = [SELECT Id, Name, Rating FROM Account WHERE Rating != 'Warm'];
        for(Account acc : accList){
            acc.Rating = 'Warm';
        }
            update accList;
    }
    public static void scheduleJob(){
        System.schedule('Rating Updated to Warm', '0 0 12 ? * MON,FRI *', new ScheduleWeekly2dUpdateRatingWarm());
    }
}