public class LoginController {
    public String username { get; set; }
    public String password { get; set; }

    public PageReference login() {
        try {
            if (String.isBlank(username) || String.isBlank(password)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Username and password are required.'));
                return null;
            }

            String startUrl = '/home/home.jsp';
            PageReference pageRef = Site.login(username, password, startUrl);
            if (pageRef == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid username or password.'));
                return null;
            }
            return pageRef;
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Login Failed: ' + e.getMessage()));
            return null;
        }
    }
}