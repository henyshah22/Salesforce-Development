public class ErrorLogger {
    public static void logException(Exception ex, String className, String methodName, String moreDetails) {
        Error_Log__c err = new Error_Log__c();
        err.Class_Name__c = className;
        err.Method_Name__c = methodName;
        err.Exception_Message__c = ex.getMessage();
        err.Line_Number__c = ex.getLineNumber();
        err.Exception_Type__c = ex.getTypeName();
        err.More_Details__c = moreDetails;
        try {
            insert err;
        } catch (Exception logEx) {
            System.debug('Failed to log error: ' + logEx.getMessage());
        }
    }
}