({
	handleEvent : function(component, event, helper) {
        var selectedUsers =event.getParam("Users");
        debugger;
        
        component.set("v.openBackupAgentModal", false);
        
        
        var detail = component.get("v.moretabs");
        var newlst = [];
        newlst.push(detail);
        for(var i=0; i < selectedUsers.length  ; i++) {
            $A.createComponent("lightning:tab", {
                "label" : selectedUsers[i].Name ,
                "id" : "new" + selectedUsers[i].Id ,
                "onactive" : component.getReference("c.addContent")
            }, function(newTab, status, error){
                if(status === "SUCCESS"){
                    newlst.push(newTab);
                    component.set("v.moretabs", newlst);
                } else {
                    throw new Error(error);
                }    
            });
        }
        
        
    /*    $A.createComponent( 'c:MSG_NewPOCAgentView', {
                'isConnectAPI' : true,
                'titleName' : 'My Messages2'
            }, */
                           
                  
                           
         /*   function(modalComponent, status, errorMessage) {
                if (component.isValid() && status === "SUCCESS") {
                    //Appending the newly created component in div
                    var body = component.get("v.body");
                body.push(modalCmp);
                component.set("v.body", body);
                    
                } else if (status === "INCOMPLETE") {
                	console.log('Server issue or client is offline.');
                } else if (status === "ERROR") {
                	console.log('error');
                }
            } */
        
   /*    $A.createComponent('c:MSG_NewPOCAgentView', {
            'isConnectAPI' : true,
                'titleName' : name
             
        }, function attachModal(modalCmp, status) {

		var existingADetails = component.get("v.agentDetails");  
            if(existingADetails == null) {
                existingADetails= [];
            }
        var agent = {'name' : 'test'}; 
        existingADetails.push(agent); 
            component.set("v.agentDetails", existingADetails); 
            
            if (component.isValid() && status === 'SUCCESS') {
               /* var body = component.get("v.body");
                body.push(modalCmp);
                component.set("v.body", body);   */
       /*     	component.set("v.agenttabs", modalCmp );
                var body = component.get("v.body");
                body.push(modalCmp);
                component.set("v.body", body); 
                
          
            }
        }); */
       
    },
    addContent : function(component, event, helper){
        var tab = event.getSource();
    /*   switch(tab.get('v.id')){
            case 'new' :
                 $A.createComponent('c:MSG_NewPOCAgentView', {
                    'isConnectAPI' : true,
                    'titleName' : "test"            
                }, function (newContent, status, error) {
        
                	if (status === 'SUCCESS') {
                        tab.set('v.body', newContent);
                    } else {
                        alert('error');
                    }
               
 
            })
        } */
        
         $A.createComponent('c:MSG_NewPOCAgentView', {
                    'isConnectAPI' : true,
                    'titleName' : "Agent Messages"            
                }, function (newContent, status, error) {
        
                	if (status === 'SUCCESS') {
                        tab.set('v.body', newContent);
                    } else {
                        alert('error');
                    }
               
 
            })
        
        
    }
	
})