public class AccountCreation {
    public static Id  createAccount(){
        Account acc = new Account(Name='TestAccount',Phone='000000000',NumberOfEmployees=1000000000);
        List<Account> accList = new List<Account>();
        accList.add(acc);
        List<Database.SaveResult> saveResultList = Database.insert(accList,false);
        System.debug('testing...');
        ErrorLog.log(saveResultList);
        return null;
    }
}