﻿<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" omit-xml-declaration="yes"/>

<xsl:include href="preferences.xsl"/>

<xsl:include href="skin-options.xsl"/>

<xsl:include href="../functions.xsl"/>

<xsl:template match="/">
<xsl:for-each select="details/movie">
<html>
<head>
  <link rel="StyleSheet" type="text/css" href="exportdetails_item_popcorn.css"></link>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <title><xsl:value-of select="title"/></title>
<script type="text/javascript">
var baseFilename = "<xsl:value-of select="/details/movie/baseFilename"/>";
//<![CDATA[
  var title = 1;
  var lnk = 1;
  function lnkt() {
    if ( title == 1 ) title = document.getElementById('title').firstChild;
    if ( lnk == 1 ) lnk = document.getElementById('playLink');
  }
  function show(x) {
    lnkt();
    title.nodeValue = document.getElementById('title'+x).firstChild.nodeValue;
    if(lnk)lnk.setAttribute('HREF', baseFilename + '.playlist' + x + '.jsp');
  }
  function hide() {
    lnkt();
    title.nodeValue = "-";
    if(lnk)lnk.setAttribute('HREF', '');
  }
//]]>
</script>
</head>

<xsl:variable name="star_rating">true</xsl:variable>
<xsl:variable name="full_rating">true</xsl:variable>

<body bgproperties="fixed" background="pictures/background.jpg" onloadset="Play">
<!-- xsl:attribute name="onloadset"><xsl:value-of select="//index[@current='true']/@name"/></xsl:attribute-->

