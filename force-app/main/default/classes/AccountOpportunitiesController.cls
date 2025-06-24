public class AccountOpportunitiesController {
    public Id selectedAccountId {get; set;}
    public List<Opportunity> opportunities {get; set;}
    public Integer pageSize {get; set;}
    public ApexPages.StandardSetController setCon {get; set;}

    public AccountOpportunitiesController() {
        pageSize = 10; // Default page size
    }


    public List<SelectOption> getAccountOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--Select Account--'));
        for (Account acc : [SELECT Id, Name FROM Account LIMIT 50]) {
            options.add(new SelectOption(acc.Id, acc.Name));
        }
        return options;
    }

    public void getOpportunities() {
        if (selectedAccountId != null) {
            opportunities = new List<Opportunity>();
            setCon = new ApexPages.StandardSetController([SELECT Id, Name, StageName, CloseDate, Amount FROM Opportunity WHERE AccountId = :selectedAccountId ORDER BY CloseDate DESC]);
            setCon.setPageSize(pageSize);
            opportunities = (List<Opportunity>) setCon.getRecords();

        } else {
            opportunities = null;
        }
    }

     public PageReference previous() {
        setCon.previous();
        opportunities = (List<Opportunity>) setCon.getRecords();
        return null;
    }

    public PageReference next() {
        setCon.next();
        opportunities = (List<Opportunity>) setCon.getRecords();
        return null;
    }

    public Boolean getHasPrevious() {
        return setCon.getHasPrevious();
    }

    public Boolean getHasNext() {
        return setCon.getHasNext();
    }
}