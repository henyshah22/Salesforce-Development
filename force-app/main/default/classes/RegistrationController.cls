public class RegistrationController {
    public String username { get; set; }
    public String email { get; set; }
    public String password { get; set; }

    public PageReference register() {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Registered Successfully!'));
        return null;
    }
}