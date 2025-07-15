import { LightningElement, track } from 'lwc';
import searchRecords from '@salesforce/apex/GlobalRecordSearchController.searchRecords';

export default class GlobalRecordSearch extends LightningElement {
    @track searchTerm = '';
    @track selectedObjects = [];
    @track results;

    get objectOptions() {
        return [
            { label: 'Account', value: 'Account' },
            { label: 'Contact', value: 'Contact' },
            { label: 'Opportunity', value: 'Opportunity' }
        ];
    }

    handleSearchTermChange(event) {
        this.searchTerm = event.target.value;
    }

    handleObjectChange(event) {
        this.selectedObjects = event.detail.value;
    }

    handleSearch() {
        if (this.searchTerm && this.selectedObjects.length > 0) {
            searchRecords({ searchTerm: this.searchTerm, objectNames: this.selectedObjects })
                .then(result => {
                    this.results = result;
                })
                .catch(error => {
                    console.error('Error:', error);
                });
        } else {
            this.results = [];
        }
    }
}
