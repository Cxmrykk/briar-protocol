**Plugin channels** allow client mods and server plugins to communicate without cluttering up chat. [This post by Dinnerbone](https://web.archive.org/web/20220711204310/https://dinnerbone.com/blog/2012/01/13/minecraft-plugin-channels-messaging/) is a good introduction and basic documentation.
<a id="internal"></a>

## Definitions

### Data Types

#### Entity Path

Represents calculated path of entity.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>Reaches Target</td>
      <td>`Boolean`</td>
      <td>Seems to always be true.</td>
    </tr>
    <tr>
      <td>Current node index</td>
      <td>`Int`</td>
      <td>Index in nodes that the entity is currently targeting.</td>
    </tr>
    <tr>
      <td>Target position</td>
      <td>`Position`</td>
      <td>The position that the entity is trying to reach as its destination.</td>
    </tr>
    <tr>
      <td>Nodes</td>
      <td>`Prefixed Array` of Path Node</td>
      <td>The nodes of this path.</td>
    </tr>
    <tr>
      <td>Target Nodes</td>
      <td>`Prefixed Array` of Path Node</td>
      <td>The nodes that the entity is targeting.</td>
    </tr>
    <tr>
      <td>Traversed Nodes</td>
      <td>`Prefixed Array` of Path Node</td>
      <td>The nodes that the entity has completed.</td>
    </tr>
    <tr>
      <td>Remaining Nodes</td>
      <td>`Prefixed Array` of Path Node</td>
      <td>The nodes that the entity needs to traverse.</td>
    </tr>
  </tbody>
</table>

You can read more at [A* search algorithm](wikipedia-a_search_algorithm.md).

#### Path Node

Represents single point in path

<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>X</td>
      <td>`Int`</td>
      <td></td>
    </tr>
    <tr>
      <td>Y</td>
      <td>`Int`</td>
      <td></td>
    </tr>
    <tr>
      <td>Z</td>
      <td>`Int`</td>
      <td></td>
    </tr>
    <tr>
      <td>Distance from origin</td>
      <td>`Float`</td>
      <td>Sum of the length of the previous nodes + the length of this node</td>
    </tr>
    <tr>
      <td>Cost</td>
      <td>`Float`</td>
      <td></td>
    </tr>
    <tr>
      <td>Has been visited</td>
      <td>`Boolean`</td>
      <td></td>
    </tr>
    <tr>
      <td>Node type</td>
      <td>`Int` `Enum`</td>
      <td>See below</td>
    </tr>
    <tr>
      <td>Heap Weight</td>
      <td>`Float`</td>
      <td></td>
    </tr>
  </tbody>
</table>

Node type can be one of the following values:

<table class="wikitable">
  <tbody>
    <tr>
      <th>ID</th>
      <th>Type</th>
    </tr>
    <tr>
      <td>0</td>
      <td>Blocked</td>
    </tr>
    <tr>
      <td>1</td>
      <td>Open</td>
    </tr>
    <tr>
      <td>2</td>
      <td>Walkable</td>
    </tr>
    <tr>
      <td>3</td>
      <td>Walkable door</td>
    </tr>
    <tr>
      <td>4</td>
      <td>Trapdoor</td>
    </tr>
    <tr>
      <td>5</td>
      <td>Powder snow</td>
    </tr>
    <tr>
      <td>6</td>
      <td>Danger powder snow</td>
    </tr>
    <tr>
      <td>7</td>
      <td>Fence</td>
    </tr>
    <tr>
      <td>8</td>
      <td>Lava</td>
    </tr>
    <tr>
      <td>9</td>
      <td>Water</td>
    </tr>
    <tr>
      <td>10</td>
      <td>Water border</td>
    </tr>
    <tr>
      <td>11</td>
      <td>Rail</td>
    </tr>
    <tr>
      <td>12</td>
      <td>Unpassable rail</td>
    </tr>
    <tr>
      <td>13</td>
      <td>Danger fire</td>
    </tr>
    <tr>
      <td>14</td>
      <td>Damage fire</td>
    </tr>
    <tr>
      <td>15</td>
      <td>Danger other</td>
    </tr>
    <tr>
      <td>16</td>
      <td>Damage other</td>
    </tr>
    <tr>
      <td>17</td>
      <td>Open door</td>
    </tr>
    <tr>
      <td>18</td>
      <td>Closed wooden door</td>
    </tr>
    <tr>
      <td>19</td>
      <td>Closed iron door</td>
    </tr>
    <tr>
      <td>20</td>
      <td>Breach (water)</td>
    </tr>
    <tr>
      <td>21</td>
      <td>Leaves</td>
    </tr>
    <tr>
      <td>22</td>
      <td>Sticky honey</td>
    </tr>
    <tr>
      <td>23</td>
      <td>Cocoa</td>
    </tr>
    <tr>
      <td>24</td>
      <td>Damage cautious</td>
    </tr>
    <tr>
      <td>25</td>
      <td>Danger trapdoor</td>
    </tr>
  </tbody>
</table>

#### Block Box

Represents a box with integer precision

<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>Min X</td>
      <td>`Int`</td>
      <td>must be less than max</td>
    </tr>
    <tr>
      <td>Min Y</td>
      <td>`Int`</td>
      <td>must be less than max</td>
    </tr>
    <tr>
      <td>Min Z</td>
      <td>`Int`</td>
      <td>must be less than max</td>
    </tr>
    <tr>
      <td>Max X</td>
      <td>`Int`</td>
      <td>must be more than min</td>
    </tr>
    <tr>
      <td>Max Y</td>
      <td>`Int`</td>
      <td>must be more than min</td>
    </tr>
    <tr>
      <td>Max Z</td>
      <td>`Int`</td>
      <td>must be more than min</td>
    </tr>
  </tbody>
</table>

#### Chunk Section Position

Represents a box with integer precision

<b>Note:</b> What you are seeing here is the latest version of the [Data types](data-types.md) article, but the position type was [different before 1.14](https://wiki.vg/index.php?title=Data_types&oldid=14345#Position).

64-bit value split into three **signed** integer parts:

- x: 22 MSBs
- z: 22 middle bits
- y: 20 LSBs

For example, a 64-bit position can be broken down as follows:

Example value (big endian): `<span style="outline: solid 2px rgb(255, 0, 0)">0000000000000000000000</span> <span style="outline: solid 2px rgb(0, 0, 255)">0000000000000000000000</span> <span style="outline: solid 2px rgb(0, 255, 0)">00000000000000000000</span>`<br>
- The red value is the X coordinate, which is `0` in this example.<br>
- The blue value is the Z coordinate, which is `0` in this example.<br>
- The green value is the Y coordinate, which is `0` in this example.<br>

Encoded as follows:

 ((x & 0x3FFFFF) << 42) | ((z & 0x3FFFFF) << 20) | (y & 0xFFFFF)

And decoded as:

 val = read_long();
 x = val >> 42;
 z = val << 20 >> 42;
 y = val << 42 >> 42;

Note: The above assumes that the right shift operator sign extends the value (this is called an [arithmetic shift](https://en.wikipedia.org/wiki/Arithmetic_shift)), so that the signedness of the coordinates is preserved. In many languages, this requires the integer type of `val` to be signed.

## Channels internal to Minecraft

These are channels used by Minecraft. Most of them are debugging-related except for brand.

### Brand

Announces the server and client implementation name right after a player has logged in.

These brands are used in crash reports and a few other locations. It's recommended that custom clients and servers use their own brand names for the purpose of identification. The brand is not processed in any other way, and Notchian clients will connect to servers with different brands with no issue (the brand is not used to validate).

The Notchian server sends a `minecraft:brand` packet right after it sends a [Login (play)](protocol.md#login-play) packet, and the Notchian client sends it right after receiving a Login (play) packet. However, some modified clients and servers will not send this packet (or will take longer to send it than normal), so it is important to not crash if the brand has not been sent. Additionally, the brand may change at any time (for instance, if connected through a BungeeCord instance, you may switch from a server with one brand to a server with another brand without receiving a Login (play) packet).

<table class="wikitable">
  <tbody>
    <tr>
      <th>Channel</th>
      <th>Bound to</th>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>`minecraft:brand`</td>
      <td>Two-way</td>
      <td>Channels</td>
      <td>`String` (32767)</td>
      <td>The brand of the server/client. The Notchian value is "vanilla".</td>
    </tr>
  </tbody>
</table>

### Debug/Path

![The rendering as seen in the [snapshot 16w14a announcement](https://web.archive.org/web/20161224194609/http://mojang.com/2016/04/minecraft-snapshot-16w14a/).](16w14a.png)

Never sent by the Notchian server. Requires modifications to the client to render.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Channel</th>
      <th>Bound to</th>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="3">`minecraft:debug/path`</td>
      <td rowspan="3">Client</td>
      <td>Entity ID</td>
      <td>`Int`</td>
      <td>ID of the entity that is traversing the path.</td>
    </tr>
    <tr>
      <td>Path</td>
      <td>Entity Path</td>
      <td></td>
    </tr>
    <tr>
      <td>Node reach proximity</td>
      <td>`Float`</td>
      <td></td>
    </tr>
  </tbody>
</table>

The current node is rendered red; the others are rendered blue. The target position is rendered as a green cube.

### Debug/Neighbors Update

Never sent by the Notchian server. Requires modifications to the client to render.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Channel</th>
      <th>Bound to</th>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="2">`minecraft:debug/path`</td>
      <td rowspan="2">Client</td>
      <td>Time</td>
      <td>`VarLong`</td>
      <td>World timestamp at which the update occurred. 200 ticks after this timestamp, the given update stops rendering.</td>
    </tr>
    <tr>
      <td>Location</td>
      <td>`Position`</td>
      <td>Location of the block that updated.</td>
    </tr>
  </tbody>
</table>

### Debug/Redstone Update Order

Never sent by the Notchian server. Requires modifications to the client to render.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Channel</th>
      <th>Bound to</th>
      <th colspan="2">Field Name</th>
      <th colspan="2">Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="3">`minecraft:debug/redstone_update_order`</td>
      <td rowspan="3">Client</td>
      <td colspan="2">Time</td>
      <td colspan="2">`VarLong`</td>
      <td>World timestamp at which the update occurred. 200 ticks after this timestamp, the given update stops rendering.</td>
    </tr>
    <tr>
      <td rowspan="2">Wires</td>
      <td>Location</td>
      <td rowspan="2">`Prefixed Array`</td>
      <td>`Position`</td>
      <td>Location of the redstone wire.</td>
    </tr>
    <tr>
      <td>Orientation</td>
      <td>`VarInt`</td>
      <td>Packed orientation. (unknown format)</td>
    </tr>
  </tbody>
</table>

### Debug/Structures
Used to debug structures. Never sent by the Notchian server. Requires modifications to the client to render.

Adds a single new structure, which will always be rendered if the player is in the same dimension.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Channel</th>
      <th>Bound to</th>
      <th colspan="2">Field Name</th>
      <th colspan="2">Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="4">`minecraft:debug/structures`</td>
      <td rowspan="4">Client</td>
      <td colspan="2">Dimension</td>
      <td colspan="2">`VarInt`</td>
      <td>The ID of the type of dimension in the `minecraft:dimension_type` registry</td>
    </tr>
    <tr>
      <td colspan="2">Box</td>
      <td colspan="2">Block Box</td>
      <td>Main box for the structure (rendered in white).</td>
    </tr>
    <tr>
      <td rowspan="2">Sub-boxes</td>
      <td>Box</td>
      <td rowspan="2">`Prefixed Array`</td>
      <td>Block box</td>
      <td></td>
    </tr>
    <tr>
      <td>Starting piece</td>
      <td>`Boolean`</td>
      <td>If true, the sub-box is rendered in green, otherwise in blue.</td>
    </tr>
  </tbody>
</table>

### Debug/World Generation Attempt

Used to debug something with world generation. Never sent by the Notchian server. Requires modifications to the client to render.

Adds a colored cube of the list of things to render. This cube is never removed.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Channel</th>
      <th>Bound to</th>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="6">`minecraft:debug/worldgen_attempt`</td>
      <td rowspan="6">Client</td>
      <td>Location</td>
      <td>`Position`</td>
      <td>The center of the location to render.</td>
    </tr>
    <tr>
      <td>Size</td>
      <td>`Float`</td>
      <td>Diameter/side length of a cube to render.</td>
    </tr>
    <tr>
      <td>Red</td>
      <td>`Float`</td>
      <td>Red value to render, from 0.0 to 1.0.</td>
    </tr>
    <tr>
      <td>Green</td>
      <td>`Float`</td>
      <td>Green value to render, from 0.0 to 1.0.</td>
    </tr>
    <tr>
      <td>Blue</td>
      <td>`Float`</td>
      <td>Blue value to render, from 0.0 to 1.0.</td>
    </tr>
    <tr>
      <td>Alpha</td>
      <td>`Float`</td>
      <td>Alpha value to render, from 0.0 to 1.0.</td>
    </tr>
  </tbody>
</table>

### Debug/Add POI

Used to add debugging [POI](poi.md). Never sent by the Notchian server. Requires modifications to the client to render.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Channel</th>
      <th>Bound to</th>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="3">`minecraft:debug/poi_added`</td>
      <td rowspan="3">Client</td>
      <td>Location of POI</td>
      <td>`Position`</td>
      <td></td>
    </tr>
    <tr>
      <td>POI Type</td>
      <td>`String` (32767)</td>
      <td>Type of POI, see the [POI](poi.md) article.</td>
    </tr>
    <tr>
      <td>Free tickets</td>
      <td>`Int`</td>
      <td></td>
    </tr>
  </tbody>
</table>

### Debug/Remove POI

Used to remove debugging [POI](poi.md). Never sent by the Notchian server. Requires modifications to the client to render.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Channel</th>
      <th>Bound to</th>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>`minecraft:debug/poi_ticket_count`</td>
      <td>Client</td>
      <td>Location of POI</td>
      <td>`Position`</td>
      <td></td>
    </tr>
  </tbody>
</table>

### Debug/Update POI

Used to set amount of free tickets for a given [POI](poi.md). Never sent by the Notchian server. Requires modifications to the client to render.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Channel</th>
      <th>Bound to</th>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="2">`minecraft:debug/poi_ticket_count`</td>
      <td rowspan="2">Client</td>
      <td>Location of POI</td>
      <td>`Position`</td>
      <td></td>
    </tr>
    <tr>
      <td>Free tickets</td>
      <td>`Int`</td>
      <td></td>
    </tr>
  </tbody>
</table>

### Debug/Village Sections

Used to add/remove Village Sections. Never sent by the Notchian server. Requires modifications to the client to render.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Channel</th>
      <th>Bound to</th>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="2">`minecraft:debug/village_sections`</td>
      <td rowspan="2">Client</td>
      <td>Sections to add</td>
      <td>`Specified Array` of Chunk Section Position</td>
      <td></td>
    </tr>
    <tr>
      <td>Sections to remove</td>
      <td>`Specified Array` of Chunk Section Position</td>
      <td></td>
    </tr>
  </tbody>
</table>

### Debug/Goal Selector

Used to debug goals of entities. Never sent by the Notchian server. Requires modifications to the client to render.

Adds multiple lines of text on the given location, spaced by 0.25 units upward on the Y-axis.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Channel</th>
      <th>Bound to</th>
      <th colspan="2">Field Name</th>
      <th colspan="2">Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="5">`minecraft:debug/goal_selector`</td>
      <td rowspan="5">Client</td>
      <td colspan="2">Entity ID</td>
      <td colspan="2">`Int`</td>
      <td></td>
    </tr>
    <tr>
      <td colspan="2">Location</td>
      <td colspan="2">`Position`</td>
      <td>The location of the goal selector.</td>
    </tr>
    <tr>
      <td rowspan="3">Goals</td>
      <td>Priority</td>
      <td rowspan="3">`Prefixed Array`</td>
      <td>`Int`</td>
      <td>Currently unused</td>
    </tr>
    <tr>
      <td>Is running</td>
      <td>`Boolean`</td>
      <td>Defines the color of the text. #00FF00 if true, #CCCCCC otherwise.</td>
    </tr>
    <tr>
      <td>Name</td>
      <td>`String` (255)</td>
      <td></td>
    </tr>
  </tbody>
</table>

### Debug/Brain

Used to debug villagers but renders on any entity with a brain. Never sent by the Notchian server. Requires modifications to the client to render.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Channel</th>
      <th>Bound to</th>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="20">`minecraft:debug/brain`</td>
      <td rowspan="20">Client</td>
      <td>Unique ID</td>
      <td>`UUID`</td>
      <td></td>
    </tr>
    <tr>
      <td>Entity ID</td>
      <td>`Int`</td>
      <td></td>
    </tr>
    <tr>
      <td>Name</td>
      <td>`String` (32767)</td>
      <td>A randomly generated name using the UUID.</td>
    </tr>
    <tr>
      <td>Profession</td>
      <td>`String` (32767)</td>
      <td></td>
    </tr>
    <tr>
      <td>Experience</td>
      <td>`Int`</td>
      <td></td>
    </tr>
    <tr>
      <td>Health</td>
      <td>`Float`</td>
      <td></td>
    </tr>
    <tr>
      <td>Max Health</td>
      <td>`Float`</td>
      <td></td>
    </tr>
    <tr>
      <td>X</td>
      <td>`Double`</td>
      <td></td>
    </tr>
    <tr>
      <td>Y</td>
      <td>`Double`</td>
      <td></td>
    </tr>
    <tr>
      <td>Z</td>
      <td>`Double`</td>
      <td></td>
    </tr>
    <tr>
      <td>Inventory</td>
      <td>`String` (32767)</td>
      <td>Doesn't render if empty</td>
    </tr>
    <tr>
      <td>Path</td>
      <td>`Prefixed Optional` Entity Path</td>
      <td></td>
    </tr>
    <tr>
      <td>Wants golem</td>
      <td>`Boolean`</td>
      <td></td>
    </tr>
    <tr>
      <td>Anger level</td>
      <td>`Integer`</td>
      <td>Possibly used for the warden.</td>
    </tr>
    <tr>
      <td>Possible activities</td>
      <td>`Specified Array` of `String` (32767)</td>
      <td></td>
    </tr>
    <tr>
      <td>Running tasks</td>
      <td>`Specified Array` of `String` (32767)</td>
      <td></td>
    </tr>
    <tr>
      <td>Memories</td>
      <td>`Specified Array` of `String` (32767)</td>
      <td></td>
    </tr>
    <tr>
      <td>Gossips</td>
      <td>`Specified Array` of `String` (32767)</td>
      <td></td>
    </tr>
    <tr>
      <td>POIs</td>
      <td>`Specified Array` of `Position`</td>
      <td></td>
    </tr>
    <tr>
      <td>Potential POIs</td>
      <td>`Specified Array` of `Position`</td>
      <td></td>
    </tr>
  </tbody>
</table>

### Debug/Bee

Used to debug bee pathfinding to hives and flowers. Never sent by the Notchian server. Requires modifications to the client to render.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Channel</th>
      <th>Bound to</th>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="11">`minecraft:debug/bee`</td>
      <td rowspan="11">Client</td>
      <td>Unique ID</td>
      <td>`UUID`</td>
      <td></td>
    </tr>
    <tr>
      <td>Entity ID</td>
      <td>`Int`</td>
      <td></td>
    </tr>
    <tr>
      <td>X</td>
      <td>`Double`</td>
      <td></td>
    </tr>
    <tr>
      <td>Y</td>
      <td>`Double`</td>
      <td></td>
    </tr>
    <tr>
      <td>Z</td>
      <td>`Double`</td>
      <td></td>
    </tr>
    <tr>
      <td>Path</td>
      <td>`Prefixed Optional` Entity Path</td>
      <td></td>
    </tr>
    <tr>
      <td>Hive position</td>
      <td>`Prefixed Optional` `Position`</td>
      <td></td>
    </tr>
    <tr>
      <td>Flower position</td>
      <td>`Prefixed Optional` `Position`</td>
      <td></td>
    </tr>
    <tr>
      <td>Travel ticks</td>
      <td>`Int`</td>
      <td></td>
    </tr>
    <tr>
      <td>Goals</td>
      <td>`Specified Array` of `String` (32767)</td>
      <td></td>
    </tr>
    <tr>
      <td>Blacklisted hives</td>
      <td>`Specified Array` of `Position`</td>
      <td></td>
    </tr>
  </tbody>
</table>

### Debug/Hive

Used to debug hives. Never sent by the Notchian server. Requires modifications to the client to render.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Channel</th>
      <th>Bound to</th>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="5">`minecraft:debug/hive`</td>
      <td rowspan="5">Client</td>
      <td>Location</td>
      <td>`Position`</td>
      <td></td>
    </tr>
    <tr>
      <td>Hive type</td>
      <td>`String` (32767)</td>
      <td></td>
    </tr>
    <tr>
      <td>Occupant count</td>
      <td>`Int`</td>
      <td></td>
    </tr>
    <tr>
      <td>Honey level</td>
      <td>`Int`</td>
      <td></td>
    </tr>
    <tr>
      <td>Sedated</td>
      <td>`Boolean`</td>
      <td></td>
    </tr>
  </tbody>
</table>

### Debug/Add Game Test Marker

Used to set different debug markers in the world. Never sent by the Notchian server. This interestingly renders without problems since 1.16.5.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Channel</th>
      <th>Bound to</th>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="4">`minecraft:debug/game_test_add_marker`</td>
      <td rowspan="4">Client</td>
      <td>Location</td>
      <td>`Position`</td>
      <td></td>
    </tr>
    <tr>
      <td>Color</td>
      <td>`Int`</td>
      <td>ARGB with each channel having 8 bits.</td>
    </tr>
    <tr>
      <td>Text</td>
      <td>`String` (32767)</td>
      <td>The text to display above the given location.</td>
    </tr>
    <tr>
      <td>Lifetime</td>
      <td>`Int`</td>
      <td>Given in milliseconds.</td>
    </tr>
  </tbody>
</table>

### Debug/Clear Game Test Markers

Clears all debug markers.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Channel</th>
      <th>Bound to</th>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>`minecraft:debug/game_test_clear`</td>
      <td>Client</td>
      <td colspan="3">*no fields*</td>
    </tr>
  </tbody>
</table>

### Debug/Raids

Used to set debug raid centers. Never sent by the Notchian server. Requires modifications to the client to render.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Channel</th>
      <th>Bound to</th>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>`minecraft:debug/raids`</td>
      <td>Client</td>
      <td>Locations</td>
      <td>`Prefixed Array` of `Position`</td>
      <td>Locations of raid centers.</td>
    </tr>
  </tbody>
</table>

### Debug/Game Event

Never sent, but used to debug game events. Never sent by the Notchian server. Requires modifications to the client to render.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Channel</th>
      <th>Bound to</th>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="4">`minecraft:debug/game_event`</td>
      <td rowspan="4">Client</td>
      <td>Game event type</td>
      <td>`VarInt`</td>
      <td>The ID of the type of game_event in the `minecraft:game_event` registry</td>
    </tr>
    <tr>
      <td>X</td>
      <td>`Double`</td>
      <td></td>
    </tr>
    <tr>
      <td>Y</td>
      <td>`Double`</td>
      <td></td>
    </tr>
    <tr>
      <td>Z</td>
      <td>`Double`</td>
      <td></td>
    </tr>
  </tbody>
</table>

### Debug/Add Game Event Listener

Used to add game event listeners. Never sent by the Notchian server. Requires modifications to the client to render.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Channel</th>
      <th>Bound to</th>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="3">`minecraft:debug/game_event_listeners`</td>
      <td rowspan="3">Client</td>
      <td>Listener type</td>
      <td>`VarInt`</td>
      <td>The ID of the type of position_source_type in the `minecraft:position_source_type` registry</td>
    </tr>
    <tr>
      <td>Listener data</td>
      <td>Listener data</td>
      <td>See below.</td>
    </tr>
    <tr>
      <td>Listener range</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
  </tbody>
</table>
 
Listener data for a block:
 
<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>Location</td>
      <td>`Position`</td>
      <td></td>
    </tr>
  </tbody>
</table>
 
Listener data for an entity:
 
<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>Entity ID</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
    <tr>
      <td>Y offset</td>
      <td>`Float`</td>
      <td>The y offset from the entity's position.</td>
    </tr>
  </tbody>
</table>

## Notable community plugin channels

Channels listed in this section are not used by the vanilla Minecraft client or server. This is just a likely-incomplete list of channels used by mods/plugins popular within the Minecraft community.

### Register

<table class="wikitable">
  <tbody>
    <tr>
      <th>Channel</th>
      <th>Bound to</th>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>`minecraft:register`</td>
      <td>Two-way</td>
      <td>Channels</td>
      <td>`Byte Array`</td>
      <td>An ASCII (sometimes UTF-8) string without a length prefix containing the channels separated by \u0000</td>
    </tr>
  </tbody>
</table>

Allows the client or server to register for one or more custom channels, indicating that data should be sent on those channels if the receiving end supports it too. This format is used on Bukkit, BungeeCord, Velocity and Fabric API.

### Unregister

<table class="wikitable">
  <tbody>
    <tr>
      <th>Channel</th>
      <th>Bound to</th>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>`minecraft:unregister`</td>
      <td>Two-way</td>
      <td>Channels</td>
      <td>`Byte Array`</td>
      <td>An ASCII (sometimes UTF-8) string without a length prefix containing the channels separated by \u0000</td>
    </tr>
  </tbody>
</table>

Allows the client or server to unregister from one or more custom channels, indicating that the receiving end should stop sending data on those channels. This format is used on Bukkit, BungeeCord, Velocity and Fabric API.

### "Common" standard

The common standard was created by the FabricMC, NeoForged, PaperMC and SpongePowered team because the current register channel lacked the game phase. It is currently used by Fabric API and NeoForge. The current version of the standard is 1, which contains the following payloads:

#### Supported Versions

<table class="wikitable">
  <tbody>
    <tr>
      <th>Channel</th>
      <th>Bound to</th>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>`c:version`</td>
      <td>Two-way</td>
      <td>Supported Versions</td>
      <td>`Prefixed Array` of `Integer`</td>
      <td></td>
    </tr>
  </tbody>
</table>

#### Register =

<table class="wikitable">
  <tbody>
    <tr>
      <th>Channel</th>
      <th>Bound to</th>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="3">`c:register`</td>
      <td rowspan="3">Two-way</td>
      <td>Common Version</td>
      <td>`Integer`</td>
      <td>The highest version that both the client and the server supports.</td>
    </tr>
    <tr>
      <td>Phase</td>
      <td>`String`</td>
      <td>"play" or "configuration"</td>
    </tr>
    <tr>
      <td>Channels</td>
      <td>`Prefixed Array` of `Identifier`</td>
      <td></td>
    </tr>
  </tbody>
</table>

Note: this standard only supports registering channels, not unregistering.

### BungeeCord

`bungeecord:main`

Formerly `BungeeCord`; additionally, note that the channel name is remapped by spigot so that the old name can still be used in plugins.

[See here](http://www.spigotmc.org/wiki/bukkit-bungee-plugin-messaging-channel/)

### Forge

_Main article: [Minecraft Wiki:Projects/wiki.vg merge/Minecraft Forge Handshake](./minecraft-forge-handshake.md)_

`fml:handshake`, `fml:play`

Previously `FML|HS`, `FML`

Used by [Minecraft Forge](http://www.minecraftforge.net/forum/index.php) to negotiate required mods, among other things.
[`fml:handshake` and `fml:play`](https://github.com/MinecraftForge/MinecraftForge/blob/1.15.x/src/main/java/net/minecraftforge/fml/network/NetworkInitialization.java)

### Fabric API

`fabric:accepted_attachments_v1`, `fabric:attachment_sync_v1`, `fabric:custom_ingredient_sync` and much more

### WorldEdit CUI

_Main article: [/WorldEditCUI](./worldeditcui.md)_

`worldedit:cui`

Used by the server-side [WorldEdit](http://www.enginehub.org/worldedit/) and the client-side [WorldEditCUI](http://www.minecraftforum.net/forums/mapping-and-modding/minecraft-mods/1292886-worldeditcui/) to coordinate selections.


[Category:Protocol Details](category-protocol-details.md)
[Category:Java Edition protocol](category-java-edition-protocol.md)
_Content is licensed under wiki.vg terms._
