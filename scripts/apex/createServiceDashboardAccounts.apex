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

System.debug('Created Service Dashboard sample Accounts.');

