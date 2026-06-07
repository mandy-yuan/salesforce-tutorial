public with sharing class ContactPracticeService {
    public static Id createSampleContact(String firstName, String lastName) {
        Contact newContact = new Contact(
            FirstName = firstName,
            LastName = lastName,
            Email = buildPracticeEmail(firstName, lastName),
            Phone = '555-0100',
            Title = 'Apex Practice Contact'
        );

        insert newContact;

        return newContact.Id;
    }

    public static List<Contact> findContactsByLastName(String lastName) {
        String searchPattern = '%' + lastName + '%';

        List<Contact> contacts = [
            SELECT Id, FirstName, LastName, Name, Email, Phone, Title
            FROM Contact
            WHERE LastName LIKE :searchPattern
            ORDER BY LastName, FirstName
            LIMIT 20
        ];

        return contacts;
    }

    public static void updateContactTitle(Id contactId, String newTitle) {
        Contact contactToUpdate = new Contact(
            Id = contactId,
            Title = newTitle
        );

        update contactToUpdate;
    }

    public static void deletePracticeContacts() {
        List<Contact> practiceContacts = [
            SELECT Id
            FROM Contact
            WHERE Email LIKE 'apex.practice.%@example.com'
            LIMIT 200
        ];

        if (!practiceContacts.isEmpty()) {
            delete practiceContacts;
        }
    }

    private static String buildPracticeEmail(String firstName, String lastName) {
        String cleanFirstName = firstName == null
            ? 'student'
            : firstName.toLowerCase().replaceAll('[^a-z0-9]', '');

        String cleanLastName = lastName == null
            ? 'learner'
            : lastName.toLowerCase().replaceAll('[^a-z0-9]', '');

        return 'apex.practice.'
            + cleanFirstName
            + '.'
            + cleanLastName
            + '.'
            + DateTime.now().getTime()
            + '@example.com';
    }
}
