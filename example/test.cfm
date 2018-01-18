<cfsetting requestTimeOut = "90000" />

<cfset aEndpoint=["Accounts","BankTransactions","BankTransfers","BrandingThemes","Contacts","ContactGroups","CreditNotes","Currencies","Employees","Invoices","InvoiceReminders","Items","Journals","LinkedTransactions","ManualJournals","Organisation","Overpayments","Payments","Prepayments","PurchaseOrders","RepeatingInvoices","Reports","TaxRates","TrackingCategories","Users"]>

<cfset aAction=["Create","Read","Update","Delete","Archive","Void","Allocate","Add","Remove","RemoveOne"]>


<html>
<head>
<title>Xero CFML Wrapper</title>

<cfinclude template="/common/header.cfm" >
</head>
<body>
<div class="container">
	<div class="row">
  		<div class="col-md-6">
<h1>Xero CFML SDK</h1>

Running tests .....<br>

<cfflush> 
		<cfset showform = false>
		<cfloop from="1" to="#ArrayLen(aEndpoint)#" index="i">
			<br><br>
			<cfoutput><strong>#aEndpoint[i]#</strong></cfoutput>
			<hr>
			<cfloop from="1" to="#ArrayLen(aAction)#" index="j">
				<cfset form.endpoint="#aEndpoint[i]#">
				<cfset form.action="#aAction[j]#">
				<cfinclude template="get.cfm">
				<cfflush>
			</cfloop>	
	
			<cfset sleep(15000)>
			<cfif i EQ 29>
				<cfbreak>
			</cfif>
		</cfloop>
		</div>
	</div>
</div>
</body>
</html>