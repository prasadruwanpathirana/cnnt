/********************************************************************************* 
Class Name     : MSGDirectMessageConnectAPI.cls
Description    : 
Created By     : 
Created Date   : 

Modification Log
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------            

*********************************************************************************/

public class MSGDirectMessageConnectAPI {
    
    string COMMUNITYNAME = 'pocconectapi' ;
    
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
    
    public static String getCommunityId() {
		List < Network > customCommunity = [select Id, name from network where name = 'pocconectapi' ];
		if (customCommunity != null && customCommunity.size() > 0) {
			return customCommunity[0].Id;
		}
		return null;
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
    
    public static MSGDirectMessageWrapper.DirectMessageComments validatepostNewCommentAttachment(String feedElementId, String msgText, String fileId) {
		if (!String.isBlank(fileId)) {
			return postNewCommentWithAttachement(feedElementId, msgText, fileId);
		} else {
			System.debug('###Msg ' + msgText);
            System.debug('###'+feedElementId);
			return postNewComment(feedElementId, msgText);
		}
	}
    
	public static MSGDirectMessageWrapper.DirectMessageComments postNewCommentWithAttachement(String feedElementId, String msgText, String documentID) {

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
			MSGDirectMessageWrapper.DirectMessageComments cmt = getCommentsFromApi(commentRep);
			return cmt;
		} else {
			return null;
		}
	}
    
