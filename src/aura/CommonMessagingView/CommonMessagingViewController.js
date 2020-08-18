({
	 newwin : function(component, event, helper){
     debugger;
         var accountId = component.get('v.selectedMsgWrapper.flMessage.familyID');
         var workspaceAPI = component.find("workspace");
         workspaceAPI.openTab({
             recordId: accountId,
             focus: true
         })
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
                         console.log('<><> '+JSON.stringify(directMsg));
                     }
                });
                
                 $A.enqueueAction(action);
                //component.set('v.selectedMsgWrapper', directMsg[i]);
            }
        }
        
	},
    postComments : function(component, event, helper) {
       
        helper.postComments(component,event);

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