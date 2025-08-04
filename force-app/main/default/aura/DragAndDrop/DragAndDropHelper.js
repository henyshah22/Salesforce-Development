({
    fetchContactsForSection1: function(component) {
        const accountName = component.get("v.accountName1");
        const action = component.get("c.getContactsForMatchingAccounts");
        action.setParams({ accountName: accountName });

        action.setCallback(this, function(response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.accountResults1", response.getReturnValue());
            } else {
                console.error("Error fetching contacts for Section 1:", response.getError());
            }
        });
        $A.enqueueAction(action);
    },

    fetchContactsForSection2: function(component) {
        const accountName = component.get("v.accountName2");
        const action = component.get("c.getContactsForMatchingAccounts");
        action.setParams({ accountName: accountName });

        action.setCallback(this, function(response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.accountResults2", response.getReturnValue());
            } else {
                console.error("Error fetching contacts for Section 2:", response.getError());
            }
        });
        $A.enqueueAction(action);
    },

    updateContactAccountForSection1: function(component, contactId, accountId) {
        const action = component.get("c.updateContactAccount");
        action.setParams({
            contactId: contactId,
            newAccountId: accountId
        });

        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                this.fetchContactsForSection1(component);
            } else {
                console.error("Error updating contact account for Section 1:", response.getError());
            }
        }.bind(this));
        $A.enqueueAction(action);
    },

    updateContactAccountForSection2: function(component, contactId, accountId) {
        const action = component.get("c.updateContactAccount");
        action.setParams({
            contactId: contactId,
            newAccountId: accountId
        });

        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                this.fetchContactsForSection2(component);
            } else {
                console.error("Error updating contact account for Section 2:", response.getError());
            }
        }.bind(this));
        $A.enqueueAction(action);
    }
});
