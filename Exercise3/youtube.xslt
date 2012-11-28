<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="/youtube">
		<h2>Youtube:</h2>
		<table style="margin: auto;">
			<xsl:for-each select="//youtube/result">
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
					<td colspan="2"><b><i><xsl:value-of select="title" /></i></b></td>
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
								http://www.youtube.com/user/<xsl:value-of select="user" />
							</xsl:attribute>
							<xsl:value-of select="user" />
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


