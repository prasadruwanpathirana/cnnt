({
	closeModel : function(component, event, helper) {
		component.set("v.openBackupAgentModal",false);
	},
    
    save:function(component,event,helper){
        debugger;
      /*  var Users = component.get('v.selectedUserLookUpRecords');
		console.log(Users);
        var action = component.get("c.addBackupAdivisors");
        
        action.setParams({
            "lstOfUsers":Users
        })
        
        action.setCallback(this,function(response){
            console.log(response.getState());
            if(response.getState() =='SUCCESS'){
                
                component.set("v.openBackupAgentModal",false);
            }
        })
        
        $A.enqueueAction(action); */
        
     /*   $A.createComponent( 'c:MSG_NewPOCAgentView', {
                'isConnectAPI' : true,
                'titleName' : 'My Messages2'
            },
            function(modalComponent, status, errorMessage) {
                if (status === "SUCCESS") {
                    //Appending the newly created component in div
                    var body = component.find('showChildModal').get("v.body");
                    body.push(modalComponent);
                    component.find( 'showChildModal' ).set("v.body", body);
                } else if (status === "INCOMPLETE") {
                	console.log('Server issue or client is offline.');
                } else if (status === "ERROR") {
                	console.log('error');
                }
            }
        ); */
        var selectedUsers = component.get('v.selectedUserLookUpRecords');
        var compEvents = component.getEvent("componentEventFired");// getting the Instance of event
        compEvents.setParams({ "Users" : selectedUsers });// setting the attribute of event
        compEvents.fire();// firing the event.
        
    }
})