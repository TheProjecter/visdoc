<?xml version='1.0' encoding='utf-8'?>


<!--
This XSL template generates:
* html for class documentation pages
* html for the lists: allclasses-frame.html, overview_tree.html, overview-frame.html, and the package html files (toc-package-packagename.html)
* jquery.js (js/jquery.js)
* VisDoc javascript functions (js/VisDoc.js)

The generated html is XHTML 1.0 Strict and tested with The W3C Markup Validation Service at http://validator.w3.org/
-->

<!DOCTYPE xsl:stylesheet [
<!ENTITY AElig "&#198;">
<!ENTITY AMP "&amp;#38;">
<!ENTITY Aacute "&#193;">
<!ENTITY Acirc "&#194;">
<!ENTITY Agrave "&#192;">
<!ENTITY Alpha "&#913;">
<!ENTITY Aring "&#197;">
<!ENTITY Atilde "&#195;">
<!ENTITY Auml "&#196;">
<!ENTITY Beta "&#914;">
<!ENTITY COPY "&#169;">
<!ENTITY Ccedil "&#199;">
<!ENTITY Chi "&#935;">
<!ENTITY Dagger "&#8225;">
<!ENTITY Delta "&#916;">
<!ENTITY ETH "&#208;">
<!ENTITY Eacute "&#201;">
<!ENTITY Ecirc "&#202;">
<!ENTITY Egrave "&#200;">
<!ENTITY Epsilon "&#917;">
<!ENTITY Eta "&#919;">
<!ENTITY Euml "&#203;">
<!ENTITY GT "&#62;">
<!ENTITY Gamma "&#915;">
<!ENTITY Iacute "&#205;">
<!ENTITY Icirc "&#206;">
<!ENTITY Igrave "&#204;">
<!ENTITY Iota "&#921;">
<!ENTITY Iuml "&#207;">
<!ENTITY Kappa "&#922;">
<!ENTITY LT "&amp;#60;">
<!ENTITY Lambda "&#923;">
<!ENTITY Mu "&#924;">
<!ENTITY Ntilde "&#209;">
<!ENTITY Nu "&#925;">
<!ENTITY OElig "&#338;">
<!ENTITY Oacute "&#211;">
<!ENTITY Ocirc "&#212;">
<!ENTITY Ograve "&#210;">
<!ENTITY Omega "&#937;">
<!ENTITY Omicron "&#927;">
<!ENTITY Oslash "&#216;">
<!ENTITY Otilde "&#213;">
<!ENTITY Ouml "&#214;">
<!ENTITY Phi "&#934;">
<!ENTITY Pi "&#928;">
<!ENTITY Prime "&#8243;">
<!ENTITY Psi "&#936;">
<!ENTITY QUOT "&#34;">
<!ENTITY REG "&#174;">
<!ENTITY Rho "&#929;">
<!ENTITY Scaron "&#352;">
<!ENTITY Sigma "&#931;">
<!ENTITY THORN "&#222;">
<!ENTITY TRADE "&#8482;">
<!ENTITY Tau "&#932;">
<!ENTITY Theta "&#920;">
<!ENTITY Uacute "&#218;">
<!ENTITY Ucirc "&#219;">
<!ENTITY Ugrave "&#217;">
<!ENTITY Upsilon "&#933;">
<!ENTITY Uuml "&#220;">
<!ENTITY Xi "&#926;">
<!ENTITY Yacute "&#221;">
<!ENTITY Yuml "&#376;">
<!ENTITY Zeta "&#918;">
<!ENTITY aacute "&#225;">
<!ENTITY aafs "&#8301;">
<!ENTITY acirc "&#226;">
<!ENTITY acute "&#180;">
<!ENTITY aelig "&#230;">
<!ENTITY agrave "&#224;">
<!ENTITY alefsym "&#8501;">
<!ENTITY alpha "&#945;">
<!ENTITY and "&#8743;">
<!ENTITY ang "&#8736;">
<!ENTITY aring "&#229;">
<!ENTITY ass "&#8299;">
<!ENTITY asymp "&#8776;">
<!ENTITY atilde "&#227;">
<!ENTITY auml "&#228;">
<!ENTITY bdquo "&#8222;">
<!ENTITY beta "&#946;">
<!ENTITY brvbar "&#166;">
<!ENTITY bull "&#8226;">
<!ENTITY cap "&#8745;">
<!ENTITY ccedil "&#231;">
<!ENTITY cedil "&#184;">
<!ENTITY cent "&#162;">
<!ENTITY chi "&#967;">
<!ENTITY circ "&#710;">
<!ENTITY clubs "&#9827;">
<!ENTITY cong "&#8773;">
<!ENTITY copy "&#169;">
<!ENTITY crarr "&#8629;">
<!ENTITY cup "&#8746;">
<!ENTITY curren "&#164;">
<!ENTITY dArr "&#8659;">
<!ENTITY dagger "&#8224;">
<!ENTITY darr "&#8595;">
<!ENTITY deg "&#176;">
<!ENTITY delta "&#948;">
<!ENTITY diams "&#9830;">
<!ENTITY divide "&#247;">
<!ENTITY eacute "&#233;">
<!ENTITY ecirc "&#234;">
<!ENTITY egrave "&#232;">
<!ENTITY empty "&#8709;">
<!ENTITY emsp "&#8195;">
<!ENTITY ensp "&#8194;">
<!ENTITY epsilon "&#949;">
<!ENTITY equiv "&#8801;">
<!ENTITY eta "&#951;">
<!ENTITY eth "&#240;">
<!ENTITY euml "&#235;">
<!ENTITY exist "&#8707;">
<!ENTITY fnof "&#402;">
<!ENTITY forall "&#8704;">
<!ENTITY frac12 "&#189;">
<!ENTITY frac14 "&#188;">
<!ENTITY frac34 "&#190;">
<!ENTITY frasl "&#8260;">
<!ENTITY gamma "&#947;">
<!ENTITY ge "&#8805;">
<!ENTITY hArr "&#8660;">
<!ENTITY harr "&#8596;">
<!ENTITY hearts "&#9829;">
<!ENTITY hellip "&#8230;">
<!ENTITY iacute "&#237;">
<!ENTITY iafs "&#8300;">
<!ENTITY icirc "&#238;">
<!ENTITY iexcl "&#161;">
<!ENTITY igrave "&#236;">
<!ENTITY image "&#8465;">
<!ENTITY infin "&#8734;">
<!ENTITY int "&#8747;">
<!ENTITY iota "&#953;">
<!ENTITY iquest "&#191;">
<!ENTITY isin "&#8712;">
<!ENTITY iss "&#8298;">
<!ENTITY iuml "&#239;">
<!ENTITY kappa "&#954;">
<!ENTITY lArr "&#8656;">
<!ENTITY lambda "&#955;">
<!ENTITY lang "&#9001;">
<!ENTITY laquo "&#171;">
<!ENTITY larr "&#8592;">
<!ENTITY lceil "&#8968;">
<!ENTITY ldquo "&#8220;">
<!ENTITY le "&#8804;">
<!ENTITY lfloor "&#8970;">
<!ENTITY lowast "&#8727;">
<!ENTITY loz "&#9674;">
<!ENTITY lre "&#8234;">
<!ENTITY lrm "&#8206;">
<!ENTITY lro "&#8237;">
<!ENTITY lsaquo "&#8249;">
<!ENTITY lsquo "&#8216;">
<!ENTITY macr "&#175;">
<!ENTITY mdash "&#8212;">
<!ENTITY micro "&#181;">
<!ENTITY middot "&#183;">
<!ENTITY minus "&#8722;">
<!ENTITY mu "&#956;">
<!ENTITY nabla "&#8711;">
<!ENTITY nads "&#8302;">
<!ENTITY nbsp "&#160;">
<!ENTITY ndash "&#8211;">
<!ENTITY ne "&#8800;">
<!ENTITY ni "&#8715;">
<!ENTITY nods "&#8303;">
<!ENTITY not "&#172;">
<!ENTITY notin "&#8713;">
<!ENTITY nsub "&#8836;">
<!ENTITY ntilde "&#241;">
<!ENTITY nu "&#957;">
<!ENTITY oacute "&#243;">
<!ENTITY ocirc "&#244;">
<!ENTITY oelig "&#339;">
<!ENTITY ograve "&#242;">
<!ENTITY oline "&#8254;">
<!ENTITY omega "&#969;">
<!ENTITY omicron "&#959;">
<!ENTITY oplus "&#8853;">
<!ENTITY or "&#8744;">
<!ENTITY ordf "&#170;">
<!ENTITY ordm "&#186;">
<!ENTITY oslash "&#248;">
<!ENTITY otilde "&#245;">
<!ENTITY otimes "&#8855;">
<!ENTITY ouml "&#246;">
<!ENTITY para "&#182;">
<!ENTITY part "&#8706;">
<!ENTITY pdf "&#8236;">
<!ENTITY permil "&#8240;">
<!ENTITY perp "&#8869;">
<!ENTITY phi "&#966;">
<!ENTITY pi "&#960;">
<!ENTITY piv "&#982;">
<!ENTITY plusmn "&#177;">
<!ENTITY pound "&#163;">
<!ENTITY prime "&#8242;">
<!ENTITY prod "&#8719;">
<!ENTITY prop "&#8733;">
<!ENTITY psi "&#968;">
<!ENTITY rArr "&#8658;">
<!ENTITY radic "&#8730;">
<!ENTITY rang "&#9002;">
<!ENTITY raquo "&#187;">
<!ENTITY rarr "&#8594;">
<!ENTITY rceil "&#8969;">
<!ENTITY rdquo "&#8221;">
<!ENTITY real "&#8476;">
<!ENTITY reg "&#174;">
<!ENTITY rfloor "&#8971;">
<!ENTITY rho "&#961;">
<!ENTITY rle "&#8235;">
<!ENTITY rlm "&#8207;">
<!ENTITY rlo "&#8238;">
<!ENTITY rsaquo "&#8250;">
<!ENTITY rsquo "&#8217;">
<!ENTITY sbquo "&#8218;">
<!ENTITY scaron "&#353;">
<!ENTITY sdot "&#8901;">
<!ENTITY sect "&#167;">
<!ENTITY shy "&#173;">
<!ENTITY sigma "&#963;">
<!ENTITY sigmaf "&#962;">
<!ENTITY sim "&#8764;">
<!ENTITY spades "&#9824;">
<!ENTITY sub "&#8834;">
<!ENTITY sube "&#8838;">
<!ENTITY sum "&#8721;">
<!ENTITY sup "&#8835;">
<!ENTITY sup1 "&#185;">
<!ENTITY sup2 "&#178;">
<!ENTITY sup3 "&#179;">
<!ENTITY supe "&#8839;">
<!ENTITY szlig "&#223;">
<!ENTITY tau "&#964;">
<!ENTITY there4 "&#8756;">
<!ENTITY theta "&#952;">
<!ENTITY thetasym "&#977;">
<!ENTITY thinsp "&#8201;">
<!ENTITY thorn "&#254;">
<!ENTITY tilde "&#732;">
<!ENTITY times "&#215;">
<!ENTITY trade "&#8482;">
<!ENTITY uArr "&#8657;">
<!ENTITY uacute "&#250;">
<!ENTITY uarr "&#8593;">
<!ENTITY ucirc "&#251;">
<!ENTITY ugrave "&#249;">
<!ENTITY uml "&#168;">
<!ENTITY upsih "&#978;">
<!ENTITY upsilon "&#965;">
<!ENTITY uuml "&#252;">
<!ENTITY weierp "&#8472;">
<!ENTITY xi "&#958;">
<!ENTITY yacute "&#253;">
<!ENTITY yen "&#165;">
<!ENTITY yuml "&#255;">
<!ENTITY zeta "&#950;">
<!ENTITY zwj "&#8205;">
<!ENTITY zwnj "&#8204;">
<!ENTITY zwsp "&#0203;">
]>
<xsl:stylesheet version='1.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform' xmlns="http://www.w3.org/1999/xhtml">

