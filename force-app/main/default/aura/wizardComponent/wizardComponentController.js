({
    next : function(component, event, helper) {
        component.set("v.isLoading", true);
        var currentStep = component.get("v.currentStep");
        if (currentStep === 1) {
            helper.createAccount(component)
                .then(function() {
                    component.set("v.currentStep", currentStep + 1);
                    helper.updateProgress(component);
                })
                .catch(function(error) {
                    console.error(error);
                })
                .finally(function() {
                    component.set("v.isLoading", false);
                });
        } else if (currentStep === 2) {
            helper.createContact(component)
                .then(function() {
                    component.set("v.currentStep", currentStep + 1);
                    helper.updateProgress(component);
                })
                .catch(function(error) {
                    console.error(error);
                })
                .finally(function() {
                    component.set("v.isLoading", false);
                });
        } else {
            component.set("v.currentStep", currentStep + 1);
            helper.updateProgress(component);
            component.set("v.isLoading", false);
        }
    },
    
    previous : function(component, event, helper) {
        component.set("v.isLoading", true);
        var currentStep = component.get("v.currentStep");
        if (currentStep > 1) {
            component.set("v.currentStep", currentStep - 1);
            helper.updateProgress(component);
        }
        component.set("v.isLoading", false);
    },
    
    goToStep : function(component, event, helper) {
        component.set("v.isLoading", true);
        var targetStep = parseInt(event.currentTarget.dataset.step);
        var currentStep = component.get("v.currentStep");
        
        if (targetStep < currentStep) {
            component.set("v.currentStep", targetStep);
            helper.updateProgress(component);
        }
        component.set("v.isLoading", false);
    },
    
    save : function(component, event, helper) {
    component.set("v.isLoading", true);
    helper.createEvent(component)
        .then(function() {
            var toast = $A.get("e.force:showToast");
            toast.setParams({
                "title": "Success",
                "message": "All records created successfully!",
                "type": "success"
            });
            toast.fire();
            
            component.set("v.currentStep", 1);
            component.set("v.account", {'sobjectType': 'Account', 'Name': '', 'Industry': '', 'Phone': '', 'Website': ''});
            component.set("v.contact", {'sobjectType': 'Contact', 'FirstName': '', 'LastName': '', 'Email': '', 'Phone': '', 'AccountId': ''});
            component.set("v.event", {'sobjectType': 'Event', 'Subject': 'Wizard Task', 'StartDateTime': '', 'EndDateTime': '', 'Location': '', 'WhoId': ''});
            component.set("v.accountId", '');
            component.set("v.contactId", '');

            component.set("v.accountName", "");
            component.set("v.accountIndustry", "");
            component.set("v.accountPhone", "");
            component.set("v.accountWebsite", "");

            component.set("v.contactFirstName", "");
            component.set("v.contactLastName", "");
            component.set("v.contactEmail", "");
            component.set("v.contactPhone", "");

            component.set("v.eventStartDateTime", "");
            component.set("v.eventEndDateTime", "");
            component.set("v.eventLocation", "");

            helper.updateProgress(component);
        })
        .catch(function(error) {
            var toast = $A.get("e.force:showToast");
            toast.setParams({
                "title": "Error",
                "message": "Error creating records: " + error.message,
                "type": "error"
            });
            toast.fire();
        })
        .finally(function() {
            component.set("v.isLoading", false);
        });
    }
})