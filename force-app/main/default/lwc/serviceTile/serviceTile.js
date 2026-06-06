import { LightningElement, api } from 'lwc';

export default class ServiceTile extends LightningElement {
    @api serviceId;
    @api serviceName;
    @api serviceDescription;
    @api serviceStatus;
    @api isSelected = false;

    get tileClass() {
        if (this.isSelected) {
            return 'slds-box slds-theme_shade selected-tile';
        }

        return 'slds-box';
    }

    get buttonLabel() {
        if (this.isSelected) {
            return 'Selected';
        }

        return 'Select';
    }

    handleSelect() {
        const serviceSelectEvent = new CustomEvent('serviceselect', {
            detail: {
                serviceId: this.serviceId,
                serviceName: this.serviceName
            }
        });

        this.dispatchEvent(serviceSelectEvent);
    }
}
