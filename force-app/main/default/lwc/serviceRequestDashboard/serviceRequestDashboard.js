import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import searchAccounts from '@salesforce/apex/ServiceRequestAccountController.searchAccounts';

import PHONE_FIELD from '@salesforce/schema/Account.Phone';
import WEBSITE_FIELD from '@salesforce/schema/Account.Website';

export default class ServiceRequestDashboard extends LightningElement {
    searchTerm = '';
    accounts = [];
    errorMessage = '';
    isLoading = false;
    hasSearched = false;

    selectedAccountId = null;
    selectedAccountName = '';

    accountFormFields = [
        PHONE_FIELD,
        WEBSITE_FIELD
    ];

    handleSearchTermChange(event) {
        this.searchTerm = event.target.value;
    }

    async handleSearch() {
        const cleanedSearchTerm = this.searchTerm.trim();

        this.accounts = [];
        this.errorMessage = '';
        this.isLoading = true;
        this.hasSearched = true;
        this.selectedAccountId = null;
        this.selectedAccountName = '';

        if (cleanedSearchTerm.length < 2) {
            this.errorMessage = 'Enter at least 2 characters before searching.';
            this.isLoading = false;
            return;
        }

        try {
            const results = await searchAccounts({
                searchTerm: cleanedSearchTerm
            });

            this.accounts = results;
        } catch (error) {
            this.errorMessage = this.reduceErrors(error).join(', ');
        } finally {
            this.isLoading = false;
        }
    }

    handleAccountSelect(event) {
        this.selectedAccountId = event.detail.accountId;
        this.selectedAccountName = event.detail.accountName;
    }

    handleRecordSave() {
        const toastEvent = new ShowToastEvent({
            title: 'Account updated',
            message: 'The selected Account was updated successfully.',
            variant: 'success'
        });

        this.dispatchEvent(toastEvent);
    }

    handleClear() {
        this.searchTerm = '';
        this.accounts = [];
        this.errorMessage = '';
        this.isLoading = false;
        this.hasSearched = false;
        this.selectedAccountId = null;
        this.selectedAccountName = '';
    }

    get hasResults() {
        return this.accounts.length > 0;
    }

    get hasSelectedAccount() {
        return this.selectedAccountId !== null;
    }

    get resultCountLabel() {
        if (!this.hasSearched) {
            return 'No search yet';
        }

        const count = this.accounts.length;

        if (count === 1) {
            return '1 result';
        }

        return `${count} results`;
    }

    reduceErrors(error) {
        if (!error) {
            return ['Unknown error'];
        }

        if (Array.isArray(error.body)) {
            return error.body.map((currentError) => currentError.message);
        }

        if (error.body && typeof error.body.message === 'string') {
            return [error.body.message];
        }

        if (typeof error.message === 'string') {
            return [error.message];
        }

        return ['Unknown error'];
    }
}
