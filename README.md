Sample App for Xero CFML SDK - connect to Xero Accounting API with CFML application servers.


* [Getting Started](#getting-started)
* [Create a Xero User Account](#create-a-xero-user-account)
* [Create a Xero a App](#create-a-xero-a-app)
* [Update Config.json with Keys and Certificates](#update-config.json-with-keys-and-certificates)

* [License](#license)


## Getting Started
### Install sample app with [CommandBox]( https://www.ortussolutions.com/products/commandbox)

  box install xero-cfml-sample-app

Alternatively, you can clone or download this repo into your wwwroot folder

### Create a Xero User Account
[Create a Xero user account](https://www.xero.com/signup) for free.  Xero does not have a designated "sandbox" for development.  Instead you'll use the free Demo company for development.  Learn how to get started with [Xero Development Accounts](http://developer.xero.com/documentation/getting-started/development-accounts/).


### Create a Xero Public App
Go to [http://app.xero.com](http://app.xero.com) and login with your Xero user account to create a Xero Public app.

* [Public](http://developer.xero.com/documentation/auth-and-limits/public-applications/)


### Update Config.json with Keys and Certificates

Look in the resources directory for your config.json file. 

Refer to Xero Developer Center [Getting Started](http://developer.xero.com/documentation/getting-started/getting-started-guide/) if you haven't created your Xero App yet - this is where you'll find the Consumer Key and Secret. 


**Public Application**
```javascript
{ 
  "AppType" : "PUBLIC",
  "UserAgent": "YourAppName",
  "ConsumerKey" : "__YOUR_CONSUMER_KEY__",
  "ConsumerSecret" : "__YOUR_CONSUMER_KEY_SECRET__",
  "CallbackBaseUrl" : "http://localhost:8500",
  "CallbackPath" : "/xero-cfml-sample-app/callback.cfm"
}
```

## Secure your config.json file
All configuration files and certificates are located in the resources directory.  In a production environment, you will move this directory outside the webroot for security reasons.  

Remember to update the *pathToConfigJSON* variable in your Application.cfc.  

  <cfset pathToConfigJSON = getDirectoryFromPath(getCurrentTemplatePath()) & "resources/config.json"> 


## Ready to Rock
Open your browser to http://localhost:8500/xero-cfml-sample-app and click the "Connect to Xero" button to start the oAuth flow.


## Code behind this App

For Public Apps you'll use 3 legged oAuth, which involves a RequestToken Call, then redirecting the user to Xero to select a Xero org, then callback to your server where you'll swap the request token for your 30 min access tokens.

### requesttoken.cfm

```java
<cfscript>

req=createObject("component","cfc.xero").init(); 

try {
  req.requestToken();
  location(req.getAuthorizeUrl());
}	

catch(any e){
  if(e.ErrorCode EQ "401") {
    location("index.cfm?" & e.message);
  } else {
    writeDump(e);
    abort;
  }
}
</cfscript>	
```


### callback.cfm

```java
<cfscript>

res=createObject("component","cfc.xero").init(); 

try {
  res.accessToken(aCallbackParams = cgi.query_string);
  location("get.cfm","false");
}	

catch(any e){
  if(e.ErrorCode EQ "401") {
    location("index.cfm?" & e.message);
  } else {
    writeDump(e);
    abort;
  }
}
</cfscript>
```


## Methods

Each endpoint supports different set of methods - refer to [Xero API Documentation](https://developer.xero.com/documentation/api/api-overview)

Below are examples of the types of methods you can call ....

Reading all objects from an endpoint

```java
<cfscript>
  account=createObject("component","cfc.model.Account").init();

  // Get all items 
  account.getAll();
	// After you getAll - you can loop over an Array of items (NOTE: Your object is not populated with the getAll method)
  account.getList();

  //After you getAll - Populate your object with the first item in the Array
  account.getObject(1);	

  //Get all using where clause
  account.getAll(where='Status=="ACTIVE"');

  //Get all using order param
  account.getAll(order='Name DESC');

  //Get all items modified since this date/time (i.e. 24 hours ago)
  dateTime24hoursAgo = DateAdd("d", -1, now());
  ifModifiedSince = DateConvert("local2utc", dateTime24hoursAgo);
  account.getAll(ifModifiedSince=ifModifiedSince);

 //Get an item by a specific ID (No need to getAll with this method)
  account.getById("XXXXXXXXXXXXXXXXX");
</cfscript>		
```


Reading a single object from an endpoint.

```java
<cfscript>  
  account=createObject("component","cfc.model.Account").init();

  //Get an item by a specific ID (No need to getAll with this method)
  account.getById("XXXXXXXXXXXXXXXXX");
</cfscript>   
```


Creating objects on an endpoint

```java
<cfscript>
  account=createObject("component","cfc.model.Account").init(); 

  account.setName("Dinner");
  account.setCode("4040");
  account.setType("CURRENT");
  account.create();
</cfscript>		
```


Update an object on an endpoint

```java
<cfscript>
  account=createObject("component","cfc.model.Account").init(); 

  // Get all objects and set the first one in the Array to update
  account.getAll().getObject(1);
  account.setName("Meals");
  account.update();
</cfscript>		
```


Delete an object on an endpoint

```java
<cfscript>
  account=createObject("component","cfc.model.Account").init(); 

  // Set the ID for the Account to Delete
  account.setAccountID("XXXXXXXXXXXXX");
  account.delete();
</cfscript>		
```


Archive an object on an endpoint

```java
<cfscript>
  account=createObject("component","cfc.model.Account").init(); 

  // Set the ID for the Account to Delete
  account.setAccountID("XXXXXXXXXXXXX");
  account.archive();
</cfscript>		
```

Void an object on an endpoint

```java
<cfscript>
  invoice=createObject("component","cfc.model.Invoice").init(); 

  // Set the ID for the Account to Delete
  invoice.setInvoiceID("XXXXXXXXXXXXX");
  invoice.void();
</cfscript>		
```


Add to an object on an endpoint

```java
<cfscript>
  trackingcategory=createObject("component","cfc.model.TrackingCategory").init(); 

  // Set the ID for the Tracking Category
  trackingcategory.setTrackingCategoryID("XXXXXXXXXXXXX");
 
  trackingoption=createObject("component","cfc.model.TrackingOption").init(); 
  trackingoption.setName("Foobar" &RandRange(1, 10000, "SHA1PRNG"));
  aTrackingOption = ArrayNew(1);
  aTrackingOption.append(trackingoption.toStruct());

  // Set the Array for Tracking Options
  trackingcategory.setOptions(aTrackingOption);
  trackingcategory.addOptions();
</cfscript>		
```


Remove from an object on an endpoint

```java
<cfscript>
  trackingcategory=createObject("component","cfc.model.TrackingCategory").init(); 	

  // Set the ID for the Tracking Category
  trackingcategory.setTrackingCategoryID("XXXXXXXXXXXXX");
 
  trackingoptionToDelete=createObject("component","cfc.model.TrackingOption").init().populate(trackingcategory.getOptions()[1]); 	
  trackingcategory.setOptionId(trackingoptionToDelete.getTrackingOptionId());	
  trackingcategory.deleteOption();				
</cfscript>		
```


## Make API calls without Models

If you find yourself limited by the models, you can always hack your own raw API call.

```java
  <cfset config = application.config.json>
  <cfset parameters = structNew()>
  <cfset body = "">
  <cfset ifModifiedSince = "">
  <cfset method = "GET">
  <cfset accept = "json/application">
  <cfset endpoint = "Organisation">

  <cfset sResourceEndpoint = "#config.ApiBaseUrl##config.ApiEndpointPath##endpoint#">
  
  <!--- Build and Call API, return new structure of XML results --->
  <cfset oRequestResult = CreateObject("component", "cfc.xero").requestData(
    sResourceEndpoint = sResourceEndpoint,
    sOAuthToken = sOAuthToken,
    sOAuthTokenSecret= sOAuthTokenSecret,
    stParameters = parameters,
    sAccept = accept,
    sMethod = method,
    sIfModifiedSince = ifModifiedSince,
    sBody = body)>

  <cfdump var="#oRequestResult#" >
```


## License

This software is published under the [MIT License](http://en.wikipedia.org/wiki/MIT_License).

	Copyright (c) 2014-2018 Xero Limited

	Permission is hereby granted, free of charge, to any person
	obtaining a copy of this software and associated documentation
	files (the "Software"), to deal in the Software without
	restriction, including without limitation the rights to use,
	copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the
	Software is furnished to do so, subject to the following
	conditions:

	The above copyright notice and this permission notice shall be
	included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
	OTHER DEALINGS IN THE SOFTWARE.
