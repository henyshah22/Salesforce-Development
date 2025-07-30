({
    getAllAccount: function(component) {
        var action = component.get("c.fetchAccount");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                component.set("v.accountList", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    getContactDetails: function(component) {
        var accountId = component.find("ac").get("v.value");
        if(!accountId) {
            component.set("v.contactList", []);
            component.set("v.filteredContacts", []);
            component.set("v.totalContacts", 0);
            component.set("v.totalPages", 1);
            component.set("v.currentPage", 1);
            component.set("v.displayRange", "");
            return;
        }
        
        var action = component.get("c.getContact");
        action.setParams({ accid: accountId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var contacts = response.getReturnValue();
                component.set("v.contactList", contacts);
                component.set("v.totalContacts", contacts.length);
                this.filterContacts(component);
            }
        });
        $A.enqueueAction(action);
    },
    
    filterContacts: function(component) {
        var searchTerm = component.get("v.searchTerm").toLowerCase();
        var allContacts = component.get("v.contactList");
        var pageSize = component.get("v.pageSize");
        var currentPage = component.get("v.currentPage");
        
        var filtered = allContacts.filter(function(con) {
            return !searchTerm || 
                (con.Name && con.Name.toLowerCase().includes(searchTerm)) ||
                (con.Phone && con.Phone.toLowerCase().includes(searchTerm)) ||
                (con.Email && con.Email.toLowerCase().includes(searchTerm));
        });
        
        var totalContacts = filtered.length;
        var totalPages = Math.ceil(totalContacts / pageSize) || 1;
        component.set("v.totalPages", totalPages);
        component.set("v.totalContacts", totalContacts);
        
        var start = (currentPage - 1) * pageSize + 1;
        var end = Math.min(currentPage * pageSize, totalContacts);
        component.set("v.displayRange", start + "-" + end);
        
        var startIndex = (currentPage - 1) * pageSize;
        var endIndex = startIndex + pageSize;
        var pagedContacts = filtered.slice(startIndex, endIndex);
        
        component.set("v.filteredContacts", pagedContacts);
    }
})