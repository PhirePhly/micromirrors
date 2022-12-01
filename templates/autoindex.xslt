<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:date="http://exslt.org/dates-and-times"
   extension-element-prefixes="date" >
  <xsl:output method="html" encoding="UTF-8"/>

  <xsl:param name="cpath"/>
  <xsl:variable name="TIMEDIFF" select="'PT8H'"/><!-- 'PT0H' '-PT6H' -->
  <xsl:template match="/">
  <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
 <html>
 <head>
   <title>FCIX Micro Mirror</title>
   <meta charset="utf-8"/>
   <meta name="viewport" content="width=device-width, initial-scale=1"/>
   <xsl:text disable-output-escaping="yes">

&lt;!--
   ========= config in nginx: ===============
    autoindex  on;
    autoindex_format  xml;
    xslt_stylesheet  /..path_to.../html/autoindex.xslt  cpath="$uri";
   ========= config in nginx: ===============
    modify variable "TIMEDIFF".
--&gt;

   </xsl:text>
   <style type="text/css">
  body {
	margin: 5px;
	background-color: #ddd;
  }
  table {
	font-size: 15px; 
	width: 96%;
	min-width:650px;
	table-layout:fixed;
	margin-top: 15px;
	margin-left: 5px; 
	margin-right: 5px; 

	box-shadow: 0 0 0.5em #999;
	border: none !important;
	margin-bottom: 1em;
	border-collapse: collapse;
	border-spacing: 0;
  }
  th {
	background: #000;
	background: -webkit-linear-gradient(top, #444, #000);
	background: -moz-linear-gradient(top, #444, #000);
	background: -ms-linear-gradient(top, #444, #000);
	background: -o-linear-gradient(top, #444, #000);
	background: linear-gradient(top, #444, #000);
	font-size: 14px;
	line-height: 24px;
	border: none;
	text-align: left;
	color: #fff;
  }
  tr {
	background: rgba(255, 255, 255, 0.8);
  }
  tr:hover {
	background: rgba(255, 255, 255, 0.5);
  }
  .f9 {
	font-size: 9px;
  }
  tr th td {
	overflow:hidden;
	text-overflow:ellipsis;
	white-space:nowrap;
	word-break:keep-all;
  }
  th, td {
	height: 20px;
	vertical-align: middle;
	white-space: nowrap;
	padding: 0.1em 0.5em;
	border: 1px solid #ccc;
  }
  a{text-decoration:none;}
  a:hover{text-decoration:underline;}
  .name{min-width:400px;text-overflow:ellipsis;overflow:hidden;white-space:nowrap;font-size:15px;}
  .size{min-width:65px;white-space:nowrap;font-size:13px;text-align:right;}
  .mtime{width:115px;white-space:nowrap;font-size:11px;text-align:center;}
   </style>
 </head>
 <body>
   <div style="margin-left:15px;margin-top:10px;font-size:15pt">
   <p>
	   This is an FCIX Micro Mirror node hosted by <a href="{{ site_sponsor_url }}">{{ site_sponsor }}</a>.
   </p>
   <b>
   Index of <xsl:value-of select="$cpath"/>
   </b>
   </div>
   <center>
    <xsl:apply-templates/>
   </center>
   <div style="margin-left:15px;font-size:15pt">
     <a href="https://github.com/PhirePhly/micromirrors/blob/main/doc/product-brief.md">Micro Mirrors</a> are a fleet of optimized free software mirrors that serve a small number of projects from across the Internet.<br/>
     The hardware for these mirrors are funded by <a href="https://liberapay.com/phirephly/">donations from the community</a>, with the hosting space, power, and network connecitivty provided by the hosting sponsor linked at the top of this page.<br/>
     If you experience any technical issues with this mirror or have questions, please contact the <a href="mailto:mirror@fcix.net">FCIX Mirror Team</a>.
     The Micro Mirrors are operated by the same team with the same policies as <a href="https://mirror.fcix.net/">mirror.fcix.net</a>.
   </div>
   <br/>
 </body>
 </html>
 </xsl:template>

  <xsl:template match="list">
    <table style="width:100%;min-width:670px;margin:0;box-shadow:none" cellpadding="0"><tr style="background:none"><td style="padding:0;border:0"><center>
    <table>
   <tr>
     <th>Name</th>
     <th width="80px">Size</th>
     <th width="115px">Modified</th>
   </tr>
   <tr>
	   <td><a href="../"> ^ Parent Directory</a></td>
     <td></td>
     <td></td>
   </tr>
    <xsl:for-each select="directory">
      <xsl:sort select="name"/>
    </xsl:for-each>
    <xsl:apply-templates/>
    </table>
    </center></td></tr></table>
  </xsl:template>

  <xsl:template match="file">
      <xsl:variable name="name">
        <xsl:value-of select="."/>
      </xsl:variable>
      <xsl:variable name="size">
        <xsl:if test="string-length(@size) &gt; 0">
          <xsl:if test="number(@size) = 0">
            <xsl:value-of select="@size" /> B
	  </xsl:if>
          <xsl:if test="number(@size) &gt; 0">
            <xsl:choose>
              <xsl:when test="round(@size div 1024) &lt; 2"><xsl:value-of select="@size" /> B</xsl:when>
              <xsl:when test="round(@size div 1048576) &lt; 2"><xsl:value-of select="format-number((@size div 1024), '0.0')" /> KB</xsl:when>
              <xsl:when test="round(@size div 1073741824) &lt; 2"><xsl:value-of select="format-number((@size div 1048576), '0.00')" /> MB</xsl:when>
              <xsl:otherwise><xsl:value-of select="format-number((@size div 1073741824), '0.00')" /> GB</xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </xsl:if>
      </xsl:variable>
   <tr>
     <td class="f11"><div class="name"><a href="{$name}" title="{$name}"><xsl:value-of select="."/></a></div></td>
     <td><div class="size" title="{@size} bytes"><xsl:value-of select="$size"/></div></td>
     <td><div class="mtime">
           <xsl:value-of select="translate(date:add(@mtime,$TIMEDIFF),'TZ','  ')" />
     </div></td>
   </tr>
  </xsl:template>

  <xsl:template match="directory" name="directory">
      <xsl:variable name="name">
        <xsl:value-of select="."/>
      </xsl:variable>
   <tr>
     <td class="f11"><div class="name">&#128194;<a href="{$name}" title="{$name}/"><xsl:value-of select="."/>/</a></div></td>
     <td><div class="size"> -- </div></td>
     <td><div class="mtime"> 
           <xsl:value-of select="@mtime" />
     </div> </td>
   </tr>
  </xsl:template>

  <xsl:template match="other" name="other">
  </xsl:template>

</xsl:stylesheet>

