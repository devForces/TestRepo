/**
* Util class to use reparenting process 
*
* 
*
* @author Samarjit Baruah
* @LastUpdate 06/23/2013
*/

public with sharing class ChangeParentUtil {
	
	// Schema.getGlobalDescribe() is called once per transaction
	static Map<String, Schema.SObjectType> gd;
	public static Map<String, Schema.SObjectType> getGlobalDesc(){
		if(gd == null) gd = Schema.getGlobalDescribe();
		return gd;
	}
	
	
	private static String objectTypeName;
	
	/**
	* This method evaluate the object type name from record Id
	* 
	* @param objectId salesforce record Id
	* @return the object type name
	*/
	public static String getObjectTypeName(String objectId){
		if(objectTypeName!=null) return objectTypeName;
		if(objectId!=null && objectId.length()>3){
			// Generate a keyprefixmap using the global describe 
		    // Then compare that to our object to determine type.  
			Map<String,String> keyPrefixMap = new Map<String,String>{};
		    Map<String, Schema.SObjectType> glodesc = getGlobalDesc();      
		    for(String sObj : glodesc.keySet()){
		    	Schema.DescribeSObjectResult r =  glodesc.get(sObj).getDescribe();
		    	keyPrefixMap.put(r.getKeyPrefix(), r.getName());
		    }
		    
		    string objectTypeKey = objectId.subString(0,3);
		    
		    objectTypeName = keyPrefixMap.get(objectTypeKey);
	    }
		
		return objectTypeName;
	}
	
	/**
	* Get child relationships of object
	* 
	* @param objectId salesforce record Id
	* @return childList List<Schema.Childrelationship>
	*/
	public static List<Schema.Childrelationship> getChildRelations(String objectId){
		List<Schema.Childrelationship> childList;
		try{
			if(objectId!=null){
				//get object type name by record Id
				String objTypeName = ChangeParentUtil.getObjectTypeName(objectId);
			    Schema.sObjectType sObjType = getGlobalDesc().get(objTypeName);  
		        Schema.DescribeSObjectResult d = sObjType.getDescribe();
		        //get all child relationships
		        childList = d.getChildRelationships();
			}
		}catch(exception e){
			throw e;
		}
        return childList;
	}
	
	
	/**
	* Retrive all child records for object related to record id objectId
	* This method builds the query and retrive all records from the child objects dynamically 
	* 
	* @param objectId record id of the parent record
	* @return soList the list of child records
	* @throw exception
	*/
	public static List<Sobject> getChildRecords(String objectId){
		List<Sobject> soList;
		try{
			String queryString = 'Select Id';
	    	//Get all the child relationship
	    	List<Schema.Childrelationship> childRelationshipList = ChangeParentUtil.getChildRelations(objectId);
	    	if(childRelationshipList !=null && !childRelationshipList.isEmpty()){
		    	for(Schema.Childrelationship cr:childRelationshipList){
		    		String relationshipName = cr.getRelationshipName();
		    		Schema.Describefieldresult descFieldResult = cr.getField().getDescribe();
		    		String parentFieldName = descFieldResult.getName();
		    		//Only re associatable childrelations need to be taken care  
		    		if(relationshipName != null && descFieldResult.isUpdateable()){
		    			queryString += ', (select Id, '+parentFieldName+' from '+relationshipName+')';
		    		}
		        }
		        //String.escapeSingleQuotes is used to take care of database injection
		        queryString += ' from '+ ChangeParentUtil.getObjectTypeName(String.escapeSingleQuotes(objectId))+' where Id =\''+ String.escapeSingleQuotes(objectId)+'\'';
		        
		        soList = Database.query(queryString);
	    	}
		}catch(Exception e){
			throw e;
		}
        return soList;
	
	}
	
	
	//The map to hold the child relationship name and recprds count of them
	public static Map<String,Integer> childCountMap;
    
    /**
	* Change the parent Id of the all the child records retrived from the source parent record
	* this methods also populate the childCountMap
	* 
	* @param soList list of all child records that needs to be re-parenting
	* @param parentId the id of the destination parent record
	* @return childObjectList list of all child records after changing the parent record Id
	*/
    public static List<sObject> reParentChild(List<Sobject> soList, String parentId){
    	List<sObject> childObjectList;
    	try{
	    	if(soList != null && !soList.isEmpty()){
	    		childCountMap = new Map<String,Integer>();
		    	childObjectList = new list<sObject>();	
		    	//Get the child relationship and iterate for all the relation to take case
		        for(Schema.Childrelationship cr:ChangeParentUtil.getChildRelations(parentId)){
		    		String relationshipName = cr.getRelationshipName();
		    		Schema.Describefieldresult descFieldResult = cr.getField().getDescribe();
		    		String parentFieldName = descFieldResult.getName();
		    		if(relationshipName != null && descFieldResult.isUpdateable()){
		    			//get all the records for the child relation related to the source parent
		    			List<Sobject> cObject = soList[0].getSObjects(relationshipName);
		    			if(cObject!=null){
		    				//Change the parent of the child record from the source parent id to the destination parent id
		    				for(sobject co:cObject){
		    					co.put(parentFieldName,parentId);
			    				childObjectList.add(co);
			    			}
			    			childCountMap.put(relationshipName,cObject.size());
		    			}
		    		}
		        }
	    	}
    	}catch(Exception e){
    		throw e;
    	}
    	return childObjectList;
    }
    
    public static String getNameField(String objectName){
    	Schema.sObjectType sObjType = getGlobalDesc().get(objectName);  
		Schema.DescribeSObjectResult d = sObjType.getDescribe();
    	Map<String,Schema.sObjectField> sObjectFieldMap = d.Fields.getMap();
    	for(String fieldName:sObjectFieldMap.keySet()){
    		Schema.sObjectField sObjField = sObjectFieldMap.get(fieldName);
    		if(sObjField.getDescribe().isNameField()){
    			return fieldName;
    		}
    	}
    	return null;
    }
	
}