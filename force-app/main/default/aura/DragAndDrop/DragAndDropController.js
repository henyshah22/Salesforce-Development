({
    searchContacts1: function(component, event, helper) {
        const accountName = component.get("v.accountName1");
        helper.fetchContacts(component, accountName, "contacts1", "contactCount1");
    },

    searchContacts2: function(component, event, helper) {
        const accountName = component.get("v.accountName2");
        helper.fetchContacts(component, accountName, "contacts2", "contactCount2");
    },

    allowDrop: function(component, event, helper) {
        event.preventDefault();
    },

    handleDragStart: function(component, event, helper) {
        const contactId = event.currentTarget.dataset.contactid;
        event.dataTransfer.setData("contactId", contactId);
    },

    handleDropToSection1: function(component, event, helper) {
        event.preventDefault();
        const contactId = event.dataTransfer.getData("contactId");
        const accountName = component.get("v.accountName1");
        helper.updateContactAccount(component, contactId, accountName, "contacts1", "contactCount1");
        const accountName2 = component.get("v.accountName2");
        helper.fetchContacts(component, accountName2, "contacts2", "contactCount2");
    },

    handleDropToSection2: function(component, event, helper) {
        event.preventDefault();
        const contactId = event.dataTransfer.getData("contactId");
        const accountName = component.get("v.accountName2");
        helper.updateContactAccount(component, contactId, accountName, "contacts2", "contactCount2");
        const accountName1 = component.get("v.accountName1");
        helper.fetchContacts(component, accountName1, "contacts1", "contactCount1");
    }
})
