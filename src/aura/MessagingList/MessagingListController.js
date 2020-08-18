({
	getSelectedTheme : function(component, event, helper){
        helper.showSpinner(component);
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
                
        	} else if(a.getState() === 'INCOMPLETE') {
              
            } else if(a.getState() === 'ERROR') {
            	
            }
           
            helper.hideSpinner(component);
            
        });
        
        $A.enqueueAction(action);
        
        //var isLoading = 'true';
        //cmp.set('v.loaded', isLoading);
        
    },
    
    getMoreData :  function(component, event, helper){
      console.log(1);   
    }
})