/**
* Trigger on FeedItem implemantation class
*
* This class is implementing the the single entry point trigger on FeedItem 
*
* @author Samarjit Baruah
* @LastUpdate 06/21/2013
*/

public with sharing class TriggerOnFeedItemImplement {
	
	/**
	* Execute for before trigger transaction on FeedItem sObject
	* Execute all the logic need to apply to all chatter post
	* Any other logic or validation if required on before trigger can be implemented here
	* Custom Label is used to add more <em>flexibility</em> for the error message with <em>localization<em> 
	* 
	* @param  
	* @return void
	*/
	public static void executeBeforeTrigger(){
		
		// Check if the current user or current user profile does have the permission to post on chatter or not
		boolean isNoChatter = (NoChatterUser__c.getValues(Userinfo.getUserId())!=null || NoChatterUser__c.getValues(Userinfo.getProfileId())!=null);
				
		//Iterate over trigger.new list to apply logic to all the records during bulk operation 
		Integer count = 0;
		for(sObject fItem:Trigger.new){
			if(isNoChatter){
				// add exception with a custom message
				fItem.addError(System.Label.No_Chatter_Message);
			}
			
		}
	}
}