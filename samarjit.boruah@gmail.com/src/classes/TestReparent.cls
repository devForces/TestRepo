/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestReparent {

    static testMethod void unitTest() {
        Account acc = new Account(name='testAcc');
        Account acc1 = new Account(name='testAcc1');
        insert new List<account>{acc,acc1};
        Contact c = new Contact(lastName='CLname',AccountId=acc.Id);
        Contact c1 = new Contact(lastName='CLname1',AccountId=acc1.Id);
        insert new List<Contact>{c,c1};
        Test.startTest();
        	PageReference pageRef = Page.ChangeParent1; //replace with your VF page name
	        Test.setCurrentPage(pageRef);
	        // Add parameters to page URL  
	    	ApexPages.currentPage().getParameters().put('id', acc.Id);
	    	ChangeParentController cpController = new ChangeParentController();
	    	cpController.initParentChange();
	    	system.assert(cpController.obj.getsObjectType() == Account.sObjectType);
	    	
	    	cpController.obj.put(cpController.fieldName, acc.id);
	    	Pagereference pageref1 = cpController.next1();
	    	system.assertEquals(pageref1, null);
	    	
	    	cpController.obj.put(cpController.fieldName, acc1.id);
	    	pageref1 = cpController.next1();
	    	PageReference pageRef2 = Page.ChangeParent2;
	    	system.assertEquals(pageref2.getURL(), pageref1.getURL());
	    	
	    	pageref1 = cpController.previous();
	    	system.assertEquals('/apex/changeparent1', pageref1.getURL());
	    	
	    	cpController.cancel();
	    	cpController.getChildRecords();
	    	Map<String,Integer> ccMap = cpController.childCountMap;
	    	
	    	system.assertEquals(1, ccMap.get('Contacts'));
	    	
	    	cpController.finish();
	    	
	    	ApexPages.currentPage().getParameters().put('id', null);
	    	cpController = new ChangeParentController();
        	cpController.initParentChange();
        	cpController.getChildRecords();
        	ChangeParentUtil.getChildRecords(null);
        Test.stopTest();
    }
}