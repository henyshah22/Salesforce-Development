import { LightningElement, wire } from 'lwc';
import { subscribe, MessageContext } from 'lightning/messageService';
import ACCOUNTMC from '@salesforce/messageChannel/accountMessageChannel__c';
import getRelatedData from '@salesforce/apex/AccountHelper.getRelatedData';

export default class RelatedDataViewer extends LightningElement {
    accountId;
    contacts;
    opportunities;

    @wire(MessageContext)
    messageContext;

    connectedCallback() {
        this.subscribeToMessageChannel();
    }

    subscribeToMessageChannel() {
        subscribe(this.messageContext, ACCOUNTMC, (message) => {
            this.accountId = message.recordId;
            this.fetchRelatedData();
        });
    }

    fetchRelatedData() {
        getRelatedData({ accountId: this.accountId }).then(result => {
            this.contacts = result.contacts;
            this.opportunities = result.opportunities;
        }).catch(error => {
            console.error('Error fetching related data', error);
        });
    }
}
