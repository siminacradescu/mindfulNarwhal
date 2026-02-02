@isTest
private class CountryUpdateScheduler_TEST {

    @isTest
    static void testSchedulerCanBeInstantiated() {
        CountryUpdateScheduler scheduler = new CountryUpdateScheduler();
        System.assertNotEquals(null, scheduler);
    }

    @isTest
    static void testCountryUpdateServiceCallWithoutCallout() {
        Country__c country = new Country__c(
            Name = 'Test Country',
            Alpha2_Code__c = 'TC',
            Alpha3_Code__c = 'TST',
            Capital_City__c = 'Test Capital',
            Region__c = 'Test Region'
        );
        insert country;

        String mockResponse = '[' +
            '{' +
                '"name": "Test Country",' +
                '"alpha2Code": "TC",' +
                '"alpha3Code": "TST",' +
                '"capital": "Test Capital",' +
                '"region": "Test Region",' +
                '"regionalBlocs": []' +
            '}' +
        ']';

        Test.setMock(HttpCalloutMock.class, new CountryLayerAPIServiceMock(200, mockResponse));

        Test.startTest();
        CountryUpdateService.updateCountries();
        Test.stopTest();

        Country__c updatedCountry = [SELECT Id, Name FROM Country__c WHERE Alpha2_Code__c = 'TC'];
        System.assertEquals('Test Country', updatedCountry.Name);
    }

    @isTest
    static void testCountryUpdateServiceWithMultipleCountries() {
        List<Country__c> countriesToInsert = new List<Country__c>{
            new Country__c(Name = 'Old US', Alpha2_Code__c = 'US', Alpha3_Code__c = 'USA', Capital_City__c = 'Old Capital', Region__c = 'Americas'),
            new Country__c(Name = 'Old Uruguay', Alpha2_Code__c = 'UY', Alpha3_Code__c = 'URY', Capital_City__c = 'Old Capital', Region__c = 'Americas')
        };
        insert countriesToInsert;

        String mockResponse = '[' +
            '{' +
                '"name": "United States of America",' +
                '"alpha2Code": "US",' +
                '"alpha3Code": "USA",' +
                '"capital": "Washington, D.C.",' +
                '"region": "Americas",' +
                '"regionalBlocs": []' +
            '},' +
            '{' +
                '"name": "Uruguay",' +
                '"alpha2Code": "UY",' +
                '"alpha3Code": "URY",' +
                '"capital": "Montevideo",' +
                '"region": "Americas",' +
                '"regionalBlocs": []' +
            '}' +
        ']';

        Test.setMock(HttpCalloutMock.class, new CountryLayerAPIServiceMock(200, mockResponse));

        Test.startTest();
        CountryUpdateService.updateCountries();
        Test.stopTest();

        List<Country__c> updatedCountries = [SELECT Id, Name FROM Country__c ORDER BY Alpha2_Code__c];
        System.assertEquals(2, updatedCountries.size());
        System.assertEquals('United States of America', updatedCountries[0].Name);
    }

    @isTest
    static void testCountryUpdateServiceApiError() {
        Country__c existingCountry = new Country__c(
            Name = 'Existing Country',
            Alpha2_Code__c = 'EC',
            Alpha3_Code__c = 'EXC',
            Capital_City__c = 'Existing Capital',
            Region__c = 'Test Region'
        );
        insert existingCountry;

        Test.setMock(HttpCalloutMock.class, new CountryLayerAPIServiceMock(401, 'Unauthorized'));

        Test.startTest();
        CountryUpdateService.updateCountries();
        Test.stopTest();

        Country__c unchangedCountry = [SELECT Id, Name FROM Country__c WHERE Alpha2_Code__c = 'EC'];
        System.assertEquals('Existing Country', unchangedCountry.Name);
    }

    private class CountryLayerAPIServiceMock implements HttpCalloutMock {
        private Integer statusCode;
        private String responseBody;

        public CountryLayerAPIServiceMock(Integer statusCode, String responseBody) {
            this.statusCode = statusCode;
            this.responseBody = responseBody;
        }

        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(statusCode);
            res.setBody(responseBody);
            return res;
        }
    }
}