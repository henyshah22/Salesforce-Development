import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class SuccessToastExample extends LightningElement {displayToastNotification() {
const evt = new ShowToastEvent({
title: 'Success',
message: 'Account created successfully',
variant: 'success'
});
this.dispatchEvent(evt);
}handleSave() {
this.displayToastNotification()
}}