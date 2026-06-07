import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import NAME_FIELD from '@salesforce/schema/Contact.Name';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import PHONE_FIELD from '@salesforce/schema/Contact.Phone';
import TITLE_FIELD from '@salesforce/schema/Contact.Title';

const CONTACT_FIELDS = [
    NAME_FIELD,
    EMAIL_FIELD,
    PHONE_FIELD,
    TITLE_FIELD
];

export default class ContactRecordPanel extends LightningElement {
    @api recordId;

    editableFields = [
        EMAIL_FIELD,
        PHONE_FIELD,
        TITLE_FIELD
    ];

    @wire(getRecord, {
        recordId: '$recordId',
        fields: CONTACT_FIELDS
    })
    contact;

    get contactName() {
        return getFieldValue(this.contact.data, NAME_FIELD);
    }

    get contactEmail() {
        return getFieldValue(this.contact.data, EMAIL_FIELD) || 'No email listed';
    }

    get contactPhone() {
        return getFieldValue(this.contact.data, PHONE_FIELD) || 'No phone listed';
    }

    get contactTitle() {
        return getFieldValue(this.contact.data, TITLE_FIELD) || 'No title listed';
    }

    get errorMessage() {
        if (this.contact.error && this.contact.error.body) {
            return this.contact.error.body.message;
        }

        return 'Unknown error';
    }

    handleSuccess() {
        const event = new ShowToastEvent({
            title: 'Contact updated',
            message: 'The Contact record was updated successfully.',
            variant: 'success'
        });

        this.dispatchEvent(event);
    }
}
