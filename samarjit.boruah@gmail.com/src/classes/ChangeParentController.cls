/**
* Custom Controller class for ChangePagent1 and ChangeParent2 pages 
*
* 
*
* @author Samarjit Baruah
* @LastUpdate 06/23/2013
*/

public with sharing class ChangeParentController {
       
    //Temporary Sobject to create the lookup field for the parent record selection 
    public SObject obj{get;set;}
    //Temporary field to create the lookup field for the parent record selection
    public String fieldName{get;set;}
    
    //holds the source parent record Id
    private String oldParentId;
    
    /**
    * Empty constructor
    * 
    */
    public changeParentController(){
        //Get the source parent record Id from the usl parameter
        oldParentId = ApexPages.currentPage().getParameters().get('Id');
    }
    
     
    /**
    * This method is called from the apex:page action attribute of ChangeParent1 page
    * Generate the lookup filed dynamically
    * @param nothing
    * @return pagerefence always null
    */
    public Pagereference initParentChange(){
        
        //Get child relations for the parent object type
        List<Schema.Childrelationship> chr = ChangeParentUtil.getChildRelations(oldParentId);
        
        if(chr !=null && !chr.isEmpty()){
                Schema.sObjectType childSObjType = chr[0].getChildSObject();
                obj = childSObjType.newSObject();
                
                Schema.Describefieldresult dfresult = chr[0].getField().getDescribe();
                fieldName = dfresult.getName();
        }else{
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'There is no child relationship for this Object!!'));
        }
        return null;
        
    }
    
    public String searchStr{get;set;}
    public String nameField {get;set;}
    public List<SobjectWrapper> sObjList {
    	get{
    		List<SobjectWrapper> searchResult = new List<SobjectWrapper>();
    		if(searchStr!=null && searchStr.length()>1){
    			String objTypeName = ChangeParentUtil.getObjectTypeName(oldParentId);
    			nameField = ChangeParentUtil.getNameField(objTypeName);
	    		String searchquery='FIND \''+searchStr+'*\' IN ALL FIELDS RETURNING '+objTypeName+'(Id,'+nameField+')';
	    		List<List<SObject>> searchList =search.query(searchquery);
	    		if(searchList != null && !searchList.isEmpty()){
	    			for(Sobject so:searchList[0]){
	    				searchResult.add(new SobjectWrapper(so));
	    			}
	    		}
    		}else{
    			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Search must be longer than 1 charater'));
    		}
    		return searchResult;
    	} 
    	set;
    }
    
    
    private Sobject selectedSobject;
    /**
    * This method takes the user to the finish page(ChangeParent2)
    * @return ChangeParent2 pagereference
    */
    public Pagereference next1(){
    	for(SobjectWrapper sow:sObjList){
    		if(sow.selected){
    			selectedSobject = sow.sobj;
    			break;
    		}
    	}
    	
    	//if the user select the same record as the original record then prevent from going next
        if(oldParentId==selectedSobject.Id){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Destination parent records must have to be other and source parent!'));
                return null;
        }
        return page.ChangeParent2;
    }
    
    /**
    * Use to navigate from finish page(ChangeParent2) to start page(ChangeParent1)
    * @return ChangeParent1 pagereference
    */
    public Pagereference previous(){
        return page.ChangeParent1;
    }
    
    /**
    * use to cancel the from any page and go back to the source record 
    * @return pagereference to the source parent Id
    */
    public Pagereference cancel(){
        return new Pagereference('/'+oldParentId);
    }
    
    //Holds the final child records need to be re-parenting
    private List<sObject> childObjectList;
    /**
    * This method is invoked while loading the 2nd step(ChangeParent2 page)
    * Dynamically retrives the Child records related to the source record
    */
    public Pagereference getChildRecords(){
        
        try{
                //Dynamically generate the query string
                List<Sobject> soList = ChangeParentUtil.getChildRecords(oldParentId);
                    
                    //this.reparentChild(soList);
                    childObjectList = ChangeParentUtil.reParentChild(soList, (String)selectedSobject.Id);
        }catch(Exception e){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }
        return null;
    }
    
    /**
    * Get the count for all the child record 
    */
    public Map<String,Integer> childCountMap{
        get{
                return ChangeParentUtil.childCountMap;
        }
    }
    
   
    
    /**
    * Re associate the child records with the new parent record
    * Call from Finish button on 2nd page(ChangeParent2)
    */
    public Pagereference finish(){
        Pagereference pageRef;
        
        // set the save point for rollback
        Savepoint sp = Database.setSavepoint();
        try{
                if(!childObjectList.isEmpty()){
                        //update all the child records with new parent id
                        update childObjectList;
                        
                        //delete the sorce parent
                        Database.delete(oldParentId);
                }
                pageRef = new Pagereference('/'+selectedSobject.Id);
                
        
        }catch(Exception e){
                //rollback if there is any exception
                Database.rollback(sp);
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }
        
        return pageRef;
    }
    
}