<!--
<xsl:output omit-xml-declaration="yes" method="xml" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" indent="yes" encoding="iso-8859-1" />
-->
<!-- back to transitional to validate when using frames -->
<xsl:output
	omit-xml-declaration="yes"
	method="xml"
	doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" 
	doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" 
	indent="no"
	encoding="%VISDOC_ENCODING%"
/>
   
   
<!-- ... Class documentation html page ... -->
<xsl:template match="document">
    <html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title><xsl:value-of select="htmlTitle" /></title>
        <xsl:for-each select="cssFile">
        	<link rel="stylesheet" type="text/css"><xsl:attribute name="href"><xsl:value-of select="." /></xsl:attribute></link>
		</xsl:for-each>
        <xsl:for-each select="jsFile">
        	<script type="text/javascript">
        		<xsl:attribute name="src"><xsl:value-of select="." /></xsl:attribute>
        	</script>
		</xsl:for-each>
    </head>
    <body>
    	<xsl:if test="navigation!=''">
    		<xsl:attribute name="class">isShowingNavigation</xsl:attribute>
    	</xsl:if>
    	<xsl:attribute name="id">page_<xsl:value-of select="pageClass" /></xsl:attribute>
    	<div id="page"> 
			<div id="wrapper">
				<div id="outer"> 
					<div id="floatWrap"> 
						<div id="main">
							<div id="clearHeaderCenter"></div> 
							<div id="mainContent">
								<xsl:if test="title!=''">
									<h1><xsl:value-of select="title" /></h1>
								</xsl:if>
								<xsl:apply-templates select="classData" />
								<xsl:apply-templates select="pageSummary|private/pageSummary" />
								<xsl:apply-templates select="tocList" />
								<xsl:apply-templates select="memberSections" />
							</div>
						</div>
						<xsl:if test="navigation!=''">
							<div id="sidebar">
								<div id="clearHeaderLeft"></div> 
								<div id="sidebarContent">							
									<xsl:apply-templates select="navigation/docTitle" />
									<xsl:apply-templates select="navigation/tocList" ><xsl:with-param name="id" select="treemenu"/></xsl:apply-templates>
									<xsl:apply-templates select="navigation/globalNav" />
								</div>
							</div>
						</xsl:if>
					</div>
					<div class="clear">&nbsp;</div> 
				</div>
			</div>
			<div id="header">
				<div id="headerContentWrapper">
					<div id="headerContent">
						<ul id="headerButtons">
							<xsl:if test="navigation!=''">
								<li id="toggleTocButton"><a href="#"><span class="disclosure">&#9660;</span><span class="closure">&#9658;</span>Navigation</a></li>
							</xsl:if>
							<xsl:call-template name="showHidePrivate" />
						</ul>
					</div>
				</div>
			</div>
			<xsl:apply-templates select="meta" />
		</div><!-- /page-->
     </body>
     </html>
