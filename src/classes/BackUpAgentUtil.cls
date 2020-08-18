public  with sharing class BackUpAgentUtil {
    
    public static String getCommunityId(){
        List<Network> customCommunity =[select Id,name from network  where name='pocconectapi'];
        if(customCommunity!=null && customCommunity.size()>0){
            return customCommunity[0].Id;
        }
        return null;
    }
      
    @AuraEnabled
    public static Boolean sendNewMessage(ID familyAccount,List<ID> lstOfMessageToUsers,String subject,String messageBody,String uploadedFiledID){
        
        try{
            
            // Define the FeedItemInput object to pass to postFeedElement
            ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
            
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
            textSegmentInput.text = messageBody;  
            
            // The MessageBodyInput object holds the text in the post
            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
            messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
            messageBodyInput.messageSegments.add(textSegmentInput);
            feedItemInput.body = messageBodyInput;
            
            //Direct Message Capability
            ConnectApi.DirectMessageCapabilityInput dmInput = new ConnectApi.DirectMessageCapabilityInput();
            dmInput.subject = subject;
            dmInput.membersToAdd = lstOfMessageToUsers;
            
            //File Input Capability
            /*ConnectApi.FileIdInput fileIdInput = new ConnectApi.FileIdInput();
            fileIdInput.id = uploadedFiledID;
            fileIdInput.operationType = ConnectApi.OperationType.Add;
            ConnectApi.FilesCapabilityInput fileInput = new ConnectApi.FilesCapabilityInput();
            fileInput.items.add(fileIdInput);*/
            
            // The FeedElementCapabilitiesInput object holds the capabilities of the feed item.
            ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput = new ConnectApi.FeedElementCapabilitiesInput();
            feedElementCapabilitiesInput.directMessage = dmInput;
            //feedElementCapabilitiesInput.files = fileInput;
            feedItemInput.capabilities = feedElementCapabilitiesInput;
            
            // Post the feed item. 
            ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(getCommunityId(), feedItemInput);
            System.debug('###'+feedElement.id);
            if(String.isNotEmpty(feedElement.id)){
                return addToFLMessagetbl(feedElement.id,familyAccount);
            }else{
                return false;
            }
        }catch(Exception ex){
            return false;
        }
    }
    
    //Insert a new record to FLMessage Object to track 
    //family and the direct message
    public static Boolean addToFLMessagetbl(String feedElementID,ID familyAccount){
        try{
            FL_Message__c flMessageRecord = new FL_Message__c();
            flMessageRecord.Feed_Id__c = feedElementID;
            flMessageRecord.Family_ID__c = familyAccount;
            Database.SaveResult saveResult =  Database.insert(flMessageRecord);
            if(saveResult.isSuccess()){
                return true;
            }else{
                return false;
            }
        }catch(Exception ex){
            return false;
        }
    }
    
    // Common method for checking attachements in posting new comment
    @AuraEnabled
    public static void validatepostNewCommentAttachment(String feedElementId, String msgText, String fileId, String fileType ){
        if(!String.isBlank(fileId)) {
            if(fileType == 'png' || fileType == 'jpg' || fileType == 'jpeg'){
                postNewCommentWithImage(feedElementId, msgText, fileId);
            } else {
                postNewCommentWithAttachement(feedElementId, msgText, fileId);
            }
        } else {
            postNewComment(feedElementId, msgText);
        }
    } 
    
    // Post new comment without any attachments
    @AuraEnabled 
    public static Boolean postNewComment(String feedElementId, String msgText){
        String communityId = getCommunityId();
        ConnectApi.CommentInput input = new ConnectApi.CommentInput();
        ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
        ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
        messageInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
        textSegment.text = msgText;
        messageInput.messageSegments.add(textSegment);
        input.body = messageInput;
        ConnectApi.Comment commentRep = ConnectApi.ChatterFeeds.postCommentToFeedElement(communityId, feedElementId, input, null);
        if(commentRep != NULL){
            return true;
        }else{
            return false;
        }
    }
    
    // Post new comment with inline image
    @AuraEnabled
    public static void postNewCommentWithImage(String feedElementId, String msgText, String imageId){
        String communityId = getCommunityId();
        ConnectApi.CommentInput input = new ConnectApi.CommentInput();
        ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
        ConnectApi.TextSegmentInput textSegment;
        ConnectApi.InlineImageSegmentInput inlineImageSegment;
        messageInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
        textSegment = new ConnectApi.TextSegmentInput();
        textSegment.text = msgText;
        messageInput.messageSegments.add(textSegment);
        inlineImageSegment = new ConnectApi.InlineImageSegmentInput();
        inlineImageSegment.fileId = imageId;
        messageInput.messageSegments.add(inlineImageSegment);
        input.body = messageInput;
        ConnectApi.ChatterFeeds.postCommentToFeedElement(communityId, feedElementId, input, null);
    }    
    
    // Post new comment with attachement
    @AuraEnabled
    public static void postNewCommentWithAttachement(String feedElementId, String msgText, String documentID ){
        String communityId = getCommunityId();
        ConnectApi.CommentInput commentInput = new ConnectApi.CommentInput();
        ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
        ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
        ConnectApi.CommentCapabilitiesInput commentCapabilitiesInput = new ConnectApi.CommentCapabilitiesInput();
        ConnectApi.ContentCapabilityInput contentCapabilityInput = new ConnectApi.ContentCapabilityInput();
        messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
        textSegmentInput.text = msgText;
        messageBodyInput.messageSegments.add(textSegmentInput);
        commentInput.body = messageBodyInput;
        contentCapabilityInput.contentDocumentId = documentID;
        commentCapabilitiesInput.content = contentCapabilityInput;
        commentInput.capabilities = commentCapabilitiesInput;
        ConnectApi.Comment commentRep = ConnectApi.ChatterFeeds.postCommentToFeedElement(communityId, feedElementId, commentInput, null);
    }
    
    @AuraEnabled
    public static void addPeopleToMessage(String directMessageFeedID, List<String> lstUsers){
        String communityId = getCommunityId();
        ConnectApi.DirectMessageCapabilityInput directMessageInput = new ConnectApi.DirectMessageCapabilityInput();
        directMessageInput.membersToAdd = lstUsers;
        ConnectApi.DirectMessageCapability addMember = ConnectApi.ChatterFeeds.updateDirectMessage(communityId, directMessageFeedID, directMessageInput);
    }
    
    @AuraEnabled
    public static void removePeopleFromMessage(String directMessageFeedID,List<String> lstUsers){
        String communityId = getCommunityId();
        ConnectApi.DirectMessageCapabilityInput directMessageInput = new ConnectApi.DirectMessageCapabilityInput();        
        directMessageInput.membersToRemove = lstUsers;
        ConnectApi.DirectMessageCapability addMember = ConnectApi.ChatterFeeds.updateDirectMessage(communityId, directMessageFeedID, directMessageInput);
    }
    
    @AuraEnabled
    public static Boolean addBackupAgent(String directMessageID, List<ID> lstUsers, Id userId){
        List<FL_Backup_Agent__c> lstBackupAgent = new List<FL_Backup_Agent__c>();
        for(Id agentId : lstUsers){
            FL_Backup_Agent__c backupAgent = new FL_Backup_Agent__c(Agent__c = userId, Backup_Agent__c = agentId);
            lstBackupAgent.add(backupAgent);
        }
        if(lstBackupAgent.size() > 0){
            try{
                insert lstBackupAgent;
                return true;
            } Catch (exception e){
                System.debug('Exception : ' + e);
            }
        }
        return false;
    }
    
   	@AuraEnabled
    public static  boolean feedToggleMarked (boolean flflag, ID feedID ){
        try{
            List<FL_Message__c> lstflMsg = [ SELECT Id, Marked__c, Feed_Id__c FROM FL_Message__c WHERE Feed_Id__c = : feedID ];
            lstflMsg[0].Marked__c = flflag;
            update lstflMsg;
            system.debug('@#$ ' + flflag + ' ' + feedID + ' ' + lstflMsg[0].Marked__c);
            return true;
        } catch (exception ex) {
            system.debug('Error ' + ex.getMessage() );
            return false;
        }
    }
    
    @AuraEnabled
    public static List<Id> getDirectMsgIdList(Id agentId){
        
        List<DirectMessageMember> directMsgList = [select DirectMessageId from DirectMessageMember where MemberId = :agentId];
        if(directMsgList!=null && directMsgList.size()>0){
            List<Id> directMsgIdList = new List<Id>();
            for (DirectMessageMember member : directMsgList){
                directMsgIdList.add(member.DirectMessageId);
            }
            return directMsgIdList;
        }
        return null;
    }
    
    @AuraEnabled
    public static List<DirectMessageWrapper> paginationFeedItemFromObject(Id agentId, Integer pageNumber, Integer pageSize){
        
        Integer pSize = (Integer)pageSize;
        Integer pNumber = (Integer)pageNumber;
        
        //Offset for SOQL
        Integer offset = (pNumber - 1) * pSize;
        Integer recordStart = offset + 1;
        
        List<Id> directMsgIdList = getDirectMsgIdList(agentId);
       
        List<DirectMessageFeed> totalDirectMessages = [SELECT Parent.Id, Parent.Subject, LastModifiedDate, CreatedById, ParentId FROM DirectMessageFeed WHERE ParentId IN :directMsgIdList ORDER BY LastModifiedDate DESC];
        
        //Total Records
        Integer totalRecords = (totalDirectMessages.size());
        Integer recordEnd = pSize * pNumber;
        
        List<DirectMessageFeed> listofDirectMessages = [SELECT Id, Parent.Id, Parent.Subject, CreatedById, LastModifiedDate, ParentId FROM DirectMessageFeed WHERE ParentId IN :directMsgIdList ORDER BY LastModifiedDate DESC LIMIT :pSize OFFSET :offset];
        List<DirectMessageMember> listofDirectMsgMembers = [SELECT DirectMessageId, MemberId FROM DirectMessageMember WHERE DirectMessageId IN :directMsgIdList AND MemberId != :agentId];
		
        System.debug('listofDirectMessages : ' + listofDirectMessages.size());        
        
        List<Id> memberIds = new List<Id>();
        for(DirectMessageMember d : listofDirectMsgMembers) {
            memberIds.add(d.MemberId);
        }
        
        List<User> listUserDetails = [SELECT Id, FirstName, LastName FROM User];
        
        Map<Id, User> userDetails = new Map<Id, User>();
        for(User us : listUserDetails) {
            userDetails.put(us.Id, us);
        }
        
        List<Id> listFeedIds = new List<Id>();
        for (DirectMessageFeed dirMsgFeed: listofDirectMessages) {
			listFeedIds.add(dirMsgFeed.Id);
		}
        
        Map<ID, ID> listFLMessageIDs = new Map<ID, ID>();
        
        List <FL_Message__c> listFLMessage = [SELECT Id, Marked__c, Feed_Id__c, Family_ID__c, Family_ID__r.Name FROM FL_Message__c WHERE Feed_Id__c in :listFeedIds];

		for (FL_Message__c flMsg: listFLMessage) {
			listFLMessageIDs.put(flMsg.Feed_Id__c, flMsg.Family_ID__c);
		}
        
        List<DirectMessageWrapper> lstDirectMessages = new List<DirectMessageWrapper>();
        for(DirectMessageFeed dirMsgFeed : listofDirectMessages){
             
            String accName = '';
			Boolean isMarked = false;
			for (FL_Message__c flmsg: listFLMessage) {
				if (flmsg.Feed_Id__c == dirMsgFeed.id) {
					isMarked = flmsg.Marked__c;
					accName = flmsg.Family_ID__r.Name;
				}
			}
            
            User us = userDetails.get(dirMsgFeed.CreatedById);
            lstDirectMessages.add(new DirectMessageWrapper(dirMsgFeed.Parent.Id, dirMsgFeed.Parent.Subject, pSize, pNumber, totalRecords, recordStart, recordEnd,
                                                                      new DirectMessageWrapper.FLMesssage(dirMsgFeed.id, listFLMessageIDs.get(dirMsgFeed.id), isMarked, accName),
                                                                      new DirectMessageWrapper.UserDetails(us.firstName,us.lastName,us.id))); 
        }
        return lstDirectMessages;
    }
    
    @AuraEnabled
    public static DirectMessageWrapper paginationFeedCommentFromObject(Id directMsgId, Integer pageNumber, Integer pageSize){
        
        Integer pSize = (Integer)pageSize;
        Integer pNumber = (Integer)pageNumber;
        System.debug('pSize : ' + pSize);
        System.debug('pNumber : ' + pNumber);
        Integer recordStart = (((pNumber - 1) * pSize) + 1);
        Integer recordEnd = (pSize * pNumber);
        
        Integer offset = ((pNumber - 1) * pSize) - 1;
        if(pNumber == 1){
            offset = 0;
            pSize = (Integer)pageSize -1;
        }
        
        
        DirectMessageFeed directMsgFeed = [SELECT Id, ParentId, Parent.Subject, CreatedById, CreatedDate, CommentCount, Body, InsertedById FROM DirectMessageFeed WHERE ParentId =: directMsgId];
        System.debug('directMsgFeed : ' + directMsgFeed);
        List<FeedComment> listofFeedComments = [SELECT Id, FeedItemId, ParentId, CreatedById, CreatedDate, CommentBody, InsertedById, ThreadLastUpdatedDate FROM FeedComment
                                                WHERE ParentId =: directMsgId ORDER BY CreatedDate ASC LIMIT :pSize OFFSET :offset];
        //System.debug('listofFeedComments : ' + listofFeedComments);
        
        List<DirectMessageMember> listofDirectMsgMembers = [SELECT MemberId FROM DirectMessageMember WHERE DirectMessageId = :directMsgId];
        
        List<Id> memberIds = new List<Id>();
        for(DirectMessageMember d : listofDirectMsgMembers) {
            memberIds.add(d.MemberId);
        }
        
        List<User> listUserDetails = [SELECT Id, FirstName, LastName FROM User WHERE Id IN :memberIds];
        
        Map<Id, User> userDetails = new Map<Id, User>();
        for(User us : listUserDetails) {
            userDetails.put(us.Id, us);
        }
        
        //Total Records
        Integer totalRecords = directMsgFeed.CommentCount + 1;
        
        FL_Message__c flMessage = [SELECT Id, Marked__c, Feed_Id__c, Family_ID__c, Family_ID__r.Name FROM FL_Message__c WHERE Feed_Id__c = :directMsgFeed.Id];
            
        List<DirectMessageWrapper.UserDetails> lstOfDirectMsgUsers = new List<DirectMessageWrapper.UserDetails>();
        for(User user : listUserDetails) {
            lstOfDirectMsgUsers.add(new DirectMessageWrapper.UserDetails(user.firstName, user.lastName, user.id));
        }
        
        String accName = flMessage.Family_ID__r.Name;
        Boolean isMarked = flMessage.Marked__c;
        
        Integer i = 1;
        DirectMessageWrapper lstFeedComments;
        List<DirectMessageWrapper.DirectMessageComments> lstComments = new List<DirectMessageWrapper.DirectMessageComments>();
        DirectMessageWrapper.FLMesssage flMsg;
        DirectMessageWrapper.UserDetails initiatedUser;
        DirectMessageWrapper.DirectMessageFeed directMessageFeed;

        if(directMsgFeed.CommentCount == 0){
            
            User u = userDetails.get(directMsgFeed.CreatedById);
            lstComments.add(new DirectMessageWrapper.DirectMessageComments(directMsgFeed.CreatedById, directMsgFeed.CreatedDate, directMsgFeed.Body, new DirectMessageWrapper.UserDetails(u.firstName, u.lastName, u.id)));
            flMsg = new DirectMessageWrapper.FLMesssage(directMsgFeed.id, flMessage.id, isMarked, accName);
            initiatedUser = new DirectMessageWrapper.UserDetails(u.FirstName, u.LastName, u.Id);
            directMessageFeed = new DirectMessageWrapper.DirectMessageFeed(directMsgFeed.CreatedDate, directMsgFeed.Body, (String)directMsgFeed.Id, lstComments, initiatedUser);
            lstFeedComments = new DirectMessageWrapper(lstOfDirectMsgUsers, directMsgFeed.Parent.Subject, directMessageFeed,  totalRecords, recordStart, recordEnd, flMsg);
        } else {
            if(pNumber == 1 && i==1){
                User u = userDetails.get(directMsgFeed.CreatedById);
                lstComments.add(new DirectMessageWrapper.DirectMessageComments(directMsgFeed.CreatedById, directMsgFeed.CreatedDate, directMsgFeed.Body, new DirectMessageWrapper.UserDetails(u.firstName, u.lastName, u.id)));
                initiatedUser = new DirectMessageWrapper.UserDetails(u.FirstName, u.LastName, u.Id);
                i++;
            } 
            for(FeedComment feedCmt : listofFeedComments){
                User u = userDetails.get(feedCmt.CreatedById);
                lstComments.add(new DirectMessageWrapper.DirectMessageComments(feedCmt.CreatedById, feedCmt.CreatedDate, feedCmt.CommentBody , new DirectMessageWrapper.UserDetails(u.firstName, u.lastName, u.id)));
                flMsg = new DirectMessageWrapper.FLMesssage(feedCmt.id, flMessage.id, isMarked, accName);
            }
            directMessageFeed = new DirectMessageWrapper.DirectMessageFeed(directMsgFeed.CreatedDate, directMsgFeed.Body, (String)directMsgFeed.Id, lstComments, initiatedUser);
            lstFeedComments = new DirectMessageWrapper(lstOfDirectMsgUsers, directMsgFeed.Parent.Subject, directMessageFeed,  totalRecords, recordStart, recordEnd, flMsg);
        }
        
        System.debug('lstFeedComments : ' + lstFeedComments);
        return lstFeedComments;
    }
}