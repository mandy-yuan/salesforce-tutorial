public with sharing class AccountTriggerHandler {
    public static void beforeInsert(List<Account> newAccounts) {
        setDefaultRating(newAccounts);
    }

    public static void beforeUpdate(
        List<Account> newAccounts,
        Map<Id, Account> oldAccountMap
    ) {
        for (Account newAccount : newAccounts) {
            Account oldAccount = oldAccountMap.get(newAccount.Id);

            Boolean industryChanged =
                oldAccount != null &&
                newAccount.Industry != oldAccount.Industry;

            if (industryChanged && String.isBlank(newAccount.Rating)) {
                newAccount.Rating = getRatingForIndustry(newAccount.Industry);
            }
        }
    }

    public static void afterInsert(List<Account> newAccounts) {
        createProspectFollowUpTasks(newAccounts);
    }

    private static void setDefaultRating(List<Account> accounts) {
        for (Account currentAccount : accounts) {
            if (String.isBlank(currentAccount.Rating)) {
                currentAccount.Rating = getRatingForIndustry(currentAccount.Industry);
            }
        }
    }

    private static String getRatingForIndustry(String industry) {
        if (String.isBlank(industry)) {
            return 'Cold';
        }

        String normalizedIndustry = industry.trim().toLowerCase();

        if (
            normalizedIndustry == 'healthcare' ||
            normalizedIndustry == 'retail' ||
            normalizedIndustry == 'technology'
        ) {
            return 'Warm';
        }

        return 'Cold';
    }

    private static void createProspectFollowUpTasks(List<Account> newAccounts) {
        List<Task> tasksToInsert = new List<Task>();

        for (Account currentAccount : newAccounts) {
            if (currentAccount.Type == 'Prospect') {
                Task followUpTask = new Task(
                    WhatId = currentAccount.Id,
                    OwnerId = currentAccount.OwnerId,
                    Subject = 'Follow up with new prospect account',
                    Status = 'Not Started',
                    Priority = 'Normal',
                    ActivityDate = Date.today().addDays(7)
                );

                tasksToInsert.add(followUpTask);
            }
        }

        if (!tasksToInsert.isEmpty()) {
            insert tasksToInsert;
        }
    }
}

