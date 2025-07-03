@isTest
private class TestDebugTriggerContext {
    @isTest
    static void testDebugTriggerContext() {
        Account acc = new Account(Name = 'Debug Trigger');
        insert acc;
        acc.Name = 'Debug Trigger Updated';
        update acc;
        delete acc;
        undelete acc;
    }
}