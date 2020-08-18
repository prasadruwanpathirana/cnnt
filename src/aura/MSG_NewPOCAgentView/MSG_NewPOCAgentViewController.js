({
	doInit : function(component, event, helper) {        
        component.set("v.isSpinnerHide", false);
        if(component.get("v.isConnectAPI")){
            //using connect api
            var userId = $A.get("$SObjectType.CurrentUser.Id");
            var action = component.get("c.getAllMessagesFromAPIonLoad");
            action.setParams({
                "recentCommentCount":25,
                "nextPageToken":"",
                "pageSize":8
            });
            action.setCallback(this,function(response){
                if(response.getState()=='SUCCESS'){
                    var wrapper = response.getReturnValue();
            		console.log(wrapper);
                    //Sameera
                    if(wrapper.length>0){

                        var value = wrapper[0].currentPageToken;
                        
                        if(typeof value == 'undefined'){
                            
                            component.set("v.nextPageToken",wrapper[0].nextPageToken);
                            component.set("v.isValuesAvailable",true);
                            component.set("v.isNextDisabled",false);
							component.set("v.isPreviousDisabled",true);
                            
                        }else{
                            
                            component.set("v.isNextDisabled",true);
							component.set("v.isPreviousDisabled",true);
                            component.set("v.nextPageToken",wrapper[0].nextPageToken);
                        	component.set("v.previousePageToken",wrapper[0].currentPageToken);
                            component.set("v.isValuesAvailable",true);
                        }
               		}
                    //sameera
                    
                    component.set('v.userIdValue', userId);
                    var directMsgWrp = response.getReturnValue();
                    component.set("v.directMsgWrapper",directMsgWrp);
                    component.set("v.FullDirectMsgWrapper",directMsgWrp);
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
            
        } else {
            //if not using connect api
            var userId = $A.get("$SObjectType.CurrentUser.Id");
            component.set('v.userIdValue', userId);
            var pageNumber = component.get("v.PageNumber"); 
            helper.getDMList(component, pageNumber, userId);            
        }
        
       
    }
    
})