> ⚠️ **Warning:** section=1|**WARNING**: [Ore UI](ore-ui.md#warning) does not support formatting codes.<ref>{{tweet|Volgar|1867216296821370992|It probably won't be supported in the new screens, but it certainly shouldn't look like this, just plain text. Thanks, I'll pass it to the team.</ref><ref>{{bug|MCPE-174371|MCPE-174371|The new "Play screen" UI doesn't support colored characters|WAI}}</ref><ref>{{bug|MCPE-152246|MCPE-152246|New Create New World UI doesn't support text formatting codes|WAI}}</ref>}}
> _About: the legacy §-based formatting system|the modern system|Text component format_

![200px|A book showing the possible formatting options with the character that performs them.](Minecraft Formatting.gif)

**Formatting codes** (also known as **color codes**) add color and modifications to text in-game. They are deprecated and will be removed in the future.<ref>https://bugs.mojang.com/browse/MC-190605</ref>

Text in *Minecraft* can be formatted with the {{w|section sign}} (`§`). {{IN|bedrock}}, the section sign can be used in [sign](sign.md)s, world names, [book and quill](book-and-quill.md)s, [anvil](anvil.md)s and [cartography table](cartography-table.md)s (to rename items and maps), and in the [chat](chat.md) input field (including in commands such as `/say` and `/title`). {{IN|java}}, section signs may be used in <samp>[server.properties](server.properties.md)</samp>, <samp>[pack.mcmeta](pack.mcmeta.md)</samp>, <samp>[splashes.txt](splash.md)</samp>, [language](language.md) files, world titles, commands (such as `/tellraw` and `/title`) in [data pack](data-pack.md)s, and server names. [External programs](programs-and-editors.md) can be used to insert it in other locations.

## Usage
Text can be formatted using the section sign (§) followed by a character. A § symbol followed by a hex digit in the message tells the client to switch colors while displaying text. {{IN|bedrock}}, the § symbol can be used in any text input, while {{in|java}}, it may be used in <samp>[server.properties](server.properties.md)</samp>, <samp>[pack.mcmeta](pack.mcmeta.md)</samp>, [language](language.md) files, world titles, commands (such as `/tellraw` and `/title`) in [datapacks](datapacks.md), and server names.

### *Java Edition*
If a color code is used after a formatting code, the formatting code is disabled beyond the color code point. For example, `§cX§nY` displays as <span class="format-c" style="font-family: Minecraft;">X<u>Y</u></span>, whereas `§nX§cY` displays as <span class="format-f" style="font-family: Minecraft"><u>X</u><span class="format-c">Y</span></span>. Therefore, when using a color code in tandem with a formatting code, ensure the color code is used first and reuse the formatting code when changing colors. Also, you could put `§r§f` in an anvil to rename an item as non-italic.

### *Bedrock Edition*
> ⚠️ **Warning:** section=1|**WARNING**: [Ore UI](ore-ui.md#warning) does not support color codes.<ref>{{tweet|Volgar|1867216296821370992|It probably won't be supported in the new screens, but it certainly shouldn't look like this, just plain text. Thanks, I'll pass it to the team.</ref><ref>{{bug|MCPE-174371|MCPE-174371|The new "Play screen" UI doesn't support colored characters|WAI}}</ref><ref>{{bug|MCPE-152246|MCPE-152246|New Create New World UI doesn't support text formatting codes|WAI}}</ref>}}

Formatting codes persist after a color code. Furthermore, if an obfuscated code is used and a reset code is not used before the end of the line, the client GUI continues to obfuscate text past the MOTD and into the version number display.
![400px](Motd scramble bug.png)

### Color codes
![x516px|Hex digit to color mapping. Use "§" followed by the corresponding color letter/number; e.g. "§e" gives yellow.](ColorsUpdated.png)
Messages sent from the server to the client can contain color codes, which allow the coloring of text for various purposes.

<table class="wikitable">
  <tbody>
    <tr>
      <th>rowspan=2 | Code</th>
      <th>rowspan=2 | Name</th>
      <th>colspan=4 | Foreground color</th>
      <th>colspan=4 | Background color</th>
      <th>rowspan=2 | Equivalent [ANSI escape code](wikipedia-ansi_escape_code.md#sgrselectgraphicrenditionparameters)</th>
      <th>rowspan=2 | Version</th>
    </tr>
    <tr>
      <th>R</th>
      <th>G</th>
      <th>B</th>
      <th><abbr title="Hexadecimal color code">Hex</abbr></th>
      <th>R</th>
      <th>G</th>
      <th>B</th>
      <th><abbr title="Hexadecimal color code">Hex</abbr></th>
    </tr>
    <tr>
      <td>§0</td>
      <td>black</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>{{color|#000000}}</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>{{color|#000000}}</td>
      <td>`\e[0;30m`</td>
      <td></td>
    </tr>
    <tr>
      <td>§1</td>
      <td>dark_blue</td>
      <td>0</td>
      <td>0</td>
      <td>170</td>
      <td>{{color|#0000AA}}</td>
      <td>0</td>
      <td>0</td>
      <td>42</td>
      <td>{{color|#00002A}}</td>
      <td>`\e[0;34m`</td>
      <td></td>
    </tr>
    <tr>
      <td>§2</td>
      <td>dark_green</td>
      <td>0</td>
      <td>170</td>
      <td>0</td>
      <td>{{color|#00AA00}}</td>
      <td>0</td>
      <td>42</td>
      <td>0</td>
      <td>{{color|#002A00}}</td>
      <td>`\e[0;32m`</td>
      <td></td>
    </tr>
    <tr>
      <td>§3</td>
      <td>dark_aqua</td>
      <td>0</td>
      <td>170</td>
      <td>170</td>
      <td>{{color|#00AAAA}}</td>
      <td>0</td>
      <td>42</td>
      <td>42</td>
      <td>{{color|#002A2A}}</td>
      <td>`\e[0;36m`</td>
      <td></td>
    </tr>
    <tr>
      <td>§4</td>
      <td>dark_red</td>
      <td>170</td>
      <td>0</td>
      <td>0</td>
      <td>{{color|#AA0000}}</td>
      <td>42</td>
      <td>0</td>
      <td>0</td>
      <td>{{color|#2A0000}}</td>
      <td>`\e[0;31m`</td>
      <td></td>
    </tr>
    <tr>
      <td>§5</td>
      <td>dark_purple</td>
      <td>170</td>
      <td>0</td>
      <td>170</td>
      <td>{{color|#AA00AA}}</td>
      <td>42</td>
      <td>0</td>
      <td>42</td>
      <td>{{color|#2A002A}}</td>
      <td>`\e[0;35m`</td>
      <td></td>
    </tr>
    <tr>
      <td>§6</td>
      <td>gold</td>
      <td>255</td>
      <td>170</td>
      <td>0</td>
      <td>{{color|#FFAA00}}</td>
      <td>64</td>
      <td>42</td>
      <td>0</td>
      <td>{{color|#3E2A00}}</td>
      <td>`\e[0;33m`</td>
      <td></td>
    </tr>
    <tr>
      <td>rowspan=2 | §7</td>
      <td>rowspan=2 | gray</td>
      <td>170</td>
      <td>170</td>
      <td>170</td>
      <td>{{color|#AAAAAA}}</td>
      <td>42</td>
      <td>42</td>
      <td>42</td>
      <td>{{color|#2A2A2A}}</td>
      <td>rowspan=2 | `\e[0;37m`</td>
      <td>{{only|je|short=1}}</td>
    </tr>
    <tr>
      <td>198</td>
      <td>198</td>
      <td>198</td>
      <td>{{color|#C6C6C6}}</td>
      <td>49</td>
      <td>49</td>
      <td>49</td>
      <td>{{color|#313131}}</td>
      <td>{{only|be|short=1}}</td>
    </tr>
    <tr>
      <td>§8</td>
      <td>dark_gray</td>
      <td>85</td>
      <td>85</td>
      <td>85</td>
      <td>{{color|#555555}}</td>
      <td>21</td>
      <td>21</td>
      <td>21</td>
      <td>{{color|#151515}}</td>
      <td>`\e[0;90m`</td>
      <td></td>
    </tr>
    <tr>
      <td>§9</td>
      <td>blue</td>
      <td>85</td>
      <td>85</td>
      <td>255</td>
      <td>{{color|#5555FF}}</td>
      <td>21</td>
      <td>21</td>
      <td>63</td>
      <td>{{color|#15153F}}</td>
      <td>`\e[0;94m`</td>
      <td></td>
    </tr>
    <tr>
      <td>§a</td>
      <td>green</td>
      <td>85</td>
      <td>255</td>
      <td>85</td>
      <td>{{color|#55FF55}}</td>
      <td>21</td>
      <td>63</td>
      <td>21</td>
      <td>{{color|#153F15}}</td>
      <td>`\e[0;92m`</td>
      <td></td>
    </tr>
    <tr>
      <td>§b</td>
      <td>aqua</td>
      <td>85</td>
      <td>255</td>
      <td>255</td>
      <td>{{color|#55FFFF}}</td>
      <td>21</td>
      <td>63</td>
      <td>63</td>
      <td>{{color|#153F3F}}</td>
      <td>`\e[0;96m`</td>
      <td></td>
    </tr>
    <tr>
      <td>§c</td>
      <td>red</td>
      <td>255</td>
      <td>85</td>
      <td>85</td>
      <td>{{color|#FF5555}}</td>
      <td>63</td>
      <td>21</td>
      <td>21</td>
      <td>{{color|#3F1515}}</td>
      <td>`\e[0;91m`</td>
      <td></td>
      <td>- <!--Do not change "Light Purple" to "Pink", it is the in game name --></td>
      <td>§d</td>
      <td>light_purple</td>
      <td>255</td>
      <td>85</td>
      <td>255</td>
      <td>{{color|#FF55FF}}</td>
      <td>63</td>
      <td>21</td>
      <td>63</td>
      <td>{{color|#3F153F}}</td>
      <td>`\e[0;95m`</td>
      <td></td>
    </tr>
    <tr>
      <td>§e</td>
      <td>yellow</td>
      <td>255</td>
      <td>255</td>
      <td>85</td>
      <td>{{color|#FFFF55}}</td>
      <td>63</td>
      <td>63</td>
      <td>21</td>
      <td>{{color|#3F3F15}}</td>
      <td>`\e[0;93m`</td>
      <td></td>
    </tr>
    <tr>
      <td>§f</td>
      <td>white</td>
      <td>255</td>
      <td>255</td>
      <td>255</td>
      <td>{{color|#FFFFFF}}</td>
      <td>63</td>
      <td>63</td>
      <td>63</td>
      <td>{{color|#3F3F3F}}</td>
      <td>`\e[0;97m`</td>
      <td></td>
    </tr>
    <tr>
      <td>§g</td>
      <td>minecoin_gold</td>
      <td>221</td>
      <td>214</td>
      <td>5</td>
      <td>{{color|#DDD605}}</td>
      <td>55</td>
      <td>53</td>
      <td>1</td>
      <td>{{color|#373501}}</td>
      <td>&mdash;</td>
      <td>{{only|be|short=1}}</td>
    </tr>
    <tr>
      <td>§h</td>
      <td>material_quartz</td>
      <td>227</td>
      <td>212</td>
      <td>209</td>
      <td>{{color|#E3D4D1}}</td>
      <td>56</td>
      <td>53</td>
      <td>52</td>
      <td>{{color|#383534}}</td>
      <td>&mdash;</td>
      <td>{{only|be|short=1}}</td>
    </tr>
    <tr>
      <td>§i</td>
      <td>material_iron</td>
      <td>206</td>
      <td>202</td>
      <td>202</td>
      <td>{{color|#CECACA}}</td>
      <td>51</td>
      <td>50</td>
      <td>50</td>
      <td>{{color|#333232}}</td>
      <td>&mdash;</td>
      <td>{{only|be|short=1}}</td>
    </tr>
    <tr>
      <td>§j</td>
      <td>material_netherite</td>
      <td>68</td>
      <td>58</td>
      <td>59</td>
      <td>{{color|#443A3B}}</td>
      <td>17</td>
      <td>14</td>
      <td>14</td>
      <td>{{color|#110E0E}}</td>
      <td>&mdash;</td>
      <td>{{only|be|short=1}}</td>
    </tr>
    <tr>
      <td>§m</td>
      <td>material_redstone</td>
      <td>151</td>
      <td>22</td>
      <td>7</td>
      <td>{{color|#971607}}</td>
      <td>37</td>
      <td>5</td>
      <td>1</td>
      <td>{{color|#250501}}</td>
      <td>&mdash;</td>
      <td>{{only|be|short=1}}</td>
    </tr>
    <tr>
      <td>§n</td>
      <td>material_copper</td>
      <td>180</td>
      <td>104</td>
      <td>77</td>
      <td>{{color|#B4684D}}</td>
      <td>45</td>
      <td>26</td>
      <td>19</td>
      <td>{{color|#2D1A13}}</td>
      <td>&mdash;</td>
      <td>{{only|be|short=1}}</td>
    </tr>
    <tr>
      <td>§p</td>
      <td>material_gold</td>
      <td>222</td>
      <td>177</td>
      <td>45</td>
      <td>{{color|#DEB12D}}</td>
      <td>55</td>
      <td>44</td>
      <td>11</td>
      <td>{{color|#372C0B}}</td>
      <td>&mdash;</td>
      <td>{{only|be|short=1}}</td>
    </tr>
    <tr>
      <td>§q</td>
      <td>material_emerald</td>
      <td>17</td>
      <td>159</td>
      <td>54</td>
      <td>{{color|#119F36}}</td>
      <td>4</td>
      <td>40</td>
      <td>13</td>
      <td>{{color|#04280D}}</td>
      <td>&mdash;</td>
      <td>{{only|be|short=1}}</td>
    </tr>
    <tr>
      <td>§s</td>
      <td>material_diamond</td>
      <td>44</td>
      <td>186</td>
      <td>168</td>
      <td>{{color|#2CBAA8}}</td>
      <td>11</td>
      <td>46</td>
      <td>42</td>
      <td>{{color|#0B2E2A}}</td>
      <td>&mdash;</td>
      <td>{{only|be|short=1}}</td>
    </tr>
    <tr>
      <td>§t</td>
      <td>material_lapis</td>
      <td>33</td>
      <td>73</td>
      <td>123</td>
      <td>{{color|#21497B}}</td>
      <td>8</td>
      <td>18</td>
      <td>30</td>
      <td>{{color|#08121E}}</td>
      <td>&mdash;</td>
      <td>{{only|be|short=1}}</td>
    </tr>
    <tr>
      <td>§u</td>
      <td>material_amethyst</td>
      <td>154</td>
      <td>92</td>
      <td>198</td>
      <td>{{color|#9A5CC6}}</td>
      <td>38</td>
      <td>23</td>
      <td>49</td>
      <td>{{color|#261731}}</td>
      <td>&mdash;</td>
      <td>{{only|be|short=1}}</td>
    </tr>
    <tr>
      <td>§v</td>
      <td>material_resin</td>
      <td>235</td>
      <td>114</td>
      <td>20</td>
      <td>{{color|#EB7114}}</td>
      <td>59</td>
      <td>29</td>
      <td>5</td>
      <td>{{color|#3B1D05}}</td>
      <td>&mdash;</td>
      <td>{{only|be|short=1}}</td>
    </tr>
  </tbody>
</table>


### Formatting codes
<table class="wikitable">
  <tbody>
    <tr>
      <th colspan="1">Code</th>
      <th colspan="1">Name</th>
      <th>Equivalent [ANSI escape code](wikipedia-ansi_escape_code.md#sgrselectgraphicrenditionparameters)</th>
      <th>Version</th>
    </tr>
    <tr>
      <td>§k</td>
      <td>obfuscated/MTS*</td>
      <td>—</td>
      <td></td>
    </tr>
    <tr>
      <td>§l</td>
      <td>**bold**</td>
      <td>`\e[1m`</td>
      <td></td>
    </tr>
    <tr>
      <td>§m</td>
      <td><s>strikethrough</s></td>
      <td>`\e[9m`</td>
      <td>{{only|je|short=1}}</td>
    </tr>
    <tr>
      <td>§n</td>
      <td><u>underlined</u></td>
      <td>`\e[4m`</td>
      <td>{{only|je|short=1}}</td>
    </tr>
    <tr>
      <td>§o</td>
      <td>*italic*</td>
      <td>`\e[3m`</td>
      <td></td>
    </tr>
    <tr>
      <td>§r</td>
      <td>reset</td>
      <td>`\e[0m`</td>
      <td></td>
    </tr>
  </tbody>
</table>

The random characters placed after `§k` are always the same width as the original characters. For example, any random character cycled through in place of the letter "m" would be a wide character while any random character in place of the letter "i" would be a narrow character.

*MTS: Magical Text Source; used in the game's source code (`this.magictextsrc`)

`§r` resets the styles of following characters; e.g., `§nXXX§rYYY` displays as <span class="format-f" style="font-family: Minecraft"><u>XXX</u>YYY</span>, which can be used to remove the default italics formatting when renaming an item in an [Anvil](anvil.md).

### Typing
See also:
  * [Wikipedia:Unicode input](./wikipedia-unicode-input.md)
- To enter "§" on Windows with most US/UK English keyboards type {{keys|Alt+NUMPAD2|NUMPAD1}} ([alt code](wikipedia-alt-code.md) on cp437) or {{Keys|Alt+NUMPAD7|NUMPAD8|NUMPAD9|}}. For any other keyboard, the Windows ANSI version {{keys|Alt+NUMPAD0|NUMPAD1|NUMPAD6|NUMPAD7}} often works.
- If `EnableHexNumpad` is enabled in the Windows registry, {{keys|Alt+NUMPAD+|A|NUMPAD7}} (using the main keyboard for "A") works for any language due to it being Unicode.
- On a Mac with a US keyboard, type {{keys|Option+6}} (or {{keys|Option+5}} for US Extended). For any other keyboard, type {{keys|Option+0|0|a|7}}.
- On Linux with the [compose key](wikipedia-compose-key.md) activated, type {{keys|Compose|s|o}}. The symbol can also be typed by using Unicode shortcuts: {{keys|Control+Shift+u|0|0|a|7}}.
- To enter "§" on a Nintendo Switch, select languages (globe icon), scroll to the bottom to find the "Symbols" language, and then select Page 2 to find the symbol to the right in the bottom line.
- For various Android keyboards:
** Google Keyboard (GBoard): The "§" is in the More Symbols section the symbols. To access it, press the Numbers and Symbols button (?123), then press the More Symbols button (=\<). Note that on previous versions of GBoard, it was behind the Paragraph Symbol "¶" in the same position, but they were recently swapped so that now "¶" is behind "§".
** Samsung Keyboard: The "§" is under the "s" key. To access, hold down on the "s" and then slide over to the "§" mark.
- For iOS:
** On the iPad the "§" is under the percent sign. To access, tap the number/symbol button and then swipe down on the percent sign.
** On the iPhone the "§" is under the ampersand "&". To access, tap the number/symbol button then hold down the ampersand key and slide over to the "§" mark.
- For Xbox:
** On the Xbox One the "§" is under the paragraph mark "¶". To access, use {{xbtn|lt}}, hold down {{xbtn|A}} while on ¶ until other options pop up. Move the cursor over to the "§" mark and use {{xbtn|A}} to select.
** One can also highlight the S key on the standard alphanumeric keyboard, then press and hold {{xbtn|A}} to reveal several "alternate" characters, including "§". This method also works on the Windows 10 version.

When part of [JSON](json-text.md) text, the symbol can be written as {{code|\u00A7}} or {{code|\u00a7}}.

Alternatively {{in|be}}, the character can be copied from this page (`§`) and pasted into virtually any text field by pressing {{keys|Ctrl+V}} (Windows) or {{keys|CMD+V}} (macOS). If pasting does not work it may be necessary to use the JSON format or another method.

While in chat in [Java Edition](java-edition.md), usage of this character disconnects the user, even in 'offline' single player mode, and thus cannot be used directly in commands such as `/say`.

In early [Java Edition Classic](java-edition-classic.md) versions, the character used was {{cd|&}} instead of {{cd|§}}.<ref name="Notch announcement">[IRC logs](https://archive.org/download/Minecraft_IRC_Logs_2009/DBN-IRC-Logs/) on Archive.org; #minecraft.20090619.log. "*P7:43:58 <Notch> Quatroking: want to know a secret?*" [...] "*P7:44:44 <Notch> /say He&1llo&f, world! &bHOW ARE YOU!?*" [...] "*P7:45:52 <Notch> it's the ega palette, almost*" (June 20, 2009, 00:43:58 UTC)</ref>

### Sample text
The following text can be pasted into a [Book and Quill](book-and-quill.md) (prior to 1.14) to produce what is shown in the picture:
