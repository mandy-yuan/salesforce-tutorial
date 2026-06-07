@IsTest
private class AccountTriggerTest {
    @IsTest
    static void beforeInsertSetsWarmRatingForSelectedIndustries() {
        Account testAccount = new Account(
            Name = 'Trigger Retail Account',
            Industry = 'Retail',
            Type = 'Customer'
        );

        insert testAccount;

        Account savedAccount = [
            SELECT Id, Name, Industry, Rating
            FROM Account
            WHERE Id = :testAccount.Id
            LIMIT 1
        ];

        System.assertEquals(
            'Warm',
            savedAccount.Rating,
            'Expected Retail accounts to receive a Warm rating.'
        );
    }

    @IsTest
    static void beforeInsertSetsColdRatingWhenIndustryIsBlank() {
        Account testAccount = new Account(
            Name = 'Trigger Blank Industry Account',
            Type = 'Customer'
        );

        insert testAccount;

        Account savedAccount = [
            SELECT Id, Rating
            FROM Account
            WHERE Id = :testAccount.Id
            LIMIT 1
        ];

        System.assertEquals(
            'Cold',
            savedAccount.Rating,
            'Expected blank Industry accounts to receive a Cold rating.'
        );
    }

    @IsTest
    static void beforeUpdateSetsRatingWhenIndustryChanges() {
        Account testAccount = new Account(
            Name = 'Trigger Update Account',
            Industry = 'Other',
            Type = 'Customer'
        );

        insert testAccount;

        testAccount = [
            SELECT Id, Industry, Rating
            FROM Account
            WHERE Id = :testAccount.Id
            LIMIT 1
        ];

        testAccount.Industry = 'Healthcare';
        testAccount.Rating = null;

        update testAccount;

        Account updatedAccount = [
            SELECT Id, Industry, Rating
            FROM Account
            WHERE Id = :testAccount.Id
            LIMIT 1
        ];

        System.assertEquals(
            'Warm',
            updatedAccount.Rating,
            'Expected Healthcare accounts to receive a Warm rating after Industry changes.'
        );
    }

    @IsTest
    static void afterInsertCreatesTaskForProspectAccount() {
        Account prospectAccount = new Account(
            Name = 'Trigger Prospect Account',
            Industry = 'Technology',
            Type = 'Prospect'
        );

        insert prospectAccount;

        List<Task> tasks = [
            SELECT Id, WhatId, Subject, Status, Priority, ActivityDate
            FROM Task
            WHERE WhatId = :prospectAccount.Id
        ];

        System.assertEquals(
            1,
            tasks.size(),
            'Expected one follow up Task for a Prospect Account.'
        );

        System.assertEquals(
            'Follow up with new prospect account',
            tasks[0].Subject,
            'Expected the follow up Task subject to match.'
        );
    }

    @IsTest
    static void bulkInsertHandlesManyAccounts() {
        List<Account> accountsToInsert = new List<Account>();

        for (Integer index = 0; index < 200; index++) {
            accountsToInsert.add(
                new Account(
                    Name = 'Bulk Trigger Account ' + index,
                    Industry = 'Retail',
                    Type = 'Prospect'
                )
            );
        }

        Test.startTest();
        insert accountsToInsert;
        Test.stopTest();

        List<Account> savedAccounts = [
            SELECT Id, Rating
            FROM Account
            WHERE Name LIKE 'Bulk Trigger Account%'
        ];

        System.assertEquals(
            200,
            savedAccounts.size(),
            'Expected all 200 bulk Accounts to be inserted.'
        );

        for (Account savedAccount : savedAccounts) {
            System.assertEquals(
                'Warm',
                savedAccount.Rating,
                'Expected each Retail account to receive a Warm rating.'
            );
        }

        List<Task> createdTasks = [
            SELECT Id
            FROM Task
            WHERE Subject = 'Follow up with new prospect account'
                AND WhatId IN :savedAccounts
        ];

        System.assertEquals(
            200,
            createdTasks.size(),
            'Expected one follow up Task for each Prospect Account.'
        );
    }
}

