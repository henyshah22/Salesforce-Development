import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import uploadFile from '@salesforce/apex/dropBox.uploadFile';
import deleteFile from '@salesforce/apex/dropBox.deleteFile';
import listFiles from '@salesforce/apex/dropBox.listFiles';

export default class DropBox extends LightningElement {
    @api recordId;
    @track files = [];
    @track fileData;
    @track selectedFileName;
    @track isLoading = false;

    connectedCallback() {
        this.loadFiles();
    }

    async loadFiles() {
        try {
            this.isLoading = true;
            const fileNames = await listFiles({ contactId: this.recordId });
            this.files = fileNames;
        } catch (error) {
            this.showToast('Error', 'Failed to load files: ' + error.body.message, 'error');
        } finally {
            this.isLoading = false;
        }
    }

    handleFileChange(event) {
        const file = event.target.files[0];
        if (file) {
            console.log('File size: ', file.size); 
            const MAX_FILE_SIZE = 4500000;
            if (file.size > MAX_FILE_SIZE) {
                console.log('File size exceeds limit, showing toast');
                this.showToast('Error', 'File size exceeds limit. Maximum allowed size is 4.5 MB.', 'error');
                setTimeout(() => {
                    this.fileData = null;
                    this.selectedFileName = null;
                    const fileInput = this.template.querySelector('lightning-input[type="file"]');
                    if (fileInput) fileInput.value = null;
                }, 0);
                return;
            }
            const reader = new FileReader();
            reader.onload = () => {
                const base64 = reader.result.split(',')[1];
                this.fileData = {
                    fileName: file.name,
                    base64
                };
                this.selectedFileName = file.name;
            };
            reader.readAsDataURL(file);
        } else {
            this.fileData = null;
            this.selectedFileName = null;
        }
    }

    async uploadFile() {
        if (!this.fileData) {
            this.showToast('Error', 'Please select a file to upload.', 'error');
            return;
        }

        try {
            this.isLoading = true;
            await uploadFile({
                contactId: this.recordId,
                fileName: this.fileData.fileName,
                base64Body: this.fileData.base64
            });
            this.showToast('Success', 'File uploaded successfully.', 'success');
            this.files = [...this.files, this.fileData.fileName];
            this.fileData = null;
            this.selectedFileName = null;
            this.template.querySelector('lightning-input[type="file"]').value = null;
        } catch (error) {
            this.showToast('Error', 'Upload failed: ' + error.body.message, 'error');
            this.files = this.files.filter(f => f !== this.fileData?.fileName);
        } finally {
            this.isLoading = false;
        }
    }

    async handleDelete(event) {
        const fileName = event.currentTarget.dataset.filename;
        if (confirm(`Are you sure you want to delete ${fileName}?`)) {
            try {
                this.isLoading = true;
                await deleteFile({ contactId: this.recordId, fileName });
                this.showToast('Success', 'File deleted successfully.', 'success');
                this.files = this.files.filter(f => f !== fileName);
                await this.loadFiles();
            } catch (error) {
                this.showToast('Error', 'Delete failed: ' + error.body.message, 'error');
            } finally {
                this.isLoading = false;
            }
        }
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title,
                message,
                variant
            })
        );
    }
}