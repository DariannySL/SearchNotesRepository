public without sharing class SearchNotesController {
    
    String accounts;
    List<Note> notes = new List<Note>();
    public Integer index = 10;
    public Integer start = 0;
    Public Integer count { get; set; }
    public Boolean nextBool { get; set; }
    public Boolean prevBool { get; set; }
    public Boolean pdfAvailable { get; set; }
    public List<Note> noteList = new List<Note>();
    
    public PageReference test() {
        return null;
    }
    
    public SearchNotesController() {
		nextBool = true;
        prevBool = true;
        pdfAvailable = false;
    }
    
    public List<SelectOption> getOptions() {
        List<SelectOption> options = new List<SelectOption>();
        List<Account> accountsList = [SELECT Id, Name FROM Account];
        
        options.add(new SelectOption('', 'Select An Account'));
        for(Account acct : accountsList) {
            options.add(new SelectOption(acct.Id, acct.Name));
        }
        return options;
    }
    
    public String getAccounts() {
        return accounts;
    }
    
    public void setAccounts(String accounts) {
        this.accounts = accounts;
    }
    
    public List<Note> getNotes() {
        notes.clear();
        Set<Id> contactIds = new Set<Id>();
        List<Contact> contacts = [ 
            SELECT Id 
            FROM Contact
            WHERE AccountId = :accounts
        ];
        
        for(Contact cont : contacts) {
            contactIds.add(cont.Id);
        }
        
        count = [SELECT Count() FROM Note
                 WHERE Parent.Id = :accounts 
                 OR Parent.Id IN :contactIds];
        
        noteList = [
            SELECT Title, Body, Parent.Type, CreatedBy.Name
            FROM Note
            WHERE Parent.Id = :accounts 
            OR Parent.Id IN :contactIds
        ];
        
        if(count > 0) {
			noteResults();
            pdfAvailable = true;
        }
        else {
            pdfAvailable = false;
        }
        
        if(count > index) {
            nextBool = false;
        } else {
            nextBool = true;
        }
        
        return notes;
    }
    
    public List<Note> noteResults() {
        for(Integer i = start; i < index; i++) {
            if(count == i) 
                break;   
            
            notes.add(noteList.get(i));
        }
        
        return notes;
    }
    
    public void next() {
        index += 10;
        start += 10;
        
        if(index > count) {
            index = Math.Mod(count, 10) + start;
            nextBool = true;
            prevBool = false;
            
            noteResults();
            
            index = start + 10;
        } else {
            noteResults();
            
            prevBool = false;
            nextBool = true;
        }
    }
    
    public void previous() {
        index -= 10;
        start -= 10;
        
        noteResults();
        
        if(start > 10) {
            nextBool = false;
            prevBool = false;
        }
        else {
            nextBool = false;
            prevBool = true;            
        }
    }
    
    public PageReference goToPdfPage() {
        PageReference page = new PageReference('https://dariscompany2-dev-ed--c.vf.force.com/apex/SearchNotesPdf?core.apexpages.request.devconsole=1&id=' + accounts);
        page.setRedirect(true);
        return page; 
    }
}