</xsl:template>


<!-- ... showHidePrivate ... -->
<xsl:template name="showHidePrivate">
	<xsl:if test="./meta/showPrivate">
		<li id="togglePrivateButton">
			<span class="privateHide">
			  <a href="#"><span class="icon"><xsl:text>&times;</xsl:text></span><span class="label"><xsl:value-of select="./meta/hidePrivate" /></span></a>
			</span>
			<span class="privateShow">
			  <a href="#"><span class="icon"><xsl:text disable-output-escaping="yes"><![CDATA[+]]></xsl:text></span><span class="label"><xsl:value-of select="./meta/showPrivate" /></span></a>
			</span>
		</li>
	</xsl:if>
</xsl:template>


<!-- ... showHideTypeInfo ... -->
<xsl:template match="showHideTypeInfo">
	<li>
		<span class="typeInfoHide">
		  <a href="#"><span class="icon"><xsl:text>&times;</xsl:text></span><xsl:value-of select="hideTypeInfo" /></a>
		</span>
		<span class="typeInfoShow">
		  <a href="#"><span class="icon"><xsl:text disable-output-escaping="yes"><![CDATA[+]]></xsl:text></span><xsl:value-of select="showTypeInfo" /></a>
		</span>
	</li>
</xsl:template>


<!-- ... showHideSummaries ... -->
<xsl:template match="showHideSummaries">
	<li>
		<span class="summariesHide">
		  <a href="#"><span class="icon"><xsl:text>&times;</xsl:text></span><xsl:value-of select="hideSummaries" /></a>
		</span>
		<span class="summariesShow">
		  <a href="#"><span class="icon"><xsl:text disable-output-escaping="yes"><![CDATA[+]]></xsl:text></span><xsl:value-of select="showSummaries" /></a>
		</span>
	</li>
