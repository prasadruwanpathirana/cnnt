({
    doInit : function(component, event, helper) {
        console.log('Modal Popup Load');
    },
     
    handleSubmit : function(component, event, helper){
        var userName = document.getElementById("userName");
        var enteredName = document.getElementById("enteredName");
        enteredName.innerHTML = userName.value;
         
        var popupWindow = component.find('modalDiv').getElement();
        if(popupWindow){
            popupWindow.style.display = 'none';
        }
    },
    handleCloseModal : function(component, event, helper){
        var popupWindow = component.find('modalDiv').getElement();
        if(popupWindow){
            popupWindow.style.display = 'none';
        }
    }
})