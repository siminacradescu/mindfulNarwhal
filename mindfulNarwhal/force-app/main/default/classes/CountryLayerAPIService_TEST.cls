@isTest
public class CountryLayerAPIService_TEST {

    @isTest
    static void testGetAllCountriesSuccess() {
        String mockResponse = '[' +
            '{' +
                '"name": "United States of America",' +
                '"topLevelDomain": [".us"],' +
                '"alpha2Code": "US",' +
                '"alpha3Code": "USA",' +
                '"callingCodes": ["1"],' +
                '"capital": "Washington, D.C.",' +
                '"altSpellings": ["US", "USA", "United States of America"],' +
                '"region": "Americas",' +
                '"regionalBlocs": []' +
            '},' +
            '{' +
                '"name": "Uruguay",' +
                '"topLevelDomain": [".uy"],' +
                '"alpha2Code": "UY",' +
                '"alpha3Code": "URY",' +
                '"callingCodes": ["598"],' +
                '"capital": "Montevideo",' +
                '"altSpellings": ["UY", "Oriental Republic of Uruguay", "República Oriental del Uruguay"],' +
                '"region": "Americas",' +
                '"regionalBlocs": []' +
            '},' +
            '{' +
                '"name": "Uzbekistan",' +
                '"topLevelDomain": [".uz"],' +
                '"alpha2Code": "UZ",' +
                '"alpha3Code": "UZB",' +
                '"callingCodes": ["998"],' +
                '"capital": "Tashkent",' +
                '"altSpellings": ["UZ", "Republic of Uzbekistan", "O\'zbekiston Respublikasi", "Ўзбекистон Республикаси"],' +
                '"region": "Asia",' +
                '"regionalBlocs": []' +
            '}' +
        ']';

        Test.setMock(HttpCalloutMock.class, new CountryLayerAPIServiceMock(200, mockResponse));

        Test.startTest();
        List<CountryLayerAPIService.CountryResponse> countries = CountryLayerAPIService.getAllCountries();
        Test.stopTest();

        System.assertNotEquals(null, countries);
        System.assertEquals(3, countries.size());

        CountryLayerAPIService.CountryResponse usCountry = countries[0];
        System.assertEquals('United States of America', usCountry.name);
        System.assertEquals('US', usCountry.alpha2Code);

        CountryLayerAPIService.CountryResponse uyCountry = countries[1];
        System.assertEquals('Uruguay', uyCountry.name);
        System.assertEquals('UY', uyCountry.alpha2Code);

        CountryLayerAPIService.CountryResponse uzCountry = countries[2];
        System.assertEquals('Uzbekistan', uzCountry.name);
        System.assertEquals('UZ', uzCountry.alpha2Code);
    }

    @isTest
    static void testGetAllCountriesEmptyResponse() {
        String mockResponse = '[]';
        Test.setMock(HttpCalloutMock.class, new CountryLayerAPIServiceMock(200, mockResponse));

        Test.startTest();
        List<CountryLayerAPIService.CountryResponse> countries = CountryLayerAPIService.getAllCountries();
        Test.stopTest();

        System.assertNotEquals(null, countries);
        System.assertEquals(0, countries.size());
    }

    @isTest
    static void testGetAllCountriesErrorResponse() {
        String mockResponse = 'Unauthorized';
        Test.setMock(HttpCalloutMock.class, new CountryLayerAPIServiceMock(401, mockResponse));

        Test.startTest();
        List<CountryLayerAPIService.CountryResponse> countries = CountryLayerAPIService.getAllCountries();
        Test.stopTest();

        System.assertNotEquals(null, countries);
        System.assertEquals(0, countries.size());
    }

    @isTest
    static void testGetAllCountriesServerError() {
        String mockResponse = 'Internal Server Error';
        Test.setMock(HttpCalloutMock.class, new CountryLayerAPIServiceMock(500, mockResponse));

        Test.startTest();
        List<CountryLayerAPIService.CountryResponse> countries = CountryLayerAPIService.getAllCountries();
        Test.stopTest();

        System.assertNotEquals(null, countries);
        System.assertEquals(0, countries.size());
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