    public static MSGDirectMessageWrapper.DirectMessageComments postNewComment(String feedElementId, String msgText) {
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
			MSGDirectMessageWrapper.DirectMessageComments cmt = getCommentsFromApi(commentRep);
			System.debug('####DirectMsgComment' + cmt);
			return cmt;
		} else {
			return null;
		}
	}
    
    public static MSGDirectMessageWrapper.DirectMessageComments getCommentsFromApi(ConnectApi.Comment comment) {
		String message = getMessagebodyFromApi(comment.body.messageSegments);
		if (comment.capabilities != null && comment.capabilities.content != null) {
			message += '<a href="' + comment.capabilities.content.downloadUrl + '">' + comment.capabilities.content.title + '.' + comment.capabilities.content.fileExtension + '</a>';
		}
		System.debug('###' + comment.user);
		return new MSGDirectMessageWrapper.DirectMessageComments(comment.createdDate, message, new MSGDirectMessageWrapper.UserDetails(comment.user.firstName, comment.user.lastName, comment.user.id), comment.id);
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
    
    public static List < MSGDirectMessageWrapper > getAllMessagesFromAPIonLoad(string communityId, integer recentCommentCount, string nextPageToken, Integer pageSize) {

		List < MSGDirectMessageWrapper > lstDirectMessages = new List < MSGDirectMessageWrapper > ();
		Map < ID,
		ID > lstFlmessageIDs = new Map < ID,
		ID > ();
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

			MSGDirectMessageWrapper.DirectMessageFeed lstDirectMessageFeed = getFeedDetailsFromApi(feedElement);
			List < MSGDirectMessageWrapper.UserDetails > lstOfDirectMsgUsers = new List < MSGDirectMessageWrapper.UserDetails > ();
			ConnectApi.DirectMessageCapability directMsgCapability = feedElement.capabilities.directMessage;

			for (ConnectApi.UserSummary user: directMsgCapability.members.users) {
				lstOfDirectMsgUsers.add(new MSGDirectMessageWrapper.UserDetails(user.firstName, user.lastName, user.id));
			}
			String accountN = '';
			Boolean isMarked = false;
			for (FL_Message__c flmsg: lstflMsg) {
				if (flmsg.Feed_Id__c == feedElement.id) {
					isMarked = flmsg.Marked__c;
					accountN = flmsg.Family_ID__r.Name;
				}
			}

			lstDirectMessages.add(new MSGDirectMessageWrapper(lstOfDirectMsgUsers, directMsgCapability.subject, lstDirectMessageFeed, new MSGDirectMessageWrapper.FLMesssage(feedElement.id, lstFlmessageIDs.get(feedElement.id), isMarked, accountN), new MSGDirectMessageWrapper.FLBackupAgent(Userinfo.getUserId(), Userinfo.getUserId()), apicurrentpagetoken, apinextpagetoken));
		}

		return lstDirectMessages;
	}
    
    public static ConnectApi.FeedElementPage getFeedItemFromConnectAPI(string communityId, Integer recentCommentCount, string pageToken, Integer pageSize, ConnectApi.FeedSortOrder sortOrder) {
		return ConnectApi.ChatterFeeds.getFeedElementsFromFeed(communityId, ConnectApi.FeedType.DirectMessages, recentCommentCount, ConnectApi.FeedDensity.AllUpdates, pageToken, pageSize, sortOrder);
	}
    
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
	}
    
    public static List < MSGDirectMessageWrapper.DirectMessageComments > getCommentsForFeedElement(String feedElementID) {
		System.debug('$$$' + feedElementID);
		List < MSGDirectMessageWrapper.DirectMessageComments > lstComments = new List < MSGDirectMessageWrapper.DirectMessageComments > ();
		String communityID = getCommunityId();
		ConnectApi.CommentPage commentPage = ConnectApi.ChatterFeeds.getCommentsForFeedElement(communityID, feedElementID);
		for (ConnectApi.Comment comment: commentPage.items) {
			lstComments.add(getCommentsFromApi(comment));
		}
		System.debug('$$$' + lstComments);
		return lstComments;
	}
    
    public static MSGDirectMessageWrapper getSelectedFeedElementDetails(String feedElementID, Integer commentCount, Integer elementsPerBundle) {

		MSGDirectMessageWrapper directMsg;
		List < MSGDirectMessageWrapper.UserDetails > lstOfDirectMsgUsers = new List < MSGDirectMessageWrapper.UserDetails > ();
		Boolean isMarked = false;
		String communityID = getCommunityId();

		ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.getFeedElement(communityID, feedElementID, commentCount, elementsPerBundle, ConnectApi.FeedCommentSortOrder.CreatedDateOldestAsc);
		FL_Message__c flMsgObjectData = [SELECT Id, Marked__c, Feed_Id__c, Family_ID__c, Family_ID__r.Name FROM FL_Message__c WHERE Feed_Id__c = :feedElement.id];

		MSGDirectMessageWrapper.DirectMessageFeed lstDirectMessageFeed = getFeedDetailsFromApi(feedElement);
		ConnectApi.DirectMessageCapability directMsgCapability = feedElement.capabilities.directMessage;

		for (ConnectApi.UserSummary user: directMsgCapability.members.users) {

			ConnectApi.User usr = (ConnectApi.User) user;

			lstOfDirectMsgUsers.add(new MSGDirectMessageWrapper.UserDetails(usr.firstName, usr.lastName, usr.id));
		}
		string accountNmae = '';
		if (flMsgObjectData.Feed_Id__c == feedElement.id) {
			isMarked = flMsgObjectData.Marked__c;
			accountNmae = flMsgObjectData.Family_ID__r.Name;
		}

		directMsg = new MSGDirectMessageWrapper(lstOfDirectMsgUsers, directMsgCapability.subject, lstDirectMessageFeed, new MSGDirectMessageWrapper.FLMesssage(feedElement.id, flMsgObjectData.Family_ID__c, isMarked, accountNmae), new MSGDirectMessageWrapper.FLBackupAgent(Userinfo.getUserId(), Userinfo.getUserId()), null, null);

		return directMsg;
	}
    
    public static MSGDirectMessageWrapper getMessagesFromObject(Id userID) {
		List < MSGDirectMessageWrapper > lstDirectMessages = new List < MSGDirectMessageWrapper > ();
		User initiatedUserInformation = [SELECT ID, FirstName, LastName FROM User WHERE Id = :userID];
		MSGDirectMessageWrapper.UserDetails directMessageUser = new MSGDirectMessageWrapper.UserDetails(initiatedUserInformation.FirstName, initiatedUserInformation.LastName, initiatedUserInformation.id);
		List < DirectMessage > lstDirectMsg = [SELECT Id, SystemModstamp, Name, Subject FROM DirectMessage WHERE ID IN(SELECT DirectMessageId FROM DirectMessageMember WHERE MemberId = :userID)];

		//Query to get all feeds and feed comment from direct message ID collected in above query.
		List < DirectMessageFeed > lstDirectMsgFeedandComment = [SELECT Id, ParentId, Type, CommentCount, Title, Body, LinkUrl, IsRichText, RelatedRecordId, (SELECT Id, FeedItemId, ParentId, CreatedById, CreatedDate, Revision, LastEditById, LastEditDate, CommentBody, InsertedById, CommentType, RelatedRecordId, IsRichText FROM FeedComments) FROM DirectMessageFeed where ParentId In: lstDirectMsg];
		for (DirectMessage directMsg: lstDirectMsg) {
			List < MSGDirectMessageWrapper.DirectMessageFeed > lstDirectMsgFeeds = new List < MSGDirectMessageWrapper.DirectMessageFeed > ();
			for (DirectMessageFeed directMsgFeed: [SELECT Id, ParentId, Type, CommentCount, Title, Body, LinkUrl, IsRichText, RelatedRecordId, (SELECT Id, FeedItemId, ParentId, CreatedById, CreatedDate, Revision, LastEditById, LastEditDate, CommentBody, InsertedById, CommentType, RelatedRecordId, IsRichText FROM FeedComments) FROM DirectMessageFeed where ParentId = :directMsg.id]) {
				List < MSGDirectMessageWrapper.DirectMessageComments > lstDirectMsgComments = new List < MSGDirectMessageWrapper.DirectMessageComments > ();
				for (FeedComment comment: directMsgFeed.FeedComments) {
					User commentedUserInformation = [SELECT ID, FirstName, LastName FROM User WHERE Id = :comment.CreatedById];
					lstdirectMsgComments.add(new MSGDirectMessageWrapper.DirectMessageComments(comment.CreatedDate, comment.CommentBody, new MSGDirectMessageWrapper.UserDetails(commentedUserInformation.FirstName, commentedUserInformation.LastName, commentedUserInformation.id), comment.Id));
				}
				//lstDirectMsgFeeds.add(new DirectMessageWrapper.DirectMessageFeed(directMsgFeed.CreatedDate,directMsgFeed.Body,directMsgFeed.Id,lstDirectMsgComments));
				lstDirectMsgComments.clear();
			}

			//lstDirectMessages.add(new DirectMessageWrapper(null,directMsg.Subject,lstDirectMsgFeeds,NULL,NULL,NULL,NULL));
			lstDirectMsgFeeds.clear();
		}
		return null;
	}
    
    public static void addPeopleToMessage(String directMessageFeedID, List < String > lstUsers) {
		String communityId = getCommunityId();
		ConnectApi.DirectMessageCapabilityInput directMessageInput = new ConnectApi.DirectMessageCapabilityInput();
		directMessageInput.membersToAdd = lstUsers;
		ConnectApi.DirectMessageCapability addMember = ConnectApi.ChatterFeeds.updateDirectMessage(communityId, directMessageFeedID, directMessageInput);
	}
    
    public static void removePeopleFromMessage(String directMessageFeedID, List < String > lstUsers) {
		String communityId = getCommunityId();
		ConnectApi.DirectMessageCapabilityInput directMessageInput = new ConnectApi.DirectMessageCapabilityInput();
		directMessageInput.membersToRemove = lstUsers;
		ConnectApi.DirectMessageCapability addMember = ConnectApi.ChatterFeeds.updateDirectMessage(communityId, directMessageFeedID, directMessageInput);
	}
    
    public static List < MSGDirectMessageWrapper > nextFeedItem(string communityId, integer recentCommentCount, string nextPageToken, Integer pageSize) {
		List < MSGDirectMessageWrapper > lstDirectMessages = new List < MSGDirectMessageWrapper > ();
		ConnectApi.FeedElementPage feedElementPage = getFeedItemFromConnectAPI(communityId, recentCommentCount, nextPageToken, pageSize, ConnectApi.FeedSortOrder.LastModifiedDateDesc);
		string apicurrentpagetoken = feedElementPage.currentPageToken;
		string apinextpagetoken = feedElementPage.nextPageToken;
		for (ConnectApi.FeedElement feedElement: feedElementPage.elements) {
			MSGDirectMessageWrapper.DirectMessageFeed lstDirectMessageFeed = getFeedDetailsFromApi(feedElement);
			List < MSGDirectMessageWrapper.UserDetails > lstOfDirectMsgUsers = new List < MSGDirectMessageWrapper.UserDetails > ();
			ConnectApi.DirectMessageCapability directMsgCapability = feedElement.capabilities.directMessage;
			for (ConnectApi.UserSummary user: directMsgCapability.members.users) {
				lstOfDirectMsgUsers.add(new MSGDirectMessageWrapper.UserDetails(user.firstName, user.lastName, user.id));
			}
			lstDirectMessages.add(new MSGDirectMessageWrapper(lstOfDirectMsgUsers, directMsgCapability.subject, lstDirectMessageFeed, new MSGDirectMessageWrapper.FLMesssage(feedElement.id, feedElement.id, true), new MSGDirectMessageWrapper.FLBackupAgent(Userinfo.getUserId(), Userinfo.getUserId()), apicurrentpagetoken, apinextpagetoken));
		}
		return lstDirectMessages;
	}
    
    public static List < MSGDirectMessageWrapper > previousFeedItem(string communityId, integer recentCommentCoun, string previousPageToken, Integer pageSize) {
		List < MSGDirectMessageWrapper > lstDirectMessages = new List < MSGDirectMessageWrapper > ();
		ConnectApi.FeedElementPage feedElementPage = getFeedItemFromConnectAPI(communityId, recentCommentCoun, previousPageToken, pageSize, ConnectApi.FeedSortOrder.LastModifiedDateDesc);
		string apicurrentpagetoken = feedElementPage.currentPageToken;
		string apinextpagetoken = feedElementPage.nextPageToken;
		for (ConnectApi.FeedElement feedElement: feedElementPage.elements) {
			MSGDirectMessageWrapper.DirectMessageFeed lstDirectMessageFeed = getFeedDetailsFromApi(feedElement);
			List < MSGDirectMessageWrapper.UserDetails > lstOfDirectMsgUsers = new List < MSGDirectMessageWrapper.UserDetails > ();
			ConnectApi.DirectMessageCapability directMsgCapability = feedElement.capabilities.directMessage;
			for (ConnectApi.UserSummary user: directMsgCapability.members.users) {
				lstOfDirectMsgUsers.add(new MSGDirectMessageWrapper.UserDetails(user.firstName, user.lastName, user.id));
			}
			lstDirectMessages.add(new MSGDirectMessageWrapper(lstOfDirectMsgUsers, directMsgCapability.subject, lstDirectMessageFeed, new MSGDirectMessageWrapper.FLMesssage(feedElement.id, feedElement.id, true), new MSGDirectMessageWrapper.FLBackupAgent(Userinfo.getUserId(), Userinfo.getUserId()), apicurrentpagetoken, apinextpagetoken));
		}
		return lstDirectMessages;
	}
    
    public static List < MSGDirectMessageWrapper.DirectMessageComments > nextFeedComment(string communityId, string feedId, string nextPageToken, integer pageSize, boolean threadedCommentsCollapsed) {
		List < MSGDirectMessageWrapper.DirectMessageComments > lstDirectMsgDetails = new List < MSGDirectMessageWrapper.DirectMessageComments > ();
		ConnectApi.CommentPage feedComment = ConnectApi.ChatterFeeds.getCommentsForFeedElement(communityId, feedId, nextPageToken, pageSize, threadedCommentsCollapsed);
		for (ConnectApi.Comment comment: feedComment.items) {
			lstDirectMsgDetails.add(getCommentsFromApi(comment));
		}
		return lstDirectMsgDetails;
	}
    
    public static List < MSGDirectMessageWrapper.DirectMessageComments > previousFeedComment(string communityId, string feedId, string previousPageToken, integer pageSize, boolean threadedCommentsCollapsed) {
		List < MSGDirectMessageWrapper.DirectMessageComments > lstDirectMsgDetails = new List < MSGDirectMessageWrapper.DirectMessageComments > ();
		ConnectApi.CommentPage feedComment = ConnectApi.ChatterFeeds.getCommentsForFeedElement(communityId, feedId, previousPageToken, pageSize, threadedCommentsCollapsed);
		for (ConnectApi.Comment comment: feedComment.items) {
			lstDirectMsgDetails.add(getCommentsFromApi(comment));
		}
		return lstDirectMsgDetails;
	}

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
    
    public static Id saveChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId) {
		if (fileId == '') {
			fileId = saveTheFile(parentId, fileName, base64Data, contentType);
		} else {
			appendToFile(fileId, base64Data);
		}

		return Id.valueOf(fileId);
	}
    
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