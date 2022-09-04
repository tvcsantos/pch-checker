<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" omit-xml-declaration="yes"/>

<xsl:include href="preferences.xsl"/>

<xsl:include href="skin-options.xsl"/>

<xsl:include href="../functions.xsl"/>

<xsl:template match="details/preferences"></xsl:template>

<xsl:template match="details/movie">
<html>
<head>
  <link rel="StyleSheet" type="text/css" href="exportdetails_item_popcorn.css"></link>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <title><xsl:value-of select="title"/></title>
</head>

<body bgproperties="fixed" background="pictures/background.jpg" onloadset="1">

<table class="main" align="center" border="0" cellpadding="0" cellspacing="0">

  <tr height="30">
    <td height="50" align="center" colspan="2">
      <!-- Navigation using remote keys: Home, PageUP/PageDown (Previous/Next) -->
      <a><xsl:attribute name="TVID">HOME</xsl:attribute><xsl:attribute name="href"><xsl:value-of select="$mjb.homePage"/>.html</xsl:attribute></a>

      <a><xsl:attribute name="TVID">PGDN</xsl:attribute><xsl:attribute name="href"><xsl:choose><xsl:when test="contains(next,'UNKNOWN')"><xsl:value-of select="first"/>.html</xsl:when><xsl:otherwise><xsl:value-of select="next"/>.html</xsl:otherwise></xsl:choose></xsl:attribute></a>
      <a><xsl:attribute name="TVID">PGUP</xsl:attribute><xsl:attribute name="href"><xsl:choose><xsl:when test="contains(previous,'UNKNOWN')"><xsl:value-of select="$mjb.homePage"/>.html</xsl:when><xsl:otherwise><xsl:value-of select="last"/>.html</xsl:otherwise></xsl:choose></xsl:attribute></a>
    </td>
  </tr>

  <tr align="left" valign="top">
    <td width="420px">
       <img width="400"><xsl:attribute name="src"><xsl:value-of select="detailPosterFile" /></xsl:attribute></img>
    </td>

    <td>
      <table border="0">
        <tr>
          <td class="title1" valign="top" colspan="2">
            <xsl:choose>
            <xsl:when test="season &gt; 0">&quot;<xsl:value-of select="title"/>&quot; Season <xsl:value-of select="season" /></xsl:when>
            <xsl:when test="season = 0">&quot;<xsl:value-of select="title"/>&quot; Specials</xsl:when>
            <xsl:otherwise><xsl:value-of select="title"/></xsl:otherwise>
            </xsl:choose>
            <xsl:if test="year != 'UNKNOWN'">
              <xsl:text> (</xsl:text>
              <xsl:choose>
                <xsl:when test="year/@index != ''">
                  <a>
                    <xsl:attribute name="href"><xsl:value-of select="year/@index" />.html</xsl:attribute>
                    <xsl:value-of select="year" />
                  </a>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="year" />
                </xsl:otherwise>
              </xsl:choose>
              <xsl:text>) </xsl:text>
            </xsl:if>
          </td>
        </tr>
        <tr>
          <td class="title2" colspan="2">
            <xsl:if test="rating != -1">
              <img><xsl:attribute name="src">pictures/rating_<xsl:value-of select="round(rating div 10)*10" />.png</xsl:attribute></img>
            </xsl:if>
            <xsl:if test="top250 != -1">
                <xsl:text>&#160;&#160;</xsl:text>Top 250: #<xsl:value-of select="top250" />
            </xsl:if>
          </td>
        </tr>
        <tr>
          <td class="title2" valign="top" colspan="2">
            <xsl:if test="director != 'UNKNOWN'">
              <xsl:choose>
                <xsl:when test="director/@index != ''">
                  <a>
                    <xsl:attribute name="href"><xsl:value-of select="director/@index" />.html</xsl:attribute>
                    <xsl:value-of select="director" /> 
                  </a>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="director" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:if test="company != 'UNKNOWN'">
              <xsl:if test="director != 'UNKNOWN'">, </xsl:if>
              <xsl:value-of select="company" />
            </xsl:if>
            <xsl:if test="country != 'UNKNOWN'">
              <xsl:text> (</xsl:text>
              <xsl:choose>
                <xsl:when test="country != 'UNKNOWN' and country/@index != ''">
                  <a>
                    <xsl:attribute name="href"><xsl:value-of select="country/@index" />.html</xsl:attribute>
                    <xsl:value-of select="country" />
                  </a>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="country" />
                </xsl:otherwise>
              </xsl:choose>
              <xsl:text>) </xsl:text>
            </xsl:if>
          </td>
        </tr>

        <tr>
          <td class="title2" valign="top" colspan="2">
            <xsl:if test="count(genres) != 0">
              <xsl:for-each select="genres/genre[position() &lt;= $genres.max]">
                <xsl:if test="position()!= 1">, </xsl:if>
                <xsl:choose>
                  <xsl:when test="@index != ''">
                    <a>
                      <xsl:attribute name="href"><xsl:value-of select="@index" />.html</xsl:attribute>
                      <xsl:value-of select="." /> 
                    </a>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="." /> 
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </xsl:if>
            <xsl:if test="runtime != 'UNKNOWN'">
              <xsl:if test="count(genres) != 0">, </xsl:if>
              <xsl:value-of select="runtime" />
            </xsl:if>
            <xsl:if test="certification != 'UNKNOWN'">
              <xsl:if test="count(genres) != 0 or runtime != 'UNKNOWN'">, </xsl:if>
                <a>
                  <xsl:attribute name="href">Rating_<xsl:value-of select="certification" />_1.html</xsl:attribute>
                  <xsl:value-of select="certification" />
                </a>
            </xsl:if>
            <xsl:if test="language != 'UNKNOWN'">
              <xsl:if test="count(genres) != 0 or runtime != 'UNKNOWN' or certification != 'UNKNOWN'">, </xsl:if>
              <xsl:value-of select="language" />
            </xsl:if>
          </td>
        </tr>

        <xsl:if test="libraryDescription != 'UNKNOWN'">
          <tr>
            <td class="title2" valign="top" colspan="2">
              Library:
              <xsl:value-of select="libraryDescription" />
            </td>
          </tr>
        </xsl:if>

        <tr class="divider"><td colspan="2" /></tr>

        <xsl:if test="plot != 'UNKNOWN'">
          <tr class="spacer"><td colspan="2" /></tr>
          <tr>
            <td class="normal" colspan="2">
                <xsl:variable name="plotTruncated">
                  <xsl:choose>
                    <xsl:when test="string-length(plot)&lt;350">
                      <xsl:value-of select="plot"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="substring(plot,1,346)"/>...
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
  
                <xsl:call-template name="string-replace-plot-BR">
                      <xsl:with-param name="text" select='$plotTruncated' />
                </xsl:call-template>
            </td>
          </tr>
        </xsl:if>

        <xsl:if test="count(cast/actor)!=0">
          <tr class="spacer"><td colspan="2" /></tr>
          <tr><td class="title2" colspan="2">Cast</td></tr>
          <tr>
            <td class="normal" colspan="2">
              <xsl:for-each select="cast/actor[position() &lt;= $actors.max]">
                <xsl:if test="position()!=1">, </xsl:if>
                <xsl:choose>
                  <xsl:when test="@index != ''">
                    <a>
                      <xsl:attribute name="href"><xsl:value-of select="@index" />.html</xsl:attribute>
                      <xsl:value-of select="." /> 
                    </a>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="." /> 
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </td>
          </tr>
        </xsl:if>
        <tr class="spacer"><td colspan="2" /></tr>

        <xsl:variable name="episodeSortOrder" select="if ($skin-reverseEpisodeOrder='true' and /details/movie/season != -1) then 'descending' else 'ascending'" />
        <xsl:choose>
          <xsl:when test="count(files/file) = 1">
            <xsl:for-each select="files/file">
              <tr valign="top">
                <xsl:if test="//movie/season != -1">
                  <td align="right" class="normal">
                    <xsl:value-of select="@firstPart"/><xsl:if test="@firstPart!=@lastPart">-<xsl:value-of select="@lastPart"/></xsl:if>.
                  </td>
                </xsl:if>
                <td align="center">
                  <a class="normal">
                    <xsl:attribute name="href"><xsl:value-of select="fileURL" /></xsl:attribute>
                    <xsl:attribute name="TVID">Play</xsl:attribute>
                    <xsl:attribute name="name">1</xsl:attribute>

                    <xsl:if test="@vod"><xsl:attribute name="vod"><xsl:value-of select="@vod" /></xsl:attribute></xsl:if>
                    <xsl:if test="@zcd"><xsl:attribute name="zcd"><xsl:value-of select="@zcd" /></xsl:attribute></xsl:if>
                    <xsl:if test="@rar"><xsl:attribute name="rar"><xsl:value-of select="@rar" /></xsl:attribute></xsl:if>

                    <xsl:if test="//movie/prebuf != -1">
                      <xsl:attribute name="prebuf"><xsl:value-of select="//movie/prebuf" /></xsl:attribute>
                    </xsl:if>

                    <xsl:choose>
                      <xsl:when test="//movie/season = -1">
                        <img src="pictures/play.png" onfocussrc="pictures/play_selected.png">
                          <xsl:attribute name="onmouseover">this.src='pictures/play_selected.png';</xsl:attribute>
                          <xsl:attribute name="onmouseout">this.src='pictures/play.png';</xsl:attribute>
                        </img>
                      </xsl:when>
                      <xsl:otherwise>
                        <img src="pictures/play_small.png" onfocussrc="pictures/play_selected_small.png" align="middle">
                          <xsl:attribute name="onmouseover">this.src='pictures/play_selected_small.png';</xsl:attribute>
                          <xsl:attribute name="onmouseout">this.src='pictures/play_small.png';</xsl:attribute>
                        </img>
                        <xsl:text>&#160;</xsl:text>

                        <xsl:choose>
                          <xsl:when test="@title='UNKNOWN'">
                            <xsl:choose>
                              <xsl:when test="@firstPart!=@lastPart">
                                Episodes <xsl:value-of select="@firstPart"/> - <xsl:value-of select="@lastPart"/>
                              </xsl:when>
                              <xsl:otherwise>
                                Episode <xsl:value-of select="@firstPart"/>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:when>
                          <xsl:otherwise><xsl:value-of select="@title"/></xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                  </a>
                </td>
              </tr>
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="//movie/container = 'BDAV' and //movie/season = -1">
            <tr valign="top">
              <td>
                <center>
                  <a class="link">
                    <xsl:attribute name="href">
                      <xsl:value-of select="concat(/details/movie/baseFilename,'.playlist.jsp')" />
                    </xsl:attribute>
                    <xsl:attribute name="TVID">Play</xsl:attribute>
                    <xsl:attribute name="name">1</xsl:attribute>

                    <xsl:attribute name="vod">playlist</xsl:attribute>
                    <img src="pictures/play.png" onfocussrc="pictures/play_selected.png">
                      <xsl:attribute name="onmouseover">this.src='pictures/play_selected.png';</xsl:attribute>
                      <xsl:attribute name="onmouseout">this.src='pictures/play.png';</xsl:attribute>
                    </img>
                  </a>
                </center>
              </td>
            </tr>
          </xsl:when>
          <xsl:otherwise>
            <tr>
              <td>
                <table>
                  <xsl:if test="($skin-playAllMovie = 'top' and /details/movie/season = -1) or ($skin-playAllTV = 'top' and /details/movie/season != -1)">
                    <tr valign="top">
                      <td>&#160;</td>
                      <td class="normal">
                        <a class="link" TVID="PLAY">
                          <xsl:attribute name="href"><xsl:value-of select="concat(/details/movie/baseFilename,'.playlist.jsp')" /></xsl:attribute>
                          <xsl:attribute name="vod">playlist</xsl:attribute>
                          <xsl:if test="//movie/prebuf != -1">
                            <xsl:attribute name="prebuf"><xsl:value-of select="//movie/prebuf" /></xsl:attribute>
                          </xsl:if>
                          <img src="pictures/play_small.png" onfocussrc="pictures/play_selected_small.png" align="middle"/>
                          <xsl:text>&#160;</xsl:text><xsl:value-of select="$skin-playAllText" />
                        </a>
                      </td>
                    </tr>
                  </xsl:if>
                  <xsl:for-each select="files/file">
                    <xsl:sort select="@firstPart" data-type="number" order="{$episodeSortOrder}"/>
                    <tr valign="top">
                      <td align="right" class="normal">
                        <xsl:value-of select="@firstPart"/><xsl:if test="@firstPart!=@lastPart">-<xsl:value-of select="@lastPart"/></xsl:if>.
                      </td>
                      <td class="normal">
                        <a>
                          <xsl:attribute name="name"><xsl:value-of select="position()" /></xsl:attribute>
                          <xsl:attribute name="href"><xsl:value-of select="fileURL" /></xsl:attribute>

                          <xsl:attribute name="TVID"><xsl:value-of select="@firstPart"/></xsl:attribute>

                          <xsl:if test="@vod"><xsl:attribute name="vod"><xsl:value-of select="@vod" /></xsl:attribute></xsl:if>
                          <xsl:if test="@zcd"><xsl:attribute name="zcd"><xsl:value-of select="@zcd" /></xsl:attribute></xsl:if>
                          <xsl:if test="@rar"><xsl:attribute name="rar"><xsl:value-of select="@rar" /></xsl:attribute></xsl:if>

                          <xsl:if test="//movie/prebuf != -1">
                            <xsl:attribute name="prebuf"><xsl:value-of select="//movie/prebuf" /></xsl:attribute>
                          </xsl:if>

                          <img src="pictures/play_small.png" onfocussrc="pictures/play_selected_small.png" align="middle">
                            <xsl:attribute name="onmouseover">this.src='pictures/play_selected_small.png';</xsl:attribute>
                            <xsl:attribute name="onmouseout">this.src='pictures/play_small.png';</xsl:attribute>
                          </img>
                          <xsl:text>&#160;</xsl:text>

                          <xsl:choose>
                            <xsl:when test="@title='UNKNOWN'">
                              <xsl:choose>
                                <xsl:when test="@firstPart!=@lastPart">
                                  <xsl:choose>
                                    <xsl:when test="/details/movie/season != -1">Episodes </xsl:when>
                                    <xsl:otherwise>Parts </xsl:otherwise>
                                  </xsl:choose>
                                  <xsl:value-of select="@firstPart"/> - <xsl:value-of select="@lastPart"/>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:choose>
                                    <xsl:when test="/details/movie/season != -1">Episode </xsl:when>
                                    <xsl:otherwise>Part </xsl:otherwise>
                                  </xsl:choose>
                                  <xsl:value-of select="@firstPart"/>
                                </xsl:otherwise>
                              </xsl:choose>
                              <xsl:value-of select="@part"/>
                            </xsl:when>
                            <xsl:otherwise><xsl:value-of select="@title"/></xsl:otherwise>
                          </xsl:choose>
                        </a>
                      </td>
                    </tr>
                  </xsl:for-each>
                  <xsl:if test="($skin-playAllMovie = 'bottom' and /details/movie/season = -1) or ($skin-playAllTV = 'bottom' and /details/movie/season != -1)">
                    <tr valign="top">
                      <td>&#160;</td>
                      <td class="normal">
                        <a class="link" TVID="PLAY">
                          <xsl:attribute name="href"><xsl:value-of select="concat(/details/movie/baseFilename,'.playlist.jsp')" /></xsl:attribute>
                          <xsl:attribute name="vod">playlist</xsl:attribute>
                          <xsl:if test="//movie/prebuf != -1">
                            <xsl:attribute name="prebuf"><xsl:value-of select="//movie/prebuf" /></xsl:attribute>
                          </xsl:if>
                          <img src="pictures/play_small.png" onfocussrc="pictures/play_selected_small.png" align="middle"/>
                          <xsl:text>&#160;</xsl:text><xsl:value-of select="$skin-playAllText" />
                        </a>
                      </td>
                    </tr>
                  </xsl:if>
                </table>
              </td>
            </tr>
          </xsl:otherwise>
        </xsl:choose>

        <xsl:if test="count(extras) != 0">
          <tr>
            <td>
              <table>
                <tr><td class="title2">Extras</td></tr>
                <xsl:for-each select="extras/extra">
                  <tr>
                    <td class="normal">
                      <a>
                        <xsl:attribute name="href"><xsl:value-of select="." /></xsl:attribute>

                        <xsl:if test="@vod"><xsl:attribute name="vod"><xsl:value-of select="@vod" /></xsl:attribute></xsl:if>
                        <xsl:if test="@zcd"><xsl:attribute name="zcd"><xsl:value-of select="@zcd" /></xsl:attribute></xsl:if>
                        <xsl:if test="@rar"><xsl:attribute name="rar"><xsl:value-of select="@rar" /></xsl:attribute></xsl:if>

                        <xsl:if test="//movie/prebuf != -1">
                          <xsl:attribute name="prebuf"><xsl:value-of select="//movie/prebuf" /></xsl:attribute>
                        </xsl:if>

                        <img src="pictures/play_small.png" onfocussrc="pictures/play_selected_small.png" align="top">
                          <xsl:attribute name="onmouseover">this.src='pictures/play_selected_small.png';</xsl:attribute>
                          <xsl:attribute name="onmouseout">this.src='pictures/play_small.png';</xsl:attribute>
                        </img>
                        <xsl:text>&#160;</xsl:text>
                        <xsl:value-of select="@title"/>
                      </a>
                    </td>
                  </tr>
                </xsl:for-each>
              </table>
            </td>
          </tr>
        </xsl:if>
      </table>
    </td>
  </tr>
</table>
</body>
</html>
</xsl:template>
</xsl:stylesheet>
