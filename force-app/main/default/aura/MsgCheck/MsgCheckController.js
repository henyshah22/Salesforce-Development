({
    handleChange : function(component, event, helper) {
        var val = event.getSource().get("v.value");
        component.set("v.selectedValue", val);
        component.set("v.hasSelected", !!val);
    }
})