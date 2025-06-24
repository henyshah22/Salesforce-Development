trigger DebugTriggerContext on Account (before insert, before update, after insert, after update, before delete, after delete, after undelete) {
    
    System.debug('Trigger Context Variables');
    System.debug('Trigger.isInsert: ' + Trigger.isInsert);
    System.debug('Trigger.isUpdate: ' + Trigger.isUpdate);
    System.debug('Trigger.isDelete: ' + Trigger.isDelete);
    System.debug('Trigger.isBefore: ' + Trigger.isBefore);
    System.debug('Trigger.isAfter: ' + Trigger.isAfter);
    System.debug('Trigger.isUndelete: ' + Trigger.isUndelete);
    System.debug('Trigger.new: ' + Trigger.new);
    System.debug('Trigger.newMap: ' + Trigger.newMap);
    System.debug('Trigger.old: ' + Trigger.old);
    System.debug('Trigger.oldMap: ' + Trigger.oldMap);
    System.debug('Trigger.size: ' + Trigger.size);

    System.debug('----');
}