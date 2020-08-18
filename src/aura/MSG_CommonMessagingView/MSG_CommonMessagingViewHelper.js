({
	postComments:function(component,event){
        if(component.get("v.isConnectAPI")) {
            //comment throught connect api
            var feedElementId = component.get("v.selectedFeedIdValue");
            var msgText = component.get("v.replyValue");
            var fileID = component.get("v.attachId");
            var action = component.get('c.validatepostNewCommentAttachment'); 
            action.setParams({
                "msgText" : msgText,
                "feedElementId" : feedElementId,
                "fileId":fileID
            });
            action.setCallback(this, function(a){			
                var state = a.getState(); // get the response state   
                if(state == 'SUCCESS') {
                    var commentlist = component.get('v.selectedMsgWrapper');
                    commentlist.directMessageFeed.directFeedComments.push(a.getReturnValue());
                    component.set('v.selectedMsgWrapper', null);
                    component.set('v.selectedMsgWrapper', commentlist);
                    component.find("replyRichText").set("v.value", "");
                    component.set(component.get("v.attachId"),null); 
                }
            });
            $A.enqueueAction(action);
        } else {
            
       		//comment without using connect api
            
        }
    }
})