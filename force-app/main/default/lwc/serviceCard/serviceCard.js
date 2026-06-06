import { LightningElement } from 'lwc';

export default class ServiceCard extends LightningElement {
    serviceName = 'Restaurant';
    handleServiceChange(event){
        this.serviceName = event.target.value;

    message = 'Hello World';
    }
}