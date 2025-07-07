import { LightningElement,api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import uploadFile from '@salesforce/apex/FileUploaderPreviewInChildComp.uploadFile';     
export default class FileUploaderPreviewInChildComp extends LightningElement {
    @api recordId;
    fileData
    openFileUpload(event){
        const file = event.target.files[0]
        var reader= new FileReader()
        reader.onload = () => {
            var base64 = reader.result.split(',')[1];
            this.fileData = {
                'filename' : file.name,
                'base64' : base64,
                'recordId' : this.recordId,
            }
            console.log('Filename:', this.fileData.filename);
            console.log('Base64', this.fileData.base64?.substring(0, 100));
            console.log('Record ID:', this.fileData.recordId);
        }
        reader.readAsDataURL(file);
    }
    submitFile(){
        const {base64, filename, recordId} = this.fileData
        console.log('FileData:', this.fileData)
        uploadFile({ base64, filename, recordId }).then(result => {
            this.fileData = null
            console.log(`${result} uploaded successfully`)
            let title = `${filename} uploaded successfully`
            this.toast(title)
        })
    }
    toast(title){
            const evt = new ShowToastEvent({
            title: title,
            variant: 'success',
        });
            this.dispatchEvent(evt);    
    }
}