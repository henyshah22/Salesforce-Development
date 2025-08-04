({
    doInit: function(component, event, helper) {
        helper.getAllAccount(component);
    },
    
    getContacts: function(component, event, helper) {
        var accountId = component.find("ac").get("v.value");
        component.set("v.accountSelected", !!accountId);
        helper.getContactDetails(component);
    },
    
    handleSearch: function(component, event, helper) {
        helper.filterContacts(component);
    },
    
    previousPage: function(component, event, helper) {
        var currentPage = component.get("v.currentPage");
        if(currentPage > 1) {
            component.set("v.currentPage", currentPage - 1);
            helper.filterContacts(component);
        }
    },
    
    nextPage: function(component, event, helper) {
        var currentPage = component.get("v.currentPage");
        var totalPages = component.get("v.totalPages");
        if(currentPage < totalPages) {
            component.set("v.currentPage", currentPage + 1);
            helper.filterContacts(component);
        }
    }
})