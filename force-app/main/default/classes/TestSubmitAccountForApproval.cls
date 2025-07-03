@IsTest
public class TestSubmitAccountForApproval {
    @IsTest
    static void testAccountApprovalSubmit() {
        Account acc = new Account();
        acc.Industry = 'Technology';
        acc.Name = 'Test Account For Approval';
        insert acc;

        List<ProcessInstance> procList = [SELECT Id, Status, TargetObjectId FROM ProcessInstance WHERE TargetObjectId = :acc.Id];
        
        System.assert(procList.size() > 0, 'Approval process instance should be created');
    }
}
