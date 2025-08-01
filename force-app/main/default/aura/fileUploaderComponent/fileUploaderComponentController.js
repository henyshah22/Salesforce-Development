({
    handleUploadFinished: function(component, event, helper) {
        const uploadedFiles = event.getParam("files");
        const docId = uploadedFiles[0].documentId;

        const action = component.get("c.getBase64ContentVersion");
        action.setParams({ contentDocumentId: docId });

        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                const base64 = response.getReturnValue();
                const imageEvent = component.getEvent("imageUploaded");
                imageEvent.setParams({ imageData: base64 });
                imageEvent.fire();
            } else {
                console.error("Failed to fetch image");
            }
        });
        $A.enqueueAction(action);
    }
})
