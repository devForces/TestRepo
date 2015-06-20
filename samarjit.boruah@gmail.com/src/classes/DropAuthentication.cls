public with sharing class DropAuthentication {

    Static AppKeyPair consumerTokenPair{
        get{
            String appKey = Dropbox_Settings__c.getValues('oauth_consumer_key').value__c;
            String appSecret = Dropbox_Settings__c.getValues('oauth_secret').value__c;
            if(appKey !=null &&appSecret !=null){
                return new AppKeyPair(appKey, appSecret);
            }  
            return null;
        }
        set;
    } 
    static {}

}