</xsl:template>


<!-- ... sortSummaries ... -->
<!--
<xsl:template match="sortSummaries">
	<li>
		<span class="sortHide">
		  <a href="#"><span class="icon"><xsl:text>&times;</xsl:text></span><xsl:value-of select="sortSourceOrder" /></a>
		</span>
		<span class="sortShow">
		  <a href="#"><span class="icon"><xsl:text disable-output-escaping="yes"><![CDATA[+]]></xsl:text></span><xsl:value-of select="sortAlphabetically" /></a>
		</span>
	</li>
</xsl:template>
-->
	
	
<!-- ... classData ... -->
<xsl:template match="classData">
	<div class="classProperties">
		<table cellspacing="0">
		<xsl:apply-templates select="kindOfClass" />
		<xsl:apply-templates select="enclosingClass" />
		<xsl:apply-templates select="package" />
		<xsl:apply-templates select="packageTitle" />
		<xsl:apply-templates select="inheritsFrom" />
		<xsl:apply-templates select="conformsTo" />
		<xsl:apply-templates select="implementedBy" />
		<xsl:apply-templates select="subclasses" />
		<xsl:apply-templates select="dispatchedBy" />
		<xsl:apply-templates select="classDetails" />
		</table>
	</div>
	<xsl:apply-templates select="sourceCode" />
	<xsl:apply-templates select="classDescription" />
</xsl:template>


<!-- ... packageTitle ... -->
<xsl:template match="packageTitle">
	<tr>
		<th colspan="2" align="left">
			<xsl:value-of select="title" />
		</th>
	</tr>
</xsl:template>


<!-- ... kindOfClass ... -->
<xsl:template match="kindOfClass">
	<tr>
		<th align="left">
			<xsl:value-of select="title" /><xsl:text>:</xsl:text>
		</th>
		<td>
			<xsl:value-of select="item" />
		</td>
	</tr>
</xsl:template>


<!-- ... enclosingClass ... -->
<xsl:template match="enclosingClass">
	<xsl:if test="node()">
		<tr>
			<th align="left">
				<xsl:value-of select="title" /><xsl:text>:</xsl:text>
			</th>
			<td>
				<ul>
				<xsl:for-each select="item">
					<li>
						<xsl:call-template name="link" />						
					</li>
				</xsl:for-each>
				</ul>
			</td>
		</tr>
	</xsl:if>
</xsl:template>


<!-- ... package ... -->
<xsl:template match="package">
	<xsl:if test="node()">
		<tr>
			<th align="left">
				<xsl:value-of select="title" /><xsl:text>:</xsl:text>
			</th>
			<td>
				<xsl:for-each select="item">
					<xsl:call-template name="link" />
					<xsl:if test="position() != last()">
						<xsl:text><![CDATA[ < ]]></xsl:text>
					</xsl:if>
				</xsl:for-each>
			</td>
		</tr>
	</xsl:if>
</xsl:template>


<!-- ... inheritsFrom ... -->
<xsl:template match="inheritsFrom">
	<xsl:if test="node()">
		<tr>
			<th align="left">
				<xsl:value-of select="title" /><xsl:text>:</xsl:text>
			</th>
			<td>
				<xsl:for-each select="item">
					<xsl:call-template name="link" />
					<xsl:if test="position() != last()">
						<xsl:text><![CDATA[ < ]]></xsl:text>
					</xsl:if>
				</xsl:for-each>
			</td>
		</tr>
	</xsl:if>
</xsl:template>


<!-- ... conformsTo ... -->
<xsl:template match="conformsTo">
	<xsl:if test="node()">
		<tr>
			<th align="left">
				<xsl:value-of select="title" /><xsl:text>:</xsl:text>
			</th>
			<td>
				<ul>
				<xsl:for-each select="item">
					<li>
						<xsl:call-template name="link" />								
					</li>
				</xsl:for-each>
				</ul>
			</td>
		</tr>
	</xsl:if>
</xsl:template>


<!-- ... implementedBy ... -->
<xsl:template match="implementedBy">
	<xsl:if test="node()">
		<tr>
			<th align="left">
				<xsl:value-of select="title" /><xsl:text>:</xsl:text>
			</th>
			<td>
				<ul>
				<xsl:for-each select="item">
					<li>
						<xsl:call-template name="link" />									
					</li>
				</xsl:for-each>
				</ul>
			</td>
		</tr>
	</xsl:if>
</xsl:template>


<!-- ... subclasses ... -->
<xsl:template match="subclasses">
	<xsl:if test="node()">
		<tr>
			<th align="left">
				<xsl:value-of select="title" /><xsl:text>:</xsl:text>
			</th>
			<td>
				<ul>
				<xsl:for-each select="item">
					<li>
						<xsl:call-template name="link" />								
					</li>
				</xsl:for-each>
				</ul>
			</td>
		</tr>
	</xsl:if>
</xsl:template>


<!-- ... dispatchedBy ... -->
<xsl:template match="dispatchedBy">
	<xsl:if test="node()">
		<tr>
			<th align="left">
				<xsl:value-of select="title" /><xsl:text>:</xsl:text>
			</th>
			<td>
				<ul>
				<xsl:for-each select="item">
					<li>
						<xsl:call-template name="link" />								
					</li>
				</xsl:for-each>
				</ul>
			</td>
		</tr>
	</xsl:if>
</xsl:template>


