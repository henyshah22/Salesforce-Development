({
    createAccount: function (component) {
        return new Promise((resolve, reject) => {
            var name = component.get("v.accountName");
            if (!name) {
                this.showErrorToast(component, [{ message: "Account Name is required" }]);
                reject(new Error("Account Name is required"));
                return;
            }

            var account = {
                sobjectType: "Account",
                Name: name,
                Industry: component.get("v.accountIndustry"),
                Phone: component.get("v.accountPhone"),
                Website: component.get("v.accountWebsite")
            };

            var action = component.get("c.createAccount");
            action.setParams({ account: account });

            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var accountId = response.getReturnValue();
                    component.set("v.accountId", accountId);
                    resolve();
                } else {
                    var errors = response.getError();
                    this.showErrorToast(component, errors);
                    reject(new Error("Error creating account"));
                }
            });

            $A.enqueueAction(action);
        });
    },

    createContact: function (component) {
        return new Promise((resolve, reject) => {
            var lastName = component.get("v.contactLastName");
            if (!lastName) {
                this.showErrorToast(component, [{ message: "Last Name is required" }]);
                reject(new Error("Last Name is required"));
                return;
            }

            var contact = {
                sobjectType: "Contact",
                FirstName: component.get("v.contactFirstName"),
                LastName: lastName,
                Email: component.get("v.contactEmail"),
                Phone: component.get("v.contactPhone"),
                AccountId: component.get("v.accountId")
            };

            var action = component.get("c.createContact");
            action.setParams({ contact: contact });

            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var contactId = response.getReturnValue();
                    component.set("v.contactId", contactId);
                    resolve();
                } else {
                    var errors = response.getError();
                    this.showErrorToast(component, errors);
                    reject(new Error("Error creating contact"));
                }
            });

            $A.enqueueAction(action);
        });
    },

    createEvent: function (component) {
        return new Promise((resolve, reject) => {
            var start = component.get("v.eventStartDateTime");
            var end = component.get("v.eventEndDateTime");

            if (!start || !end) {
                this.showErrorToast(component, [{ message: "Start and End Date/Time are required" }]);
                reject(new Error("Start and End Date/Time are required"));
                return;
            }

            var event = {
                sobjectType: "Event",
                Subject: "Wizard Task",
                StartDateTime: start,
                EndDateTime: end,
                Location: component.get("v.eventLocation"),
                WhoId: component.get("v.contactId") 
            };

            var action = component.get("c.createEvent");
            action.setParams({ event: event });

            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    resolve();
                } else {
                    var errors = response.getError();
                    this.showErrorToast(component, errors);
                    reject(new Error("Error creating event"));
                }
            });

            $A.enqueueAction(action);
        });
    },

    updateProgress: function (component) {
        var currentStep = component.get("v.currentStep");
        for (var i = 1; i <= 3; i++) {
            var step = component.find("step" + i);
            if (i < currentStep) {
                $A.util.removeClass(step, "slds-is-active");
                $A.util.addClass(step, "slds-is-completed");
            } else if (i === currentStep) {
                $A.util.addClass(step, "slds-is-active");
                $A.util.removeClass(step, "slds-is-completed");
            } else {
                $A.util.removeClass(step, "slds-is-active");
                $A.util.removeClass(step, "slds-is-completed");
            }
        }
    },

    showErrorToast: function (component, errors) {
        var toast = $A.get("e.force:showToast");
        toast.setParams({
            "title": "Error",
            "message": "An error occurred: " + ((errors && errors[0] && errors[0].message) || "Unknown error"),
            "type": "error"
        });
        toast.fire();
    }
});