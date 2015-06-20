public class ErrorLog {
    public static void log(Database.SaveResult[] saveResult){
        if(saveResult.size()>0){
	        for (Integer count = 0; count < saveResult.size(); count++) {
	            if (!saveResult[count].isSuccess()){
	                for(Database.Error err: saveResult[count].getErrors()){
                        try{
                            throw new DMLCustomException();
                        }catch(DMLCustomException dce){
                            system.debug('stackTrace=='+dce.getStackTraceString());
                        }
	                    //setErrorRecordId.add(saveResult[count].getId());
	                    //el = new BIIB_Error_Log__c(BIIB_Failure_Record_Id__c = listOfObjects[count].Id, BIIB_Component_Name__c = className, BIIB_Error_Detail__c = (err.getMessage()).left(250), BIIB_Object__c = objectName,  BIIB_Method_Name__c = methodName, BIIB_Operation__c = operation, BIIB_Timestamp__c = system.now());
	                    //lstErrors.add(el);
	                }
	            }
	        }
        }
    }
    
    class DMLCustomException extends exception{}
}