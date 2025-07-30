({
    createContact : function(component, event, helper) {
        var action = component.get("c.insertContact");
        action.setParams({
            contactName: component.get("v.contactName"),
            mobileNumber: component.get("v.mobileNumber")
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var toast = $A.get("e.force:showToast");
                toast.setParams({
                    "title": "Success!",
                    "message": "Contact created successfully!",
                    "type": "success"
                });
                toast.fire();

                component.set("v.contactName", "");
                component.set("v.mobileNumber", "");
            } else {
                var errors = response.getError();
                var message = "Unknown error";
                if (errors && errors[0] && errors[0].message) {
                    message = errors[0].message;
                }
                var toast = $A.get("e.force:showToast");
                toast.setParams({
                    "title": "Error",
                    "message": message,
                    "type": "error"
                });
                toast.fire();
            }
        });

        $A.enqueueAction(action);
    }
})
