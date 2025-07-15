import { LightningElement, track } from 'lwc';
import getRecords from '@salesforce/apex/ObjectRecordsController.getRecords';
import sendEmail from '@salesforce/apex/ObjectRecordsController.sendEmail';

export default class ObjectSelector extends LightningElement {
    @track currentSection = 1;
    @track selectedObject = '';
    @track records = [];
    @track emailSubject = '';
    @track emailBody = '';
    @track previewEmails = [];
    @track toNames = '';

    get objectOptions() {
        return [
            { label: 'Lead', value: 'Lead' },
            { label: 'Account', value: 'Account' },
            { label: 'Contact', value: 'Contact' }
        ];
    }

    get showSection1() {
        return this.currentSection === 1;
    }

    get showSection2() {
        return this.currentSection === 2;
    }

    get showSection3() {
        return this.currentSection === 3;
    }

    handleObjectChange(event) {
        this.selectedObject = event.detail.value;
        getRecords({ objectName: this.selectedObject })
            .then(result => {
                this.records = result.map(rec => {
                    return { ...rec, checked: false };
                });
            })
            .catch(error => {
                console.error('Error fetching records', error);
            });
    }

    handleCheckboxChange(event) {
        const recordId = event.target.dataset.id;
        const isChecked = event.target.checked;
        this.records = this.records.map(rec => {
            if (rec.Id === recordId) {
                return { ...rec, checked: isChecked };
            }
            return rec;
        });
    }

    handleNextSection1() {
        const selected = this.records.filter(rec => rec.checked);
        if (selected.length === 0) {
            alert('select atleast one record.');
            return;
        }
        const names = selected .map(record => record.Name);
        this.toNames = names.join(', ');
        const emails = selected.map(record => {
            if (record.Email__c) {
                return record.Email__c;
            } else {
                return record.Email;
            }
        });
        this.previewEmails = emails;
        this.currentSection = 2;
    }

    handleSubjectChange(event) {
        this.emailSubject = event.target.value;
    }


    handlePreviousSection2() {
        this.currentSection = 1;
    }

    handleNextSection2() {
        if (!this.emailBody) {
            alert('draft your email.');
            return;
        }
        this.currentSection = 3;
    }

    handlePreviousSection3() {
        this.currentSection = 2;
    }

    handleEmailChange(event) {
        this.emailBody = event.target.value;
    }

    handleSend() {
        let emails = this.previewEmails;
        let subject = this.emailSubject;
        sendEmail({ emailAddresses: emails, subject: subject, body: this.emailBody })
            .then(() => {
                alert('Email sent successfully!');
                this.resetWizard();
            })
            .catch(error => {
                console.error('Error sending email', error);
            });
    }

    resetWizard() {
        this.currentSection = 1;
        this.selectedObject = '';
        this.records = [];
        this.emailSubject = '';
        this.emailBody = '';
        this.previewEmails = [];
        this.toNames = '';
    }
}
