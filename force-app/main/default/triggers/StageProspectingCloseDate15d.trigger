// trigger StageProspectingCloseDate15d on Opportunity (before insert) {
// for(Opportunity opp : Trigger.new){
//      opp.StageName = 'Prospecting';
//      opp.CloseDate = Date.Today().addDays(15);
// }
// }

trigger StageProspectingCloseDate15d on Opportunity (after delete) {

}
