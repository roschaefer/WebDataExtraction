<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                version="1.0">

    <xsl:output method="html" indent="yes" version="4.0"/>
    
    <!-- Document Sources -->
    <xsl:variable name="discogs" select="document('./discogs.xml')"/>
    <xsl:variable name="youtube" select="document('./youtube.xml')"/>
    <xsl:variable name="songkick" select="document('./songkick.xml')"/>
    <xsl:variable name="amazon" select="document('./amazon.xml')"/>
    
    <!-- Main Template: Generates main HTML structure -->
    <xsl:template match="/">

        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html lang="en">
            <head>
                <meta charset="utf-8"></meta>
                <title>Web Data Extraction and Integration - Stage 3</title>
                <link href="http://netdna.bootstrapcdn.com/twitter-bootstrap/2.2.1/css/bootstrap-combined.min.css" rel="stylesheet"></link>
            </head>
            <body>
                <div class="container">
                    
                    <div class="page-header">
                        <h2>Information for the artist: Coldplay</h2>
                    </div>
                    
                    <div class="row">
                        <div class="span12"> 
                            <h2>Discography</h2>
                            <xsl:call-template name="generateDiscography" />  
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="span12"> 
                            <h2>Concert Dates</h2>
                            <xsl:call-template name="generateConcertDates" />  
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="span12"> 
                            <h2>Products on Amazon</h2>
                            <xsl:call-template name="generateProducts" />  
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
                    </strong>
                    (
                    <xsl:value-of select="labels" />)
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>


    <!-- HTML for products from amazon.xml -->
    <xsl:template name="generateProducts">
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>Type</th>
                    <th>Name</th>
                    <th>Price</th>
                </tr>
            </thead>
            <tbody>
                <xsl:for-each select="$amazon//product">
                    <tr>
                        <th>
                            <xsl:value-of select="type"/>
                        </th>
                        <th>
                            <xsl:value-of select="title"/> 
                        </th>
                        <th>
                            <xsl:value-of select="price"/>
                        </th>
                    </tr>
                </xsl:for-each>
            </tbody>
        </table>
    </xsl:template>
    
    <!-- HTML for concert dates from songkick.xml -->
    <xsl:template name="generateConcertDates">
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>Year</th>
                    <th>Date</th>
                    <th>Venue</th>
                </tr>
            </thead>
            <tbody>
                <xsl:for-each select="$songkick//event">
                    <tr>
                        <th>
                            <xsl:value-of select="year"/>
                        </th>
                        <th>
                            <xsl:value-of select="day"/> 
                            - 
                            <xsl:value-of select="month"/> 
                            - 
                            <xsl:value-of select="date"/>
                        </th>
                        <th>
                            <xsl:value-of select="venue"/>
                        </th>
                    </tr>
                </xsl:for-each>
            </tbody>
        </table>
    </xsl:template>
    
    <!-- HTML for videos from youtube.xml -->
    <xsl:template name="generateYoutubeVideos">
        <table class="table table-striped" >
            <xsl:for-each select="$youtube//result">
                <tr>
                    <td rowspan="6">
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
                </tr>
                <tr>
                    <td colspan="2">
                        <b>
                            <i>
                                <xsl:value-of select="title" />
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
                                <xsl:value-of select="user" />
                            </xsl:attribute>
                            <xsl:value-of select="user" />
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
                            <xsl:attribute name="href">
                                <xsl:value-of select="link" />
                            </xsl:attribute>
                            <xsl:value-of select="link" />
                        </a>
                    </td>
                </tr>
            </xsl:for-each>
        </table>
    </xsl:template>
</xsl:stylesheet>


