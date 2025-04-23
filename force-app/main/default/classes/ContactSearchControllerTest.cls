@isTest
public class ContactSearchControllerTest {
    private static List<String> possibleDomains = new List<String>{
        'http://www.blast.com',
        'https://www.blast.com',
        'blast.com.ca',
        'blast.com.au',
        'blast.com'
    };
    @TestSetup
    static void makeData(){
        Contact testContact = new Contact(
            LastName = 'Test Contact',
            Email= 'test@blast.com'
        );
        Contact controlContact1 = new Contact(
            LastName = 'No Email 1',
            Email= ''
        );
        Contact controlContact2 = new Contact(
            LastName = 'No Email 2',
            Email= ''
        );
        insert new List<Contact>{testContact, controlContact1, controlContact2};
    }
    @isTest
    static void getContactByEmailDomainNoEmpty() {
        Contact expectedContact = [SELECT Id FROM Contact WHERE LastName = 'Test Contact'];
        for (String domain : possibleDomains) {
            List<Contact> actualContacts = ContactSearchController.searchContactsByWebsite(domain);
            Assert.areEqual(1, actualContacts.size(), 'There should be only one contact with ' + domain + ' email field.');
            Assert.areEqual(expectedContact.Id, actualContacts[0].Id, 'The contact should have the same Id as expected.');
        }
    }
    @isTest
    static void getContactByEmailDomainEmpty() {
        List<Contact> actualContacts = ContactSearchController.searchContactsByWebsite('');
        Assert.areEqual(2, actualContacts.size(), 'There should be two contacts with empty email');
    }
}