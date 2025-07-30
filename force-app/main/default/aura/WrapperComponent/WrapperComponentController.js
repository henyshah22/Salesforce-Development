({
    doInit: function(component, event, helper) {
        var action = component.get("c.getAccountData");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                component.set("v.accountWrapperList", response.getReturnValue());
            } else {
                console.error("Failed to fetch data");
            }
        });
        $A.enqueueAction(action);
    }
})