({
	closeModel : function(component, event, helper) {
		component.set("v.openBackupAgentModal",false);
	},
    
    save:function(component,event,helper){
        
        var compEvents = component.getEvent("componentEventFired");
        compEvents.setParams({ "message" : "Child Event Fired" });
        
    }
})