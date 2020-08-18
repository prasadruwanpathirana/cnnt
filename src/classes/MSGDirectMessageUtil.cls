/********************************************************************************* 
Class Name     : MSGDirectMessageUtil.cls
Description    : 
Created By     : 
Created Date   : 

Modification Log
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------            

*********************************************************************************/

public with sharing class MSGDirectMessageUtil {

	//Working
	@AuraEnabled
	public static Boolean sendNewMessage(ID familyAccount, List < ID > lstOfMessageToUsers, String subject, String messageBody, String uploadedFiledID) {
		system.debug('Accessed DirectMsgUtil' + uploadedFiledID + messageBody);
		return MSGDirectMessageConnectAPI.sendNewMessage(familyAccount,lstOfMessageToUsers, subject, messageBody, uploadedFiledID);
	}

	//Insert a new record to FLMessage Object to track 
	//family and the direct message
	public static Boolean addToFLMessagetbl(String feedElementID, ID familyAccount) {
		try {
			system.debug('Accessed addToFLMessagetbl');
			FL_Message__c flMessageRecord = new FL_Message__c();
			flMessageRecord.Feed_Id__c = feedElementID;
			flMessageRecord.Family_ID__c = familyAccount;
			Database.SaveResult saveResult = Database.insert(flMessageRecord);
			if (saveResult.isSuccess()) {
				system.debug('Accessed succeed' );
				return true;
			} else {
				system.debug('Accessed not succeed');
				return false;
			}
		} catch(Exception ex) {
			system.debug('Error in addToFLMessagetbl ' + ex.getMessage() + ' ' + ex.getLineNumber() + ' ' + ex.getCause());
			return false;
		}
	}


	@AuraEnabled
	public static MSGDirectMessageWrapper.DirectMessageComments validatepostNewCommentAttachment(String feedElementId, String msgText, String fileId) {
		return MSGDirectMessageConnectAPI.validatepostNewCommentAttachment(feedElementId, msgText, fileId);
	}

	// Post new comment without any attachments
	@AuraEnabled
	public static MSGDirectMessageWrapper.DirectMessageComments postNewComment(String feedElementId, String msgText) {
		return MSGDirectMessageConnectAPI.postNewComment(feedElementId, msgText);
	}

	@AuraEnabled
	public static MSGDirectMessageWrapper.DirectMessageComments postNewCommentWithAttachement(String feedElementId, String msgText, String documentID) {
		return MSGDirectMessageConnectAPI.postNewCommentWithAttachement(feedElementId, msgText, documentID);		
	}

	//Working
	//Added By Pallavi: This method will return all Messages and Comments from Context User Point of view. Passing 'null' for pagetoken will return first page of DirectFeeditem and FeedComments on load.
	@AuraEnabled(cacheable = true)
	public static List < MSGDirectMessageWrapper > getAllMessagesFromAPIonLoad(string communityId, integer recentCommentCount, string nextPageToken, Integer pageSize) {
		return MSGDirectMessageConnectAPI.getAllMessagesFromAPIonLoad(communityId, recentCommentCount, nextPageToken, pageSize);
	}

	//Return directMessagemembers list when feedElementID is provided
	@AuraEnabled(cacheable = true)
	public static List < MSGDirectMessageWrapper.DirectMessageComments > getCommentsForFeedElement(String feedElementID) {
		return MSGDirectMessageConnectAPI.getCommentsForFeedElement(feedElementID);
	}

	@AuraEnabled(cacheable = true)
	public static MSGDirectMessageWrapper getSelectedFeedElementDetails(String feedElementID, Integer commentCount, Integer elementsPerBundle) {
		return MSGDirectMessageConnectAPI.getSelectedFeedElementDetails(feedElementID, commentCount, elementsPerBundle);
	}

	@AuraEnabled
	public static MSGDirectMessageWrapper getMessagesFromObject(Id userID) {
		return MSGDirectMessageConnectAPI.getMessagesFromObject(userID);
	}

	//working
	@AuraEnabled
	public static void addPeopleToMessage(String directMessageFeedID, List < String > lstUsers) {
		MSGDirectMessageConnectAPI.addPeopleToMessage(directMessageFeedID, lstUsers);
	}

	//working
	@AuraEnabled
	public static void removePeopleFromMessage(String directMessageFeedID, List < String > lstUsers) {
		MSGDirectMessageConnectAPI.removePeopleFromMessage(directMessageFeedID, lstUsers);
	}

	@AuraEnabled
	public static Boolean addBackupAgent(String directMessageID, List < ID > lstUsers) {
		return null;
	}

	//working
	@AuraEnabled
	public static List < MSGDirectMessageWrapper > nextFeedItem(string communityId, integer recentCommentCount, string nextPageToken, Integer pageSize) {
		return MSGDirectMessageConnectAPI.nextFeedItem(communityId, recentCommentCount, nextPageToken, pageSize);
	}

	//working    
	@AuraEnabled
	public static List < MSGDirectMessageWrapper > previousFeedItem(string communityId, integer recentCommentCoun, string previousPageToken, Integer pageSize) {
		return MSGDirectMessageConnectAPI.previousFeedItem(communityId, recentCommentCoun, previousPageToken, pageSize);
	}

	//working
	@AuraEnabled
	public static List < MSGDirectMessageWrapper.DirectMessageComments > nextFeedComment(string communityId, string feedId, string nextPageToken, integer pageSize, boolean threadedCommentsCollapsed) {
		return MSGDirectMessageConnectAPI.nextFeedComment(communityId, feedId, nextPageToken, pageSize, threadedCommentsCollapsed);
	}

	//working
	@AuraEnabled
	public static List < MSGDirectMessageWrapper.DirectMessageComments > previousFeedComment(string communityId, string feedId, string previousPageToken, integer pageSize, boolean threadedCommentsCollapsed) {
		return MSGDirectMessageConnectAPI.previousFeedComment(communityId, feedId, previousPageToken, pageSize, threadedCommentsCollapsed);
	}
/*
	public static ConnectApi.FeedElementPage getFeedItemFromConnectAPI(string communityId, Integer recentCommentCount, string pageToken, Integer pageSize, ConnectApi.FeedSortOrder sortOrder) {
		return ConnectApi.ChatterFeeds.getFeedElementsFromFeed(communityId, ConnectApi.FeedType.DirectMessages, recentCommentCount, ConnectApi.FeedDensity.AllUpdates, pageToken, pageSize, sortOrder);
	}
	public static ConnectApi.CommentPage getFeedCommentFromConnectAPI(string communityId, string feedElementId, string pageToken, Integer pageSize, Boolean threadedCommentsCollapsed, ConnectApi.FeedCommentSortOrder sortOrder) {
		return ConnectApi.ChatterFeeds.getCommentsForFeedElement(communityId, feedElementId, pageToken, pageSize, threadedCommentsCollapsed, sortOrder);
	} */
/*
	public static MSGDirectMessageWrapper.DirectMessageComments getCommentsFromApi(ConnectApi.Comment comment) {
		String message = getMessagebodyFromApi(comment.body.messageSegments);
		if (comment.capabilities != null && comment.capabilities.content != null) {
			message += '<a href="' + comment.capabilities.content.downloadUrl + '">' + comment.capabilities.content.title + '.' + comment.capabilities.content.fileExtension + '</a>';
		}
		System.debug('###' + comment.user);
		return new MSGDirectMessageWrapper.DirectMessageComments(comment.createdDate, message, new MSGDirectMessageWrapper.UserDetails(comment.user.firstName, comment.user.lastName, comment.user.id), comment.id);
	} */
/*
	public static MSGDirectMessageWrapper.DirectMessageFeed getFeedDetailsFromApi(ConnectApi.FeedElement feedElement) {

		MSGDirectMessageWrapper.UserDetails initiatedUser;

		List < MSGDirectMessageWrapper.DirectMessageComments > lstDirectMsgComments = new List < MSGDirectMessageWrapper.DirectMessageComments > ();
		//String messageBody = getMessagebodyFromApi(feedElement.header.messageSegments);

		if (feedElement.feedElementType == ConnectApi.FeedElementType.FeedItem) {

			ConnectApi.FeedItem feedItem = (ConnectApi.FeedItem) feedElement;
			ConnectApi.UserSummary user = (ConnectApi.UserSummary) feedItem.actor;
			initiatedUser = new MSGDirectMessageWrapper.UserDetails(user.firstName, user.lastName, user.id);

		}

		String messageBody = feedElement.body.text;

		if (feedElement.capabilities.files != null) {
			for (ConnectApi.Content con: feedElement.capabilities.files.items) {

				messageBody += '<br>';
				messageBody += '<a href="' + con.downloadUrl + '">' + con.title + '.' + con.fileType + '</a>';
			}
		}
		//System.debug('### ItemCount '+ feedElement.capabilities.files.items.size());

		for (ConnectApi.Comment comment: feedElement.capabilities.comments.page.items) {
			lstDirectMsgComments.add(getCommentsFromApi(comment));
		}
		MSGDirectMessageWrapper.DirectMessageFeed feed = new MSGDirectMessageWrapper.DirectMessageFeed(feedElement.createdDate, messageBody, feedElement.id, lstDirectMsgComments, initiatedUser);
		return feed;
	} */
/*
	public static String getMessagebodyFromApi(List < ConnectApi.MessageSegment > messageSegments) {
		String message = '';
		for (ConnectApi.MessageSegment msgSegment: messageSegments) {
			if (msgSegment instanceof ConnectApi.HashtagSegment) {
				ConnectApi.HashtagSegment hashtagOutput = (ConnectApi.HashtagSegment) msgSegment;
				message += hashtagOutput.tag;
			} else if (msgSegment instanceof ConnectApi.InlineImageSegment) {
				ConnectApi.InlineImageSegment imageSeg = (ConnectApi.InlineImageSegment) msgSegment;
				message += '<img src="' + imageSeg.url + ' data-fileid="" alt="' + imageSeg.altText + '">';
			} else if (msgSegment instanceof ConnectApi.LinkSegment) {
				ConnectApi.LinkSegment linkOutput = (ConnectApi.LinkSegment) msgSegment;
				message += linkOutput.url;
			} else if (msgSegment instanceof ConnectApi.MarkupBeginSegment) {
				ConnectApi.MarkupBeginSegment markUpBegin = (ConnectApi.MarkupBeginSegment) msgSegment;
				message += '<' + markUpBegin.htmlTag + '>';
			} else if (msgSegment instanceof ConnectApi.MarkupEndSegment) {
				ConnectApi.MarkupEndSegment markUpEnd = (ConnectApi.MarkupEndSegment) msgSegment;
				message += '</' + markUpEnd.htmlTag + '>';
			} else if (msgSegment instanceof ConnectApi.MentionSegment) {
				ConnectApi.MentionSegment mentionOutput = (ConnectApi.MentionSegment) msgSegment;
				message += mentionOutput.record.id;
			} else if (msgSegment instanceof ConnectApi.TextSegment) {
				ConnectApi.TextSegment textOutput = (ConnectApi.TextSegment) msgSegment;
				message += textOutput.text;
			}
		}
		return message;
	} */

	//TBD... working @Vamsi
	@AuraEnabled
	public static boolean feedToggleMarked(boolean flflag, ID feedID) {
		return MSGDirectMessageConnectAPI.feedToggleMarked(flflag, feedID);
	}

	//File Uploader
	@AuraEnabled
	public static Id saveChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId) {
		return MSGDirectMessageConnectAPI.saveChunk(parentId, fileName, base64Data, contentType, fileId);
	}

	//File Uploader
	@AuraEnabled
	public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType) {
		return MSGDirectMessageConnectAPI.saveTheFile(parentId, fileName, base64Data, contentType);
	}

	//File Uploader
	@AuraEnabled
	public static void appendToFile(Id fileId, String base64Data) {
		MSGDirectMessageConnectAPI.appendToFile(fileId, base64Data);
	}
    
	public MSGDirectMessageUtil() {}
