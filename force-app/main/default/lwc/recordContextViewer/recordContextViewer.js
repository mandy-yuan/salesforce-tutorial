import { LightningElement, api } from 'lwc';

export default class RecordContextViewer extends LightningElement {
    @api recordId;
    @api objectApiName;

    get isContactPage() {
        return this.objectApiName === 'Contact';
    }
}
