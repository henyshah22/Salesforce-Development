// trigger NewCustomer on Opportunity (before insert) {
// for(Opportunity opp : Trigger.new){
//     opp.Type = 'New Customer';
// }

trigger NewCustomer on Opportunity (after delete) {

}