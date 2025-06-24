public class ContactListController {
    private ApexPages.StandardSetController con;

    public ContactListController(ApexPages.StandardController controller) {
    }

    public ApexPages.StandardSetController getSetCon() {
        if (con == null) {
            con = new ApexPages.StandardSetController(Database.getQueryLocator(
                [SELECT Id, FirstName, LastName, Email, Phone FROM Contact]
            ));
            con.setPageSize(30);
        }
        return con;
    }

    public List<Contact> getContacts() {
        return (List<Contact>) getSetCon().getRecords();
    }

    public PageReference first() {
        getSetCon().first();
        return null;
    }

    public PageReference previous() {
        getSetCon().previous();
        return null;
    }

    public PageReference next() {
        getSetCon().next();
        return null;
    }

    public PageReference last() {
        getSetCon().last();
        return null;
    }

    public Integer getPageNumber() {
        return getSetCon().getPageNumber();
    }

    public Integer getTotalPages() {
        return (Integer) Math.ceil(getSetCon().getResultSize() / (Decimal) getSetCon().getPageSize());
    }
}