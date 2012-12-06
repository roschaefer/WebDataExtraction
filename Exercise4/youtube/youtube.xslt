<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" indent="yes" version="4.0"/>

	<xsl:template match="/result">
		<h2>Youtube:</h2>
		<table style="margin: auto;">
			<xsl:for-each select="//youtube/result">
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
</xsl:stylesheet>


