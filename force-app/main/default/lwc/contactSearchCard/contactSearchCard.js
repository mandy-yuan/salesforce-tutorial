import { LightningElement } from 'lwc';

export default class ContactSearchCard extends LightningElement {
    searchTerm = '';
    hasSearched = false;
    filteredContacts = [];

    contacts = [
        {
            id: 1,
            name: 'Sofia Martinez',
            role: 'Operations Manager',
            company: 'Acme Services'
        },
        {
            id: 2,
            name: 'Ethan Chen',
            role: 'Sales Representative',
            company: 'Northstar Retail'
        },
        {
            id: 3,
            name: 'Maya Patel',
            role: 'Customer Success Lead',
            company: 'CloudPoint Solutions'
        },
        {
            id: 4,
            name: 'Daniel Kim',
            role: 'Account Executive',
            company: 'Acme Services'
        },
        {
            id: 5,
            name: 'Olivia Johnson',
            role: 'Marketing Coordinator',
            company: 'BrightPath Media'
        }
    ];

    handleSearchTermChange(event) {
        this.searchTerm = event.target.value;
    }

    handleSearch() {
        const normalizedSearchTerm = this.searchTerm.trim().toLowerCase();

        this.hasSearched = true;

        if (normalizedSearchTerm === '') {
            this.filteredContacts = [];
            return;
        }

        this.filteredContacts = this.contacts.filter((contact) => {
            const name = contact.name.toLowerCase();
            const role = contact.role.toLowerCase();
            const company = contact.company.toLowerCase();

            return (
                name.includes(normalizedSearchTerm) ||
                role.includes(normalizedSearchTerm) ||
                company.includes(normalizedSearchTerm)
            );
        });
    }

    handleClear() {
        this.searchTerm = '';
        this.hasSearched = false;
        this.filteredContacts = [];
    }

    get hasResults() {
        return this.filteredContacts.length > 0;
    }

    get resultCountLabel() {
        if (!this.hasSearched) {
            return 'No search yet';
        }

        const count = this.filteredContacts.length;

        if (count === 1) {
            return '1 result';
        }

        return `${count} results`;
    }
}
