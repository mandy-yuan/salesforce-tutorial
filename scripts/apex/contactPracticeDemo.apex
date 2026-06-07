Id contactId = ContactPracticeService.createSampleContact('Apex', 'Learner');

System.debug('Created Contact Id: ' + contactId);

List<Contact> matchingContacts = ContactPracticeService.findContactsByLastName('Learner');

System.debug('Number of matching Contacts: ' + matchingContacts.size());

for (Contact currentContact : matchingContacts) {
    System.debug(
        'Contact: '
        + currentContact.Name
        + ', Email: '
        + currentContact.Email
        + ', Title: '
        + currentContact.Title
    );
}

ContactPracticeService.updateContactTitle(contactId, 'Apex Beginner');

Contact updatedContact = [
    SELECT Id, Name, Email, Phone, Title
    FROM Contact
    WHERE Id = :contactId
    LIMIT 1
];

System.debug('Updated Contact Title: ' + updatedContact.Title);

ContactPracticeService.deletePracticeContacts();

System.debug('Practice Contacts deleted.');