<!-- ... classDetails ... -->
<xsl:template match="classDetails">
	<xsl:if test="node()">
		<xsl:for-each select="item">
			<tr>
				<th class="classDetails" align="left">
					<xsl:value-of select="title" /><xsl:text>:</xsl:text>
				</th>
				<td class="classDetails">
					<xsl:call-template name="substituteLinefeeds">
						<xsl:with-param name="string" select="value" />
					</xsl:call-template>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:if>
</xsl:template>


<!-- ... sourceCode ... -->
<xsl:template match="sourceCode">
	<xsl:if test="node()">
		<div class="sourceCode">
			<xsl:if test="viewSourceButton!=''">
				<span class="sourceCodeShow"><a href="#"><span class="closure">&#9658;<xsl:text disable-output-escaping="yes">&nbsp;</xsl:text></span><span class="linkLabel"><xsl:value-of select="viewSourceButton" /></span></a></span><span class="sourceCodeHide"><a href="#"><span class="disclosure">&#9660;<xsl:text disable-output-escaping="yes">&nbsp;</xsl:text></span><span class="linkLabel"><xsl:value-of select="hideSourceButton" /></span></a></span>
			</xsl:if>
			<pre id="source"><xsl:attribute name="class">brush: 
			<xsl:if test="/document/language='as2'">as3;</xsl:if>
			<xsl:if test="/document/language='as3'">as3;</xsl:if>
			<xsl:if test="/document/language='java'">java;</xsl:if></xsl:attribute><xsl:value-of select="sourceCodeText" /></pre>
		</div>
	</xsl:if>
</xsl:template>


<!-- ... pageSummary ... -->
<xsl:template match="pageSummary|private/pageSummary">
	<div class="toc">
		<xsl:if test="../../private!=''">
			<xsl:attribute name="class">toc private</xsl:attribute>
		</xsl:if>
		<h2><xsl:attribute name="id"><xsl:value-of select="id" /></xsl:attribute><xsl:value-of select="title" /></h2>
		<div class="docNav">
			<ul>
				<xsl:if test="(memberList/showHideTypeInfo!='')"><xsl:apply-templates select="memberList/showHideTypeInfo" /></xsl:if>
				<xsl:if test="(memberList/showHideSummaries!='')"><xsl:apply-templates select="memberList/showHideSummaries" /></xsl:if>
				<!--
				<xsl:apply-templates select="memberList/sortSummaries" />
				-->
			</ul>
			<div class="clear"></div>
		</div>
		<div class="memberList">
			<xsl:apply-templates select="memberList" />
		</div>
	</div>
</xsl:template>


<!-- ... fields ... -->
<xsl:template match="fields">
	<xsl:if test="node()">
		<div class="classFields">
			<div class="boxWithBorder">
				<xsl:apply-templates select="field" />
			</div>
		</div>
	</xsl:if>
</xsl:template>


<!-- ... field ... -->
<xsl:template match="field">
	<div class="boxedElem">
		<div class="contentHolder">
			<span class="title"><xsl:value-of select="title" /><xsl:text>:</xsl:text></span>
			<xsl:choose>
				<xsl:when test="paramfield!=''">
					<!-- ... param ... -->
					<xsl:apply-templates select="paramfield" />
				</xsl:when>
				<xsl:otherwise>
					<!-- ... field ... -->
					<div class="item">
						<xsl:if test="description/item!=''">
							<ul>
								<xsl:for-each select="description/item">
									<li>
										<xsl:if test="value!=''">
											<xsl:call-template name="substituteLinefeeds">
												<xsl:with-param name="string" select="value" />
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="summary!=''">
											<ul class="summary inheritDoc">
												<li>
													<xsl:call-template name="substituteLinefeeds">
														<xsl:with-param name="string" select="summary" />
													</xsl:call-template>
												</li>
											</ul>
										</xsl:if>
									</li>
								</xsl:for-each>
							</ul>
							</xsl:if>
						<!-- ... metadatatags ... -->
						<xsl:apply-templates select="metadatatags" />
					</div>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</div>
</xsl:template>


<!-- ... metadatatags ... -->
<xsl:template match="metadatatags">
	<table>
	<xsl:for-each select="tag">
		<tr>
		<th align="left">
			<xsl:if test="position() mod 2 = 0">
				<xsl:attribute name="class">even</xsl:attribute>
			</xsl:if>
			<xsl:if test="position() mod 2 = 1">
				<xsl:attribute name="class">uneven</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="title"/>
		</th>
		<td>
			<xsl:if test="position() mod 2 = 0">
				<xsl:attribute name="class">even</xsl:attribute>
			</xsl:if>
			<xsl:if test="position() mod 2 = 1">
				<xsl:attribute name="class">uneven</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="metadatatagattribute" />
		</td>
		</tr>
	</xsl:for-each>
	</table>
</xsl:template>


<!-- ... descriptionfield ... -->
<xsl:template name="descriptionfield">
	<div class="field">
		<span class="title"><xsl:value-of select="title" /><xsl:text><![CDATA[ ]]></xsl:text></span>
		<xsl:for-each select="description">
			<xsl:call-template name="substituteLinefeeds">
				<xsl:with-param name="string" select="." />
			</xsl:call-template>
		</xsl:for-each>
	</div>
</xsl:template>


<!-- ... paramfield ... -->
<xsl:template match="paramfield">
	<div class="item">
		<xsl:call-template name="keyvalue">
			<xsl:with-param name="string" select="value" />
		</xsl:call-template>
	</div>
</xsl:template>


