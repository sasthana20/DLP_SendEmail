@isTest
public with sharing class cemSendEmailController_Test {

    @TestSetup
    static void makeData(){
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Contact c = new Contact(FirstName = 'Test', LastName = 'Contact', AccountId = acc.Id, Email = 'testcontact@outlook.com', Phone = '1234567890');
        insert c;
        
        EmailMessage emailRec = new EmailMessage();
        emailRec.TextBody='Test';
        insert emailRec;
    }


    @isTest
    static void searchResults() {
//        User u = SendEmailController.getUserDetails(UserInfo.getUserId());
        Contact c = [SELECT Id, Email FROM Contact limit 1];
        list<LookupSearchResult> results = cemSendEmailController.getInitialSelection(c.Id);
        list<LookupSearchResult> searchResults = cemSendEmailController.search('test', new list<string>());
        results[0].getId();
        results[0].getSObjectType();
        results[0].getSubtitle();
        results[0].getIcon();
        results[0].getTitle();
        results[0].compareTo(results[0]);
        if (searchResults.size() > 0)
            results[0].compareTo(searchResults[0]);
    }


    @isTest
    static void sendEmail() {
        
        list<cemSendEmailController.PicklistOptions> classification = cemSendEmailController.getClassification();
        list<cemSendEmailController.PicklistOptions> deliveryOptions = cemSendEmailController.getDeliveryOptions();

        User u = cemSendEmailController.getUserDetails(UserInfo.getUserId());
        Contact c = [SELECT Id, Email FROM Contact limit 1];
        list<LookupSearchResult> results = cemSendEmailController.getInitialSelection(c.Id);
        list<LookupSearchResult> searchResults = cemSendEmailController.search('user', new list<string>());
        List<EmailTemplate> template = [SELECT Id, Name, FolderName, FolderId FROM EmailTemplate limit 1];
        Id templateID = template[0].id;

//        SendEmailController.getRecentlyViewed();

        list<string> toIds = new list<string>();
        toIds.add(c.Id);
        list<string> toAddress = new list<string>();
        toAddress.add(c.Email);
		test.startTest();
            cemSendEmailController.sendEmail('' + u.Id, '' + c.Id, u.Email, u.Name, 'test subject', 'email Body', toIds, toAddress, toIds, toAddress, classification[0].value, deliveryOptions[0].value, templateID);    
            EmailMessage em = [SELECT Id FROM EmailMessage limit 1];
            cemSendEmailController.getInitialSelection(em.Id);
            cemSendEmailController.getCCSelection(em.Id);
            cemSendEmailController.getEmail(em.Id);
            cemSendEmailController.getEmailTemplates('myLightTemplates');
            cemSendEmailController.getEmailTemplates('allLightTemplates');
        	cemSendEmailController.getEmailTemplates('myClassicTemplates');
        cemSendEmailController.getRelatedAccounts();
        cemSendEmailController.getEmailMessage(templateID,c.id);
       test.stopTest();
    }
    @isTest
    static void sendEmailQueueable() {
        
        list<cemSendEmailController.PicklistOptions> classification = cemSendEmailController.getClassification();
        list<cemSendEmailController.PicklistOptions> deliveryOptions = cemSendEmailController.getDeliveryOptions();

        User u = cemSendEmailController.getUserDetails(UserInfo.getUserId());
        Contact c = [SELECT Id, Email FROM Contact limit 1];
        list<LookupSearchResult> results = cemSendEmailController.getInitialSelection(c.Id);
        list<LookupSearchResult> searchResults = cemSendEmailController.search('user', new list<string>());
        List<EmailTemplate> template = [SELECT Id, Name, FolderName, FolderId FROM EmailTemplate limit 1];
        Id templateID = template[0].id;

//        SendEmailController.getRecentlyViewed();

        list<string> toIds = new list<string>();
        toIds.add(c.Id);
        list<string> toAddress = new list<string>();
        toAddress.add(c.Email);
		test.startTest();
        	System.enqueueJob(new cemSendEmailQueueable('' + u.Id, '' + c.Id, u.Email, u.Name, 'test subject', 'email Body', toIds, toAddress, toIds, toAddress, classification[0].value, deliveryOptions[0].value, templateID,null));    
        
         
        test.stopTest();
    }
}