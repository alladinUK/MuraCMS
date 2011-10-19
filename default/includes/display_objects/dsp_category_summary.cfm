<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on 
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with 
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without 
Mura CMS under the license of your choice, provided that you follow these specific guidelines: 

Your custom code 

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

 /admin/
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfif isJSON(arguments.params)>
	<cfset arguments.params=deserializeJSON(arguments.params)>
	<cfif structKeyExists(arguments.params,"displayRSS")>
		<cfset useRSS=arguments.params.displayRSS>
	</cfif>
</cfif>
<cfparam name="useRss" default="false">
<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" name="rsSection">select contentid,filename,menutitle,target,restricted,restrictgroups,type,sortBy,sortDirection from tcontent where siteid='#$.event('siteID')#' and contentid='#arguments.objectid#' and approved=1 and active=1 and display=1</cfquery>
<cfif rsSection.recordcount>
<cfsilent>
<cfif rsSection.type neq "Calendar">
<cfset today=now() />
<cfelse>
<cfset today=createDate($.event('year'),$.event('month'),1) />
</cfif>
<cfset rs=$.getBean('contentGateway').getKidsCategorySummary($.event('siteID'),arguments.objectid,$.event('relatedID'),today,rsSection.type)>

<cfset viewAllURL="#$.globalConfig('context')##getURLStem($.event('siteID'),rsSection.filename)#">
<cfif len($.event('relatedID'))>
	<cfset viewAllURL=viewAllURL & "?relatedID=#HTMLEditFormat($.event('relatedID'))#">
</cfif>
</cfsilent>
<cfif rs.recordcount>

<cfoutput>
<div class="svCatSummary svIndex">
<#$.getHeaderTag('subHead1')#>#$.rbKey('list.categories')#</#$.getHeaderTag('subHead1')#>
<ul class="navSecondary"><cfloop query="rs">
	<cfsilent>
	<cfif len(rs.filename)>
		<cfset categoryURL="#$.globalConfig('context')##getURLStem($.event('siteID'),rsSection.filename & '/category/' & rs.filename)#">
		<cfif len($.event('relatedID'))>
			<cfset categoryURL=categoryURL & "?relatedID=#HTMLEditFormat($.event('relatedID'))#">
		</cfif>
	<cfelse>
		<cfset categoryURL="#$.globalConfig('context')##getURLStem($.event('siteID'),rsSection.filename)#?categoryID=#rs.categoryID#">
		<cfif len($.event('relatedID'))>
			<cfset categoryURL=categoryURL & "&relatedID=#HTMLEditFormat($.event('relatedID'))#">
		</cfif>
	</cfif>
	</cfsilent>
	<cfset class=iif(rs.currentrow eq 1,de('first'),de(''))>
		<li class="#class#<cfif listFind($.event('categoryID'),rs.categoryID)> current</cfif>"><a href="#categoryURL#">#rs.name# (#rs.count#)</a><cfif useRss><a class="rss" href="#$.globalConfig('context')#/tasks/feed/index.cfm?siteid=#$.event('siteID')#&contentID=#rsSection.contentid#&categoryID=#rs.categoryID#" <cfif listFind($.event('categoryID'),rs.categoryID)>class="current"</cfif>>RSS</a></cfif></li>
	</cfloop>
	<li class="last"><a href="#viewAllURL#">View All</a><cfif useRss><a class="rss" href="#$.globalConfig('context')#/tasks/feed/index.cfm?siteid=#$.event('siteID')#&contentID=#rsSection.contentid#">RSS</a></cfif></li>
</ul>
</div>
</cfoutput>
</cfif></cfif>