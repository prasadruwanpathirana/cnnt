/********************************************************************************* 
Class Name     : MSGDirectMessageBackUpAgentWrapper.cls
Description    : 
Created By     : 
Created Date   : 

Modification Log
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------            

*********************************************************************************/

public class MSGDirectMessageBackUpAgentWrapper {
	 
    @AuraEnabled
    public List<UserDetails> lstDirectMessageUsers;
    @AuraEnabled
    public String directMssageSubject;
    @AuraEnabled
    public Integer pageSize;
    @AuraEnabled
    public Integer pageNumber;
    @AuraEnabled
    public Integer totalRecords;
    @AuraEnabled
    public Integer recordStart;
    @AuraEnabled
    public Integer recordEnd;
    @AuraEnabled
    public Id feedId;
    
    public MSGDirectMessageBackUpAgentWrapper(List<UserDetails> lstDirectMessageUsers, Id directMssageId, String directMssageSubject, Integer pageSize, Integer pageNumber,Integer totalRecords, Integer recordStart, Integer recordEnd){
        this.lstDirectMessageUsers = lstDirectMessageUsers;
        this.directMssageSubject = directMssageSubject;
        this.pageSize = pageSize;
        this.pageNumber = pageNumber;
        this.totalRecords = totalRecords;
        this.recordStart = recordStart;
        this.recordEnd = recordEnd;
        this.feedId = directMssageId;
    }
    
    public class UserDetails{
        @AuraEnabled
        public String userId;
        @AuraEnabled
        public String userFirstName;
        @AuraEnabled
        public String userLastName;
        
        public UserDetails(String firstName,String lastName,String userId){
            this.userId = userId;
            this.userFirstName = firstName;
            this.userLastName = lastName;
        }
    }
    
    public class DirectMessageComments{
        @AuraEnabled
        public DateTime commentCreatedDateTime;
        @AuraEnabled
        public String commentBody;
        @AuraEnabled
        public String commentedUserFirstName;
        @AuraEnabled
        public String commentedUserLastName;
        @AuraEnabled
        public Integer totalRecords;
        @AuraEnabled
        public Integer recordStart;
        @AuraEnabled
        public Integer recordEnd;
		@AuraEnabled
        public Id commentedUserID;
        
        public DirectMessageComments(Id commentedUserID, DateTime cmtCreatedDateTIme, String cmtBody, UserDetails user, Integer totalRecords, Integer recordStart, Integer recordEnd){
            this.commentCreatedDateTime = cmtCreatedDateTIme;
            this.commentBody = cmtBody;
            this.commentedUserFirstName = user.userFirstName;
            this.commentedUserLastName = user.userLastName;
            this.totalRecords = totalRecords;
            this.recordStart = recordStart;
            this.recordEnd = recordEnd;
            this.commentedUserID = commentedUserID;
        }
        
    }
}