public with sharing class CountryLayerAPIService {


    public static final String COUNTRY_LAYER_NAMED_CREDENTIALS = 'callout:Country_Layer_API';
    public static final String API_KEY_QUERY_PARAM = 'access_key=';

    public static List<CountryResponse> getAllCountries() {

        API_Key__mdt apiKey = [SELECT DeveloperName, API_Key__c FROM API_Key__mdt WHERE DeveloperName = 'Country_Layer_API_Key' LIMIT 1];

        String endpoint = COUNTRY_LAYER_NAMED_CREDENTIALS + '?' + API_KEY_QUERY_PARAM + apiKey.API_Key__c;

        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 200) {
            return (List<CountryResponse>) JSON.deserialize(res.getBody(), List<CountryResponse>.class);
        }
        return new List<CountryResponse>();
    }

    public class CountryResponse {
        public String name;
        public String alpha2Code;
        public String alpha3Code;
        public String capital;
        public String region;
        public List<RegionalBloc> regionalBlocs;
    }

    public class RegionalBloc {
        public String acronym;
    }
}