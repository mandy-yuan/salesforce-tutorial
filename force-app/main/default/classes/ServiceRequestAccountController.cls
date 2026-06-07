public with sharing class ServiceRequestAccountController {
    @AuraEnabled(cacheable=true)
    public static List<Account> searchAccounts(String searchTerm) {
        String cleanedSearchTerm = String.isBlank(searchTerm)
            ? ''
            : searchTerm.trim();

        if (cleanedSearchTerm.length() < 2) {
            return new List<Account>();
        }

        String searchPattern = '%' + cleanedSearchTerm + '%';

        return [
            SELECT Id, Name, Phone, Website
            FROM Account
            WHERE Name LIKE :searchPattern
                OR Phone LIKE :searchPattern
                OR Website LIKE :searchPattern
            ORDER BY Name
            LIMIT 20
        ];
    }
}