<table class="main" align="center" border="0" cellpadding="0" cellspacing="0">
  <tr height="30">
    <td height="50" align="center" colspan="2">
      <!-- Navigation using remote keys: Home, PageUP/PageDown (Previous/Next) -->
      <a>
        <xsl:attribute name="TVID">HOME</xsl:attribute>
        <xsl:attribute name="href"><xsl:value-of select="$mjb.homePage" />.html</xsl:attribute>
      </a>
      <a TVID="PGDN">
        <xsl:attribute name="href"><xsl:choose><xsl:when
          test="contains(next,'UNKNOWN')"><xsl:value-of select="first" />.html</xsl:when><xsl:otherwise><xsl:value-of
          select="next" />.html</xsl:otherwise></xsl:choose></xsl:attribute>
      </a>
      <a TVID="PGUP">
        <xsl:attribute name="href"><xsl:choose><xsl:when
          test="contains(previous,'UNKNOWN')"><xsl:value-of select="last" />.html</xsl:when><xsl:otherwise><xsl:value-of
          select="previous" />.html</xsl:otherwise></xsl:choose></xsl:attribute>
      </a>
    </td>
  </tr>

  <tr align="right" valign="top">

    <td>
      <table border="0" width="95%" align="right">
        <tr>
          <td class="title1" valign="top" colspan="2" align="right">
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
            <xsl:if test="season != -1">
              <xsl:value-of select="season" /> הנוע 
            </xsl:if>
            <xsl:value-of select="title"/>
          </td>
        </tr>
        <xsl:if test="originalTitle != title">
          <tr>
            <td class="title1sub" valign="top" colspan="4" align="right">
              <xsl:value-of select="originalTitle"/>
            </td>
          </tr>
        </xsl:if>
        <tr>
          <td class="title2" valign="top" align="right">
            <xsl:if test="top250 != -1">
              <xsl:text>&#160;&#160;</xsl:text>#<xsl:value-of select="top250" /> :ץלמומ 
            </xsl:if>
            <xsl:if test="rating != -1">
              <xsl:if test="$full_rating = 'true'">
                <xsl:if test="$star_rating = 'true'">
                   (<xsl:value-of select="rating div 10" />/10)
                </xsl:if>
                <xsl:if test="$star_rating = 'false'">
                  IMDB Rating: <xsl:value-of select="rating div 10" />/10
                </xsl:if>
              </xsl:if>
              <xsl:if test="$star_rating = 'true'">
                <img><xsl:attribute name="src">pictures/rating_<xsl:value-of select="round(rating div 10)*10" />.png</xsl:attribute></img>
              </xsl:if>
            </xsl:if>
          </td>
        </tr>
        <tr>
          <td class="title2" valign="top" colspan="2" align="right"> 
            <xsl:if test="country != 'UNKNOWN'">
              <xsl:text>(</xsl:text>
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
            <xsl:if test="company != 'UNKNOWN'">
              <xsl:value-of select="company" />
              <xsl:if test="director != 'UNKNOWN'"> ,</xsl:if>
            </xsl:if>
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
          </td>
        </tr>

        <xsl:if test="count(cast/actor) != 0">
          <tr>
            <td class="title2" colspan="2" align="right"> 
              <xsl:for-each select="cast/actor[position() &lt;= $actors.max]">
                <xsl:if test="position()!=1"> ,</xsl:if>
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
              </xsl:for-each> םע
            </td>
          </tr>
        </xsl:if>

        <tr>
          <td class="title2" valign="top" colspan="3" align="right">
            <xsl:if test="language != 'UNKNOWN'">
              <xsl:value-of select="language" />
              <xsl:if test="count(genres) != 0 or runtime != 'UNKNOWN' or certification != 'UNKNOWN'"> ,</xsl:if>
            </xsl:if>
            <xsl:if test="certification != 'UNKNOWN'">
              <xsl:value-of select="certification" />
              <xsl:if test="count(genres) != 0 or runtime != 'UNKNOWN'"> ,</xsl:if>
            </xsl:if>
            <xsl:if test="runtime != 'UNKNOWN'">
              <xsl:value-of select="runtime" />
              <xsl:if test="count(genres) != 0"> ,</xsl:if>
            </xsl:if>
            <xsl:if test="count(genres) != 0">
              <xsl:for-each select="genres/genre[position() &lt;= $genres.max]">
                <xsl:if test="position()!= 1"> ,</xsl:if>
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
          </td>
        </tr>

        <tr class="divider"><td colspan="2"><xsl:text> </xsl:text></td></tr>

        <tr>
          <td width="95%" class="normal" colspan="2" align="right">
            <xsl:if test="plot != 'UNKNOWN'">
              <xsl:variable name="plotLinebreakReplaced">
                <xsl:call-template name="string-replace-plot-BR">
                      <xsl:with-param name="text" select='translate(plot,"{}","&lt;&gt;")' />
                </xsl:call-template>
                </xsl:variable>
            
            
              <xsl:value-of disable-output-escaping="yes" select='$plotLinebreakReplaced' />
            </xsl:if>
          </td>
        </tr>

        <tr class="spacer"><td><xsl:text> </xsl:text></td></tr>

        <tr>
          <td colspan="2"><center><table width="95%">
            <tr align="right">
              <td class="normalinfo" width="20%"><xsl:value-of select="videoSource" /></td>
              <td class="title3info" width="10%">רוקמ</td>
              <td class="normalinfo" width="20%">
                <xsl:choose>
                  <xsl:when test="subtitles='YES'">שי</xsl:when>
                  <xsl:when test="subtitles='NO'">ןיא</xsl:when>
                </xsl:choose>
              </td>
              <td class="title3info" width="10%">תויבותכ</td>
            </tr>
            <tr align="right">
              <td class="normalinfo" width="20%"><xsl:value-of select="container" /></td>
              <td class="title3info" width="10%">תכרעמ</td>
              <td class="normalinfo" width="20%"><xsl:value-of select="resolution" /></td>
              <td class="title3info" width="10%">הדרפה</td>
            </tr>
            <tr align="right">
              <td class="normalinfo" width="30%"><xsl:value-of select="videoCodec" /></td>
              <td class="title3info" width="15%">הנומת</td>
              <td class="normalinfo" width="30%"><xsl:value-of select="videoOutput" /></td>
              <td class="title3info" width="15%">טלפ</td>
            </tr>
            <tr align="right">
              <td class="normalinfo" width="30%"><xsl:value-of select="audioCodec" /></td>
              <td class="title3info" width="15%">לוק</td>
              <td class="normalinfo" width="30%"><xsl:value-of select="fps" /></td>
              <td class="title3info" width="15%">הינשל תונומת</td>
            </tr>
            <tr align="right">
              <td class="normalinfo" width="30%" valign="top"><xsl:value-of select="audioChannels" /></td>
              <td class="title3info" width="15%" valign="top">םיצורע</td>
              <td class="normal" width="30%" valign="top">
                <xsl:if test="libraryDescription != 'UNKNOWN'">
                  <xsl:value-of select="libraryDescription" />
                </xsl:if>
              </td>
              <td class="title3info" width="10%" valign="top">
                <xsl:if test="libraryDescription != 'UNKNOWN'">
                  Library
                </xsl:if>
              </td>
            </tr>
          </table></center>
          </td>
        </tr>
        
        <tr class="spacer" colspan="2"><td> </td></tr>

        <xsl:choose>
          <xsl:when test="count(files/file) = 1">
            <xsl:for-each select="files/file">
              <tr valign="top">
                <td align="center">
                  <a class="link">
                    <xsl:attribute name="href"><xsl:value-of select="fileURL" /></xsl:attribute>
                    <xsl:attribute name="TVID">Play</xsl:attribute>
                    <xsl:attribute name="name">Play</xsl:attribute>

                    <xsl:if test="@vod"><xsl:attribute name="vod"><xsl:value-of select="@vod" /></xsl:attribute></xsl:if>
                    <xsl:if test="@zcd"><xsl:attribute name="zcd"><xsl:value-of select="@zcd" /></xsl:attribute></xsl:if>
                    <xsl:if test="@rar"><xsl:attribute name="rar"><xsl:value-of select="@rar" /></xsl:attribute></xsl:if>

                    <xsl:if test="//movie/prebuf != -1">
                      <xsl:attribute name="prebuf"><xsl:value-of select="//movie/prebuf" /></xsl:attribute>
                    </xsl:if>

                    <xsl:choose>
                      <xsl:when test="//movie/season = -1">
                        <img src="pictures/play.png" onfocussrc="pictures/play_selected.png"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:choose>
                          <xsl:when test="@title='UNKNOWN'">
                            <xsl:choose>
                              <xsl:when test="@firstPart!=@lastPart">
                                          קרפ <xsl:value-of select="@firstPart"/> - <xsl:value-of select="@lastPart"/>
                              </xsl:when>
                              <xsl:otherwise>
                                קרפ <xsl:value-of select="@firstPart"/>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:when>
                          <xsl:otherwise><xsl:value-of select="@title"/></xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="//movie/season != -1">
                          .<xsl:if test="@firstPart!=@lastPart">-<xsl:value-of select="@lastPart"/></xsl:if>
                          <xsl:value-of select="@firstPart"/>
                        </xsl:if>
                        <img src="pictures/play_small.png" onfocussrc="pictures/play_selected_small.png" align="top"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </a>
                </td>
              </tr>
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="//movie/container = 'BDAV' and //movie/season = -1">
            <tr>
              <td align="center">
                <a class="link">
                  <xsl:attribute name="href">
                    <xsl:value-of select="concat(/details/movie/baseFilename,'.playlist.jsp')" />
                  </xsl:attribute>
                  <xsl:attribute name="TVID">Play</xsl:attribute>
                  <xsl:attribute name="name">Play</xsl:attribute>

                  <xsl:attribute name="vod">playlist</xsl:attribute>
                  <img src="pictures/play.png" onfocussrc="pictures/play_selected.png"/>
                </a>
              </td>
            </tr>
          </xsl:when>
          <xsl:otherwise>
            <tr>
              <xsl:variable name="episodeSortOrder">
                <xsl:choose>
                  <xsl:when test="$skin-reverseEpisodeOrder='true' and //movie/season != -1">
                    <xsl:text>ascending</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>descending</xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <td>
                <table align="right">
                  <tr align="right" valign="top">
                    <td class="normal">
                      <xsl:for-each select="files/file">
                        <xsl:sort select="@firstPart" data-type="number" order="{$episodeSortOrder}"/>
                        <xsl:if test="position() = 1">
                          <a tvid="Play" vod="playlist">
                            <xsl:attribute name="href"><xsl:value-of select="fileURL" /></xsl:attribute>
                          </a>
                        </xsl:if>
                        <a class="link">
                          <xsl:if test="position() = last()">
                            <xsl:attribute name="class">firstMovie</xsl:attribute>
                          </xsl:if>

                          <xsl:text>&#160;&#160;</xsl:text>
                          <xsl:value-of select="@firstPart"/>
                          <xsl:if test="@firstPart!=@lastPart">-<xsl:value-of select="@lastPart"/>
                          </xsl:if>
                        </a>
                        <a>
                          <xsl:attribute name="href"><xsl:value-of select="fileURL" /></xsl:attribute>
                          <xsl:attribute name="TVID"><xsl:value-of select="@firstPart"/></xsl:attribute>
                          <xsl:attribute name="name">e<xsl:value-of select="position()"/></xsl:attribute>
                          <xsl:attribute name="onkeyleftset">e<xsl:value-of select="position()-1"/></xsl:attribute>
                          <xsl:attribute name="onkeyrightset">e<xsl:value-of select="position()+1"/></xsl:attribute>
                          <xsl:attribute name="onfocus">show(<xsl:value-of select="@firstPart"/>)</xsl:attribute>
                          <xsl:attribute name="onblur">hide()</xsl:attribute>

                          <xsl:if test="@vod"><xsl:attribute name="vod"><xsl:value-of select="@vod" /></xsl:attribute></xsl:if>
                          <xsl:if test="@zcd"><xsl:attribute name="zcd"><xsl:value-of select="@zcd" /></xsl:attribute></xsl:if>
                          <xsl:if test="@rar"><xsl:attribute name="rar"><xsl:value-of select="@rar" /></xsl:attribute></xsl:if>

                          <xsl:if test="//movie/prebuf != -1">
                            <xsl:attribute name="prebuf"><xsl:value-of select="//movie/prebuf" /></xsl:attribute>
                          </xsl:if>

                          <xsl:if test="position() = last()">
                            <xsl:attribute name="name">Play</xsl:attribute>
                          </xsl:if>

                          <img src="pictures/play_small.png" onfocussrc="pictures/play_selected_small.png" align="top">
                            <xsl:attribute name="onmouseover">show(<xsl:value-of select="@firstPart"/>);</xsl:attribute>
                            <xsl:attribute name="onmouseout">hide();</xsl:attribute>
                          </img>
                        </a>
                      </xsl:for-each>
                    </td>
                  </tr>
                  <tr align="right">
                    <td class="normal">
                      <div id="title">&#160; </div>
                      <a class="link">
                        <xsl:attribute name="onfocus">hide()</xsl:attribute>
                        <xsl:attribute name="href"><xsl:value-of select="concat(/details/movie/baseFilename,'.playlist.jsp')" /></xsl:attribute>
                        <xsl:attribute name="vod">playlist</xsl:attribute>
                        <xsl:if test="//movie/prebuf != -1">
                           <xsl:attribute name="prebuf"><xsl:value-of select="//movie/prebuf" /></xsl:attribute>
                        </xsl:if>
                        <xsl:text>&#160;</xsl:text>לכה ןגנ
                        <img src="pictures/play_small.png" onfocussrc="pictures/play_selected_small.png" align="top"/>
                      </a>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
          </xsl:otherwise>
        </xsl:choose>
        
        <xsl:if test="count(extras) != 0">
          <tr>
            <td>
              <table align="right">
                <tr><td class="title2" align="right">םינומידק</td></tr>
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

                        <xsl:value-of select="@title"/>
                        <xsl:text>&#160;</xsl:text>
                        <img src="pictures/play_small.png" onfocussrc="pictures/play_selected_small.png" align="top"/>
                      </a>
                    </td>
                  </tr>
                </xsl:for-each>
              </table>
            </td>
          </tr>
        </xsl:if>

      </table>

      <xsl:for-each select="files/file">
        <div class="title">
          <xsl:attribute name="id">title<xsl:value-of select="@firstPart" /></xsl:attribute>
          <xsl:choose>
            <xsl:when test="@title='UNKNOWN'">
              <xsl:choose>
                <xsl:when test="@firstPart!=@lastPart">
                  <xsl:value-of select="@firstPart" /> - <xsl:value-of select="@lastPart" />
                  <xsl:choose>
                    <xsl:when test="/details/movie/season != -1"> םיקרפ</xsl:when>
                    <xsl:otherwise> םיקלח</xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="@firstPart" />
                  <xsl:choose>
                    <xsl:when test="/details/movie/season != -1"> קרפ</xsl:when>
                    <xsl:otherwise> קלח</xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:value-of select="@part" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@title" />
              <xsl:if test="@firstPart!=@lastPart"> - <xsl:value-of select="@lastPart" /></xsl:if>.
              <xsl:value-of select="@firstPart" />
            </xsl:otherwise>
          </xsl:choose>
        </div>
      </xsl:for-each>
    </td>
    <td width="420px">
      <img width="400">
        <xsl:attribute name="src">
          <xsl:value-of select="detailPosterFile" />
        </xsl:attribute>
      </img>
    </td>

  </tr>
</table>
<!--  
<xsl:if test="count(sets/set) > 0">
  <div align="center">
    <table width="80%">
      <tr>
        <td class="title2" align="center" width="30%">
          <xsl:attribute name="colspan"><xsl:value-of select="count(sets/set)" /></xsl:attribute>
          <img src="pictures/set.png" align="middle" />Sets
        </td>
        <xsl:for-each select="sets/set">
          <td class="normal">
            <a>
            <xsl:attribute name="href"><xsl:value-of select="@index" />.html</xsl:attribute>
              <img align="top">
                <xsl:attribute name="src"><xsl:value-of select="@index" />_small.png</xsl:attribute>
              </img>
            </a>
          </td>
        </xsl:for-each>
      </tr>
    </table>
  </div>
</xsl:if>
-->
</body>
</html>
</xsl:for-each>
</xsl:template>

</xsl:stylesheet>
