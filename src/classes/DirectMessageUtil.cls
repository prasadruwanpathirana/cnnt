public with sharing class DirectMessageUtil {

	public DirectMessageUtil() {}

	public static String getCommunityId() {
		List < Network > customCommunity = [select Id, name from network where name = 'pocconectapi'];
		if (customCommunity != null && customCommunity.size() > 0) {
			return customCommunity[0].Id;
		}
		return null;
	}

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

	//Working
	@AuraEnabled
	public static Boolean sendNewMessage(ID familyAccount, List < ID > lstOfMessageToUsers, String subject, String messageBody, String uploadedFiledID) {
		system.debug('Accessed DirectMsgUtil' + uploadedFiledID + messageBody);
		try {

			if (uploadedFiledID != NULL) {
				system.debug('Accessed with attachment');
				// Define the FeedItemInput object to pass to postFeedElement
				ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();

				ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
				if (messageBody != NULL) {
					textSegmentInput.text = messageBody;
				}
				else {
					textSegmentInput.text = 'Posted a file. ';
				}

				// The MessageBodyInput object holds the text in the post
				ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
				messageBodyInput.messageSegments = new List < ConnectApi.MessageSegmentInput > ();
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
				system.debug('@@@ ' + fileIdInput.id + ' ' + fileIdInput.operationType);
				ConnectApi.FilesCapabilityInput fileInput = new ConnectApi.FilesCapabilityInput();
				fileInput.items = new List < ConnectApi.FileIdInput > ();
				List < ConnectApi.FileIdInput > lstFileId = new List < ConnectApi.FileIdInput > ();
				lstFileId.add(fileIdInput);
				fileInput.items = lstFileId;
				// fileInput.items.add(fileIdInput);
				// The FeedElementCapabilitiesInput object holds the capabilities of the feed item.
				ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput = new ConnectApi.FeedElementCapabilitiesInput();

				// The FeedElementCapabilitiesInput object holds the capabilities of the feed item.
				feedElementCapabilitiesInput.directMessage = dmInput;
				feedItemInput.capabilities = feedElementCapabilitiesInput;
				feedElementCapabilitiesInput.files = fileInput;
				system.debug('feedElementCapabilitiesInput----' + feedElementCapabilitiesInput);

				// Post the feed item. 
				ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(getCommunityId(), feedItemInput);
				system.debug('feedElement----' + feedElement);
				for (ConnectApi.Content con: feedElement.capabilities.files.items) {
					system.debug(' my file id' + con.id);
					system.debug(' my file fileType' + con.fileType);
					system.debug(' my file title' + con.title);
					System.debug(' Download URL ' + con.downloadUrl);
					System.debug(' Description ' + con.description);
				}
				System.debug('###' + feedElement.id);
				if (String.isNotEmpty(feedElement.id)) {
					return addToFLMessagetbl(feedElement.id, familyAccount);
				} else {
					return false;
				}
			}
			else {
				system.debug('Accessed without attachment');
				// Define the FeedItemInput object to pass to postFeedElement
				ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();

				ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text = messageBody;

				// The MessageBodyInput object holds the text in the post
				ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
				messageBodyInput.messageSegments = new List < ConnectApi.MessageSegmentInput > ();
				messageBodyInput.messageSegments.add(textSegmentInput);
				feedItemInput.body = messageBodyInput;

				//Direct Message Capability
				ConnectApi.DirectMessageCapabilityInput dmInput = new ConnectApi.DirectMessageCapabilityInput();
				dmInput.subject = subject;
				dmInput.membersToAdd = lstOfMessageToUsers;

				// The FeedElementCapabilitiesInput object holds the capabilities of the feed item.
				ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput = new ConnectApi.FeedElementCapabilitiesInput();

				// The FeedElementCapabilitiesInput object holds the capabilities of the feed item.
				feedElementCapabilitiesInput.directMessage = dmInput;
				feedItemInput.capabilities = feedElementCapabilitiesInput;
				system.debug('feedElementCapabilitiesInput----' + feedElementCapabilitiesInput);

				// Post the feed item. 
				ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(getCommunityId(), feedItemInput);
				system.debug('feedElement----' + feedElement);

				System.debug('###' + feedElement.id);
				if (String.isNotEmpty(feedElement.id)) {
					return addToFLMessagetbl(feedElement.id, familyAccount);
				} else {
					return false;
				}
			}

		} catch(Exception ex) {
			system.debug('Error in DirectMsgUtil ' + ex.getMessage() + ' ' + ex.getLineNumber() + ' ' + ex.getCause());
			return false;
		}
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
				system.debug('Accessed succeed');
				return true;
			} else {
				system.debug('Accessed succeed1');
				return false;
			}
		} catch(Exception ex) {
			system.debug('error addToFLMessagetbl');
			return false;
		}
	}

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
	public static DirectMessageWrapper.DirectMessageComments validatepostNewCommentAttachment(String feedElementId, String msgText, String fileId) {
		if (!String.isBlank(fileId)) {
			return postNewCommentWithAttachement(feedElementId, msgText, fileId);
		} else {
			System.debug('###Msg ' + msgText);
			return postNewComment(feedElementId, msgText);
		}
	}

	// Post new comment without any attachments
	@AuraEnabled
	public static DirectMessageWrapper.DirectMessageComments postNewComment(String feedElementId, String msgText) {
		String communityId = getCommunityId();
		ConnectApi.CommentInput input = new ConnectApi.CommentInput();
		ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
		ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
		messageInput.messageSegments = new List < ConnectApi.MessageSegmentInput > ();
		textSegment.text = msgText;
		messageInput.messageSegments.add(textSegment);
		input.body = messageInput;
		ConnectApi.Comment commentRep = ConnectApi.ChatterFeeds.postCommentToFeedElement(communityId, feedElementId, input, null);
		if (commentRep != NULL) {
			DirectMessageWrapper.DirectMessageComments cmt = getCommentsFromApi(commentRep);
			System.debug('####DirectMsgComment' + cmt);
			return cmt;
		} else {
			return null;
		}
	}

	// Post new comment with inline image
	@AuraEnabled
	public static void postNewCommentWithImage(String feedElementId, String msgText, String imageId) {
		String communityId = getCommunityId();
		ConnectApi.CommentInput input = new ConnectApi.CommentInput();
		ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
		ConnectApi.TextSegmentInput textSegment;
		ConnectApi.InlineImageSegmentInput inlineImageSegment;
		messageInput.messageSegments = new List < ConnectApi.MessageSegmentInput > ();
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
	@AuraEnabled
	public static DirectMessageWrapper.DirectMessageComments postNewCommentWithAttachement(String feedElementId, String msgText, String documentID) {

		String communityId = getCommunityId();
		ConnectApi.CommentInput commentInput = new ConnectApi.CommentInput();
		ConnectApi.MessageBodyInput messageBodyInput;
		ConnectApi.TextSegmentInput textSegmentInput;

		if (String.isNotEmpty(msgText)) {

			messageBodyInput = new ConnectApi.MessageBodyInput();
			textSegmentInput = new ConnectApi.TextSegmentInput();

			messageBodyInput.messageSegments = new List < ConnectApi.MessageSegmentInput > ();
			textSegmentInput.text = msgText;
			messageBodyInput.messageSegments.add(textSegmentInput);
			commentInput.body = messageBodyInput;
		}

		ConnectApi.CommentCapabilitiesInput commentCapabilitiesInput = new ConnectApi.CommentCapabilitiesInput();
		ConnectApi.ContentCapabilityInput contentCapabilityInput = new ConnectApi.ContentCapabilityInput();

		contentCapabilityInput.contentDocumentId = documentID;
		commentCapabilitiesInput.content = contentCapabilityInput;
		commentInput.capabilities = commentCapabilitiesInput;
		ConnectApi.Comment commentRep = ConnectApi.ChatterFeeds.postCommentToFeedElement(communityId, feedElementId, commentInput, null);

		if (commentRep != NULL) {
			DirectMessageWrapper.DirectMessageComments cmt = getCommentsFromApi(commentRep);
			return cmt;
		} else {
			return null;
		}
	}

	//Working
	//Added By Pallavi: This method will return all Messages and Comments from Context User Point of view. Passing 'null' for pagetoken will return first page of DirectFeeditem and FeedComments on load.
	@AuraEnabled(cacheable = true)
	public static List < DirectMessageWrapper > getAllMessagesFromAPIonLoad(string communityId, integer recentCommentCount, string nextPageToken, Integer pageSize) {

		List < DirectMessageWrapper > lstDirectMessages = new List < DirectMessageWrapper > ();
		Map < ID, ID > lstFlmessageIDs = new Map < ID, ID > ();
		List < Id > lstFeed = new List < Id > ();

		ConnectApi.FeedElementPage feedElementPage = getFeedItemFromConnectAPI(communityId, recentCommentCount, nextPageToken, pageSize, ConnectApi.FeedSortOrder.LastModifiedDateDesc);
		string apicurrentpagetoken = feedElementPage.currentPageToken;
		string apinextpagetoken = feedElementPage.nextPageToken;

		for (ConnectApi.FeedElement element: feedElementPage.elements) {
			lstFeed.add(element.Id);
		}

		List < FL_Message__c > lstflMsg = [SELECT Id, Marked__c, Feed_Id__c, Family_ID__c, Family_ID__r.Name FROM FL_Message__c WHERE Feed_Id__c in :lstFeed];

		for (FL_Message__c flmsg: lstflMsg) {
			lstFlmessageIDs.put(flmsg.Feed_Id__c, flmsg.Family_ID__c);
		}

		for (ConnectApi.FeedElement feedElement: feedElementPage.elements) {

			DirectMessageWrapper.DirectMessageFeed lstDirectMessageFeed = getFeedDetailsFromApi(feedElement);
			List < DirectMessageWrapper.UserDetails > lstOfDirectMsgUsers = new List < DirectMessageWrapper.UserDetails > ();
			ConnectApi.DirectMessageCapability directMsgCapability = feedElement.capabilities.directMessage;

			for (ConnectApi.UserSummary user: directMsgCapability.members.users) {
				lstOfDirectMsgUsers.add(new DirectMessageWrapper.UserDetails(user.firstName, user.lastName, user.id));
			}
			String accountN = '';
			Boolean isMarked = false;
			for (FL_Message__c flmsg: lstflMsg) {
				if (flmsg.Feed_Id__c == feedElement.id) {
					isMarked = flmsg.Marked__c;
					accountN = flmsg.Family_ID__r.Name;
				}
			}

			lstDirectMessages.add(new DirectMessageWrapper(lstOfDirectMsgUsers, directMsgCapability.subject, lstDirectMessageFeed, new DirectMessageWrapper.FLMesssage(feedElement.id, lstFlmessageIDs.get(feedElement.id), isMarked, accountN), new DirectMessageWrapper.FLBackupAgent(Userinfo.getUserId(), Userinfo.getUserId()), apicurrentpagetoken, apinextpagetoken));
		}

		return lstDirectMessages;
	}

	//Return directMessagemembers list when feedElementID is provided
	@AuraEnabled(cacheable = true)
	public static List < DirectMessageWrapper.DirectMessageComments > getCommentsForFeedElement(String feedElementID) {
		System.debug('$$$' + feedElementID);
		List < DirectMessageWrapper.DirectMessageComments > lstComments = new List < DirectMessageWrapper.DirectMessageComments > ();
		String communityID = getCommunityId();
		ConnectApi.CommentPage commentPage = ConnectApi.ChatterFeeds.getCommentsForFeedElement(communityID, feedElementID);
		for (ConnectApi.Comment comment: commentPage.items) {
			lstComments.add(getCommentsFromApi(comment));
		}
		System.debug('$$$' + lstComments);
		return lstComments;
	}

	@AuraEnabled(cacheable = true)
	public static DirectMessageWrapper getSelectedFeedElementDetails(String feedElementID, Integer commentCount, Integer elementsPerBundle) {

		DirectMessageWrapper directMsg;
		List < DirectMessageWrapper.UserDetails > lstOfDirectMsgUsers = new List < DirectMessageWrapper.UserDetails > ();
		Boolean isMarked = false;
		String communityID = getCommunityId();

		ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.getFeedElement(communityID, feedElementID, commentCount, elementsPerBundle, ConnectApi.FeedCommentSortOrder.CreatedDateOldestAsc);
		FL_Message__c flMsgObjectData = [SELECT Id, Marked__c, Feed_Id__c, Family_ID__c, Family_ID__r.Name FROM FL_Message__c WHERE Feed_Id__c = :feedElement.id];

		DirectMessageWrapper.DirectMessageFeed lstDirectMessageFeed = getFeedDetailsFromApi(feedElement);
		ConnectApi.DirectMessageCapability directMsgCapability = feedElement.capabilities.directMessage;

		for (ConnectApi.UserSummary user: directMsgCapability.members.users) {

			ConnectApi.User usr = (ConnectApi.User) user;

			lstOfDirectMsgUsers.add(new DirectMessageWrapper.UserDetails(usr.firstName, usr.lastName, usr.id));
		}
		string accountNmae = '';
		if (flMsgObjectData.Feed_Id__c == feedElement.id) {
			isMarked = flMsgObjectData.Marked__c;
			accountNmae = flMsgObjectData.Family_ID__r.Name;
		}

		directMsg = new DirectMessageWrapper(lstOfDirectMsgUsers, directMsgCapability.subject, lstDirectMessageFeed, new DirectMessageWrapper.FLMesssage(feedElement.id, flMsgObjectData.Family_ID__c, isMarked, accountNmae), new DirectMessageWrapper.FLBackupAgent(Userinfo.getUserId(), Userinfo.getUserId()), null, null);

		return directMsg;
	}

	@AuraEnabled
	public static DirectMessageWrapper getMessagesFromObject(Id userID) {
		List < DirectMessageWrapper > lstDirectMessages = new List < DirectMessageWrapper > ();
		User initiatedUserInformation = [SELECT ID, FirstName, LastName FROM User WHERE Id = :userID];
		DirectMessageWrapper.UserDetails directMessageUser = new DirectMessageWrapper.UserDetails(initiatedUserInformation.FirstName, initiatedUserInformation.LastName, initiatedUserInformation.id);
		List < DirectMessage > lstDirectMsg = [SELECT Id, SystemModstamp, Name, Subject FROM DirectMessage WHERE ID IN(SELECT DirectMessageId FROM DirectMessageMember WHERE MemberId = :userID)];

		//Query to get all feeds and feed comment from direct message ID collected in above query.
		List < DirectMessageFeed > lstDirectMsgFeedandComment = [SELECT Id, ParentId, Type, CommentCount, Title, Body, LinkUrl, IsRichText, RelatedRecordId, (SELECT Id, FeedItemId, ParentId, CreatedById, CreatedDate, Revision, LastEditById, LastEditDate, CommentBody, InsertedById, CommentType, RelatedRecordId, IsRichText FROM FeedComments) FROM DirectMessageFeed where ParentId In: lstDirectMsg];
		for (DirectMessage directMsg: lstDirectMsg) {
			List < DirectMessageWrapper.DirectMessageFeed > lstDirectMsgFeeds = new List < DirectMessageWrapper.DirectMessageFeed > ();
			for (DirectMessageFeed directMsgFeed: [SELECT Id, ParentId, Type, CommentCount, Title, Body, LinkUrl, IsRichText, RelatedRecordId, (SELECT Id, FeedItemId, ParentId, CreatedById, CreatedDate, Revision, LastEditById, LastEditDate, CommentBody, InsertedById, CommentType, RelatedRecordId, IsRichText FROM FeedComments) FROM DirectMessageFeed where ParentId = :directMsg.id]) {
				List < DirectMessageWrapper.DirectMessageComments > lstDirectMsgComments = new List < DirectMessageWrapper.DirectMessageComments > ();
				for (FeedComment comment: directMsgFeed.FeedComments) {
					User commentedUserInformation = [SELECT ID, FirstName, LastName FROM User WHERE Id = :comment.CreatedById];
					lstdirectMsgComments.add(new DirectMessageWrapper.DirectMessageComments(comment.CreatedDate, comment.CommentBody, new DirectMessageWrapper.UserDetails(commentedUserInformation.FirstName, commentedUserInformation.LastName, commentedUserInformation.id), comment.Id));
				}
				//lstDirectMsgFeeds.add(new DirectMessageWrapper.DirectMessageFeed(directMsgFeed.CreatedDate,directMsgFeed.Body,directMsgFeed.Id,lstDirectMsgComments));
				lstDirectMsgComments.clear();
			}

			//lstDirectMessages.add(new DirectMessageWrapper(null,directMsg.Subject,lstDirectMsgFeeds,NULL,NULL,NULL,NULL));
			lstDirectMsgFeeds.clear();
		}
		return null;
	}

	//working
	@AuraEnabled
	public static void addPeopleToMessage(String directMessageFeedID, List < String > lstUsers) {
		String communityId = getCommunityId();
		ConnectApi.DirectMessageCapabilityInput directMessageInput = new ConnectApi.DirectMessageCapabilityInput();
		directMessageInput.membersToAdd = lstUsers;
		ConnectApi.DirectMessageCapability addMember = ConnectApi.ChatterFeeds.updateDirectMessage(communityId, directMessageFeedID, directMessageInput);
	}

	//working
	@AuraEnabled
	public static void removePeopleFromMessage(String directMessageFeedID, List < String > lstUsers) {
		String communityId = getCommunityId();
		ConnectApi.DirectMessageCapabilityInput directMessageInput = new ConnectApi.DirectMessageCapabilityInput();
		directMessageInput.membersToRemove = lstUsers;
		ConnectApi.DirectMessageCapability addMember = ConnectApi.ChatterFeeds.updateDirectMessage(communityId, directMessageFeedID, directMessageInput);
	}

	@AuraEnabled
	public static Boolean addBackupAgent(String directMessageID, List < ID > lstUsers) {
		return null;
	}

	//working
	@AuraEnabled
	public static List < DirectMessageWrapper > nextFeedItem(string communityId, integer recentCommentCount, string nextPageToken, Integer pageSize) {
		List < DirectMessageWrapper > lstDirectMessages = new List < DirectMessageWrapper > ();
		ConnectApi.FeedElementPage feedElementPage = getFeedItemFromConnectAPI(communityId, recentCommentCount, nextPageToken, pageSize, ConnectApi.FeedSortOrder.LastModifiedDateDesc);
		string apicurrentpagetoken = feedElementPage.currentPageToken;
		string apinextpagetoken = feedElementPage.nextPageToken;
		for (ConnectApi.FeedElement feedElement: feedElementPage.elements) {
			DirectMessageWrapper.DirectMessageFeed lstDirectMessageFeed = getFeedDetailsFromApi(feedElement);
			List < DirectMessageWrapper.UserDetails > lstOfDirectMsgUsers = new List < DirectMessageWrapper.UserDetails > ();
			ConnectApi.DirectMessageCapability directMsgCapability = feedElement.capabilities.directMessage;
			for (ConnectApi.UserSummary user: directMsgCapability.members.users) {
				lstOfDirectMsgUsers.add(new DirectMessageWrapper.UserDetails(user.firstName, user.lastName, user.id));
			}
			lstDirectMessages.add(new DirectMessageWrapper(lstOfDirectMsgUsers, directMsgCapability.subject, lstDirectMessageFeed, new DirectMessageWrapper.FLMesssage(feedElement.id, feedElement.id, true), new DirectMessageWrapper.FLBackupAgent(Userinfo.getUserId(), Userinfo.getUserId()), apicurrentpagetoken, apinextpagetoken));
		}
		return lstDirectMessages;
	}

	//working    
	@AuraEnabled
	public static List < DirectMessageWrapper > previousFeedItem(string communityId, integer recentCommentCoun, string previousPageToken, Integer pageSize) {
		List < DirectMessageWrapper > lstDirectMessages = new List < DirectMessageWrapper > ();
		ConnectApi.FeedElementPage feedElementPage = getFeedItemFromConnectAPI(communityId, recentCommentCoun, previousPageToken, pageSize, ConnectApi.FeedSortOrder.LastModifiedDateDesc);
		string apicurrentpagetoken = feedElementPage.currentPageToken;
		string apinextpagetoken = feedElementPage.nextPageToken;
		for (ConnectApi.FeedElement feedElement: feedElementPage.elements) {
			DirectMessageWrapper.DirectMessageFeed lstDirectMessageFeed = getFeedDetailsFromApi(feedElement);
			List < DirectMessageWrapper.UserDetails > lstOfDirectMsgUsers = new List < DirectMessageWrapper.UserDetails > ();
			ConnectApi.DirectMessageCapability directMsgCapability = feedElement.capabilities.directMessage;
			for (ConnectApi.UserSummary user: directMsgCapability.members.users) {
				lstOfDirectMsgUsers.add(new DirectMessageWrapper.UserDetails(user.firstName, user.lastName, user.id));
			}
			lstDirectMessages.add(new DirectMessageWrapper(lstOfDirectMsgUsers, directMsgCapability.subject, lstDirectMessageFeed, new DirectMessageWrapper.FLMesssage(feedElement.id, feedElement.id, true), new DirectMessageWrapper.FLBackupAgent(Userinfo.getUserId(), Userinfo.getUserId()), apicurrentpagetoken, apinextpagetoken));
		}
		return lstDirectMessages;
	}

	//working
	@AuraEnabled
	public static List < DirectMessageWrapper.DirectMessageComments > nextFeedComment(string communityId, string feedId, string nextPageToken, integer pageSize, boolean threadedCommentsCollapsed) {
		List < DirectMessageWrapper.DirectMessageComments > lstDirectMsgDetails = new List < DirectMessageWrapper.DirectMessageComments > ();
		ConnectApi.CommentPage feedComment = ConnectApi.ChatterFeeds.getCommentsForFeedElement(communityId, feedId, nextPageToken, pageSize, threadedCommentsCollapsed);
		for (ConnectApi.Comment comment: feedComment.items) {
			lstDirectMsgDetails.add(getCommentsFromApi(comment));
		}
		return lstDirectMsgDetails;
	}

	//working
	@AuraEnabled
	public static List < DirectMessageWrapper.DirectMessageComments > previousFeedComment(string communityId, string feedId, string previousPageToken, integer pageSize, boolean threadedCommentsCollapsed) {
		List < DirectMessageWrapper.DirectMessageComments > lstDirectMsgDetails = new List < DirectMessageWrapper.DirectMessageComments > ();
		ConnectApi.CommentPage feedComment = ConnectApi.ChatterFeeds.getCommentsForFeedElement(communityId, feedId, previousPageToken, pageSize, threadedCommentsCollapsed);
		for (ConnectApi.Comment comment: feedComment.items) {
			lstDirectMsgDetails.add(getCommentsFromApi(comment));
		}
		return lstDirectMsgDetails;
	}

	public static ConnectApi.FeedElementPage getFeedItemFromConnectAPI(string communityId, Integer recentCommentCount, string pageToken, Integer pageSize, ConnectApi.FeedSortOrder sortOrder) {
		return ConnectApi.ChatterFeeds.getFeedElementsFromFeed(communityId, ConnectApi.FeedType.DirectMessages, recentCommentCount, ConnectApi.FeedDensity.AllUpdates, pageToken, pageSize, sortOrder);
	}
	public static ConnectApi.CommentPage getFeedCommentFromConnectAPI(string communityId, string feedElementId, string pageToken, Integer pageSize, Boolean threadedCommentsCollapsed, ConnectApi.FeedCommentSortOrder sortOrder) {
		return ConnectApi.ChatterFeeds.getCommentsForFeedElement(communityId, feedElementId, pageToken, pageSize, threadedCommentsCollapsed, sortOrder);
	}

	public static DirectMessageWrapper.DirectMessageComments getCommentsFromApi(ConnectApi.Comment comment) {
		String message = getMessagebodyFromApi(comment.body.messageSegments);
		if (comment.capabilities != null && comment.capabilities.content != null) {
			message += '<a href="' + comment.capabilities.content.downloadUrl + '">' + comment.capabilities.content.title + '.' + comment.capabilities.content.fileExtension + '</a>';
		}
		System.debug('###' + comment.user);
		return new DirectMessageWrapper.DirectMessageComments(comment.createdDate, message, new DirectMessageWrapper.UserDetails(comment.user.firstName, comment.user.lastName, comment.user.id), comment.id);
	}

	public static DirectMessageWrapper.DirectMessageFeed getFeedDetailsFromApi(ConnectApi.FeedElement feedElement) {

		DirectMessageWrapper.UserDetails initiatedUser;

		List < DirectMessageWrapper.DirectMessageComments > lstDirectMsgComments = new List < DirectMessageWrapper.DirectMessageComments > ();
		//String messageBody = getMessagebodyFromApi(feedElement.header.messageSegments);
		if (feedElement.feedElementType == ConnectApi.FeedElementType.FeedItem) {

			ConnectApi.FeedItem feedItem = (ConnectApi.FeedItem) feedElement;
			ConnectApi.UserSummary user = (ConnectApi.UserSummary) feedItem.actor;
			initiatedUser = new DirectMessageWrapper.UserDetails(user.firstName, user.lastName, user.id);

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
		DirectMessageWrapper.DirectMessageFeed feed = new DirectMessageWrapper.DirectMessageFeed(feedElement.createdDate, messageBody, feedElement.id, lstDirectMsgComments, initiatedUser);
		return feed;
	}

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
	}

	//TBD... working @Vamsi
	@AuraEnabled
	public static boolean feedToggleMarked(boolean flflag, ID feedID) {
		try {
			List < FL_Message__c > lstflMsg = [SELECT Id, Marked__c, Feed_Id__c FROM FL_Message__c WHERE Feed_Id__c = :feedID];
			lstflMsg[0].Marked__c = flflag;
			update lstflMsg;
			system.debug('@#$ ' + flflag + ' ' + feedID + ' ' + lstflMsg[0].Marked__c);
			return true;
		} catch(exception ex) {
			system.debug('Error ' + ex.getMessage());
			return false;
		}
	}

	//File Uploader
	@AuraEnabled
	public static Id saveChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId) {
		if (fileId == '') {
			fileId = saveTheFile(parentId, fileName, base64Data, contentType);
		} else {
			appendToFile(fileId, base64Data);
		}

		return Id.valueOf(fileId);
	}

	//File Uploader
	@AuraEnabled
	public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType) {
		base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');

		Attachment oAttachment = new Attachment();
		oAttachment.parentId = parentId;

		oAttachment.Body = EncodingUtil.base64Decode(base64Data);
		oAttachment.Name = fileName;
		oAttachment.ContentType = contentType;

		insert oAttachment;

		return oAttachment.Id;
	}

	//File Uploader
	@AuraEnabled
	public static void appendToFile(Id fileId, String base64Data) {
		base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');

		Attachment a = [
		SELECT Id, Body
		FROM Attachment
		WHERE Id = :fileId];

		String existingBody = EncodingUtil.base64Encode(a.Body);

		a.Body = EncodingUtil.base64Decode(existingBody + base64Data);

		update a;
	}
}