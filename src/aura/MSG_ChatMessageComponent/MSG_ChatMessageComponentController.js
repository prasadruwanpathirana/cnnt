({
    postComments : function(component, event, helper) {
        var feedId = component.get("v.selectedFeedIdValue");
        var reply = component.get("v.replyValue");
        var action = component.get('c.postComment'); 
        action.setParams({
            "commentText" : reply,
            "feedElementID" : feedId,
        });
        // Post Comment
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            console.log('this is post comment-'+a.getReturnValue());
            if(state == 'SUCCESS') {
                //$A.get('e.force:refreshView').fire();
                component.set('v.messageDetail', a.getReturnValue());
                component.find("replyRichText").set("v.value", "");
            }
        });
        $A.enqueueAction(action);
    },
    
    openBackupAdvisorModal:function(component,event,helper){
        component.set("v.openBackupAgentModal",true);
    },
    closeBackupAgentModal:function(component,event,helper){
        component.set("v.openBackupAgentModal",false);
    },
    createNewMessage: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpen", true);
    },
    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", false);
    },
    doInit : function(component, event, helper) {
        
        component.set("v.isSpinnerHide", false);
		component.set('v.isSpinnerHide', false);
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        var action = component.get("c.getAllMessagesFromAPIonLoad");
        action.setParams({
            
            "recentCommentCount":25,
            "nextPageToken":"",
            "pageSize":100
        });
        action.setCallback(this,function(response){
            if(response.getState()=='SUCCESS'){
                
                console.log(response.getReturnValue());
                
               var wrapper = response.getReturnValue();
                component.set('v.userIdValue', userId);
                var directMsgWrp = response.getReturnValue();
                component.set("v.directMsgWrapper",directMsgWrp);// left 
                component.set("v.FullDirectMsgWrapper",directMsgWrp);
                 console.log('<><> '+JSON.stringify(directMsgWrp));
                var i;
                var markeddata = [];
                var unMarkeddata = [];
                for (i = 0; i < directMsgWrp.length; i++) {
                    if(directMsgWrp[i].flMessage.marked){
                        markeddata.push(directMsgWrp[i]); 
                    }else{
                        unMarkeddata.push(directMsgWrp[i]); 
                    }
                    
                }
                component.set('v.markDirectMsgWrapper', markeddata);
                component.set('v.unMarkedDirectMsgWrapper', unMarkeddata);
                
                
                console.log('markeddata>> '+markeddata.length);
                console.log('unMarkeddata>> '+unMarkeddata.length);
                //component.set('v.selectedMsgWrapper', wrapper[0]);
                component.set('v.selectedFeedIdValue', wrapper[0].directMessageFeed.directMessageFeedID);
                
                var action1 = component.get("c.getSelectedFeedElementDetails");
                action1.setParams({
                    "feedElementID":wrapper[0].directMessageFeed.directMessageFeedID,
                    "commentCount":25,
                    "elementsPerBundle":10
                });
                action1.setCallback(this,function(response1){
                    
                    var result = response1.getReturnValue();
                    component.set("v.selectedMsgWrapper",result);
                    console.log(result);
					component.set('v.isSpinnerHide', true);
                });
                
                $A.enqueueAction(action1);
                
            }
        });
        
        $A.enqueueAction(action);

        
    },
    
    
    
    
    
    getSelectedTheme : function(component, event, helper){
        var feedElementIDValue = '';
        var selectedItem = event.currentTarget;
        var ids = selectedItem.dataset.id;
        var Elements = component.find('vertical-tab');
        for (var i = 0; i < Elements.length; i++) {
            var val = Elements[i].getElement().getAttribute('data-id');
            var feedElementID = Elements[i].getElement().getAttribute('data-feedelement-id');
            console.log('feedElementID...'+feedElementID);
            if(val != ids){
                $A.util.removeClass(Elements[i], "current");
                $A.util.addClass(Elements[i], "border-class");
            } else {
                feedElementIDValue = feedElementID;
                $A.util.addClass(Elements[i],"current");
                $A.util.removeClass(Elements[i], "border-class");
            }
        }
        var action = component.get('c.getSelectedFeedElementDetails'); 
        action.setParams({
            "feedElementID" : feedElementIDValue,
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state

            if(a.getState() === 'SUCCESS') {
                component.set('v.selectedFeedIdValue', feedElementIDValue);
                component.set('v.selectedMsgWrapper', a.getReturnValue());
                component.set('v.replyValue',"");
                console.log(a.getReturnValue());
                /*var eleId = component.get('v.selectedFeedIdValue');
                var directMsg = component.get("v.directMsgWrapper");
                for(let i = 0; i < directMsg.length; i++){
                    if(directMsg[i].directMessageFeed.directMessageFeedID == eleId){
                        component.set('v.selectedMsgWrapper', directMsg[i]);
                    }
                }*/
            }
        });
        $A.enqueueAction(action);
        
    },
         getMoreData :  function(component, event, helper){
      console.log(1);   
    },
        handleFilesChange : function (component, event, helper) {
            var files = event.getSource().get("v.files");
            if(files){
                var file = files[0]
                var reader = new FileReader();
                reader.readAsDataURL(file);
                reader.onload = function () {
                    var template = component.get("v.richtextvalue");
                    if(template===undefined) template = '';
                    template += '<img src="'+reader.result+'"/>';
                    component.set("v.newMessageBody",template);
                    console.log(template);
                };
                reader.onerror = function (error) {
                    console.log('Error: ', error);
                };
            }
        },
            sendFirstMessage : function(component,event,helper){
                var selectedUserId = component.find("lookupSearch").get("v.lstSelectedRecords");
                var messageBody = component.get("v.newMessageBody");
                var subjectValue = component.get("v.subjectValue");
                var userIdArray = [];
                for (var i = 0; i < selectedUserId.length; i++) {
                    userIdArray.push(selectedUserId[i].Id);
                }
                var action = component.get('c.startConversation'); 
                action.setParams({
                    "userIdSet" : userIdArray,
                    "postText" : messageBody,
                    "subjectId" : subjectValue
                });
                action.setCallback(this, function(a){
                    var state = a.getState(); // get the response state
                    if(state == 'SUCCESS') {
                        console.log(a.getReturnValue());
                        $A.get('e.force:refreshView').fire();
                    }
                });
                $A.enqueueAction(action);
                component.set("v.isOpen", false);
            },
                handleAttach : function(component,event,helper){
                    
                },
                    handleUploadFinished: function (cmp, event,helper) {
                        var uploadedFiles = event.getParam("files");
                        var documentId = uploadedFiles[0].documentId;
                        var fileName = uploadedFiles[0].Name;
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Success!",
                            "message": "File "+fileName+" Uoload successfully"
                        })
                        toastEvent.fire();
                        
                        $A.get('e.lightning:openFiles').fire({
                            recordIds: [documentId]
                        })
                    },
                        //File Uploader Added by pavithra on 2020-07-06
                        doSave: function(component, event, helper) {
                            if (component.find("fileId").get("v.files").length > 0) {
                                helper.uploadHelper(component, event);
                            } else {
                                alert('Please Select a Valid File');
                            }
                        },
                            //File Uploader Added by pavithra on 2020-07-06
                            handleFilesChange: function(component, event, helper) {
                                var fileName = 'No File Selected..';
                                if (event.getSource().get("v.files").length > 0) {
                                    fileName = event.getSource().get("v.files")[0]['name'];
                                }
                                component.set("v.fileName", fileName);
                            },
})