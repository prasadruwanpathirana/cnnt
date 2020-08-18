public class reUsableMultiSelectLookupCtrl {
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName, List<sObject> ExcludeitemsList) {
       
        String sQuery;
        String userID = UserInfo.getUserId();
        
        String searchKey = '%' + searchKeyWord + '%';
        List < sObject > returnList = new List < sObject > ();
 
        List<string> lstExcludeitems = new List<string>();
        for(sObject item : ExcludeitemsList ){
            lstExcludeitems.add(item.id);
        }
        
        if(ObjectName.equals('Account')){
            
            sQuery =  'select id, Name from ' +ObjectName + ' where Name LIKE: searchKey AND OwnerId=:userID AND Id NOT IN : lstExcludeitems order by createdDate DESC limit 5';
        }else{
            sQuery =  'select id, Name from ' +ObjectName + ' where Name LIKE: searchKey AND Id NOT IN : lstExcludeitems order by createdDate DESC limit 5';
        }
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5 and exclude already selected records  

       // String sQuery =  'select id, Name from ' +ObjectName + ' where Name LIKE: searchKey  order by createdDate DESC limit 5';
        List < sObject > lstOfRecords = Database.query(sQuery);
		System.debug('$$$'+lstOfRecords);
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
}