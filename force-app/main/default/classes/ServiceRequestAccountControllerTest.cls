@IsTest
private class ServiceRequestAccountControllerTest {
    @TestSetup
    static void makeData() {
        List<Account> accounts = new List<Account>{
            new Account(
                Name = 'Service Dashboard Acme Account',
                Phone = '555-1001',
                Website = 'https://acme.example.com'
            ),
            new Account(
                Name = 'Service Dashboard Northstar Account',
                Phone = '555-1002',
                Website = 'https://northstar.example.com'
            ),
            new Account(
                Name = 'Service Dashboard BrightPath Account',
                Phone = '555-1003',
                Website = 'https://brightpath.example.com'
            )
        };

        insert accounts;
    }

    @IsTest
    static void searchByAccountNameReturnsMatches() {
        List<Account> results =
            ServiceRequestAccountController.searchAccounts('Acme');

        System.assertEquals(
            1,
            results.size(),
            'Expected one Account to match Acme.'
        );

        System.assertEquals(
            'Service Dashboard Acme Account',
            results[0].Name,
            'Expected the Acme Account to be returned.'
        );
    }

    @IsTest
    static void searchByPhoneReturnsMatches() {
        List<Account> results =
            ServiceRequestAccountController.searchAccounts('555-1002');

        System.assertEquals(
            1,
            results.size(),
            'Expected one Account to match the phone number.'
        );

        System.assertEquals(
            'Service Dashboard Northstar Account',
            results[0].Name,
            'Expected the Northstar Account to be returned.'
        );
    }

    @IsTest
    static void shortSearchTermReturnsEmptyList() {
        List<Account> results =
            ServiceRequestAccountController.searchAccounts('A');

        System.assertEquals(
            0,
            results.size(),
            'Expected search terms under 2 characters to return no results.'
        );
    }

    @IsTest
    static void blankSearchTermReturnsEmptyList() {
        List<Account> results =
            ServiceRequestAccountController.searchAccounts('');

        System.assertEquals(
            0,
            results.size(),
            'Expected blank search terms to return no results.'
        );
    }
}

