({
    handleImageUpload: function(component, event, helper) {
        const imageData = event.getParam("imageData");
        component.set("v.uploadedImage", imageData);
    }
})