<!-- ... metadatatagattribute ... -->
<xsl:template match="metadatatagattribute">
	<p>
	<xsl:call-template name="keyvalue">
		<xsl:with-param name="string" select="value" />
	</xsl:call-template>
	</p>
</xsl:template>


<!-- ... keyvalue ... -->
<xsl:template name="keyvalue">
	<span class="colorizedCode code"><xsl:value-of select="name" />
	<xsl:if test="name!=''"><span class="itemSeparator"><xsl:text><![CDATA[:]]></xsl:text></span></xsl:if></span>
	<xsl:choose>
		<xsl:when test="description!=''">
			<xsl:call-template name="substituteLinefeeds">
				<xsl:with-param name="string" select="description" />
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text disable-output-escaping="yes">&nbsp;</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:if test="access!=''">
		<span class="access"><xsl:value-of select="access" /></span>
	</xsl:if>
</xsl:template>


<!-- ... classDescription ... -->
<xsl:template match="classDescription">
	<div class="classDescription">
		<!-- ... fields at top of description ... -->
		<xsl:if test="fields!=''">
			<div class="fields">
				<xsl:for-each select="fields/field">
					<xsl:call-template name="descriptionfield">
						<xsl:with-param name="string" select="." />
					</xsl:call-template>
				</xsl:for-each>
			</div>
		</xsl:if>
		<xsl:if test="summary!=''">
			<span class="descriptionSummary">
				<xsl:call-template name="substituteLinefeeds">
					<xsl:with-param name="string" select="summary" />
				</xsl:call-template>
			</span>
		</xsl:if>
		<xsl:call-template name="substituteLinefeeds">
			<xsl:with-param name="string" select="restOfDescription" />
		</xsl:call-template>
		<!-- ... CLASS FIELDS ... -->
		<xsl:apply-templates select="../fields" />
	</div>
</xsl:template>


<!-- ... memberList ... -->
<xsl:template match="memberList">
	<xsl:for-each select="memberSummaryPart|private/memberSummaryPart">
		<xsl:if test="node()">
			<div class="memberSummaryPart">
				<xsl:if test="../../private!=''">
					<xsl:attribute name="class">memberSummaryPart private</xsl:attribute>
				</xsl:if>
				<span class="title"><xsl:value-of select="title" /></span>
					<xsl:if test="item!=''">
						<ul class="sortable"><xsl:attribute name="id">sortul<xsl:number value="position()" format="1" /></xsl:attribute>
							<xsl:for-each select="item|item/private">
								<xsl:if test="id!=''">
									<li><xsl:attribute name="class">sortli listnum<xsl:number value="position()" format="1" /></xsl:attribute>
										<xsl:if test="../private!=''">
											<xsl:attribute name="class">private sortli listnum<xsl:number value="position()" format="1" /></xsl:attribute>
										</xsl:if>
										<a><xsl:attribute name="href">#<xsl:value-of select="id/text()" /></xsl:attribute><xsl:value-of select="title/text()" /></a>
										<xsl:if test="typeInfo/typeInfoString!=''">
											<span class="typeInfo"><xsl:text> </xsl:text><xsl:value-of select="typeInfo/typeInfoString" disable-output-escaping="yes" /></span>
										</xsl:if>
										<xsl:if test="typeInfo/summary!=''">
											<ul class="summary">
												<li><xsl:value-of select="typeInfo/summary" disable-output-escaping="yes" /></li>
											</ul>
										</xsl:if>
									</li>
								</xsl:if>
							</xsl:for-each>
						</ul>
					</xsl:if>
				<xsl:apply-templates select="inheritedMethods" />
			</div>
		</xsl:if>
	</xsl:for-each>	
</xsl:template>


<!-- ... inheritedMethods ... -->
<xsl:template match="inheritedMethods">
	<xsl:if test="node()">
		<div>
			<xsl:choose>
				<xsl:when test="private">
					<xsl:attribute name="class">boxWithBorder private</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class">boxWithBorder</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:for-each select=".">
				<xsl:for-each select="fromClass">
					<div class="boxedElem">
						<div class="contentHolder">
							<span class="title">
							<xsl:value-of select="title/text" /><xsl:text disable-output-escaping="yes">&nbsp;</xsl:text><xsl:text> </xsl:text>
								<span class="superclass">
									<xsl:choose>
										<xsl:when test="title/link/uri!=''">
											<a><xsl:attribute name="class">className</xsl:attribute><xsl:attribute name="href"><xsl:value-of select="title/link/uri" />.html</xsl:attribute>
											<xsl:value-of select="title/link/name" /></a>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="title/link/name" />
										</xsl:otherwise>
									</xsl:choose>
								</span>
							</span>
							<div class="item inheritedList">
								<xsl:for-each select="item">
									<a><xsl:if test="private"><xsl:attribute name="class">private</xsl:attribute></xsl:if><xsl:attribute name="href"><xsl:value-of select="link/uri" />.html#<xsl:value-of select="link/member" /></xsl:attribute><xsl:value-of select="link/name" /></a><xsl:if test="position() != last()"><xsl:text>  </xsl:text></xsl:if>
								</xsl:for-each>
							</div>
						</div>
					</div>
				</xsl:for-each>
			</xsl:for-each>
		</div>
	</xsl:if>
</xsl:template>



