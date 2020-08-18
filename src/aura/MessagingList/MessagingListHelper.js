({
	showSpinner: function(component) {
        //var spinnerMain =  component.find("Spinner");
        //$A.util.removeClass(spinnerMain, "slds-hide");
        
        component.set('v.isSpinnerHide', false);
        
    },
    
    hideSpinner : function(component) {
        //var spinnerMain =  component.find("Spinner");
        //$A.util.addClass(spinnerMain, "slds-hide");
        component.set('v.isSpinnerHide', true);
    },
})