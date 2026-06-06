import { LightningElement } from 'lwc';

export default class ServiceDashboard extends LightningElement {
    selectedServiceId = null;
    selectedServiceName = '';

    services = [
        {
            id: 'restaurant',
            name: 'Restaurant',
            description: 'Places where residents can buy prepared meals.',
            status: 'Everyday service'
        },
        {
            id: 'supermarket',
            name: 'Supermarket',
            description: 'Stores where residents can buy groceries and household goods.',
            status: 'Essential service'
        },
        {
            id: 'medical-clinic',
            name: 'Medical Clinic',
            description: 'Facilities where residents can access basic health services.',
            status: 'Health service'
        }
    ];

    get servicesWithSelection() {
        return this.services.map((service) => {
            return {
                ...service,
                isSelected: service.id === this.selectedServiceId
            };
        });
    }

    get hasSelectedService() {
        return this.selectedServiceId !== null;
    }

    handleServiceSelect(event) {
        this.selectedServiceId = event.detail.serviceId;
        this.selectedServiceName = event.detail.serviceName;
    }
}

