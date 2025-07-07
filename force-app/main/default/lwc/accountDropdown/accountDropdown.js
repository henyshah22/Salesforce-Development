import { LightningElement, wire } from 'lwc';
import getAccounts from '@salesforce/apex/AccountHelper.getAccounts';
import { publish, MessageContext } from 'lightning/messageService';
import ACCOUNTMC from '@salesforce/messageChannel/accountMessageChannel__c';

export default class AccountDropdown extends LightningElement {
    accountOptions = [];

    @wire(MessageContext)
    messageContext;

    @wire(getAccounts)
    wiredAccounts({ data, error }) {
        console.log(data);
        if (data) {
            this.accountOptions = data.map(acc => ({
                label: acc.Name,
                value: acc.Id
            }));
        } else if (error){
            console.error(error);
        }
    }

    handleChange(event) {
        const selectedAccountId = event.detail.value;
        publish(this.messageContext, ACCOUNTMC, {
            recordId: selectedAccountId
        });
    }
}