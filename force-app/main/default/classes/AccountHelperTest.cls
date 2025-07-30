@isTest
public class AccountHelperTest {
    @isTest
    static void AccountHelpertest() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Contact con = new Contact(FirstName = 'Test', LastName = 'TestContact', AccountId = acc.Id);
        insert con;

        Opportunity opp = new Opportunity(Name = 'TestOpportunity', StageName = 'Prospecting', CloseDate = Date.today().addDays(30), AccountId = acc.Id);
        insert opp;

        List<Account> accList = AccountHelper.getAccounts();

        Map<String, Object> result = AccountHelper.getRelatedData(acc.Id);
        List<Contact> contactList = (List<Contact>) result.get('contacts');
        List<Opportunity> oppList = (List<Opportunity>) result.get('opportunities');

        System.Assert.areEqual(1, contactList.size());
        System.Assert.areEqual(1, oppList.size());  
    }
}



// <apex:page controller="LoginController" showHeader="false" sidebar="false">
//     <style>
//         .center-container {
//             display: flex;
//             justify-content: center;
//             align-items: center;
//             height: 100vh;
//             background-color: #f4f6f9;
//         }
//         .login-box {
//             padding: 20px;
//             background: #fff;
//             border-radius: 8px;
//             box-shadow: 0 0 10px rgba(0,0,0,0.1);
//         }
//     </style>

//     <div class="center-container">
//         <apex:form >
//             <div class="login-box">
//                 <apex:pageMessages id="error"/>
//                 <apex:pageBlock title="Login">
//                     <apex:pageBlockSection >
//                         <apex:inputText value="{!username}" label="Username"/><br/>
//                         <apex:inputSecret value="{!password}" label="Password"/>
//                     </apex:pageBlockSection>
//                     <apex:commandButton value="Login" action="{!login}"/>
//                 </apex:pageBlock>
//                 <br/>
//                 <apex:outputLink value="/apex/ForgotPasswordController">Forgot Password?</apex:outputLink> 
//                 <br/>
//                 <apex:outputLink value="/apex/RegistrationPage">New User? Register</apex:outputLink>
//             </div>
//         </apex:form>
//     </div>
// </apex:page>


// <apex:page controller="LoginController" showHeader="false" sidebar="false">
//     <style>
//         .center-container {
//             display: flex;
//             justify-content: center;
//             align-items: center;
//             height: 100vh;
//             background-color: #f4f6f9;
//         }
//         .login-box {
//             padding: 20px;
//             background: #fff;
//             border-radius: 8px;
//             box-shadow: 0 0 10px rgba(0,0,0,0.1);
//         }
//     </style>

//     <div class="center-container">
//         <apex:form >
//             <div class="login-box">
//                 <apex:pageMessages id="error"/>
//                 <apex:pageBlock title="Login">
//                     <apex:pageBlockSection >
//                         <apex:inputText value="{!username}" label="Username"/><br/>
//                         <apex:inputSecret value="{!password}" label="Password"/>
//                     </apex:pageBlockSection>
//                     <apex:commandButton value="Login" action="{!login}"/>
//                 </apex:pageBlock>
//                 <br/>
//                 <apex:outputLink value="/apex/ForgotPasswordController">Forgot Password?</apex:outputLink> 
//                 <br/>
//                 <apex:outputLink value="/apex/RegistrationPage">New User? Register</apex:outputLink>
//             </div>
//         </apex:form>
//     </div>
// </apex:page>


// public class LoginController {
//     public String username { get; set; }
//     public String password { get; set; }

//     public PageReference login() {
//         if(username == 'admin' && password == 'admin123') {
//             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Login Successful'));
//         } else {
//             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid Credentials'));
//         }
//         return null;
//     }
// }


// public class RegistrationController {
//     public String username { get; set; }
//     public String email { get; set; }
//     public String password { get; set; }

//     public PageReference register() {
//         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Registered Successfully!'));
//         return null;
//     }
// }
