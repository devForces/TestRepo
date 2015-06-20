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
private class NoChatterTest {

    static testMethod void noChatUnitTest() {
        //Prepare data
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        
      	User noChatterUser = new User(Alias = 'noChat', Email='noChatterUser@noChatterUser.com', 
         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
         LocaleSidKey='en_US', ProfileId = p.Id, 
         TimeZoneSidKey='America/Los_Angeles', UserName='noChatterUser@noChatterUser.com');
         insert noChatterUser;
         
         //Add user to the "No Chatter User" custom setting
         NoChatterUser__c noChatter = new NoChatterUser__c();
         noChatter.SetUpOwnerId = noChatterUser.Id;
         insert noChatter;
         
         Test.startTest();
         system.runAs(noChatterUser){
         	try{
	         FeedItem fItem = new FeedItem(Body='Test Chat',ParentId = noChatterUser.Id);
	         insert fItem;
         	}catch(System.DMLException dmle){
         		for (Integer i = 0; i < dmle.getNumDml(); i++) {
			        // Assert with the defined message
			        system.assertEquals(dmle.getDmlMessage(i), system.label.No_Chatter_Message);
			    }
         		
         	}
         }
         
         Test.stopTest();
         
    }
}