import { LightningElement, api, track } from 'lwc';
import retrieveFilesPaginated from '@salesforce/apex/AttachmentController.retrieveFilesPaginated';
import getTotalFileCount from '@salesforce/apex/AttachmentController.getTotalFileCount';

export default class AttachmentRelatedList extends LightningElement {
    @api recordId;
    @track results = [];
    relatedListTitle;

    pageSize = 4;
    currentPage = 1;
    totalFiles = 0;
    totalPages = 0;

    connectedCallback() {
        this.fetchFileData();
    }

    async fetchFileData() {
        try {
            this.totalFiles = await getTotalFileCount({ recordId: this.recordId });
            this.totalPages = Math.ceil(this.totalFiles / this.pageSize);
            const offset = (this.currentPage - 1) * this.pageSize;

            const data = await retrieveFilesPaginated({
                recordId: this.recordId,
                pageSize: this.pageSize,
                offsetVal: offset
            });

            this.prepareFileRows(data);
        } catch (err) {
            console.error(err);
        }
    }

    prepareFileRows(data) {
        this.relatedListTitle = `Attachments (${this.totalFiles})`;
        this.results = data.map(element => ({
            fileId: element.Id,
            fileName: element.Title,
            filePath: element.PathOnClient,
            fileType: element.FileType,
            fileExtn: element.FileExtension,
            fileSize: this.formatFileSize(element.ContentSize),
            fileDate: this.formatDateString((element.CreatedDate).slice(0, 10)),
            thumbnailPath: `/sfc/servlet.shepherd/version/renditionDownload?rendition=thumb120by90&versionId=${element.Id}&operationContext=CHATTER&contentId=${element.ContentDocumentId}`,
            downloadUrl: `/sfc/servlet.shepherd/document/download/${element.ContentDocumentId}`,
            viewUrl: `/lightning/r/ContentDocument/${element.ContentDocumentId}/view`
        }));
    }

    handlePrevious() {
        if (this.currentPage > 1) {
            this.currentPage--;
            this.fetchFileData();
        }
    }

    handleNext() {
        if (this.currentPage < this.totalPages) {
            this.currentPage++;
            this.fetchFileData();
        }
    }

    @api
    refreshList(linkedEntityId) {
        this.currentPage = 1;
        this.recordId = linkedEntityId;
        this.fetchFileData();
    }

    get isPreviousDisabled() {
        return this.currentPage === 1;
    }

    get isNextDisabled() {
        return this.currentPage === this.totalPages || this.totalPages === 0;
    }

    formatDateString(dateStr) {
        const dt = new Date(dateStr);
        const year = new Intl.DateTimeFormat('en', { year: 'numeric' }).format(dt);
        const month = new Intl.DateTimeFormat('en', { month: 'short' }).format(dt);
        const day = new Intl.DateTimeFormat('en', { day: '2-digit' }).format(dt);
        return month + ' ' + day + ', ' + year;
    }

    formatFileSize(fileSize) {
        let f = Math.abs(fileSize / 1024);
        return f > 1024 ? (fileSize / (1024 * 1024)).toFixed(2) + ' MB' : Math.round(f) + ' KB';
    }
}
