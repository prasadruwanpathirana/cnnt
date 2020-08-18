({
	openInNewTab : function(component, event, helper){
         var accountId = component.get('v.selectedMsgWrapper.flMessage.familyID');
         var workspaceAPI = component.find("workspace");
         workspaceAPI.openTab({
             recordId: accountId,
             focus: true
         })
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
    
    postComments : function(component, event, helper) {
        helper.postComments(component,event);
    },
    
    handleUploadFinishedNew : function(component, event, helper) {
        var uploadedFiles = event.getParam("files");
        var documentId = uploadedFiles[0].documentId;
        var fileName = uploadedFiles[0].name;
        component.set("v.fileName", fileName);
        component.set("v.attachId", documentId);
        var toastEvent = $A.get("e.force:showToast");
        for(var i = 1; i < uploadedFiles.length; i++){
            fileName = fileName + ','+''+ uploadedFiles[i].name;
        }
        toastEvent.setParams({
            "title": "Success!",
            "message": "File(s) "+ fileName +" Uploaded successfully.",
            "type" : "SUCCESS"
        });
        toastEvent.fire();
    }

})