public with sharing class ExportViewController {


// ApexPages.StandardSetController must be instantiated
    // for standard list controllers
    public ApexPages.StandardSetController setCon {
        get {
            String filterID = ApexPages.currentPage().getParameters().get('fcf');
            if(setCon == null) {
                List<Sobject> soList = database.query('SELECT Name, CloseDate FROM Opportunity limit 1');
                setCon = new ApexPages.StandardSetController(soList);
                setCon.setFilterId(filterID);
            }
            return setCon;
        }
        set;
    }

    // Initialize setCon and return a list of records
    public List<Opportunity> getOpportunities() {
        return (List<Opportunity>) setCon.getRecords();
    }

}