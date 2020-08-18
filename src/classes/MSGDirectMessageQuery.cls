/********************************************************************************* 
Class Name     : MSGDirectMessageQuery.cls
Description    : 
Created By     : 
Created Date   : 

Modification Log
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------            

*********************************************************************************/

public class MSGDirectMessageQuery {
    
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