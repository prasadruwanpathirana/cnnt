({
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
    
    createNewMessage:function(component,event,helper){
        
        component.set("v.isOpenNewMsg",true);
    },
    
    openBackupAdvisorModal:function(component,event,helper){
        
        component.set("v.openBackupAgentModal",true);
    },
    
    
})