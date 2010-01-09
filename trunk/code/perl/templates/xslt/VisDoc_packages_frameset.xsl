<?xml version='1.0' encoding='utf-8'?>


<!--
This XSL template generates:
* html the frameset index.html

The generated html uses the tags frameborder="no" and framespacing="0" to disable frame borders, and hence will NOT 
validate with The W3C Markup Validation Service at http://validator.w3.org/ .
-->


<xsl:stylesheet version='1.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform' xmlns="http://www.w3.org/1999/xhtml">

<xsl:output omit-xml-declaration="yes" method="xml" doctype-public="-//W3C//DTD XHTML 1.0 Frameset//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd" indent="yes"  encoding="UTF-8" />


<!-- ......................... # Index # ......................... -->
<!-- written to toc-frame.html -->
<xsl:template match="index">
	<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
			<title><xsl:value-of select="title" /></title>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
			<script src="../js/jquery.js" type="text/javascript"><xsl:text>//</xsl:text></script>
			<script src="../js/common.js" type="text/javascript"><xsl:text>//</xsl:text></script>
			<script src="../js/index.js" type="text/javascript">//</script>
		</head>
		<frameset><xsl:attribute name="cols"><xsl:value-of select="frameSizes" /></xsl:attribute>
            <frame src="toc-frame.html" name="packageTocFrame"/>
			<frame name="docFrame" scrolling="auto"/>
        </frameset>
	</html>
</xsl:template>

</xsl:stylesheet>

