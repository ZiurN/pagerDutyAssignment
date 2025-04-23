public with sharing class ContactSearchController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> searchContactsByWebsite(String websiteInput) {
        String domain = websiteInput.toLowerCase().replaceAll('.+//|www.|', '').replaceAll('\\..*', '');
        if (String.isBlank(domain)) {
            return [SELECT Id,
                        Name,
                        Email,
                        Title,
                        CreatedDate
                    FROM Contact
                    WHERE Email = ''
                    ORDER BY CreatedDate DESC];
        } else {
            return [SELECT Id,
                        Name,
                        Email,
                        Title,
                        CreatedDate
                FROM Contact
                WHERE Email LIKE :('%@%' + domain + '%')
                ORDER BY CreatedDate DESC];
        }
    }
}