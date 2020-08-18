({
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

    getToggleButtonValue : function(component, event, helper) {
      /*  
        //var comId = component.find(component.get('v.selectedMsgWrapper').flMessage.feedId);
        var eleId = component.get('v.selectedFeedIdValue');
		var directMsg = component.get("v.directMsgWrapper");
        for(let i = 0; i < directMsg.length; i++){
            if(directMsg[i].directMessageFeed.directMessageFeedID == eleId){
                directMsg[i].flMessage.marked = true;
                component.set('v.selectedMsgWrapper', directMsg[i]);
            }
        }
        component.set("v.directMsgWrapper", directMsg); */

        //var comId = component.find(component.get('v.selectedMsgWrapper').flMessage.feedId);
        var eleId = component.get('v.selectedFeedIdValue');
        var isMarked = true;
        
        
        isMarked = event.getSource().get('v.value');
        //console.log("--eleId--"+eleId);
        var directMsg = component.get("v.directMsgWrapper");
        //console.log('directMsg >> '+JSON.stringify(directMsg));
        for(let i = 0; i < directMsg.length; i++){
            if(directMsg[i].directMessageFeed.directMessageFeedID == eleId){
               // component.set('v.selectedMsgWrapper', directMsg[i]);
               // server call - feedToggleMarked
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
                //component.set('v.selectedMsgWrapper', directMsg[i]);
            }
        }
        
	},
      
    getSelectedTheme : function(component, event, helper){
  /*      helper.showSpinner(component);
        var feedElementIDValue = '';
        var selectedItem = event.currentTarget;
        var ids = selectedItem.dataset.id;
        
        var Elements = component.find('vertical-tab');
        for (var i = 0; i < Elements.length; i++) {
            var val = Elements[i].getElement().getAttribute('data-id');
            var feedElementID = Elements[i].getElement().getAttribute('data-feedelement-id');
            //console.log('feedElementID...'+feedElementID);
            if(val != ids){
                $A.util.removeClass(Elements[i], "current");
                $A.util.addClass(Elements[i], "border-class");
            } else {
                feedElementIDValue = feedElementID;
                component.set('v.idX', val);
                console.log('Elements[i]>> '+Elements[i]);     
                $A.util.addClass(Elements[i],"current");
                $A.util.removeClass(Elements[i], "border-class");
            }
        }
        var action = component.get('c.getSelectedFeedElementDetails'); 
        action.setParams({
            "feedElementID" : feedElementIDValue,
            "commentCount":25,
            "elementsPerBundle":10
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
                
        /*	} else if(a.getState() === 'INCOMPLETE') {
              
            } else if(a.getState() === 'ERROR') {
            	
            }
           
            helper.hideSpinner(component);
            
        });
        
        $A.enqueueAction(action);
        
        //var isLoading = 'true';
        //cmp.set('v.loaded', isLoading); */
        
    },
    
    
 newwin : function(component, event, helper){
     
  /*   var accountId = component.get('v.selectedMsgWrapper.flMessage.familyID');
     var workspaceAPI = component.find("workspace");
     workspaceAPI.openTab({
         recordId: accountId,
         focus: true
     }) */
 },
    
    sendFirstMessage:function(component,event,helper){        
       /* var selectedAccounts = component.get("v.selectedAccountLookUpRecords");
        var selectedUserId = component.get("v.selectedUserLookUpRecords");
        var messageBody = component.get("v.newMessageBody");
        var subjectValue = component.get("v.subjectValue");
        //var UploadedFileID = component.get("v.fileName");
        //system.debug('UploadedFileID --> ' + UploadedFileID);
        var userIdArray = [];
        for (var i = 0; i < selectedUserId.length; i++) {
            userIdArray.push(selectedUserId[i].Id);
        }
        var action = component.get('c.sendNewMessage'); 
        action.setParams({
            "familyAccount":selectedAccounts[0].Id,
            "lstOfMessageToUsers" : userIdArray,
            "subject" : subjectValue,
            "messageBody" : messageBody
        });
        action.setCallback(this, function(a){
            
            var state = a.getState(); // get the response state
          
            if(state == 'SUCCESS') {
               
                if(a.getReturnValue()){
                    
                   $A.get('e.force:refreshView').fire();
                    
                }
            }
        });
        $A.enqueueAction(action);
        component.set("v.isOpenNewMsg", false);
        component.set("v.fileName", "");
        component.set("v.attachId", ""); */
        
    },
    createNewMessage:function(component,event,helper){
        
       // component.set("v.isOpenNewMsg",true);
    },
    openBackupAdvisorModal:function(component,event,helper){
        
       // component.set("v.openBackupAgentModal",true);
    },
    closeModel:function(component,event,helper){
        
        component.set("v.isOpenNewMsg",false);
        component.set("v.openBackupAgentModal",false);
    },
    postComments : function(component, event, helper) {
       
        helper.postComments(component,event);

    },   
    
    handleUploadFinished: function (cmp, event) {
        // Get the list of uploaded files

        var uploadedFiles = event.getParam("files");
        alert("Files uploaded : " + uploadedFiles.length);
		
        // Get the file name
        uploadedFiles.forEach(file => console.log(file.name));
    },

     handleUploadFinishedNew : function(component, event, helper) {
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

    },
       selectFilterOption :function(component,event,helper){
        
     /*   var selectedItem = document.getElementById("selectItem").value;
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
            
        } */
        
        
    }
    
})