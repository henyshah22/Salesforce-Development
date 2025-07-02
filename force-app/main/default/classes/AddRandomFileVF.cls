public class AddRandomFileVF {
    public Opportunity opp { get; set; }

    public AddRandomFileVF(ApexPages.StandardController controller) {
        opp = (Opportunity)controller.getRecord();
    }

    public PageReference addRandomFile() {
    AddRandomFile.attachRandomImage(opp.Id);
    return null;  
    }
}


