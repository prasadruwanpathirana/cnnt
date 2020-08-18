({
	getSelectedRecord : function(component, event, helper){
        
       
        helper.showSpinner(component);
        if(component.get("v.isConnectAPI")){
            //when using connect api
            var feedElementIDValue = '';
            var selectedItem = event.currentTarget;
            var ids = selectedItem.dataset.id;        
            var Elements = component.find('vertical-tab');
            for (var i = 0; i < Elements.length; i++) {
                var val = Elements[i].getElement().getAttribute('data-id');
                var feedElementID = Elements[i].getElement().getAttribute('data-feedelement-id');
                if(val != ids){
                    $A.util.removeClass(Elements[i], "current");
                    $A.util.addClass(Elements[i], "border-class");
                } else {
                    feedElementIDValue = feedElementID;
                    component.set('v.idX', val);    
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
                } else if(a.getState() === 'INCOMPLETE') {
                  
                } else if(a.getState() === 'ERROR') {
                    
                }           
                helper.hideSpinner(component);            
            });        
            $A.enqueueAction(action);
        } else {
            // when connect api is not using
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
        }
    },
    
    getMoreData :  function(component, event, helper){
      console.log(1);   
    },
    
    handleNext: function(component, event, helper) {
        if(component.get("v.isConnectAPI") == false){
            var pageNumber = component.get("v.PageNumber");  
            pageNumber++;
            var userId = $A.get("$SObjectType.CurrentUser.Id");
            helper.getDMList(component, pageNumber, userId);
        }
    },
    
    handlePrev: function(component, event, helper) {
        if(component.get("v.isConnectAPI") == false){
            var pageNumber = component.get("v.PageNumber");  
            pageNumber--;
            var userId = $A.get("$SObjectType.CurrentUser.Id");
            helper.getDMList(component, pageNumber, userId);
        }
    },
    
    getNextPages:function(component,event,helper){

        var nextPageToken = component.get("v.nextPageToken");
        
        var action = component.get("c.nextFeedItem");
        action.setParams({
            "recentCommentCount":25,
            "nextPageToken":nextPageToken,
            "pageSize":8
        });
        action.setCallback(this,function(response){
            
            var wrapper = response.getReturnValue();
			var value = wrapper[0].nextPageToken;
            
            
            component.set("v.directMsgWrapper",wrapper);

            if(typeof value == "undefined"){

                component.set("v.isNextDisabled",true);
                component.set("v.isPreviousDisabled",false);
                component.set("v.previousePageToken",wrapper[0].currentPageToken);
                component.set("v.selectedMsgWrapper",wrapper[0]);
                
            }else{
                
                component.set("v.isPreviousDisabled",false);
                component.set("v.nextPageToken",wrapper[0].nextPageToken);
            	component.set("v.previousePageToken",wrapper[0].currentPageToken);
                component.set("v.selectedMsgWrapper",wrapper[0]);
            }
        });
        
        $A.enqueueAction(action);
    },
    
    getPreviousePage:function(component,event,helper){
    	
        var previouseToken = component.get("v.previousePageToken");
        var action = component.get("c.previousFeedItem");
        
        action.setParams({
            "recentCommentCoun":25,
            "previousPageToken":'',
            "pageSize":10
        });
        
        action.setCallback(this,function(response){

            var wrapper = response.getReturnValue();

            component.set("v.directMsgWrapper",wrapper);
            var value = wrapper[0].nextPageToken;
			         
            if(typeof value == "undefined"){
                
               
                component.set("v.previousePageToken",wrapper[0].currentPageToken);
                component.set("v.selectedMsgWrapper",wrapper[0]);
            }else{
                component.set("v.nextPageToken",wrapper[0].nextPageToken);
            	component.set("v.previousePageToken",wrapper[0].currentPageToken);
                component.set("v.selectedMsgWrapper",wrapper[0]);
            }

            
        });
        
        $A.enqueueAction(action);
	},
})