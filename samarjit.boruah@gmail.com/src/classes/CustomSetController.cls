public with sharing class CustomSetController {

    public CustomSetController(ApexPages.StandardSetController controller) {
        List<Opportunity> Opportunities = [SELECT Id FROM Opportunity LIMIT 1];
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(Opportunities );
        system.debug('standard set controller count before filter: '+ssc.getResultSize());
        

    }

}