/*********************************************************************************
 * 
 * Class Name:MSGDirectMessageUtilDataFactory
 * Description: Test utility class which provides data required
 * Created By : Sameera De Silva
 * Created Date : 7/31/2020
 * 
 * Modification Log 
 * -------------------------------------------------------------------------------
 * Developer            Date			Description
 * 
 * Sameera De Silva		7/31/2020   	
 * ------------------------------------------------------------------------------- 					
 * 
 *********************************************************************************/

@isTest
global class MSGDirectMessageUtilDataFactory {

    //Insert accounts 
    public static void createAccountRecords(Integer numberOfAccounts){
        
        List<Account> lstAccounts = new List<Account>();
        
        for(Integer start=0;start<numberOfAccounts;start++){
            
            Account accountRecord = new Account();
            accountRecord.Name = 'MSGTestAccount'+start;
            
            lstAccounts.add(accountRecord);
        }
        
        insert lstAccounts;
        
    }
    
    //Insert FL_Message records
    public static void createFLMessageRecords(Integer numberOfflMessages){
        
        createAccountRecords(numberOfflMessages);
		List<FL_Message__c> lstFlmessages = new List<FL_Message__c>();
        List<Account> flMessage = [SELECT Id FROM Account WHERE Name LIKE 'MSGTestAccount%'];
        
        for(Integer start=0;start<numberOfflMessages;start++){
            
            FL_Message__c flMessageRecord = new FL_Message__c();
			flMessageRecord.Feed_Id__c = '0D52w00000G5ywyCAB'; //Feedelement IDs need to create from a method
			flMessageRecord.Family_ID__c = flMessage[0].Id;
		           
            lstFlmessages.add(flMessageRecord);
        }
        
        insert lstFlmessages;
     }
    
    //Inserts content document
    public static void insertContentDocument(){
        
        ContentVersion contentVersionInsert = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.jpg',
            VersionData = Blob.valueOf('Test Content Data'),
            IsMajorVersion = true
        );
        insert contentVersionInsert;
 
    }
    
    global static ConnectApi.FeedElementPage getFeedElement() {
        ConnectApi.FeedElementPage elements = 
            ConnectApi.ChatterFeeds.getFeedElementsFromFeed(null,
                ConnectApi.FeedType.DirectMessages, 'me');
        return elements;
    }
    
    public static ConnectApi.FeedElement getFeed(){
        
        List<ID> lstUsers = new List<ID>();
        
        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();

		ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
		textSegmentInput.text = 'Test';

				// The MessageBodyInput object holds the text in the post
		ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
		messageBodyInput.messageSegments = new List < ConnectApi.MessageSegmentInput > ();
		messageBodyInput.messageSegments.add(textSegmentInput);
		feedItemInput.body = messageBodyInput;

				//Direct Message Capability
		ConnectApi.DirectMessageCapabilityInput dmInput = new ConnectApi.DirectMessageCapabilityInput();
		dmInput.subject = 'Test';
        
        for(User usr:[SELECT Id FROM User LIMIT 2]){
            lstUsers.add(usr.id);
        }
		dmInput.membersToAdd = lstUsers;

				// The FeedElementCapabilitiesInput object holds the capabilities of the feed item.
		ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput = new ConnectApi.FeedElementCapabilitiesInput();

				// The FeedElementCapabilitiesInput object holds the capabilities of the feed item.
		feedElementCapabilitiesInput.directMessage = dmInput;
		feedItemInput.capabilities = feedElementCapabilitiesInput;
				
		Network customCommunity =[select Id,name from network  where name='pocconectapi'];
				// Post the feed item. 
		ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(customCommunity.id, feedItemInput);
        
        return feedElement; 
    }
}