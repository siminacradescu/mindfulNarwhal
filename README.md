### Salesforce Coding exercise solution

## Exercise 1

I have created a new custom object named {Country__c}(https://github.com/siminacradescu/mindfulNarwhal/tree/main/mindfulNarwhal/force-app/main/default/objects/Country__c) with custom fields.

For the API connection, I have created:
- free account on CountryLayer
- {named credential}(https://github.com/siminacradescu/mindfulNarwhal/blob/main/mindfulNarwhal/force-app/main/default/namedCredentials/Country_Layer_API.namedCredential-meta.xml)
- {custom metadata}(https://github.com/siminacradescu/mindfulNarwhal/tree/main/mindfulNarwhal/force-app/main/default/customMetadata) for storing the key
- {service apex class}(https://github.com/siminacradescu/mindfulNarwhal/blob/main/mindfulNarwhal/force-app/main/default/classes/CountryLayerAPIService.cls) for the request
  
Salesforce does not allow merging the API key in the URL endpoint because the request passes the API Key as an endpoint parameter, hence I've used the custom metadata.
It is not a best practice to store credentials as plain text, the common way of working for the APIs is to have the key in the payload of the request or in the Authorization header 
and in these situations it can be stored in the Named Credentials fields.  

Additional logic:
- class for the upsert logic of the countries records - CountryUpdateService.cls & test class
- class for scheduling the upsert logic class - CountryUpdateScheduler.cls & test class

Potential improvements:
- create an API framework with interface for having a standardize way of writing API related logic
- find a suitable way to store the API key


## Exercise 2

{Validation rule}(https://github.com/siminacradescu/mindfulNarwhal/blob/main/mindfulNarwhal/force-app/main/default/objects/Lead/validationRules/Restrict_Owner_Changes.validationRule-meta.xml) for limiting the records update based on conditions

## Exercise 3

{Flow}(https://github.com/siminacradescu/mindfulNarwhal/blob/main/mindfulNarwhal/force-app/main/default/flows/LEAD_Update_Owner_Since_Field.flow-meta.xml) that will track the Lead owner timestamp 
