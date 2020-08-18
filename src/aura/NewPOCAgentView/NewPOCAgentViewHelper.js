({
    showSpinner: function(component) {
        var spinnerMain =  component.find("Spinner");
        $A.util.removeClass(spinnerMain, "slds-hide");
    },
    
    hideSpinner : function(component) {
        var spinnerMain =  component.find("Spinner");
        $A.util.addClass(spinnerMain, "slds-hide");
    },

    
    postComments:function(component,event){
        var feedElementId = component.get("v.selectedFeedIdValue");
        var msgText = component.get("v.replyValue");
        var fileID = component.get("v.attachId");
        
        /*var action = component.get('c.postNewComment'); 
        action.setParams({
            "msgText" : msgText,
            "feedElementId" : feedElementId,
        });*/
        var action = component.get('c.validatepostNewCommentAttachment'); 
        action.setParams({
            "msgText" : msgText,
            "feedElementId" : feedElementId,
            "fileId":fileID
        });
        action.setCallback(this, function(a){
			
            var state = a.getState(); // get the response state
            console.log(state);
   
            if(state == 'SUCCESS') {
                //$A.get('e.force:refreshView').fire();
                var commentlist = component.get('v.selectedMsgWrapper');
                commentlist.directMessageFeed.directFeedComments.push(a.getReturnValue());
                //commentlist.pust(a.getReturnValue());
                component.set('v.selectedMsgWrapper', commentlist);
                //component.set('v.messageDetail', a.getReturnValue());
                component.find("replyRichText").set("v.value", "");

                var chatHistory = document.getElementById("scrollbar");
				chatHistory.scrollHeight = chatHistory.scrollTop + 50;
               
                //component.set(component.get("v.replyValue"),'');
               // component.set(component.get("v.attachId"),''); 
                
                //component.set("v.fileName",NULL);
        		
                //document.getElementById('scrollbar').scrollTop = document.getElementById('scrollbar').scrollHeight - document.getElementById('scrollbar').clientHeight
            }
        });
        $A.enqueueAction(action);
    }
})