public with sharing class AccountSearchController {
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
            SELECT Id, Name, Industry, Phone, Type, Website
            FROM Account
            WHERE Name LIKE :searchPattern
                OR Industry LIKE :searchPattern
                OR Type LIKE :searchPattern
            ORDER BY Name
            LIMIT 25
        ];
    }
}

