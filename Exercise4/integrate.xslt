<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="yes" version="4.0"/>
    
    <!-- Document Sources -->
    <xsl:variable name="flickr" select="document('./flickr.xml')"/>
    <xsl:variable name="discogs" select="document('./discographies.xml')"/>
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
                        <h2>Information for the artist: ARTIST_NAME</h2>
                    </div>
                    
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

    <xsl:template name="generateYoutubeVideos">
		<h2>Youtube:</h2>
        <table class="table table-striped" >
            <xsl:for-each select="$youtube//result">
				<tr>
					<td rowspan="6">
						<a>
							<xsl:attribute name="href">
								http://www.youtube.com/watch?v=<xsl:value-of select="id" />
							</xsl:attribute>
							<img>
								<xsl:attribute name="src">http://i2.ytimg.com/vi/<xsl:value-of select="id" />/mqdefault.jpg</xsl:attribute>
							</img>
						</a>
					</td>
				</tr>
				<tr>
					<td colspan="2"><b><i><xsl:value-of select="title" disable-output-escaping="yes" /></i></b></td>
				</tr>
				<tr>
					<td><b>Time:</b></td>
					<td><xsl:value-of select="time" /></td>
				</tr>
				<tr>
					<td><b>Uploader:</b></td>
					<td>
						<a target="_blank">
							<xsl:attribute name="href">
								http://www.youtube.com/user/<xsl:value-of select="uploader" />
							</xsl:attribute>
							<xsl:value-of select="uploader" />
						</a>
					</td>
				</tr>
				<tr>
					<td><b>Views:</b></td>
					<td><xsl:value-of select="views" /></td>
				</tr>
				<tr>
					<td><b>Link:</b></td>
					<td>
						<a target="_blank">
							<xsl:attribute name="href">
								http://www.youtube.com/watch?v=<xsl:value-of select="id" />
							</xsl:attribute>
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
                    </strong>
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>
    
    <xsl:template name="generateProducts">
    </xsl:template>
    <xsl:template name="generateImages">
    </xsl:template>
    <xsl:template name="generateConcertDates">
    </xsl:template>
</xsl:stylesheet>

