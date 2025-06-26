trigger CreateTaskForOwner on Opportunity (after update) {
    List<Task> tasks = new List<Task>();
    for (Opportunity opp : Trigger.new) {
        Opportunity oldOpp = Trigger.oldMap.get(opp.Id);
        if (opp.Name != oldOpp.Name) {
            Task newTask = new Task();
            newTask.Subject = 'Opportunity Name Changed';
            newTask.Description= 'This Opportunity\'s name has changed to ' + opp.Name;
            newTask.WhatId = opp.Id;
            newTask.OwnerId = opp.OwnerId;
            newTask.Priority = 'High';
            newTask.Status = 'Not Started';
            newTask.ActivityDate = Date.today();
            tasks.add(newTask);
        }
    }
        insert tasks;
}