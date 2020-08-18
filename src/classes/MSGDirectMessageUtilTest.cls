/*********************************************************************************
 * 
 * Class Name:MSGDirectMessageUtilTest
 * Description: Test class to cover DirectMessageUtil class methods
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
public class MSGDirectMessageUtilTest {

    //Test community ID
    @isTest(SeeAllData=true)
    static void getCommunityIDPositiveTest(){
     
        Network customCommunity =[select Id,name from network  where name='pocconectapi'];
        
        String commnityID = MSGDirectMessageUtil.getCommunityId();
        
        System.assertEquals(customCommunity.id,commnityID ,'Community IDs are not equal');

    }
    
    //New Message Test without attachments
   	@isTest(SeeAllData=true)
    static void sendMessageWithoutAttachmentTest(){
        
        MSGDirectMessageUtilDataFactory.createAccountRecords(1);
        
        Account account = [SELECT Id FROM Account WHERE Name LIKE 'MSGTestAccount%'];
        Profile p = [Select Id, Name, (Select Id, Name From Users) From Profile where Name like 'System%'];
        List<ID> lstUser = new List<ID>();
        lstUser.add(p.Users[0].Id);
        
        String subject = 'TestWithoutAttachments';
        String messageBody = 'TestBodyWithoutAttachments';
        String uploadFileId = null;
        Boolean result;

        Test.startTest();
        	
        	result = MSGDirectMessageUtil.sendNewMessage(account.Id,lstUser,subject,messageBody,uploadFileId);
        
        Test.stopTest();
        
        System.assertEquals(true,result,'Successfully recieved expected result');
    }
    
    //New Message Test without attachments Exception Test
   	@isTest(SeeAllData=true)
    static void sendMessageWithoutAttachmentExceptionTest(){
        
        MSGDirectMessageUtilDataFactory.createAccountRecords(1);
        
        Account account = [SELECT Id FROM Account WHERE Name LIKE 'MSGTestAccount%'];
        Profile p = [Select Id, Name, (Select Id, Name From Users) From Profile where Name like 'System%'];
        List<ID> lstUser = new List<ID>();
        lstUser.add(p.Users[0].Id);
        
        String subject = 'TestWithoutAttachments';
        String messageBody = 'TestBodyWithoutAttachments';
        String uploadFileId = null;
        Boolean result;
        
        Test.startTest();
        	
        	result = MSGDirectMessageUtil.sendNewMessage(p.Id,lstUser,subject,messageBody,uploadFileId);
        
        Test.stopTest();
        
        System.assertEquals(false,result,'Exception not captured');
    }
    
    //New Message Test with attachments
    @isTest(SeeAllData=true)
    static void sendMessageWithAttachmentsTest(){
        
        MSGDirectMessageUtilDataFactory.createAccountRecords(1);
        
        Account account = [SELECT Id FROM Account WHERE Name LIKE 'MSGTestAccount%'];
        Profile p = [Select Id, Name, (Select Id, Name From Users) From Profile where Name like 'System%'];
        List<ID> lstUser = new List<ID>();
        lstUser.add(p.Users[0].Id);
        
        MSGDirectMessageUtilDataFactory.insertContentDocument();
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        String subject = 'TestWithAttachments'; 
        String messageBody = 'TestBodyWithAttachments';
        String uploadFileId = documents[0].id;
        Boolean result;
        
        Test.startTest();
        	
        	result = MSGDirectMessageUtil.sendNewMessage(account.Id,lstUser,subject,messageBody,uploadFileId);
        
        Test.stopTest();
        
        System.assertEquals(true,result,'Successfully recieved expected results'); 
    }
    
    //New Message Test with attachments
    @isTest(SeeAllData=true)
    static void sendMessageWithAttachmentsEmptyBodyTest(){
        
        MSGDirectMessageUtilDataFactory.createAccountRecords(1);
        
        Account account = [SELECT Id FROM Account WHERE Name LIKE 'MSGTestAccount%'];
        Profile p = [Select Id, Name, (Select Id, Name From Users) From Profile where Name like 'System%'];
        List<ID> lstUser = new List<ID>();
        lstUser.add(p.Users[0].Id);
        
        MSGDirectMessageUtilDataFactory.insertContentDocument();
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        String subject = 'TestWithAttachments';
        String messageBody = null;
        String uploadFileId = documents[0].id;
        
        Test.startTest();
        	
        	MSGDirectMessageUtil.sendNewMessage(p.Users[0].Id,lstUser,subject,messageBody,uploadFileId);
        
        Test.stopTest();
    }
    
    //toggle button test
    //feedToggleMarked - true
    @isTest 
    static void feedToggleTrueTest(){
        
        MSGDirectMessageUtilDataFactory.createFLMessageRecords(1);
        
        //Feedelement IDs need to create from a method
        MSGDirectMessageUtil.feedToggleMarked(true,'0D52w00000G5ywyCAB');
        
        FL_Message__c  flMsg = [SELECT Id, Marked__c, Feed_Id__c FROM FL_Message__c WHERE Feed_Id__c = '0D52w00000G5ywyCAB'];
        
        System.assertEquals(true,flMsg.Marked__c,'FL Message Not Updated To True');
        
    }
    
    //toggle button test
    //feedToggleMarked - false
    @isTest 
    static void feedToggleFalseTest(){
        
        MSGDirectMessageUtilDataFactory.createFLMessageRecords(1);
        
        //Feedelement IDs need to create from a method
        MSGDirectMessageUtil.feedToggleMarked(false,'0D52w00000G5ywyCAB');
        
        FL_Message__c  flMsg = [SELECT Id, Marked__c, Feed_Id__c FROM FL_Message__c WHERE Feed_Id__c = '0D52w00000G5ywyCAB'];
        
        System.assertEquals(false,flMsg.Marked__c,'FL Message Not Updated To False');
    }
    
    @isTest
    static void addFLMessageSuccessTest(){
        
        /*ConnectApi.FeedElementPage testPage = new ConnectApi.FeedElementPage();
        List<ConnectApi.FeedItem> testItemList = new List<ConnectApi.FeedItem>();
        testItemList.add(new ConnectApi.FeedItem());
        testItemList.add(new ConnectApi.FeedItem());
        testPage.elements = testItemList;

        // Set the test data
        ConnectApi.ChatterFeeds.setTestGetFeedElementsFromFeed(null,
            ConnectApi.FeedType.DirectMessages, 'me', testPage);
        
        ConnectApi.FeedElementPage feedElementPage = MSGDirectMessageUtilDataFactory.getFeedElement();*/
        ConnectApi.FeedElement feedElement = MSGDirectMessageUtilDataFactory.getFeed();
        MSGDirectMessageUtilDataFactory.createAccountRecords(1);
        
        Account account = [SELECT Id FROM Account WHERE Name LIKE 'MSGTestAccount%'];
        
        Boolean result = MSGDirectMessageUtil.addToFLMessagetbl(feedElement.id,account.id); 
        
        System.assertEquals(true, result,'FL Message Record Not Inserted');
    }
    
    @isTest
    static void validatepostNewCommentAttachmentTest(){
        
        ConnectApi.FeedElementPage testPage = new ConnectApi.FeedElementPage();
        List<ConnectApi.FeedItem> testItemList = new List<ConnectApi.FeedItem>();
        testItemList.add(new ConnectApi.FeedItem());
        testItemList.add(new ConnectApi.FeedItem());
        testPage.elements = testItemList;

        // Set the test data
        ConnectApi.ChatterFeeds.setTestGetFeedElementsFromFeed(null,
            ConnectApi.FeedType.DirectMessages, 'me', testPage);
        
        ConnectApi.FeedElementPage feedElementPage = MSGDirectMessageUtilDataFactory.getFeedElement();
        System.debug('&&&'+feedElementPage.elements[0].Id);
        MSGDirectMessageUtil.validatepostNewCommentAttachment(feedElementPage.elements[0].Id,'Test','');
    }
}