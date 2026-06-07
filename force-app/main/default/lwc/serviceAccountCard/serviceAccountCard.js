import { LightningElement, api } from 'lwc';

export default class ServiceAccountCard extends LightningElement {
    @api account;
    @api selectedAccountId;

    get isSelected() {
        return this.account && this.account.Id === this.selectedAccountId;
    }

    get cardClass() {
        if (this.isSelected) {
            return 'slds-box slds-m-bottom_small selected-card';
        }

        return 'slds-box slds-m-bottom_small';
    }

    get buttonLabel() {
        if (this.isSelected) {
            return 'Selected';
        }

        return 'Select Account';
    }

    get buttonVariant() {
        if (this.isSelected) {
            return 'success';
        }

        return 'brand';
    }

    get displayPhone() {
        if (this.account && this.account.Phone) {
            return this.account.Phone;
        }

        return 'No phone listed';
    }

    get displayWebsite() {
        if (this.account && this.account.Website) {
            return this.account.Website;
        }

        return 'No website listed';
    }

    handleSelect() {
        const accountSelectEvent = new CustomEvent('accountselect', {
            detail: {
                accountId: this.account.Id,
                accountName: this.account.Name
            }
        });

        this.dispatchEvent(accountSelectEvent);
    }
}

