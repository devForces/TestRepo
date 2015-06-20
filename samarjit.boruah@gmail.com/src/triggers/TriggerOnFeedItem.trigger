/**
* Single point entry trigger on FeedItem
* 
* This is currently implemented aonly to achieve the requirement "No Chatter"
* Only before insert is implemented as no other transaction is required to achieve the "No Chatter"
* Implementation of any other logic won't beak the "No Chatter"
* 
* @Author Samarjit Baruah
* @LastModified 06/20/2013 
*/


trigger TriggerOnFeedItem on FeedItem (before insert) {
	if(trigger.isBefore){
		TriggerOnFeedItemImplement.executeBeforeTrigger();
	}
}