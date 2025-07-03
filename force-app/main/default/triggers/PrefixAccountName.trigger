// trigger PrefixAccountName on Account (before insert) {
// {
//     for(Account a : Trigger.New)
//     {
//         a.Name = 'Mr.'+a.Name;
//     }
// }
// }

trigger PrefixAccountName on Account (after delete) {

}