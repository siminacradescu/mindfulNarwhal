public with sharing class CountryUpdateScheduler implements Schedulable {
    public void execute(SchedulableContext ctx) {
        CountryUpdateService.updateCountries();
    }
}


//code to schedule the class
//System.schedule('Daily Country Sync', '0 0 1 * * ?', new CountryUpdateScheduler());
