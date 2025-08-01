({
    fetchContacts: function(component, accountName, contactsAttr, countAttr) {
        const action = component.get("c.getContactsForAccount");
        action.setParams({ accountName: accountName });
        action.setCallback(this, function(response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                const result = response.getReturnValue();
                component.set("v." + contactsAttr, result.contacts);
                component.set("v." + countAttr, result.count);
            } else {
                console.error("Failed to fetch contacts: ", response.getError());
            }
        });
        $A.enqueueAction(action);
    },

    updateContactAccount: function(component, contactId, accountName, contactsAttr, countAttr) {
        const action = component.get("c.updateContactAccount");
        action.setParams({
            contactId: contactId,
            newAccountName: accountName
        });
        action.setCallback(this, function(response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                this.fetchContacts(component, accountName, contactsAttr, countAttr);
            } else {
                console.error("Failed to update contact account: ", response.getError());
            }
        });
        $A.enqueueAction(action);
    }
})