<!-- ... memberSections ... -->
<xsl:template match="memberSections">
	<xsl:for-each select="memberSection|private/memberSection">
		<div class="memberSection">
			<xsl:if test="../../private!=''">
				<xsl:attribute name="class">memberSection private</xsl:attribute>
			</xsl:if>
			<h2><xsl:attribute name="id"><xsl:value-of select="id" /></xsl:attribute><xsl:value-of select="title" /></h2>
			<xsl:for-each select="member|class">
				<div>
					<xsl:choose>
						<xsl:when test="private!=''">
							<xsl:if test="../class!=''">
								<xsl:attribute name="class">class private</xsl:attribute>
							</xsl:if>
							<xsl:if test="../member!=''">
								<xsl:attribute name="class">member private</xsl:attribute>
							</xsl:if>
							<!--<xsl:attribute name="style">display:none;</xsl:attribute>-->
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="../class!=''">
								<xsl:attribute name="class">class</xsl:attribute>
							</xsl:if>
							<xsl:if test="../member!=''">
								<xsl:attribute name="class">member</xsl:attribute>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:attribute name="id"><xsl:value-of select="id" /></xsl:attribute>
					<h3> 
						<xsl:choose>
							<xsl:when test="title/link/uri!=''">
								<a>
									<xsl:if test="private!=''">
										<xsl:attribute name="class">private</xsl:attribute>
									</xsl:if>
									<xsl:attribute name="href"><xsl:value-of select="title/link/uri" />.html</xsl:attribute>
									<span>
										<xsl:if test="../class!=''">
											<xsl:attribute name="class">className</xsl:attribute>
										</xsl:if>
										<xsl:value-of select="title/link/name" />
									</span>
								</a>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="title" />
							</xsl:otherwise>
						</xsl:choose>
					</h3>
					<xsl:if test="attribute!=''">
						<xsl:text disable-output-escaping="yes">&nbsp;</xsl:text><span class="attribute"><xsl:value-of select="attribute" /></span>
					</xsl:if>
					<!-- ... full member ... -->
					<xsl:if test="fullMemberString!=''">
						<div class="fullMemberString">
								<span class="code"><xsl:value-of select="fullMemberString/member" disable-output-escaping="yes" /></span>
								<xsl:if test="fullMemberString/access!=''"><span class="access"><xsl:text>(</xsl:text><xsl:value-of select="fullMemberString/access" /><xsl:text>)</xsl:text></span></xsl:if>
						</div>
					</xsl:if>
					<!-- ... description ... -->
					<xsl:if test="description!=''">
						<div class="description">
							<!-- ... fields at top of description ... -->
							<xsl:if test="description/fields!=''">
								<div class="fields">
									<xsl:for-each select="description/fields/field">
										<xsl:call-template name="descriptionfield">
											<xsl:with-param name="string" select="." />
										</xsl:call-template>
									</xsl:for-each>
								</div>
							</xsl:if>
							<xsl:call-template name="substituteLinefeeds">
								<xsl:with-param name="string" select="description/text" />
							</xsl:call-template>
						</div>
					</xsl:if>
					<!-- ... fields ... -->
					<xsl:if test="fields!=''">
						<div class="boxWithBorder">
							<xsl:apply-templates select="fields/field" />
						</div>
					</xsl:if>
				</div>
			</xsl:for-each>
		</div>
	</xsl:for-each>
</xsl:template>


<!-- ... footer ... -->
<xsl:template match="meta">
	<xsl:if test="(copyright!='') or (createdWith!='')">
		<div id="footer">
			<div id="footerContent">
				<ul>
					<xsl:if test="copyright!=''">
						<li class="copyright">
							<xsl:value-of select="copyright" />
						</li>
					</xsl:if>
					<xsl:if test="createdWith!=''">
						<li class="createdWith"><xsl:value-of select="createdWith" /><xsl:text> </xsl:text><xsl:if test="link!=''"><a><xsl:attribute name="href"><xsl:value-of select="link/uri" /></xsl:attribute><xsl:value-of select="link/name" /></a></xsl:if>
						</li>
					</xsl:if>
				</ul>
			</div>
		</div>
	</xsl:if>
</xsl:template>


<!-- ... substituteLinefeeds ... -->
<!-- substitutes \n with <br /> -->

<xsl:template name="substituteLinefeeds">
	<xsl:param name="string" />
	<xsl:param name="from" select="'\n'" />
	<xsl:param name="to"><br /></xsl:param>
	<xsl:choose>
		<xsl:when test="contains($string, $from)">
			<xsl:value-of select="substring-before($string, $from)" disable-output-escaping="yes" />
			<xsl:apply-templates select="$to" mode="copy" />
			<xsl:call-template name="substituteLinefeeds">
				<xsl:with-param name="string" select="substring-after($string, $from)" />
        	    <xsl:with-param name="from" select="$from" />
            	<xsl:with-param name="to" select="$to" />
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$string" disable-output-escaping="yes" />
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<!-- ... summary ... -->
<xsl:template match="summary">
	<strong><xsl:value-of select="." disable-output-escaping="yes" /></strong>
</xsl:template>


<!-- ... copy ...
    copy template to replace <xsl:copy-of select="." /> /
    now use: <xsl:apply-templates select="." mode="copy" />
-->
<xsl:template match="*" mode="copy">
  <xsl:element name="{local-name()}">
    <xsl:copy-of select="@*" />
    <xsl:apply-templates mode="copy" />
  </xsl:element>
</xsl:template>

<xsl:template match="text()" mode="copy">
  <xsl:value-of select="." />
</xsl:template>


<!-- ... linkAsId ... -->
<xsl:template name="linkAsId">
	<xsl:if test="(link/name) and (not(member))">
		<xsl:attribute name="id">
			<xsl:choose>
				<xsl:when test="link/uri!=''">
					<xsl:text disable-output-escaping="yes"><![CDATA[menu_]]></xsl:text><xsl:value-of select="link/uri" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:text disable-output-escaping="yes"><![CDATA[menu_]]></xsl:text><xsl:value-of select="link/name" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:if>
