<cfcomponent
    displayname="XeroCFMLSampleApp"
    output="true"
    hint="Sample App for Xero application.">
 
 
    <!--- Set up the application. --->
    <cfset THIS.Name = "XeroCFMLSampleApp" />
    <cfset THIS.ApplicationTimeout = CreateTimeSpan( 0, 0, 3, 0 ) />
    <cfset THIS.SessionManagement = true />
    <cfset THIS.SetClientCookies = true />
    
    
    <!--- Define the page request properties. --->
    <cfsetting
        requesttimeout="20"
        showdebugoutput="true"
        enablecfoutputonly="false"
        />
 
    <cffunction
        name="OnApplicationStart"
        access="public"
        returntype="boolean"
        output="false"
        hint="Fires when the application is first created.">
        
        <cfset pathToConfigJSON = getDirectoryFromPath(getCurrentTemplatePath()) & "resources/config.json">
        <cfset application.xero = CreateObject("component", "modules.xero-cfml.xero").init(pathToConfigJSON)>

        <!--- Return out. --->
        <cfreturn true />
    </cffunction>
 
 
    
 
 
    <cffunction
        name="OnRequestStart"
        access="public"
        returntype="boolean"
        output="false"
        hint="Fires at first part of page processing.">
 
        <!--- Define arguments. --->
        <cfargument
            name="TargetPage"
            type="string"
            required="true"
            />

        <cfif structKeyExists(url, "reload")>
            <cfset onApplicationStart()>
        </cfif>

        <!--- Return out. --->
        <cfreturn true />
    </cffunction>
 
   
 
</cfcomponent>