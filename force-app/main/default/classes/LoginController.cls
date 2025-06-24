public class LoginController {
    public String username { get; set; }
    public String password { get; set; }

    public PageReference login() {
        if(username == 'admin' && password == 'admin123') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Login Successful'));
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid Credentials'));
        }
        return null;
    }
}