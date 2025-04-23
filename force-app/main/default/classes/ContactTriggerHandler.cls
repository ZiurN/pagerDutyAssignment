public class ContactTriggerHandler {
    public static void assignAccountsByEmailDomain(List<Contact> contacts) {
        Set<String> emailDomains = new Set<String>();
        for (Contact con : contacts) {
            if (String.isNotBlank(con.Email) && con?.Email.contains('@')) {
                String domain = con.Email.split('@')[1].toLowerCase();
                emailDomains.add(domain);
            }
        }
        if (emailDomains.isEmpty()) { return; }
        Map<String, Id> domainToAccountId = new Map<String, Id>();
        // Probably it should be better to create a custom field for the domain to create a positive query
        List<Account> accounts = [SELECT Id,
                                    Website
                                FROM Account
                                WHERE Website != null];
        for (Account acc : accounts) {
            String cleanWebsite = acc.Website.toLowerCase().replaceAll('.+//|www.|', '');
            for (String domain : emailDomains) {
                if (cleanWebsite.contains(domain)) {
                    domainToAccountId.put(domain, acc.Id);
                }
            }
        }
        for (Contact con : contacts) {
            if (String.isNotBlank(con.Email) && con?.Email.contains('@')) {
                String domain = con?.Email.split('@')[1].toLowerCase();
                if (domainToAccountId.containsKey(domain)) {
                    con.AccountId = domainToAccountId.get(domain);
                }
            }
        }
    }
}
