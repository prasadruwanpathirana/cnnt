({
	closeModel:function(component,event,helper){
        
        component.set("v.isOpenNewMsg",false);
        component.set("v.openBackupAgentModal",false);
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
})