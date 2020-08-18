({
    doInit : function(component, event, helper) {
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        component.set('v.userIdValue', userId);
        var pageNumber = component.get("v.PageNumber"); 
        helper.getDMList(component, pageNumber, userId);
    },
    
    handleNext: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber");  
        pageNumber++;
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        helper.getDMList(component, pageNumber, userId);
    },
    
    handlePrev: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber");  
        pageNumber--;
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        helper.getDMList(component, pageNumber, userId);
    },
    
    detailHandleNext: function(component, event, helper) {
        var detailPageNumber = component.get("v.DetailPageNumber");  
        detailPageNumber++;
        var feedIDValue = component.get("v.FeedIDValue");  
        //console.log('feedIDValue : ' + feedIDValue);
        helper.getDMDetailList(component, feedIDValue, detailPageNumber);
    },
    
    detailHandlePrev: function(component, event, helper) {
        var detailPageNumber = component.get("v.DetailPageNumber");  
        detailPageNumber--;
        var feedIDValue = component.get("v.FeedIDValue");  
        //console.log('feedIDValue : ' + feedIDValue);
        helper.getDMDetailList(component, feedIDValue, detailPageNumber);
    },
    
    getToggleButtonValue : function(component, event, helper) {
        
        var eleId = component.get('v.selectedFeedIdValue');
        var isMarked = true;

        isMarked = event.getSource().get('v.value');
        var directMsg = component.get("v.directMsgWrapper");
        for(let i = 0; i < directMsg.length; i++){
            if(directMsg[i].directMessageFeed.directMessageFeedID == eleId){
                directMsg[i].flMessage.marked = isMarked;
                var action = component.get("c.feedToggleMarked");
                
                action.setParams({
                    "flflag":isMarked,
                    "feedID":eleId
                });
                
                action.setCallback(this,function(response){
                    var result = response.getReturnValue();
                    if(result == true) { 
                        component.set("v.directMsgWrapper", directMsg);
                        component.set('v.selectedMsgWrapper', directMsg[i]);
                    }
                });
 
                $A.enqueueAction(action);
            }
        } 
    },
    
    getSelectedTheme : function(component, event, helper){
        helper.showSpinner(component);
        var feedIDValue = '';
        var selectedItem = event.currentTarget;
        var ids = selectedItem.dataset.id;
        
        var Elements = component.find('vertical-tab');
        for (var i = 0; i < Elements.length; i++) {
            var val = Elements[i].getElement().getAttribute('data-id');
            var feedID = Elements[i].getElement().getAttribute('data-feed-id');
            if(val != ids){
                $A.util.removeClass(Elements[i], "current");
                $A.util.addClass(Elements[i], "border-class");
            } else {
                feedIDValue = feedID;
                component.set('v.idX', val);
                console.log('Elements[i]>> '+Elements[i]);     
                $A.util.addClass(Elements[i],"current");
                $A.util.removeClass(Elements[i], "border-class");
            }
        }
        
        component.set('v.FeedIDValue', feedIDValue );
        component.set('v.DetailPageNumber', 1);
        
        var detailPageNumber = component.get("v.DetailPageNumber");
        helper.getDMDetailList(component, feedIDValue, detailPageNumber);
        helper.hideSpinner(component);        
    },
    
    newwin : function(component, event, helper){
        
        var workspaceAPI = component.find("workspace");       
        workspaceAPI.openTab({
            url: '/lightning/r/Account/0012w00000GjZ1OAAV/view',
            focus: true
        }).then(function(response) {
            workspaceAPI.openSubtab({
                parentTabId: response,
                url: '/lightning/r/Contact/0032w00000C4maDAAR/view',
                focus: true
            });
        })
        .catch(function(error) {
            console.log(error);
        });
    },
    
    createNewMessage:function(component,event,helper){
        
        component.set("v.isOpenNewMsg",true);
    },
    
    openBackupAdvisorModal:function(component,event,helper){
        
        component.set("v.openBackupAgentModal",true);
    },
    
    closeModel:function(component,event,helper){
        
        component.set("v.isOpenNewMsg",false);
        component.set("v.openBackupAgentModal",false);
    },
    
    postComments : function(component, event, helper) {
        
        helper.postComments(component,event);
        
    },
    
    sendFirstMessage:function(component,event,helper){     
        debugger;
        component.set("v.isSpinnerHide", false);
        var selectedAccounts = component.get("v.selectedAccountLookUpRecords");
        var selectedUserId = component.get("v.selectedUserLookUpRecords");
        var messageBody = component.get("v.newMessageBody");
        var subjectValue = component.get("v.subjectValue");
        var UploadedFileID = component.get("v.attachId");
        var userIdArray = [];
        for (var i = 0; i < selectedUserId.length; i++) {
            userIdArray.push(selectedUserId[i].Id);
        }
        console.log('UploadedFileID----'+UploadedFileID);
        var action = component.get('c.sendNewMessage'); 
        action.setParams({
            "familyAccount":selectedAccounts[0].Id,
            "lstOfMessageToUsers" : userIdArray,
            "subject" : subjectValue,
            "messageBody" : messageBody,
            "uploadedFiledID":UploadedFileID == undefined ? null : UploadedFileID
        });
        action.setCallback(this, function(a){      
            component.set("v.isOpenNewMsg", false);
            component.set("v.fileName", "");
            component.set("v.attachId", "");
            var state = a.getState(); // get the response state
            debugger;
            if(state == 'SUCCESS') {               
                if(a.getReturnValue()){
                    console.log("SUCCESS");
                    //$A.get('e.force:refreshView').fire();                
                    var p = component.get("v.parent");
                    p.parentMethod();   
                    component.set("v.isSpinnerHide", true);
                }
            }
            else if (state === "INCOMPLETE") {
                console.log("Incomplete");
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
                    else
                    {
                        alert('Error');
                        console.log("Unknown error");
                    } 
            
        });
        $A.enqueueAction(action);
        // component.set("v.isOpenNewMsg", false);
        // component.set("v.fileName", "");
        // component.set("v.attachId", "");
        
    },
    
    selectFilterOption :function(component,event,helper){
        debugger;
        var selectedItem = document.getElementById("selectItem").value;
        //var selectedItem = component.find("selectItem").get("v.value");
        console.log('selectedItem> '+selectedItem);
        if(selectedItem === 'Marked'){
            var markeddata  = component.get('v.markDirectMsgWrapper');
            component.set('v.directMsgWrapper', undefined);
            component.set('v.directMsgWrapper', markeddata);
            
        }else if(selectedItem === 'Unmarked'){
            var unmarkeddata  = component.get('v.unMarkedDirectMsgWrapper');
            component.set('v.directMsgWrapper', undefined);
            component.set('v.directMsgWrapper', unmarkeddata);
        }else{
            var alldata = component.get('v.FullDirectMsgWrapper');
            component.set('v.directMsgWrapper', undefined);
            component.set('v.directMsgWrapper', alldata);
            
        }
        
    },
    
    handleUploadFinishedNew : function(component, event, helper) {
        debugger;
        var uploadedFiles = event.getParam("files");
        var documentId = uploadedFiles[0].documentId;
        var fileName = uploadedFiles[0].name;
        component.set("v.fileName", fileName);
        component.set("v.attachId", documentId);
        for(var i = 0; i < uploadedFiles.length; i++){
            console.log(uploadedFiles[i].name);
            console.log(uploadedFiles[i].documentId);
        }
        
        var toastEvent = $A.get("e.force:showToast");
        for(var i = 1; i < uploadedFiles.length; i++){
            fileName = fileName + ','+''+ uploadedFiles[i].name;
        }
        console.log("Names::::::"+fileName);
        
        toastEvent.setParams({
            "title": "Success!",
            "message": "File(s) "+ fileName +" Uploaded successfully.",
            "type" : "SUCCESS"
        });
        toastEvent.fire();
        
    }
    
})