/*
	public static String getCommunityId() {
		List < Network > customCommunity = [select Id, name from network where name = 'pocconectapi' ];
		if (customCommunity != null && customCommunity.size() > 0) {
			return customCommunity[0].Id;
		}
		return null;
	} */
    
    	// Post new comment with attachement
	/* @AuraEnabled
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
    }*/
    
    //Working
	/* @AuraEnabled
    public static Boolean sendNewMessage(ID familyAccount,List<ID> lstOfMessageToUsers,String subject,String messageBody,String uploadedFiledID){
        system.debug('Accessed DirectMsgUtil'+uploadedFiledID+messageBody);
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

         
               //File Input Capability // Commented part uncommented
                ConnectApi.FileIdInput fileIdInput = new ConnectApi.FileIdInput();
                fileIdInput.id = uploadedFiledID;
                //fileIdInput.operationType = ConnectApi.OperationType.Add;
                system.debug('@@@ ' + fileIdInput.id + ' ' + fileIdInput.operationType );
                ConnectApi.FilesCapabilityInput fileInput = new ConnectApi.FilesCapabilityInput();
                fileInput.items = new List<ConnectApi.FileIdInput>();
                List<ConnectApi.FileIdInput> lstFileId = new List<ConnectApi.FileIdInput>();
                lstFileId.add(fileIdInput);
                fileInput.items = lstFileId;
                // fileInput.items.add(fileIdInput);
              
                
            // The FeedElementCapabilitiesInput object holds the capabilities of the feed item.
            ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput = new ConnectApi.FeedElementCapabilitiesInput();

            // The FeedElementCapabilitiesInput object holds the capabilities of the feed item.
            feedElementCapabilitiesInput.directMessage = dmInput;
            feedItemInput.capabilities = feedElementCapabilitiesInput;
            feedElementCapabilitiesInput.files = fileInput;
            system.debug('feedElementCapabilitiesInput----'+feedElementCapabilitiesInput);
            
            // Post the feed item. 
            ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(getCommunityId(), feedItemInput);
                        system.debug('feedElement----'+feedElement);
            for(ConnectApi.Content con: feedElement.capabilities.files.items)
            {
             system.debug(' my file id'+con.id); 
             system.debug(' my file fileType'+con.fileType);                
             system.debug(' my file title'+con.title); 
             System.debug(' Download URL '+con.downloadUrl);
             System.debug(' Description '+con.description);
           
                
            }
            System.debug('###'+feedElement.id);
                if(String.isNotEmpty(feedElement.id)){
                    return addToFLMessagetbl(feedElement.id,familyAccount);
                }else{
                    return false;
                }
        }catch(Exception ex){
            system.debug('Error in DirectMsgUtil ' + ex.getMessage() + ' ' + ex.getLineNumber() + ' ' + ex.getCause() );
            return false;
        }
    }*/
    
    	//To get Id's from Community 

	// Common method for checking attachements in posting new comment
	/* @AuraEnabled
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
    } */
    
    
    @AuraEnabled
    public static List<DirectMessageWrapper> paginationFeedItemFromObject(Id agentId, Integer pageNumber, Integer pageSize){
    	return MSGDirectMessageQuery.paginationFeedItemFromObject(agentId, pageNumber, pageSize);
    }
    
    @AuraEnabled
    public static List<Id> getDirectMsgIdList(Id agentId){
		return MSGDirectMessageQuery.getDirectMsgIdList(agentId);
    }
    
    @AuraEnabled
    public static DirectMessageWrapper paginationFeedCommentFromObject(Id directMsgId, Integer pageNumber, Integer pageSize){
        return MSGDirectMessageQuery.paginationFeedCommentFromObject(directMsgId, pageNumber, pageSize);
    }
    
    
     @AuraEnabled
    public static Boolean addBackupAdivisors(List<Object> lstOfUsers){
        
        Boolean finalResult;
        List<FL_Backup_Agent__c> lstOfBackupUsers = new List<FL_Backup_Agent__c>();
        
        String currentUserID = UserInfo.getUserId();
        
        for(Object usr:lstOfUsers){
            
            Map<Object,Object> userMap = (Map<Object,Object>)usr;

            FL_Backup_Agent__c backupAgent = new FL_Backup_Agent__c();
            backupAgent.Agent__c = currentUserID;
            backupAgent.Backup_Agent__c = (Id)userMap.get('Id');
            backupAgent.Name = (String)userMap.get('Name');
            
            lstOfBackupUsers.add(backupAgent);
        }
        
        List<Database.UpsertResult> upsertResults = Database.upsert(lstOfBackupUsers);
        
        for(Database.UpsertResult upsertResult:upsertResults){
            
            if(upsertResult.isSuccess()){
                finalResult = true;
            }else{
                finalResult = false;
                break;
            }
            
        }
     
        return finalResult;   
    }

    
}