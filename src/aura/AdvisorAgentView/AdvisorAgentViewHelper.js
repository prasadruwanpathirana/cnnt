({
    getDMList: function(component, pageNumber, userId) {
        
        
        var pageSize = 6;
        var action = component.get("c.paginationFeedItemFromObject");
        action.setParams({
            "pageNumber": pageNumber,
            "pageSize": pageSize,
            "agentId": userId            
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (component.isValid() && state === "SUCCESS"){
                var resultData = result.getReturnValue();
                //alert(resultData[0].directMssageSubject);
                component.set("v.DMList", resultData);
                component.set("v.PageNumber", pageNumber);
                component.set("v.TotalRecords", resultData[0].totalRecords);
                component.set("v.RecordStart", resultData[0].recordStart);
                if(resultData[0].recordEnd > resultData[0].totalRecords){
                    component.set("v.RecordEnd", resultData[0].totalRecords);
                } else {
                    component.set("v.RecordEnd", resultData[0].recordEnd);
                }
                component.set("v.TotalPages", Math.ceil(resultData[0].totalRecords / pageSize));
                
                var detailPageNumber = component.get("v.DetailPageNumber");
                var feedIDValue = resultData[0].feedId;
                this.getDMDetailList(component, feedIDValue, detailPageNumber);
            }
        });
        $A.enqueueAction(action);
    },
    
    getDMDetailList: function(component, feedIDValue, detailPageNumber){
        var detailPageSize = 5;
        var action = component.get('c.paginationFeedCommentFromObject'); 
        console.log('detailPageNumber in helper : ' + detailPageNumber);
        console.log('feedIDValue in helper : ' + feedIDValue);
        action.setParams({
            "pageNumber": detailPageNumber,
            "pageSize": detailPageSize,
            "directMsgId" : feedIDValue            
        });
        
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (component.isValid() && state === "SUCCESS"){
                var resultData = result.getReturnValue();
                //alert(resultData[0].directMssageSubject);
                component.set("v.DMDetailList", resultData);
                component.set("v.DetailPageNumber", detailPageNumber);
                component.set("v.DetailTotalRecords", resultData.totalRecords);
                component.set("v.DetailRecordStart", resultData.recordStart);
                if(resultData.recordEnd > resultData.totalRecords){
                    component.set("v.DetailRecordEnd", resultData.totalRecords);
                } else {
                    component.set("v.DetailRecordEnd", resultData.recordEnd);
                }
                component.set("v.DetailTotalPages", Math.ceil(resultData.totalRecords / detailPageSize));
            }
        });
        
        $A.enqueueAction(action);
    },
    
    showSpinner: function(component) {
        var spinnerMain =  component.find("Spinner");
        $A.util.removeClass(spinnerMain, "slds-hide");
    },
    
    hideSpinner : function(component) {
        var spinnerMain =  component.find("Spinner");
        $A.util.addClass(spinnerMain, "slds-hide");
    },
    
    postComments:function(component,event){
        
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
            console.log(state);
            
            if(state == 'SUCCESS') {
                var commentlist = component.get('v.selectedMsgWrapper');
                commentlist.directMessageFeed.directFeedComments.push(a.getReturnValue());
                console.log('###Comments'+JSON.stringify(a.getReturnValue()));
                console.log('###Comments'+JSON.stringify(commentlist));
                component.set('v.selectedMsgWrapper', null);
                component.set('v.selectedMsgWrapper', commentlist);
                console.log('###Comments'+JSON.stringify(component.get('v.selectedMsgWrapper')));
                component.find("replyRichText").set("v.value", "");
                
                component.set(component.get("v.attachId"),null);
            }
        });
        
        $A.enqueueAction(action);
    }
})