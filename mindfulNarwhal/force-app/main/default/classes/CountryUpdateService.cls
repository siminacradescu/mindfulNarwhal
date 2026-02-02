public with sharing class CountryUpdateService {

    public static void updateCountries() {
        List<CountryLayerAPIService.CountryResponse> countries = CountryLayerAPIService.getAllCountries();

        List<Country__c> countriesToUpsert = new List<Country__c>();

        List<Country__c> countryRecords = [SELECT Id, Name, Alpha2_Code__c, Alpha3_Code__c, Capital_City__c, Region__c, Regional_Blocks__c FROM Country__c];

        Map<String, Country__c> countryMap = new Map<String, Country__c>();

        for(Country__c countryRecord : countryRecords) {
            countryMap.put(countryRecord.Alpha2_Code__c, countryRecord);
        }

        for (CountryLayerAPIService.CountryResponse country : countries) {
            if(countryMap.containsKey(country.alpha2Code)) {
                Country__c existingCountry = countryMap.get(country.alpha2Code);
                Boolean isUpdated = false;

                if(existingCountry.Name != country.Name){
                    existingCountry.Name = country.Name;
                    isUpdated = true;
                }
                if(existingCountry.Capital_City__c != country.capital){
                    existingCountry.Capital_City__c = country.capital;
                    isUpdated = true;
                }
                if(existingCountry.Region__c != country.region){
                    existingCountry.Region__c = country.region; 
                    isUpdated = true;
                }
                if(existingCountry.Alpha2_Code__c != country.alpha2Code){
                    existingCountry.Alpha2_Code__c = country.alpha2Code;
                    isUpdated = true;
                }
                if(existingCountry.Alpha3_Code__c != country.alpha3Code){
                    existingCountry.Alpha3_Code__c = country.alpha3Code;
                    isUpdated = true;
                }
                if(country.regionalBlocs != null && !country.regionalBlocs.isEmpty() && existingCountry.Regional_Blocks__c != String.join(country.regionalBlocs, ',') ){
                    existingCountry.Regional_Blocks__c = String.join(country.regionalBlocs, ',');
                    isUpdated = true;
                }
                if(isUpdated){
                    countriesToUpsert.add(existingCountry);
                }
            } else {
                Country__c newCountry = new Country__c();
                newCountry.Name = country.Name;
                newCountry.Alpha2_Code__c = country.alpha2Code;
                newCountry.Alpha3_Code__c = country.alpha3Code;
                newCountry.Capital_City__c = country.capital;
                newCountry.Region__c = country.region;

                if(country.regionalBlocs != null &&!country.regionalBlocs.isEmpty()){
                    newCountry.Regional_Blocks__c = String.join(country.regionalBlocs, ',');
                }
                countriesToUpsert.add(newCountry);
            }
        }
        upsert countriesToUpsert;
    }
}