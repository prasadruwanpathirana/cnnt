public without sharing class DirectMessageWrapper {
    
    @AuraEnabled
    public List<UserDetails> lstDirectMessageUsers;
    @AuraEnabled
    public String directMssageSubject;
    @AuraEnabled
    public DirectMessageFeed directMessageFeed;
    @AuraEnabled
    public FLMesssage flMessage;
    @AuraEnabled
    public FLBackupAgent flbackupagent;
    @AuraEnabled
    public String currentPageToken;
    @AuraEnabled
    public String nextPageToken;
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
    @AuraEnabled
    public UserDetails initatedUser; 
    
    public DirectMessageWrapper(List<UserDetails> lstDirectMessageUsers,String directMssageSubject,
                                DirectMessageFeed lstdirectMessageFeed,FLMesssage flMessage,FLBackupAgent flbackupagent,
                                String currentPageToken,String nextPageTokent){
                               
                                    this.lstDirectMessageUsers = lstDirectMessageUsers;
                                    this.directMessageFeed = lstdirectMessageFeed;
                                    this.directMssageSubject = directMssageSubject;
                                    this.flMessage = flMessage;
                                    this.flbackupagent = flbackupagent;
                                    this.currentPageToken = currentPageToken;
                                    this.nextPageToken = nextPageTokent;

                                }
    
    public DirectMessageWrapper(Id directMssageId, String directMssageSubject, Integer pageSize, Integer pageNumber,Integer totalRecords, Integer recordStart, Integer recordEnd, FLMesssage flMessage, UserDetails user){   
        this.directMssageSubject = directMssageSubject;
        this.pageSize = pageSize;
        this.pageNumber = pageNumber;
        this.totalRecords = totalRecords;
        this.recordStart = recordStart;
        this.recordEnd = recordEnd;
        this.feedId = directMssageId;
        this.flMessage = flMessage;
        this.initatedUser = user;
    }
    
    public DirectMessageWrapper(List<UserDetails> lstDirectMessageUsers, String directMssageSubject, DirectMessageFeed directMessageFeed, Integer totalRecords, Integer recordStart, Integer recordEnd, FLMesssage flMessage){
        this.lstDirectMessageUsers = lstDirectMessageUsers;
        this.directMessageFeed = directMessageFeed;
        this.directMssageSubject = directMssageSubject;
        this.flMessage = flMessage;
        this.totalRecords = totalRecords;
        this.recordStart = recordStart;
        this.recordEnd = recordEnd;
    }
    
    /*Store Message Feed Related Data
     */
    public class DirectMessageFeed{
        @AuraEnabled  
        public DateTime directMessageFeedCreatedDateTime;
        @AuraEnabled
        public UserDetails initatedUser;
        @AuraEnabled
        public String directMessageFeedBody;
        @AuraEnabled
        public String directMessageFeedID;
        @AuraEnabled
        public String currentPageToken;
        @AuraEnabled
        public String previousPageToken;
        @AuraEnabled
        public String nextPageToken;
        @AuraEnabled
        public list<DirectMessageComments> directFeedComments;
       
        public DirectMessageFeed(DateTime feedCreatedDateTime,String feedBody,String feedID, list<DirectMessageComments> feedComments,UserDetails user){
            this.directFeedComments= new list<DirectMessageComments> ();
            this.directMessageFeedCreatedDateTime = feedCreatedDateTime;
            this.directMessageFeedBody = feedBody;
            this.directMessageFeedID = feedID;
            this.directFeedComments = feedComments;
            this.initatedUser = user;
        }
    }
    
    /*
     * Stores Comment data
     */ 
    public class DirectMessageComments{
        @AuraEnabled
        public DateTime commentCreatedDateTime;
        @AuraEnabled
        public Id commentID;
        @AuraEnabled
        public String commentBody;
        @AuraEnabled
        public String commentedUserFirstName;
        @AuraEnabled
        public String commentedUserLastName;
        @AuraEnabled
        public String commentedUserID;
        @AuraEnabled
        public String hovercomments;
               
        public DirectMessageComments(DateTime cmtCreatedDateTIme,String cmtBody,UserDetails user,Id commentID){
            this.commentCreatedDateTime = cmtCreatedDateTIme; 
            
            this.hovercomments = cmtBody.replaceAll('\\<.*?\\>', '');  
            this.commentBody = cmtBody;
            this.commentedUserFirstName = user.userFirstName;
            this.commentedUserLastName = user.userLastName;
            this.commentID = commentID;
            this.commentedUserID = user.userId;
        }
        
        public DirectMessageComments(Id commentedUserID, DateTime cmtCreatedDateTime, String cmtBody, UserDetails user){
            this.commentCreatedDateTime = cmtCreatedDateTime;
            this.commentBody = cmtBody;
            this.commentedUserFirstName = user.userFirstName;
            this.commentedUserLastName = user.userLastName;
            this.commentedUserID = commentedUserID;
        }
        
    }
    
    /*
     * Stores User relatedData
     */ 
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
    
    /*
     * Stores data to uniqule identify 
     * initiated message with the account
     */ 
    public class FLMesssage{
         @AuraEnabled
        public String feedId;
         @AuraEnabled
        public ID familyID;
         @AuraEnabled
        public Boolean marked;
        @AuraEnabled
        public String accountName;
        
        public FLMesssage(String feedID,ID familyID,Boolean marked,String accountName){
            
            this.feedId = feedID;
            this.familyID = familyID;
            this.marked = marked;
            this.accountName = accountName;
        }
        
        public FLMesssage(String feedID,ID familyID,Boolean marked){
            
            this.feedId = feedID;
            this.familyID = familyID;
            this.marked = marked;
            this.accountName = accountName;
        }
        
    }
    
    /*
     * Stores data when backup 
     * agents are utilized
     */ 
    public class FLBackupAgent{
        @AuraEnabled
        public ID agent;
        @AuraEnabled
        public ID backupAgent;
        
        public FLBackupAgent(ID agent, ID backupAgent){
            this.agent = agent;
            this.backupAgent = backupAgent;
        }
    }
}