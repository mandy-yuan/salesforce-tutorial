@IsTest
private class AccountSearchControllerTest {
    @TestSetup
    static void makeData() {
        List<Account> accounts = new List<Account>{
            new Account(
                Name = 'Acme Grocery Services',
                Industry = 'Retail',
                Type = 'Customer',
                Phone = '555-0101',
                Website = 'https://example.com/acme'
            ),
            new Account(
                Name = 'Northstar Medical Group',
                Industry = 'Healthcare',
                Type = 'Prospect',
                Phone = '555-0102',
                Website = 'https://example.com/northstar'
            ),
            new Account(
                Name = 'BrightPath Media',
                Industry = 'Media',
                Type = 'Partner',
                Phone = '555-0103',
                Website = 'https://example.com/brightpath'
            )
        };

        insert accounts;
    }

    @IsTest
    static void searchByAccountNameReturnsMatches() {
        List<Account> results = AccountSearchController.searchAccounts('Acme');

        System.assertEquals(
            1,
            results.size(),
            'Expected one Account to match Acme.'
        );

        System.assertEquals(
            'Acme Grocery Services',
            results[0].Name,
            'Expected Acme Grocery Services to be returned.'
        );
    }

    @IsTest
    static void searchByIndustryReturnsMatches() {
        List<Account> results = AccountSearchController.searchAccounts('Healthcare');

        System.assertEquals(
            1,
            results.size(),
            'Expected one Account to match Healthcare.'
        );

        System.assertEquals(
            'Northstar Medical Group',
            results[0].Name,
            'Expected Northstar Medical Group to be returned.'
        );
    }

    @IsTest
    static void shortSearchTermReturnsEmptyList() {
        List<Account> results = AccountSearchController.searchAccounts('A');

        System.assertEquals(
            0,
            results.size(),
            'Expected short search terms to return no Accounts.'
        );
    }

    @IsTest
    static void blankSearchTermReturnsEmptyList() {
        List<Account> results = AccountSearchController.searchAccounts('');

        System.assertEquals(
            0,
            results.size(),
            'Expected blank search terms to return no Accounts.'
        );
    }
}
