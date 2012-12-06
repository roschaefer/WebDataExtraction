<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="yes" version="4.0"/>
    
    <!-- Document Sources -->
    <xsl:variable name="flickr" select="document('./flickr.xml')"/>
    <xsl:variable name="discogs" select="document('./discographies.xml')"/>
    <xsl:variable name="youtube" select="document('./youtube.xml')"/>
    <xsl:variable name="pitchfork" select="document('./pitchfork.xml')"/>
    <xsl:variable name="cduniverse" select="document('./cduniverse.xml')"/>
    
    
    <!-- Main Template: Generates main HTML structure -->
    <xsl:template match="/">

        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html lang="en">
            <head>
                <meta charset="utf-8"></meta>
                <title>Web Data Extraction and Integration - Stage 4</title>
                <link href="http://netdna.bootstrapcdn.com/twitter-bootstrap/2.2.1/css/bootstrap-combined.min.css" rel="stylesheet"></link>
            </head>
            <body>
                <div class="container">
                    
                    <div class="page-header">
                        <h2>Integrated Data</h2>
                    </div>
                    
                    <hr/>
                    
                    <div class="row">
                        <div class="span12"> 
                            <h2>Images</h2>
                            <xsl:call-template name="generateImages" />  
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="span12"> 
                            <h2>Discography</h2>
                            <xsl:call-template name="generateDiscography" />  
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="span12"> 
                            <h2>Products on CDUniverse</h2>
                            <xsl:call-template name="generateProducts" />  
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="span12"> 
                            <h2>Pitchfork News</h2>
                            <xsl:call-template name="generatePitchforkNews" />  
                        </div>
                    </div>
 
                    <div class="row">
                        <div class="span12"> 
                            <h2>Youtube</h2>
                            <xsl:call-template name="generateYoutubeVideos" />
                        </div>
                    </div>
                    
                </div>
            </body>
        </html>
    </xsl:template>

    <xsl:template name="generateYoutubeVideos">
        <table class="table table-striped" >
            <xsl:for-each select="$youtube/result/youtube//result[position() &lt; 10]">
                <tr>
                    <td rowspan="6">
                        <a>
                            <xsl:attribute name="href">http://www.youtube.com/watch?v=<xsl:value-of select="id" /></xsl:attribute>
                            <img>
                                <xsl:attribute name="src">http://i2.ytimg.com/vi/<xsl:value-of select="id" />/mqdefault.jpg</xsl:attribute>
                            </img>
                        </a>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <b>
                            <i>
                                <xsl:value-of select="title" disable-output-escaping="yes" />
                            </i>
                        </b>
                    </td>
                </tr>
                <tr>
                    <td>
                        <b>Time:</b>
                    </td>
                    <td>
                        <xsl:value-of select="time" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <b>Uploader:</b>
                    </td>
                    <td>
                        <a target="_blank">
                            <xsl:attribute name="href">
                                http://www.youtube.com/user/
                                <xsl:value-of select="uploader" />
                            </xsl:attribute>
                            <xsl:value-of select="uploader" />
                        </a>
                    </td>
                </tr>
                <tr>
                    <td>
                        <b>Views:</b>
                    </td>
                    <td>
                        <xsl:value-of select="views" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <b>Link:</b>
                    </td>
                    <td>
                        <a target="_blank">
                            <xsl:attribute name="href">http://www.youtube.com/watch?v=<xsl:value-of select="id" /></xsl:attribute>
                            http://www.youtube.com/watch?v=<xsl:value-of select="id" />
                        </a>
                    </td>
                </tr>
            </xsl:for-each>
        </table>
    </xsl:template>

    <!-- HTML for discography from discogs.xml -->
    <xsl:template name="generateDiscography">
        <ul>
            <xsl:for-each select="$discogs//album">
                <xsl:sort select="year" order="ascending" data-type="number" />
                <li>
                    <strong>
                        <xsl:value-of select="year" />
                        - 
                        <xsl:value-of select="title" />
                        <ul>
                            <xsl:for-each select="./tracks/track">
                                <li>
                                    <strong>
                                        <xsl:value-of select="./text()" />
                                    </strong>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </strong>
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>
    
    <!-- HTML for news from pitchfork.xml -->
    <xsl:template name="generatePitchforkNews">
        <xsl:for-each select="$pitchfork/result/pitchfork//result[position() &lt; 10]">
            <h3>
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="link" />
                    </xsl:attribute>
                    <xsl:value-of select="headline" />                    
                </a>
            </h3>
            <div>
                <strong>
                    <xsl:value-of select="newsdate" />
                </strong>
            </div>
            <div>
                <xsl:value-of select="article" />
            </div>
            <hr/>
        </xsl:for-each>
    </xsl:template>
    
    <!-- HTML for products from cduniverse.xml -->
    <xsl:template name="generateProducts">
        <table class="table table-striped" >
            <xsl:for-each select="$cduniverse/result/cduniverse//result[position() &lt; 10]">
                <tr>
                    <td>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="link" />
                            </xsl:attribute>
                            <img>
                                <xsl:attribute name="src">
                                    <xsl:value-of select="image" />
                                </xsl:attribute>
                            </img>
                        </a>
                    </td>
                    <td>
                        <b>
                            <xsl:value-of select="name" />
                        </b>
                    </td>
                    <td>
                        <xsl:value-of select="description" />
                    </td>
                </tr>
            </xsl:for-each>
        </table>
    </xsl:template>
    
    <!-- HTML for images from flickr.xml -->
    <xsl:template name="generateImages">
        <xsl:for-each select="$flickr//Item">
            <img>
                <xsl:attribute name="src">
                    <xsl:value-of select="Picture" />    
                </xsl:attribute>
                <xsl:attribute name="title">
                    <xsl:value-of select="Author" />    
                </xsl:attribute>
            </img>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>


