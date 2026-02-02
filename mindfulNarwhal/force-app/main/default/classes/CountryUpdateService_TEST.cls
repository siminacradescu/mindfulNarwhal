@isTest
private class CountryUpdateService_TEST {

    @isTest
    static void testUpdateCountriesWithNewCountries() {
        String mockResponse = '[' +
            '{' +
                '"name": "United States of America",' +
                '"alpha2Code": "US",' +
                '"alpha3Code": "USA",' +
                '"capital": "Washington, D.C.",' +
                '"region": "Americas",' +
                '"regionalBlocs": []' +
            '}' +
        ']';

        Test.setMock(HttpCalloutMock.class, new CountryLayerAPIServiceMock(200, mockResponse));

        Test.startTest();
        CountryUpdateService.updateCountries();
        Test.stopTest();

        List<Country__c> countries = [SELECT Id, Name, Alpha2_Code__c, Alpha3_Code__c, Capital_City__c, Region__c FROM Country__c];
        System.assertEquals(0, countries.size());
    }

    @isTest
    static void testUpdateCountriesUpdatesExistingCountries() {
        Country__c existingCountry = new Country__c(
            Name = 'Old United States',
            Alpha2_Code__c = 'US',
            Alpha3_Code__c = 'USA',
            Capital_City__c = 'Old Capital',
            Region__c = 'Old Region',
            Regional_Blocks__c = 'NAFTA'
        );
        insert existingCountry;

        String mockResponse = '[' +
            '{' +
                '"name": "United States of America",' +
                '"alpha2Code": "US",' +
                '"alpha3Code": "USA",' +
                '"capital": "Washington, D.C.",' +
                '"region": "Americas",' +
                '"regionalBlocs": []' +
            '}' +
        ']';

        Test.setMock(HttpCalloutMock.class, new CountryLayerAPIServiceMock(200, mockResponse));

        Test.startTest();
        CountryUpdateService.updateCountries();
        Test.stopTest();

        Country__c updatedCountry = [SELECT Id, Name, Alpha2_Code__c, Alpha3_Code__c, Capital_City__c, Region__c FROM Country__c LIMIT 1];
        System.assertEquals('United States of America', updatedCountry.Name);
        System.assertEquals('US', updatedCountry.Alpha2_Code__c);
    }

    @isTest
    static void testUpdateCountriesMultipleCountries() {
        Country__c country1 = new Country__c(
            Name = 'Old USA',
            Alpha2_Code__c = 'US',
            Alpha3_Code__c = 'USA',
            Capital_City__c = 'Old Capital 1',
            Region__c = 'Americas'
        );
        Country__c country2 = new Country__c(
            Name = 'Old Uruguay',
            Alpha2_Code__c = 'UY',
            Alpha3_Code__c = 'URY',
            Capital_City__c = 'Old Capital 2',
            Region__c = 'Americas'
        );
        insert new List<Country__c> { country1, country2 };

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

        List<Country__c> updatedCountries = [SELECT Id, Name, Alpha2_Code__c, Capital_City__c FROM Country__c ORDER BY Alpha2_Code__c];
        System.assertEquals(2, updatedCountries.size());
        
        Country__c us = updatedCountries[0];
        System.assertEquals('United States of America', us.Name);
        System.assertEquals('Washington, D.C.', us.Capital_City__c);

        Country__c uy = updatedCountries[1];
        System.assertEquals('Uruguay', uy.Name);
        System.assertEquals('Montevideo', uy.Capital_City__c);
    }

    @isTest
    static void testUpdateCountriesNoChangesNeeded() {
        Country__c existingCountry = new Country__c(
            Name = 'United States of America',
            Alpha2_Code__c = 'US',
            Alpha3_Code__c = 'USA',
            Capital_City__c = 'Washington, D.C.',
            Region__c = 'Americas'
        );
        insert existingCountry;

        String mockResponse = '[' +
            '{' +
                '"name": "United States of America",' +
                '"alpha2Code": "US",' +
                '"alpha3Code": "USA",' +
                '"capital": "Washington, D.C.",' +
                '"region": "Americas",' +
                '"regionalBlocs": []' +
            '}' +
        ']';

        Test.setMock(HttpCalloutMock.class, new CountryLayerAPIServiceMock(200, mockResponse));

        Test.startTest();
        CountryUpdateService.updateCountries();
        Test.stopTest();

        Country__c unchangedCountry = [SELECT Id, Name FROM Country__c LIMIT 1];
        System.assertEquals('United States of America', unchangedCountry.Name);
    }

    @isTest
    static void testUpdateCountriesEmptyApiResponse() {
        Country__c country1 = new Country__c(
            Name = 'United States of America',
            Alpha2_Code__c = 'US',
            Alpha3_Code__c = 'USA',
            Capital_City__c = 'Washington, D.C.',
            Region__c = 'Americas'
        );
        insert country1;

        String mockResponse = '[]';
        Test.setMock(HttpCalloutMock.class, new CountryLayerAPIServiceMock(200, mockResponse));

        Test.startTest();
        CountryUpdateService.updateCountries();
        Test.stopTest();

        List<Country__c> countries = [SELECT Id, Name FROM Country__c];
        System.assertEquals(1, countries.size());
        System.assertEquals('United States of America', countries[0].Name);
    }

    @isTest
    static void testUpdateCountriesApiError() {
        Country__c country1 = new Country__c(
            Name = 'United States of America',
            Alpha2_Code__c = 'US',
            Alpha3_Code__c = 'USA',
            Capital_City__c = 'Washington, D.C.',
            Region__c = 'Americas'
        );
        insert country1;

        String mockResponse = 'Unauthorized';
        Test.setMock(HttpCalloutMock.class, new CountryLayerAPIServiceMock(401, mockResponse));

        Test.startTest();
        CountryUpdateService.updateCountries();
        Test.stopTest();

        List<Country__c> countries = [SELECT Id, Name FROM Country__c];
        System.assertEquals(1, countries.size());
        System.assertEquals('United States of America', countries[0].Name);
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
