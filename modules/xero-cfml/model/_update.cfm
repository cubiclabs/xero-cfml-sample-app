<!---Account.cfc","Address.cfc", "BankAccount.cfc", "BankTransaction.cfc","BankTransfer.cfc" ,"Bill.cfc","BrandingTheme.cfc" ,"Contact.cfc",
"ContactGroup.cfc","ContactPerson.cfc","ContactPerson.cfc","CreditNote.cfc","Currency.cfc","Employee.cfc","ExternalLink.cfc","Invoice.cfc","Item.cfc","LineItem.cfc","Journal.cfc","JournalLine.cfc","LinkedTransaction.cfc","ManualJournal.cfc","Organisation.cfc","Overpayment.cfc","Payment.cfc","PaymentTerm.cfc","Phone.cfc","Prepayment.cfc","Purchase.cfc","PurchaseOrder.cfc,"RepeatingInvoice.cfc","Schedule.cfc","TaxComponent.cfc","TaxRate.cfc","TrackingCategory.cfc","TrackingOption.cfc","User.cfc""
--->
<cfset cfcArray = []>
<cfloop array="#cfcArray#" index="item">

<cffile action ="read"  file = "#GetDirectoryFromPath(GetCurrentTemplatePath())##item#" variable ="fileContent">

<cfset find["POS"][1] = 1>
<cfset start = 1>

<cfloop condition='find["POS"][1] NEQ 0'>
	<cfset find = ReFind("List\[ *[A-Za-z]+\]", fileContent,start ,true)>

	<cfif find["POS"][1] NEQ 0>
		<cfset substring = Mid(fileContent, find["POS"][1], find["LEN"][1])>
		<cfset obj = listGetAt(substring, 2,"[")>
		<cfset obj = listGetAt(obj, 1,"]")>
		<cfset lastChar = right(obj,1)>
		<cfset last3Char = right(obj,3)>

		<cfif lastChar EQ "s">
			<cfset endWith = "es">
		<cfelse>
			<cfset endWith = "s">
		</cfif>
		<cfset start = find["POS"][1] + find["LEN"][1]>
		
		<cfset fileContent = ReReplace(fileContent,'hint="I am the #obj##endWith#." />\n *<cfset variables.instance.#obj##endWith# = arguments.#obj##endWith# />', 'hint="I am the #obj##endWith#." />
			<cfscript>
		        var arr = ArrayNew(1);
		        for (var i=1;i LTE ArrayLen(arguments.#obj##endWith#);i=i+1) {
		          var item=createObject("component","cfc.model.#obj#").init().populate(arguments.#obj##endWith#[i]); 
		          ArrayAppend(arr,item);
		        }
		      </cfscript>
		      <cfset variables.instance.#obj##endWith# = arr />
		' ,"ALL")>

		<cfset fileContent = ReReplace(fileContent,'set#obj##endWith#\(""\);', 'set#obj##endWith#(ArrayNew(1));' ,"ALL")>
	</cfif>
</cfloop>

<!--- REPLACE --->
<cfset fileContent = ReReplace(fileContent,"List\[ *[A-Za-z]+\]", "array" ,"ALL")>
<cfset fileContent = ReReplace(fileContent,"BigDecimal", "String" ,"ALL")>

<!--- CONTACT --->
<cfset fileContent = ReReplace(fileContent,'setSalesTrackingCategories\(""\)', "setSalesTrackingCategories(ArrayNew(1))" ,"ALL")>
<cfset fileContent = ReReplace(fileContent,'setPurchasesTrackingCategories\(""\)', "setPurchasesTrackingCategories(ArrayNew(1))" ,"ALL")>
<cfset fileContent = ReReplace(fileContent,'setBalances\(""\)', "setBalances(StructNew())" ,"ALL")>
<cfset fileContent = ReReplace(fileContent,'name="Balances" type="String"', 'name="Balances" type="Struct"' ,"ALL")>
<cfset fileContent = ReReplace(fileContent,'setHasAttachments\(""\);', 'setHasAttachments(false);' ,"ALL")>

<!---
<cfset fileContent = ReReplace(fileContent
,'name="archive" access="public" output="false">
    <cfset variables.result = Super.post\(endpoint="Contacts",body=this.toJSON\(\)'
,'name="archive" access="public" output="false">
    <cfset variables.result = Super.post(endpoint="Contacts",body=this.toJSON(exclude="ContactNumber,AccountNumber,Name,FirstName,LastName,EmailAddress,
SkypeUserName,ContactPersons,BankAccountDetails,TaxNumber,AccountsReceivableTaxType,
AccountsPayableTaxType,Addresses,Phones,IsSupplier,IsCustomer,DefaultCurrency,
XeroNetworkKey,SalesDefaultAccountCode,PurchasesDefaultAccountCode,SalesTrackingCategories,
PurchasesTrackingCategories,TrackingCategoryName,TrackingCategoryOption,UpdatedDateUTC,
ContactGroups,Website,BatchPayments,Discount,Balances,HasAttachments")'
,'ALL')>
--->

<!--- ACCOUNT --->
<cfset fileContent = ReReplace(fileContent,'type=" *[A-Za-z]+\Enum"', 'type="String"' ,"ALL")>


<!---
<cfset fileContent = ReReplace(fileContent
,'name="archive" access="public" output="false">
    <cfset variables.result = Super.post\(endpoint="Accounts",body=this.toJSON\(\)'
,'name="archive" access="public" output="false">
    <cfset variables.result = Super.post(endpoint="Accounts",body=this.toJSON(exclude="Code,Name,Type,Description,BankAccountNumber,BankAccountType,CurrencyCode,TaxType,UpdatedDateUTC,HasAttachments,ReportingCodeName,ReportingCode,SystemAccount,Class,ShowInExpenseClaims,EnablePaymentsToAccount")'
,'ALL')>
--->

<cfset fileContent = ReReplace(fileContent,'name="update" access="public" output="false">
    <cfset variables.result = Super.post\(endpoint="Accounts",body=this.toJSON\(\)', 'name="update" access="public" output="false">
    <cfset variables.result = Super.post(endpoint="Accounts",body=this.toJSON(exclude="Status,Class")' ,"ALL")>

<!--- BANK TRANSACTION --->
<cfset fileContent = ReReplace(fileContent,'name="Balances" type="String"', 'name="Balances" type="Struct"' ,"ALL")>

<!---
<cfdump var="#fileContent#" abort>
--->
<cffile action ="write"  file = "#GetDirectoryFromPath(GetCurrentTemplatePath())##item#" output ="#fileContent#">

</cfloop>

SUCCESS UPDATE