</xsl:template>		


<!-- ... listItemType ... -->
<xsl:template name="listItemType">
	<xsl:if test="(package!='') or (interface!='') or (private!='')">
		<xsl:attribute name="class">
			<xsl:if test="package='true'">package </xsl:if>			<xsl:if test="interface='true'">interface </xsl:if>
			<xsl:if test="private='true'">private </xsl:if>
		</xsl:attribute>
	</xsl:if>
</xsl:template>


<!-- ... listGroupItem ... -->
<xsl:template name="listGroupItem">
	<xsl:if test="node()">
			<xsl:for-each select="listGroup">
				<xsl:call-template name="tocListGroup" />
			</xsl:for-each>
			<xsl:if test="link/uri!=''">
				<a>
					<xsl:choose>
						<xsl:when test="link/member!=''">
							<xsl:attribute name="href"><xsl:value-of select="link/uri" />.html#<xsl:value-of select="link/member" /></xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="href"><xsl:value-of select="link/uri" />.html</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="packagePath!=''">
						<span class="packagePath"><xsl:value-of select="packagePath" /></span>
					</xsl:if>
					<xsl:if test="link/name!=''">
						<span><xsl:if test="(class|interface)='true'"><xsl:attribute name="class">className</xsl:attribute></xsl:if><xsl:value-of select="link/name" /></span>
					</xsl:if>
					<xsl:if test="className!=''">
						<span class="className"><xsl:text disable-output-escaping="yes">(</xsl:text><xsl:value-of select="className" /><xsl:text disable-output-escaping="yes"><![CDATA[)]]></xsl:text></span>
					</xsl:if>
					<xsl:if test="attribute!=''">
						<xsl:text disable-output-escaping="yes"><![CDATA[ ]]></xsl:text><span class="attribute"><xsl:value-of select="attribute" /></span>
					</xsl:if>
				</a>
				<xsl:if test="interface='true'"><span><xsl:attribute name="class">type small</xsl:attribute> interface</span></xsl:if>
				<xsl:if test="private='true'"><span><xsl:attribute name="class">type small</xsl:attribute> private</span></xsl:if>
			</xsl:if>
			<xsl:if test="not(link/uri)">
				<xsl:value-of select="link/name" />
			</xsl:if>
			<xsl:if test="summary!=''">
				<ul>
					<xsl:attribute name="class">summary</xsl:attribute>
					<li>
						<xsl:call-template name="substituteLinefeeds">
							<xsl:with-param name="string" select="summary" />
						</xsl:call-template>
					</li>
				</ul>
			</xsl:if>
	</xsl:if>
</xsl:template>


<!-- ... tocList ... -->
<xsl:template match="tocList">
	<xsl:if test="node()">
		<div class="list">
			<xsl:if test="title!=''">
				<xsl:value-of select="title" />
			</xsl:if>
			<xsl:for-each select="listGroup">
				<xsl:call-template name="tocListGroup" />
			</xsl:for-each>
		</div>
	</xsl:if>
</xsl:template>


<!-- ... tocListGroup ... -->
<xsl:template name="tocListGroup">
	<ul>
		<xsl:if test="id">
			<xsl:attribute name="id"><xsl:value-of select="id" /></xsl:attribute>
		</xsl:if>
		<xsl:choose>
  			<xsl:when test="listGroupTitle">
				<li>
					<xsl:choose>
						<xsl:when test="listGroupTitle/item">		
							<xsl:for-each select="listGroupTitle/item">
								<xsl:call-template name="linkAsId" />
								<xsl:call-template name="listItemType" />
								<xsl:call-template name="listGroupItem" />
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="listGroupTitle" />
						</xsl:otherwise>
					</xsl:choose>
					<xsl:for-each select="listGroup">
						<xsl:call-template name="tocListGroup" />
					</xsl:for-each>
				</li>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="listGroup">
					<xsl:call-template name="tocListGroup" />
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:for-each select="item">
			<li>
				<xsl:call-template name="linkAsId" />
				<xsl:call-template name="listItemType" />
				<xsl:call-template name="listGroupItem" />
			</li>
		</xsl:for-each>
	</ul>
</xsl:template>


<!-- ... docTitle ... -->
<xsl:template match="docTitle">
	<xsl:call-template name="link" />
</xsl:template>
	

<!-- ... globalNav ... -->
<xsl:template match="globalNav">
	<div class="globalNav">
		<xsl:if test="title!=''">
			<span><xsl:attribute name="class">item</xsl:attribute><xsl:value-of select="title" /></span>
		</xsl:if>
		<xsl:if test="items!=''">
			<ul>
				<xsl:for-each select="items/item">
					<li>
						<xsl:call-template name="linkAsId" />
						<xsl:attribute name="class">item</xsl:attribute>
						<xsl:call-template name="link" />
					</li>
				</xsl:for-each>
			</ul>
		</xsl:if>
	</div>
</xsl:template>


<!-- ... link ... -->
<xsl:template name="link">
	<xsl:if test="node()">
		<xsl:choose>
			<xsl:when test="link/uri!=''">
				<a><xsl:attribute name="href"><xsl:value-of select="link/uri" />.html</xsl:attribute><xsl:value-of select="link/name" /></a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="link/name!=''">
						<xsl:value-of select="link/name" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="." />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:if>
</xsl:template>


</xsl:stylesheet>