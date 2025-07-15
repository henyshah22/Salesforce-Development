import { LightningElement, api, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { CloseActionScreenEvent } from 'lightning/actions';
import sendEmail from '@salesforce/apex/SendEmailAction.sendEmail';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';

export default class EmailAction extends LightningElement {
    @api recordId;

    @track toEmail = '';
    @track subject = '';
    @track body = '';
    @track files = [];
    @track fileNames = [];
    @track success = false;
    @track error = '';

    @wire(getRecord, { recordId: '$recordId', fields: [EMAIL_FIELD] })
    contactRecord({ data, error }) {
        if (data) {
            this.toEmail = data.fields.Email.value || '';
        } else if (error) {
            this.error = 'Could not load contact email.';
        }
    }

    handleToEmailChange(e) { this.toEmail = e.target.value; }
    handleSubjectChange(e) { this.subject = e.target.value; }
    handleBodyChange(e) { this.body = e.target.value; }
    handleFileChange(e) {
        this.files = e.target.files;
        this.fileNames = Array.from(this.files).map(file => file.name);
    }

    async handleSend() {
        this.error = '';
        this.success = false;

        try {
            const attachments = [];
            for (let file of this.files) {
                const content = await this.readFileAsBase64(file);
                attachments.push({ name: file.name, content });
            }

            await sendEmail({
                toEmail: this.toEmail,
                subject: this.subject,
                body: this.body,
                attachments: attachments
            });

            this.success = true;
            setTimeout(() => this.dispatchEvent(new CloseActionScreenEvent()), 2000);
        } catch (err) {
            this.error = 'Error: ' + (err.body?.message || err.message || 'Unknown error');
        }
    }

    handleCancel() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    readFileAsBase64(file) {
        return new Promise((resolve, reject) => {
            const reader = new FileReader();
            reader.onload = () => resolve(reader.result.split(',')[1]);
            reader.onerror = () => reject(new Error('Failed to read file.'));
            reader.readAsDataURL(file);
        });
    }
}
