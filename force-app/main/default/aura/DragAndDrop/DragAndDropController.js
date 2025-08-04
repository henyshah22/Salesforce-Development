({
    searchContacts1: function(component, event, helper) {
        helper.fetchContactsForSection1(component);
    },

    searchContacts2: function(component, event, helper) {
        helper.fetchContactsForSection2(component);
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
        const accountId = event.currentTarget.dataset.accountid;

        helper.updateContactAccountForSection1(component, contactId, accountId);
        helper.fetchContactsForSection2(component);
    },

    handleDropToSection2: function(component, event, helper) {
        event.preventDefault();
        const contactId = event.dataTransfer.getData("contactId");
        const accountId = event.currentTarget.dataset.accountid;

        helper.updateContactAccountForSection2(component, contactId, accountId);
        helper.fetchContactsForSection1(component);
    }
});
