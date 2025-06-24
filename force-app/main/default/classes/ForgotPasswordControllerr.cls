public class ForgotPasswordControllerr {
    public String email { get; set; }

    public PageReference resetPassword() {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Password reset link sent to your email.'));
        return null;
    }
}