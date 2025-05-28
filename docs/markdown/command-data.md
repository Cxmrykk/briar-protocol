From Minecraft 1.13, the **Command Graph** data structure defines commands which can be used in chat or in command blocks, and how they're parsed. For more information see the page on [command argument types](argument-types.md).

## Graph Structure

The graph consists of nodes of type `root`, `literal` and `argument`. A node may point to a number of child nodes, or redirect to another node, or neither. The root node is nameless, and its children are literal nodes for familiar commands ("msg", "me", etc). 

Nodes are marked as executable if the node stack to this point constitutes a valid command. E.g. this is false for `/ban` but true for `/ban Dinnerbone` and `/ban Dinnerbone created this crazy format`.

When including redirects, this structure is a directed graph that may include cycles (e.g. consider `/execute run execute run execute ...`). When excluding redirects, the structure no longer contains cycles but may still not be a tree, as a node may have multiple parents.

## Node Format

<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>[Flags](.md#flags)</td>
      <td>`Byte`</td>
      <td>See below.</td>
    </tr>
    <tr>
      <td>Children count</td>
      <td>`VarInt`</td>
      <td>Number of elements in the following array.</td>
    </tr>
    <tr>
      <td>Children</td>
      <td>`Array` of `VarInt`</td>
      <td>Array of indices of child nodes.</td>
    </tr>
    <tr>
      <td>Redirect node</td>
      <td>`Optional` `VarInt`</td>
      <td>Only if `flags & 0x08`. Index of redirect node.</td>
    </tr>
    <tr>
      <td>Name</td>
      <td>`Optional` `String` (32767)</td>
      <td>Only for `argument` and `literal` nodes.</td>
    </tr>
    <tr>
      <td>[Parser ID](.md#parsers)</td>
      <td>`Optional` `VarInt`</td>
      <td>Only for `argument` nodes.</td>
    </tr>
    <tr>
      <td>Properties</td>
      <td>`Optional` Varies</td>
      <td>Only for `argument` nodes. Varies by parser.</td>
    </tr>
    <tr>
      <td>[Suggestions type](.md#suggestionstypes)</td>
      <td>`Optional` `Identifier`</td>
      <td>Only if `flags & 0x10`.</td>
    </tr>
  </tbody>
</table>

### Flags

<table class="wikitable">
  <tbody>
    <tr>
      <th>Bit Mask</th>
      <th>Flag Name</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>`0x03`</td>
      <td>Node type</td>
      <td>0: `root`, 1: `literal`, 2: `argument`. 3 is not used.</td>
    </tr>
    <tr>
      <td>`0x04`</td>
      <td>Is executable</td>
      <td>Set if the node stack to this point constitutes a valid command.</td>
    </tr>
    <tr>
      <td>`0x08`</td>
      <td>Has redirect</td>
      <td>Set if the node redirects to another node.</td>
    </tr>
    <tr>
      <td>`0x10`</td>
      <td>Has suggestions type</td>
      <td>Only present for `argument` nodes.</td>
    </tr>
  </tbody>
</table>

### Parsers

Clients are expected to implement all parsers, including properties (if any). If an unknown parser is encountered by a client, unpacking of the [Commands](protocol.md#commands) packet should stop immediately, as the structure of the remainder of the packet cannot be guessed.

Since 1.19, parsers are identified by their ID in the Node Format. Parsers (as well as parser IDs) are provided only for `argument` nodes. If properties for parser are not specified, then this parser has no properties and "Properties" section in Node Format contains no data.
> ⚠️ **Warning:**  Some IDs have changed thoughout versions
<table class="wikitable">
  <tbody>
    <tr>
      <th>Numeric ID</th>
      <th>String Identifier</th>
      <th>Properties</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>0</td>
      <td>`brigadier:bool`</td>
      <td>N/A</td>
      <td>Boolean value (`true` or `false`, case-sensitive)</td>
    </tr>
    <tr>
      <td>1</td>
      <td>`brigadier:float`</td>
      <td>[See below](.md#brigadierfloat)</td>
      <td>Float</td>
    </tr>
    <tr>
      <td>2</td>
      <td>`brigadier:double`</td>
      <td>[See below](.md#brigadierdouble)</td>
      <td>Double</td>
    </tr>
    <tr>
      <td>3</td>
      <td>`brigadier:integer`</td>
      <td>[See below](.md#brigadierinteger)</td>
      <td>Integer</td>
    </tr>
    <tr>
      <td>4</td>
      <td>`brigadier:long`</td>
      <td>[See below](.md#brigadierlong)</td>
      <td>Long</td>
    </tr>
    <tr>
      <td>5</td>
      <td>`brigadier:string`</td>
      <td>[See below](.md#brigadierstring)</td>
      <td>A string</td>
    </tr>
    <tr>
      <td>6</td>
      <td>`minecraft:entity`</td>
      <td>[See below](.md#minecraftentity)</td>
      <td>A selector, player name, or UUID.</td>
    </tr>
    <tr>
      <td>7</td>
      <td>`minecraft:game_profile`</td>
      <td>N/A</td>
      <td>A player, online or not.  Can also use a selector, which may match one or more players (but not entities).</td>
    </tr>
    <tr>
      <td>8</td>
      <td>`minecraft:block_pos`</td>
      <td>N/A</td>
      <td>A location, represented as 3 numbers (which must be integers).  May use relative locations with `~`.</td>
    </tr>
    <tr>
      <td>9</td>
      <td>`minecraft:column_pos`</td>
      <td>N/A</td>
      <td>A column location, represented as 2 numbers (which must be integers).  May use relative locations with `~`.</td>
    </tr>
    <tr>
      <td>10</td>
      <td>`minecraft:vec3`</td>
      <td>N/A</td>
      <td>A location, represented as 3 numbers (which may have a decimal point, but will be moved to the center of a block if none is specified).  May use relative locations with `~`.</td>
    </tr>
    <tr>
      <td>11</td>
      <td>`minecraft:vec2`</td>
      <td>N/A</td>
      <td>A location, represented as 2 numbers (which may have a decimal point, but will be moved to the center of a block if none is specified).  May use relative locations with `~`.</td>
    </tr>
    <tr>
      <td>12</td>
      <td>`minecraft:block_state`</td>
      <td>N/A</td>
      <td>A block state, optionally including NBT and state information.</td>
    </tr>
    <tr>
      <td>13</td>
      <td>`minecraft:block_predicate`</td>
      <td>N/A</td>
      <td>A block, or a block tag.</td>
    </tr>
    <tr>
      <td>14</td>
      <td>`minecraft:item_stack`</td>
      <td>N/A</td>
      <td>An item, optionally including NBT.</td>
    </tr>
    <tr>
      <td>15</td>
      <td>`minecraft:item_predicate`</td>
      <td>N/A</td>
      <td>An item, or an item tag.</td>
    </tr>
    <tr>
      <td>16</td>
      <td>`minecraft:color`</td>
      <td>N/A</td>
      <td>A chat color.  One of the names from [Text formatting#Colors](text-formatting.md#colors), or `reset`.  Case-insensitive.</td>
    </tr>
    <tr>
      <td>17</td>
      <td>`minecraft:component`</td>
      <td>N/A</td>
      <td>A JSON [text component](text-formatting.md#text-components).</td>
    </tr>
    <tr>
      <td>18</td>
      <td>`minecraft:style`</td>
      <td>N/A</td>
      <td>A JSON object containing the [text component styling fields](text-formatting.md#styling-fields).</td>
    </tr>
    <tr>
      <td>19</td>
      <td>`minecraft:message`</td>
      <td>N/A</td>
      <td>A regular message, potentially including selectors.</td>
    </tr>
    <tr>
      <td>20</td>
      <td>`minecraft:nbt`</td>
      <td>N/A</td>
      <td>An NBT value, parsed using JSON-NBT rules.</td>
    </tr>
    <tr>
      <td>21</td>
      <td>`minecraft:nbt_tag`</td>
      <td>N/A</td>
      <td>Represents a partial nbt tag, usable in data modify command.</td>
    </tr>
    <tr>
      <td>22</td>
      <td>`minecraft:nbt_path`</td>
      <td>N/A</td>
      <td>A path within an NBT value, allowing for array and member accesses.</td>
    </tr>
    <tr>
      <td>23</td>
      <td>`minecraft:objective`</td>
      <td>N/A</td>
      <td>A scoreboard objective.</td>
    </tr>
    <tr>
      <td>24</td>
      <td>`minecraft:objective_criteria`</td>
      <td>N/A</td>
      <td>A single score criterion.</td>
    </tr>
    <tr>
      <td>25</td>
      <td>`minecraft:operation`</td>
      <td>N/A</td>
      <td>A scoreboard operator.</td>
    </tr>
    <tr>
      <td>26</td>
      <td>`minecraft:particle`</td>
      <td>N/A</td>
      <td>A particle effect (an identifier with extra information following it for specific particles, mirroring the [[#Particle|Particle]] packet)</td>
    </tr>
    <tr>
      <td>27</td>
      <td>`minecraft:angle`</td>
      <td>N/A</td>
      <td></td>
    </tr>
    <tr>
      <td>28</td>
      <td>`minecraft:rotation`</td>
      <td>N/A</td>
      <td>An angle, represented as 2 numbers (which may have a decimal point, but will be moved to the center of a block if none is specified).  May use relative locations with `~`.</td>
    </tr>
    <tr>
      <td>29</td>
      <td>`minecraft:scoreboard_slot`</td>
      <td>N/A</td>
      <td>A scoreboard display position slot.  `list`, `sidebar`, `belowName`, and `sidebar.team.${color}` for all chat colors (`reset` is not included)</td>
    </tr>
    <tr>
      <td>30</td>
      <td>`minecraft:score_holder`</td>
      <td>[See below](.md#minecraftscoreholder)</td>
      <td>Something that can join a team.  Allows selectors and `*`.</td>
    </tr>
    <tr>
      <td>31</td>
      <td>`minecraft:swizzle`</td>
      <td>N/A</td>
      <td>A collection of up to 3 axes.</td>
    </tr>
    <tr>
      <td>32</td>
      <td>`minecraft:team`</td>
      <td>N/A</td>
      <td>The name of a team.  Parsed as an unquoted string.</td>
    </tr>
    <tr>
      <td>33</td>
      <td>`minecraft:item_slot`</td>
      <td>N/A</td>
      <td>A name for an inventory slot.</td>
    </tr>
    <tr>
      <td>34</td>
      <td>`minecraft:resource_location`</td>
      <td>N/A</td>
      <td>An Identifier.</td>
    </tr>
    <tr>
      <td>35</td>
      <td>`minecraft:function`</td>
      <td>N/A</td>
      <td>A function.</td>
    </tr>
    <tr>
      <td>36</td>
      <td>`minecraft:entity_anchor`</td>
      <td>N/A</td>
      <td>The entity anchor related to the facing argument in the teleport command, is feet or eyes.</td>
    </tr>
    <tr>
      <td>37</td>
      <td>`minecraft:int_range`</td>
      <td>N/A</td>
      <td>An integer range of values with a min and a max.</td>
    </tr>
    <tr>
      <td>38</td>
      <td>`minecraft:float_range`</td>
      <td>N/A</td>
      <td>A floating-point range of values with a min and a max.</td>
    </tr>
    <tr>
      <td>39</td>
      <td>`minecraft:dimension`</td>
      <td>N/A</td>
      <td>Represents a dimension.</td>
    </tr>
    <tr>
      <td>40</td>
      <td>`minecraft:gamemode`</td>
      <td>N/A</td>
      <td>Represents a gamemode. (`survival`, `creative`, `adventure` or `spectator`)</td>
    </tr>
    <tr>
      <td>41</td>
      <td>`minecraft:time`</td>
      <td>[See below](.md#minecrafttime)</td>
      <td>Represents a time duration.</td>
    </tr>
    <tr>
      <td>42</td>
      <td>`minecraft:resource_or_tag`</td>
      <td>[See below](.md#minecraftresourceortag)</td>
      <td>An identifier or a tag name for a registry.</td>
    </tr>
    <tr>
      <td>43</td>
      <td>`minecraft:resource_or_tag_key`</td>
      <td>[See below](.md#minecraftresourceortagkey)</td>
      <td>An identifier or a tag name for a registry.</td>
    </tr>
    <tr>
      <td>44</td>
      <td>`minecraft:resource`</td>
      <td>[See below](.md#minecraftresource)</td>
      <td>An identifier for a registry.</td>
    </tr>
    <tr>
      <td>45</td>
      <td>`minecraft:resource_key`</td>
      <td>[See below](.md#minecraftresourcekey)</td>
      <td>An identifier for a registry.</td>
    </tr>
    <tr>
      <td>46</td>
      <td>`minecraft:template_mirror`</td>
      <td>N/A</td>
      <td>Mirror type (`none`, `left_right` or `front_back`)</td>
    </tr>
    <tr>
      <td>47</td>
      <td>`minecraft:template_rotation`</td>
      <td>N/A</td>
      <td>Rotation type (`none`, `clockwise_90`, `180` or `counterclockwise_90`)</td>
    </tr>
    <tr>
      <td>48</td>
      <td>`minecraft:heightmap`</td>
      <td>N/A</td>
      <td>Post-worldgen heightmap type (`motion_blocking`, `motion_blocking_no_leaves`, `ocean_floor` and `world_surface`)</td>
    </tr>
    <tr>
      <td>49</td>
      <td>`minecraft:uuid`</td>
      <td>N/A</td>
      <td>Represents a UUID value.</td>
    </tr>
    <tr>
      <td>?</td>
      <td>`forge:modid`</td>
      <td>Unknown</td>
      <td>Represents a mod identifier. Added by Minecraft Forge. Vanilla clients/servers do not support this parser.</td>
    </tr>
    <tr>
      <td>?</td>
      <td>`forge:enum`</td>
      <td>Unknown</td>
      <td>Represents a enum class to use for suggestion. Added by Minecraft Forge. Vanilla clients/servers do not support this parser.</td>
    </tr>
  </tbody>
</table>

#### `brigadier:double`

Specifies min and max values.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>Flags</td>
      <td>`Byte`</td>
      <td></td>
    </tr>
    <tr>
      <td>Min</td>
      <td>`Optional` `Double`</td>
      <td>Only if flags & 0x01.  If not specified, defaults to `-Double.MAX_VALUE` (≈ -1.7976931348623157E307)</td>
    </tr>
    <tr>
      <td>Max</td>
      <td>`Optional` `Double`</td>
      <td>Only if flags & 0x02.  If not specified, defaults to `Double.MAX_VALUE` (≈ 1.7976931348623157E307)</td>
    </tr>
  </tbody>
</table>

#### `brigadier:float`

Specifies min and max values.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>Flags</td>
      <td>`Byte`</td>
      <td></td>
    </tr>
    <tr>
      <td>Min</td>
      <td>`Optional` `Float`</td>
      <td>Only if flags & 0x01.  If not specified, defaults to `-Float.MAX_VALUE` (≈ 3.4028235E38)</td>
    </tr>
    <tr>
      <td>Max</td>
      <td>`Optional` `Float`</td>
      <td>Only if flags & 0x02.  If not specified, defaults to `Float.MAX_VALUE` (≈ 3.4028235E38)</td>
    </tr>
  </tbody>
</table>
 
#### `brigadier:integer`

Specifies min and max values.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>Flags</td>
      <td>`Byte`</td>
      <td></td>
    </tr>
    <tr>
      <td>Min</td>
      <td>`Optional` `Int`</td>
      <td>Only if flags & 0x01.  If not specified, defaults to `Integer.MIN_VALUE`  (-2147483648)</td>
    </tr>
    <tr>
      <td>Max</td>
      <td>`Optional` `Int`</td>
      <td>Only if flags & 0x02.  If not specified, defaults to `Integer.MAX_VALUE`  (2147483647)</td>
    </tr>
  </tbody>
</table>

#### `brigadier:long`

Specifies min and max values.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>Flags</td>
      <td>`Byte`</td>
      <td></td>
    </tr>
    <tr>
      <td>Min</td>
      <td>`Optional` `Long`</td>
      <td>Only if flags & 0x01.  If not specified, defaults to `Long.MIN_VALUE`  (−9,223,372,036,854,775,808)</td>
    </tr>
    <tr>
      <td>Max</td>
      <td>`Optional` `Long`</td>
      <td>Only if flags & 0x02.  If not specified, defaults to `Long.MAX_VALUE`  (9,223,372,036,854,775,807)</td>
    </tr>
  </tbody>
</table>

#### `brigadier:string`

A `VarInt` `Enum`.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>Behavior</td>
      <td>`VarInt` `Enum`</td>
      <td>Parsing behavior (see below).</td>
    </tr>
  </tbody>
</table>

<table class="wikitable">
  <tbody>
    <tr>
      <th>ID</th>
      <th>Behavior Name</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>0</td>
      <td>`SINGLE_WORD`</td>
      <td>Reads a single word</td>
    </tr>
    <tr>
      <td>1</td>
      <td>`QUOTABLE_PHRASE`</td>
      <td>If it starts with a `"`, keeps reading until another `"` (allowing escaping with `\`).  Otherwise behaves the same as `SINGLE_WORD`</td>
    </tr>
    <tr>
      <td>2</td>
      <td>`GREEDY_PHRASE`</td>
      <td>Reads the rest of the content after the cursor.  Quotes will not be removed.</td>
    </tr>
  </tbody>
</table>

#### `minecraft:entity`

Has a single flags byte.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Bit Mask</th>
      <th>Meaning</th>
    </tr>
    <tr>
      <td>0x01</td>
      <td>If set, only allows a single entity/player</td>
    </tr>
    <tr>
      <td>0x02</td>
      <td>If set, only allows players</td>
    </tr>
  </tbody>
</table>

#### `minecraft:score_holder`

Has a single flags byte.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Bit Mask</th>
      <th>Meaning</th>
    </tr>
    <tr>
      <td>0x01</td>
      <td>If set, allows multiple.</td>
    </tr>
  </tbody>
</table>

#### `minecraft:time`

<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>Min</td>
      <td>`Int`</td>
      <td>Minimum duration in ticks</td>
    </tr>
  </tbody>
</table>

#### `minecraft:resource_or_tag`

Has a single identifier.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>Registry</td>
      <td>`Identifier`</td>
      <td>The registry from where suggestions will be sourced from.</td>
    </tr>
  </tbody>
</table>

#### `minecraft:resource_or_tag_key`

Has a single identifier.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>Registry</td>
      <td>`Identifier`</td>
      <td>The registry from where suggestions will be sourced from.</td>
    </tr>
  </tbody>
</table>

#### `minecraft:resource`

Has a single identifier.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>Registry</td>
      <td>`Identifier`</td>
      <td>The registry from where suggestions will be sourced from.</td>
    </tr>
  </tbody>
</table>

#### `minecraft:resource_key`

Has a single identifier.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>Registry</td>
      <td>`Identifier`</td>
      <td>The registry from where suggestions will be sourced from.</td>
    </tr>
  </tbody>
</table>

#### `forge:modid`
Added by Minecraft Forge, vanilla clients/servers do not have this.

- Registered in https://github.com/MinecraftForge/MinecraftForge/blob/19f8d2a7937dc7968ecbef2f9785687193fcd210/src/main/java/net/minecraftforge/common/ForgeMod.java#L175
- Serialized in https://github.com/MinecraftForge/MinecraftForge/blob/9177ac1b2e326a3acffaf476eeff28a1cf9a637f/src/main/java/net/minecraftforge/server/command/ModIdArgument.java

#### `forge:enum`

Added by Minecraft Forge, vanilla clients/servers do not have this.
Enum class to use for suggestions. 
The value is literally as is fed into the java method Class.forName
see net.minecraftforge.server.command.EnumArgument

<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>Class</td>
      <td>`String`</td>
      <td>Enum Class to use</td>
    </tr>
  </tbody>
</table>

- Registered in https://github.com/MinecraftForge/MinecraftForge/blob/19f8d2a7937dc7968ecbef2f9785687193fcd210/src/main/java/net/minecraftforge/common/ForgeMod.java#L175
- Serialized in https://github.com/MinecraftForge/MinecraftForge/blob/bca20ace4ecb1da07806c8fc6c749826c3bd57e1/src/main/java/net/minecraftforge/server/command/EnumArgument.java

### Suggestions Types

If the provided suggestion type is not recognized by Notchian client, it will use `minecraft:ask_server`.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Identifier</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>`minecraft:ask_server`</td>
      <td>Sends the [Command Suggestions Request](protocol.md#command20suggestions20request) packet to the server to request tab completions.</td>
    </tr>
    <tr>
      <td>`minecraft:all_recipes`</td>
      <td>Suggests all the available recipes.</td>
    </tr>
    <tr>
      <td>`minecraft:available_sounds`</td>
      <td>Suggests all the available sounds.</td>
    </tr>
    <tr>
      <td>`minecraft:summonable_entities`</td>
      <td>Suggests all the summonable entities.</td>
    </tr>
  </tbody>
</table>

## Example Graphs

![center|Command graph from 18w22c. Executable nodes are shown in green; redirects are dashed.](Command_graph_18w22c.png)

[Category:Protocol Details](category-protocol-details.md)
[Category:Java Edition protocol](category-java-edition-protocol.md)
_Content is licensed under wiki.vg terms._
