import { LightningElement, wire } from 'lwc';
import searchAccounts from '@salesforce/apex/AccountSearchController.searchAccounts';

export default class AccountSearch extends LightningElement {
    searchTerm = '';
    wiredSearchTerm = '';
    accounts = [];
    errorMessage = '';
    isLoading = false;
    hasSearched = false;
    searchMode = 'No search yet';

    @wire(searchAccounts, { searchTerm: '$wiredSearchTerm' })
    wiredAccounts({ data, error }) {
        if (!this.hasSearched || this.searchMode !== 'Wired Apex') {
            return;
        }

        this.isLoading = false;

        if (data) {
            this.accounts = data;
            this.errorMessage = '';
        } else if (error) {
            this.accounts = [];
            this.errorMessage = this.reduceErrors(error).join(', ');
        }
    }

    handleSearchTermChange(event) {
        this.searchTerm = event.target.value;
    }

    handleWiredSearch() {
        this.resetSearchState('Wired Apex');

        const cleanedSearchTerm = this.searchTerm.trim();

        if (cleanedSearchTerm.length < 2) {
            this.errorMessage = 'Enter at least 2 characters before searching.';
            this.isLoading = false;
            return;
        }

        this.wiredSearchTerm = cleanedSearchTerm;
    }

    async handleImperativeSearch() {
        this.resetSearchState('Imperative Apex');

        const cleanedSearchTerm = this.searchTerm.trim();

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
            this.errorMessage = '';
        } catch (error) {
            this.accounts = [];
            this.errorMessage = this.reduceErrors(error).join(', ');
        } finally {
            this.isLoading = false;
        }
    }

    handleClear() {
        this.searchTerm = '';
        this.wiredSearchTerm = '';
        this.accounts = [];
        this.errorMessage = '';
        this.isLoading = false;
        this.hasSearched = false;
        this.searchMode = 'No search yet';
    }

    resetSearchState(mode) {
        this.accounts = [];
        this.errorMessage = '';
        this.isLoading = true;
        this.hasSearched = true;
        this.searchMode = mode;
    }

    get hasResults() {
        return this.accounts.length > 0;
    }

    get resultCountLabel() {
        if (!this.hasSearched) {
            return '0 results';
        }

        const count = this.accounts.length;

        if (count === 1) {
            return '1 result';
        }

        return `${count} results`;
    }

    get searchModeLabel() {
        return this.searchMode;
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

