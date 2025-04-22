@isTest
public with sharing class ContactTriggerTest {
    private static List<Account> testAccounts = new List<Account>();
    @TestSetup
    static void makeData(){
        for (Integer i = 0; i < 10; i++){
            Account testAccount = new Account(
                Name = 'Test Account ' + i,
                Website = 'https://www.blast' + i + '.com'
            );
            testAccounts.add(testAccount);
        }
        insert testAccounts;
    }
    @isTest
    static void ifNoEmailInContactDontAssignAccount() {
        Contact testContact = new Contact(
            LastName = 'Test',
            AccountId = null,
            Email = 'test@nodomain.com'
        );
        insert testContact;
        Contact updatedContact = [SELECT
                                    AccountId
                                FROM Contact
                                WHERE LastName = 'Test'
                                LIMIT 1];
        Assert.isNull(updatedContact.AccountId, 'AccountId should be null.');
    }
    @isTest
    static void ifContactEmailMatchAccountWebsiteDomainAssignAccount() {
        Integer numberOfAccounts = [SELECT COUNT() FROM Account];
        List<Contact> testContacts = new List<Contact>();
        for (Integer i = 0; i < numberOfAccounts; i++) {
            for (Integer j = 0; j < 10; j++) {
                Contact testContact = new Contact(
                    LastName = 'Test Contact ' + j + ' Acc ' + i,
                    AccountId = null,
                    Email = 'test' + i + j + '@blast' + i + '.com'
                );
                testContacts.add(testContact);
            }
        }
        Assert.areEqual(100, testContacts.size(), 'There should be 100 contacts to be created');
        insert testContacts;
        List<Account> accountsWithContacts = [SELECT Website, (SELECT Email, AccountId FROM Contacts) FROM Account];
        Assert.areEqual(10, accountsWithContacts.size(), 'There should be 10 accounts.');
        for (Account acc: accountsWithContacts) {
            Assert.areEqual(10, acc.Contacts.size(), 'Each account should have 10 contacts.');
            Pattern p = Pattern.compile('');
            String webDomain = acc.Website.replaceAll('.+//|www.|', '');
            Assert.areEqual(10, acc.Contacts.size(), 'There should be 10 contacts per account');
            for (Contact assignedContact : acc.Contacts) {
                String emailDomain = assignedContact.Email.substringAfter('@');
                Assert.areEqual(webDomain, emailDomain, 'The domains are different');
            }
        }
    }
    @isTest
    static void checkIfAccountWithHTTPSWWWWebsiteIsAssigned() {
        Account testAccount = new Account(
            Name = 'Test Account 11',
            Website = 'https://www.test.com'
        );
        insert testAccount;
        Contact testContact = new Contact(
            LastName = 'Test Contact for Account 11',
            AccountId = null,
            Email = 'email@test.com'
        );
        insert testContact;
        testContact = [SELECT AccountId
                        FROM Contact
                        WHERE LastName = 'Test Contact for Account 11'
                    LIMIT 1];
        Assert.areEqual(testAccount.Id, testContact.AccountId, 'AccountId should be the same as testAccount.Id');
    }
    @isTest
    static void checkIfAccountWithHTTPWWWWebsiteIsAssigned() {
        Account testAccount = new Account(
            Name = 'Test Account 11',
            Website = 'http://www.test.com'
        );
        insert testAccount;
        Contact testContact = new Contact(
            LastName = 'Test Contact for Account 11',
            AccountId = null,
            Email = 'email@test.com'
        );
        insert testContact;
        testContact = [SELECT AccountId
                        FROM Contact
                        WHERE LastName = 'Test Contact for Account 11'
                    LIMIT 1];
        Assert.areEqual(testAccount.Id, testContact.AccountId, 'AccountId should be the same as testAccount.Id');
    }
    @isTest
    static void checkIfAccountWithOnlyWWWWebsiteIsAssigned() {
        Account testAccount = new Account(
            Name = 'Test Account 11',
            Website = 'www.test.com'
        );
        insert testAccount;
        Contact testContact = new Contact(
            LastName = 'Test Contact for Account 11',
            AccountId = null,
            Email = 'email@test.com'
        );
        insert testContact;
        testContact = [SELECT AccountId
                        FROM Contact
                        WHERE LastName = 'Test Contact for Account 11'
                    LIMIT 1];
        Assert.areEqual(testAccount.Id, testContact.AccountId, 'AccountId should be the same as testAccount.Id');
    }
    @isTest
    static void checkIfAccountWithOnlyDomainWebsiteIsAssigned() {
        Account testAccount = new Account(
            Name = 'Test Account 11',
            Website = 'test.com'
        );
        insert testAccount;
        Contact testContact = new Contact(
            LastName = 'Test Contact for Account 11',
            AccountId = null,
            Email = 'email@test.com'
        );
        insert testContact;
        testContact = [SELECT AccountId
                        FROM Contact
                        WHERE LastName = 'Test Contact for Account 11'
                    LIMIT 1];
        Assert.areEqual(testAccount.Id, testContact.AccountId, 'AccountId should be the same as testAccount.Id');
    }
}