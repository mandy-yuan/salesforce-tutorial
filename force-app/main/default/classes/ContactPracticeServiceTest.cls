@IsTest
private class ContactPracticeServiceTest {
    @IsTest
    static void createFindUpdateAndDeletePracticeContacts() {
        Id contactId = ContactPracticeService.createSampleContact('Salesforce', 'Student');

        List<Contact> matchingContacts = ContactPracticeService.findContactsByLastName('Student');

        System.assert(
            !matchingContacts.isEmpty(),
            'Expected at least one Contact with last name Learner.'
        );

        ContactPracticeService.updateContactTitle(contactId, 'Updated Apex Title');

        Contact updatedContact = [
            SELECT Id, Title
            FROM Contact
            WHERE Id = :contactId
            LIMIT 1
        ];

        System.assertEquals(
            'Updated Apex Title',
            updatedContact.Title,
            'Expected the Contact title to be updated.'
        );

        ContactPracticeService.deletePracticeContacts();

        List<Contact> remainingContacts = [
            SELECT Id
            FROM Contact
            WHERE Id = :contactId
        ];

        System.assertEquals(
            0,
            remainingContacts.size(),
            'Expected the tutorial Contact to be deleted.'
        );
    }
}