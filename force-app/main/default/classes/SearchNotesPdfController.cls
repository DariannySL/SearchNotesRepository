public without sharing class SearchNotesPdfController {
    
    Account account;
    String accountId;
    
    public SearchNotesPdfController() {
        accountId = System.currentPageReference().getParameters().get('id');
    }
    
    Public Account getAccount() {
        if(AccountId != null) {
            account = [SELECT Id, Name FROM Account 
                      WHERE Id =: AccountId LIMIT 1];
        }
        
        return account;
    }
    
    public List<Note> getNotes() {    
        Set<Id> contactIds = new Set<Id>();
        List<Contact> contacts = [ 
            SELECT Id 
            FROM Contact
            WHERE AccountId = :accountId
        ];
        
        for(Contact cont : contacts) {
            contactIds.add(cont.Id);
        }
        
        return [
            SELECT Title, Body, Parent.Type, CreatedBy.Name
            FROM Note
            WHERE Parent.Id = :accountId 
            OR Parent.Id IN :contactIds
        ];
    }
}