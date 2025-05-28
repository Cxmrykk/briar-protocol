This article describes in additional detail the format of the [Chunk Data](packets.md#chunkdataandupdatelight) packet.

## Concepts

### Chunks columns and Chunk sections

You've probably heard the term "chunk" before. Minecraft uses chunks to store and transfer world data.  However, there are actually 2 different concepts that are both called "chunks" in different contexts: chunk columns and chunk sections.

<a id="chunk-column"></a>A **chunk column** is a collection of blocks with a horizontal size of 16&times;16, spanning the entire buildable area on the vertical axis.  This is what most players think of when they hear the term "chunk".  However, these are not the smallest unit data is stored in in the game; chunk columns are vertically divided into chunk sections, each 16 blocks tall.

Chunk columns store block entities, entities, tick data, and an array of sections.

<a id="chunk-section"></a>A **chunk section** is a 16&times;16&times;16 collection of blocks (chunk sections are cubic).  This is the actual area that blocks are stored in, and is often the concept Mojang refers to via "chunk".  Breaking columns into sections wouldn't be useful, except that you don't need to send all chunk sections in a column: If a section is empty, then it doesn't need to be sent (more on this later).

Chunk sections store blocks, biomes and light data (both block light and sky light).  Additionally, they can be associated with at most two [[#Palettes|palettes]]&mdash;one for blocks, one for biomes.  A chunk section can contain at maximum 4096 (16&times;16&times;16, or 2<sup>12</sup>) unique block state IDs, and 64 (4&times;4&times;4) unique biome IDs (but, it is highly unlikely that such a section will occur in normal circumstances).

Chunk columns and chunk sections are both displayed when chunk border rendering is enabled (<kbd>F3</kbd>+<kbd>G</kbd>).  Chunk columns borders are indicated via the red vertical lines, while chunk sections borders are indicated by the blue lines.

### Registries

The registries are the primary, protocol-wide mappings from block states and biomes to numeric identifiers.

#### Block state registry

The block state registry is hardcoded into Minecraft, and can only be changed via modding. Such changes break protocol compatibility, and as such, modding frameworks typically include protocol extensions to negotiate which IDs the client and server have in common.

One block state ID is allocated for each unique block state of a block; if a block has multiple properties then the number of allocated states is the product of the number of values for each property. The block state IDs belonging to a given block are always consecutive. Other than that, the ordering of block states is hardcoded, and somewhat arbitrary.

The [Data Generators](data-generators.md) system can be used to generate a list of all block state IDs.

#### Biome registry

The biome registry is defined at runtime in a [Registry data](registry-data.md) packet sent by the server during the Configuration phase.

The Notchian server pulls these biome definitions [from data packs](biome-definition.md).

### Palettes

![Illustration of an indexed palette ([[Commons:File:Indexed_palette.png|Source](Indexed_palette.png))]]

A palette maps a smaller set of IDs within a [[#Chunk section|chunk section]] to registry IDs. Other than skipping empty sections, correct use of palettes is the biggest place where data can be saved. For example, encoding any of the IDs in the block state registry as of vanilla 1.20.2 requires 15 bits. Given that most sections contain only a few different blocks, using 15 bits per block to represent a chunk section that is only stone, gravel, and air would be extremely wasteful.  Instead, a list of registry IDs is sent (for instance, `40 57 0`), and indices into that list&mdash;the palette&mdash;are sent as the block state or biome values within the chunk (so `40` would be sent as `0`, `57` as `1`, and `0` as `2`).<ref group="concept note">There is no requirement for IDs in a palette to be [monotonic](wikipedia-monotonic.md); the order within the list is entirely arbitrary and often has to do with how the palette is built (if it finds a stone block before an air block, stone can come first).  (However, although the order of the palette entries can be arbitrary, it can theoretically be optimized to ensure the maximum possible DEFLATE compression.  This optimization offers little to no gain, so generally do not attempt it.)  However, there shouldn't be any gaps in the palette, as gaps would increase the size of the palette when it is sent.</ref>

The number of bits used to encode palette indices varies based on the number of indices, and the registry in question. If a threshold on the number of unique IDs in the section is exceeded, a palette is not used, and registry IDs are used directly instead.

The concept of palettes is more commonly used with colors in an image; Wikipedia's articles on [color look-up tables](wikipedia-color-look-up-table.md), [indexed colors](wikipedia-indexed-color.md), and [palettes in general](wikipedia-palette-computing.md) may be helpful for fully grokking it.

> ⚠️ **Warning:** Note that the notchian client (and server) store their chunk data within the compacted, paletted format.  Sending non-compacted data not only wastes bandwidth, but also leads to increased memory use clientside; while this is OK for an initial implementation it is strongly encouraged that one compacts the block data as soon as possible.

### Notes

<references group="concept note" />

## Packet structure

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>State</th>
      <th>Bound To</th>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="7">0x27</td>
      <td rowspan="7">Play</td>
      <td rowspan="7">Client</td>
      <td>Chunk X</td>
      <td>`Int`</td>
      <td>Chunk coordinate (block coordinate divided by 16, rounded down).</td>
    </tr>
    <tr>
      <td>Chunk Z</td>
      <td>`Int`</td>
      <td>Chunk coordinate (block coordinate divided by 16, rounded down).</td>
    </tr>
    <tr>
      <td>Heightmap Count</td>
      <td>`VarInt`</td>
      <td>Number of Heightmaps.</td>
    </tr>
    <tr>
      <td>Heightmaps</td>
      <td>Heightmap Array</td>
      <td>See [#Heightmaps structure](heightmaps-structure.md) below.</td>
    </tr>
    <tr>
      <td>Size</td>
      <td>`VarInt`</td>
      <td>Size of Data in bytes; in some cases this is larger than it needs to be (e.g. [MC-131684](https://bugs.mojang.com/browse/MC-131684), [MC-247438](https://bugs.mojang.com/browse/MC-247438)) in which case extra bytes should be skipped before reading fields after Data.</td>
    </tr>
    <tr>
      <td>Data</td>
      <td>`Byte Array`</td>
      <td>See [#Data structure](data-structure.md) below.</td>
    </tr>
    <tr>
      <td>Additional Data</td>
      <td>Various</td>
      <td>See [Protocol#Chunk Data and Update Light](packets.md#chunk-data-and-update-light).</td>
    </tr>
  </tbody>
</table>

### Heightmap structure

Minecraft uses heightmaps to optimize various operations on both the server and the client. All heightmaps share the basic structure of encoding the position of the highest "occupied" block in each column of blocks within a chunk column. The differences have to do with which blocks are considered to be "occupied".

Rather than calculating them from the chunk data, the client receives the initial heightmaps it needs from the server. This trades an increase in network usage for a decrease in client-side processing. Once a chunk is loaded, the client updates its heightmaps based on block changes independently from the server.

No heightmaps are strictly required for the client to accept a chunk. If a heightmap is missing from a Chunk Data packet, the client will initialize it with all heights set to their minimum values. However, block changes will still cause the corresponding height values to be updated as normal.

As of 1.21.5, the Heightmap structure is as follows.

<table class="wikitable">
  <caption>Heightmap Structure</caption>
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>Type</td>
      <td>`VarInt`</td>
      <td>Each heightmap is prefixed with a VarInt, which is likely the type</td>
    </tr>
    <tr>
      <td>Data length</td>
      <td>`VarInt`</td>
      <td>Length of the following long array</td>
    </tr>
    <tr>
      <td>Data</td>
      <td>`Array` of `Long`</td>
      <td>Packed data array. Described below.</td>
    </tr>
  </tbody>
</table>

The height values of a heightmap are packed into the long array in the same manner described in [#Data Array format](data-array-format.md), and ordered such that the fastest-increasing coordinate is x. (However, there are only 256 entries&mdash;one for each block column.) The Bits Per Entry value used is calculated as ceil(log2(world height + 1)). This is because the number of possible height values is one more than the world height&mdash;ranging from 0 (completely blank column; not even bedrock) to world height (highest position is occupied). Note that this means, for example, that a world with height 256 will use a Bits Per Entry of 9.

The following heightmaps are currently used by the client:

<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Considers Occupied</th>
      <th>Purposes</th>
    </tr>
    <tr>
      <td>MOTION_BLOCKING</td>
      <td>"Solid" blocks, except bamboo saplings and cactuses; fluids.</td>
      <td>To determine where to display rain and snow.</td>
    </tr>
    <tr>
      <td>WORLD_SURFACE</td>
      <td>All blocks other than air, cave air and void air.</td>
      <td>To determine if a beacon beam is obstructed.</td>
    </tr>
  </tbody>
</table>

This list appears to be exhaustive as of 1.20.2. As of 1.21.5, there appears to be an additional heightmap, but the heightmap names have been removed from the packet.

### Data structure

The data section of the packet contains most of the useful data for the chunk.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>Data</td>
      <td>`Array` of [[#Chunk Section structure|Chunk Section]]</td>
      <td>This array is NOT length-prefixed. The number of elements in the array is calculated based on the world's height. Sections are sent bottom-to-top. Starting with 1.18, the world height changes based on the dimension. The height of each dimension is assigned by the server in its corresponding [registry data](registry-data.md#dimension-type) entry. For example, the vanilla overworld is 384 blocks tall, meaning 24 chunk sections will be included in this array.</td>
    </tr>
  </tbody>
</table>

#### Chunk Section structure

> 🔄 **Update (section 1):** How do biomes work now?  The biome change happened at the same time as the seed change, but it's not clear how/if biomes could be computed given that it's not the actual seed...  ([/r/mojira discussion](https://www.reddit.com/r/Mojira/comments/e5at6i/a_discussion_for_the_changes_to_how_biomes_are/) which notes that it seems to be some kind of interpolation)

A Chunk Section is defined in terms of other [data types](data-types.md). A Chunk Section consists of the following fields:

<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>Block count</td>
      <td>`Short`</td>
      <td>Number of non-air blocks present in the chunk section. "Non-air" is defined as any fluid and block other than air, cave air, and void air. The client will keep count of the blocks as they are broken and placed, and, if the block count reaches 0, the whole chunk section is not rendered, even if it still has blocks.</td>
    </tr>
    <tr>
      <td>Block states</td>
      <td>[[#Paletted Container structure|Paletted Container]]</td>
      <td>Consists of 4096 entries, representing all the blocks in the chunk section.</td>
    </tr>
    <tr>
      <td>Biomes</td>
      <td>[[#Paletted Container structure|Paletted Container]]</td>
      <td>Consists of 64 entries, representing 4&times;4&times;4 biome regions in the chunk section.</td>
    </tr>
  </tbody>
</table>

## Paletted Container structure

A Paletted Container is a palette-based storage of entries. Paletted Containers have an associated registry (either block states or biomes as of now), where values are mapped from. A Paletted Container consists of the following fields:

<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>Bits Per Entry</td>
      <td>`Unsigned Byte`</td>
      <td>Determines how many bits are used to encode entries. Note that not all numbers are valid here.</td>
    </tr>
    <tr>
      <td>Palette</td>
      <td>Varies</td>
      <td>See [#Palette formats](palette-formats.md) below.</td>
    </tr>
    <tr>
      <td>Data Array</td>
      <td>`Array` of `Long`</td>
      <td>See [#Data Array format](data-array-format.md) below.</td>
    </tr>
  </tbody>
</table>

### Palette formats

The Bits Per Entry value determines what format is used for the palette.

> ⚠️ **Warning:** Values not listed in the following table are rounded upwards to the next one specified, or downwards if larger than the value for Direct. Therefore such values will lead to unexpected results, and should not be used.

There are currently three possible palette formats:

<table class="wikitable">
  <tbody>
    <tr>
      <th><abbr title="Bits Per Entry">BPE</abbr> (blocks)</th>
      <th><abbr title="Bits Per Entry">BPE</abbr> (biomes)</th>
      <th>Palette Format</th>
    </tr>
    <tr>
      <td>0</td>
      <td>0</td>
      <td>[[#Single valued|Single valued]]</td>
    </tr>
    <tr>
      <td>4-8</td>
      <td>1-3</td>
      <td>[[#Indirect|Indirect]]</td>
    </tr>
    <tr>
      <td>15**</td>
      <td>6*</td>
      <td>[[#Direct|Direct]]</td>
    </tr>
  </tbody>
</table>

*The Notchian client calculates the Bits Per Entry values for the Direct palette format at runtime based on the sizes of the block state and biome registries. As such, the value used for biomes is entirely dependent on the contents of the biome registry sent in the [Registry Data](registry-data.md) packet; the value shown is only valid for vanilla servers with no custom data packs. If the BPE requirement for Direct is less than or equal to the maximum for Indirect, Direct will never be used given BPE values within the valid range.

**Similarly, if a sufficiently large number of blocks is added with mods, the value will be increased to compensate for the increased ID count. This increase can go up to 31 bits per entry (since registry IDs are signed integers). In case of Minecraft Forge, you can get the number of blocks with the "Number of ids" field found in the [RegistryData packet in the Forge Handshake](minecraft-forge-handshake.md#registrydata).

#### Single valued

When this palette is used, the Data Array sent/received is empty, since entries can be inferred from the palette's single value.

<table class="wikitable">
  <tbody>
    <tr>
      <td>- class="tc-yes"</td>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>Value</td>
      <td>`VarInt`</td>
      <td>ID of the corresponding entry in its registry.</td>
    </tr>
  </tbody>
</table>

#### Indirect

This is an actual palette which lists the entries used. Values in the Data Array are indices into the palette, which in turn gives a proper registry ID.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>Palette Length</td>
      <td>`VarInt`</td>
      <td>Number of elements in the following array.</td>
    </tr>
    <tr>
      <td>Palette</td>
      <td>`Array` of `VarInt`</td>
      <td>Mapping of IDs in the registry to indices of this array.</td>
    </tr>
  </tbody>
</table>

#### Direct

Registry IDs are stored directly as entries in the Data Array.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td colspan="3">*no fields*</td>
    </tr>
  </tbody>
</table>

#### Example

Here is an example showing a Chunk Section using a single-valued palette for block states, and an indirect palette with 2 indices for biomes:

<code
><span style="border: 2px solid red">00 00</span
><span style="border: 2px solid orange">00</span
><span style="border: 2px solid lime">00</span
><span style="border: 2px solid orange">01</span
><span style="border: 2px solid yellow">02</span
><span style="border: 2px solid lime">27 03</span
><span style="border: 2px solid green">01</span
><span style="border: 2px solid aqua">CC FF CC FF CC FF CC FF</span
></code>
  
The first bytes <span style="border: 2px solid red">00 00</span> are the number of non-air blocks in the chunk.
They are followed by the Bits Per Entry <span style="border: 2px solid orange">00</span>, which is zero so we know the palette will have one element (not prefixed with length). This single element is the block state ID of air, <span style="border: 2px solid lime">00</span>.
  
The second part of the packet is for biomes. The first byte is their Bits Per Entry <span style="border: 2px solid orange">01</span>, followed by the length of the palette <span style="border: 2px solid yellow">02</span> and the two elements <span style="border: 2px solid lime">27 03</span>. The indexed data of this biome has <span style="border: 2px solid green">01</span> long element, which are 8 bytes each, giving the long <span style="border: 2px solid aqua">CC FF CC FF CC FF CC FF</span>.

### Data Array format

As of 1.21.5, the length of the data array is no longer sent with the packet, but is instead calculated from the bits per entry and the number of entries.

The Data Array stores entries as Bits Per Entry&ndash;bit integers, corresponding to either palette indices or registry IDs depending on the palette format in use. If Bits Per Entry is 0, it is empty.

Entries are stored in order of increasing x coordinate, within rows at increasing z coordinates, within layers at increasing y coordinates. In other words, if the Data Array were a multidimensional array in C (modulo the packed encoding), it would be indexed <code style="white-space: pre">array[y][z][x]</code>.

A single long of the array holds several entries. The entries are tightly packed within the long, with the first entry on the least significant bits. An entry cannot span across multiple longs; instead, padding is inserted as required, starting from the most significant bits.

For example, assuming a bits per block value of 15, and that bit 0 is the least significant bit, the data is stored such that bits 0 through 14 are the first entry, 15 through 29 are the second, and so on. The fourth entry ends on bit 59, and since only 4 bits are left, they become padding, and the fifth entry starts on the next long.

Note that since longs are sent in big endian order, the least significant bit of the first entry in a long will be on the *last* byte of the long on the wire.

> ⚠️ **Warning:** This format was changed in Minecraft 1.16. In prior versions, entries could cross long boundaries, and there was no padding.

#### Visual example

5 bits per block, containing the following references to entries in a palette (not shown):
<code
><span style="border: solid 2px hsl(  0, 90%, 60%); margin-left: -2px; padding: 0 1px">1</span
><span style="border: solid 2px hsl( 30, 90%, 60%); margin-left: -2px; padding: 0 1px">2</span
><span style="border: solid 2px hsl( 60, 90%, 60%); margin-left: -2px; padding: 0 1px">2</span
><span style="border: solid 2px hsl( 90, 90%, 60%); margin-left: -2px; padding: 0 1px">3</span
><span style="border: solid 2px hsl(120, 90%, 60%); margin-left: -2px; padding: 0 1px">4</span
><span style="border: solid 2px hsl(150, 90%, 60%); margin-left: -2px; padding: 0 1px">4</span
><span style="border: solid 2px hsl(180, 90%, 60%); margin-left: -2px; padding: 0 1px">5</span
><span style="border: solid 2px hsl(210, 90%, 60%); margin-left: -2px; padding: 0 1px">6</span
><span style="border: solid 2px hsl(240, 90%, 60%); margin-left: -2px; padding: 0 1px">6</span
><span style="border: solid 2px hsl(270, 90%, 60%); margin-left: -2px; padding: 0 1px">4</span
><span style="border: solid 2px hsl(300, 90%, 60%); margin-left: -2px; padding: 0 1px">8</span
><span style="border: solid 2px hsl(330, 90%, 60%); margin-left: -2px; padding: 0 1px">0</span
><span style="border: solid 2px hsl(  0, 90%, 30%); margin-left: -2px; padding: 0 1px">7</span
><span style="border: solid 2px hsl( 30, 90%, 30%); margin-left: -2px; padding: 0 1px">4</span
><span style="border: solid 2px hsl( 60, 90%, 30%); margin-left: -2px; padding: 0 1px">3</span
><span style="border: solid 2px hsl( 90, 90%, 30%); margin-left: -2px; padding: 0 1px">13</span
><span style="border: solid 2px hsl(120, 90%, 30%); margin-left: -2px; padding: 0 1px">15</span
><span style="border: solid 2px hsl(150, 90%, 30%); margin-left: -2px; padding: 0 1px">16</span
><span style="border: solid 2px hsl(180, 90%, 30%); margin-left: -2px; padding: 0 1px">9</span
><span style="border: solid 2px hsl(210, 90%, 30%); margin-left: -2px; padding: 0 1px">14</span
><span style="border: solid 2px hsl(240, 90%, 30%); margin-left: -2px; padding: 0 1px">10</span
><span style="border: solid 2px hsl(270, 90%, 30%); margin-left: -2px; padding: 0 1px">12</span
><span style="border: solid 2px hsl(300, 90%, 30%); margin-left: -2px; padding: 0 1px">0</span
><span style="border: solid 2px hsl(330, 90%, 30%); margin:    0 -2px; padding: 0 1px">2</span
></code>

`0020863148418841`<code
><span style="border: dashed 2px black;             margin-left: -2px">0000</span
><span style="border: solid 2px hsl(330, 90%, 60%); margin-left: -2px">00000</span
><span style="border: solid 2px hsl(300, 90%, 60%); margin-left: -2px">01000</span
><span style="border: solid 2px hsl(270, 90%, 60%); margin-left: -2px">00100</span
><span style="border: solid 2px hsl(240, 90%, 60%); margin-left: -2px">00110</span
><span style="border: solid 2px hsl(210, 90%, 60%); margin-left: -2px">00110</span
><span style="border: solid 2px hsl(180, 90%, 60%); margin-left: -2px">00101</span
><span style="border: solid 2px hsl(150, 90%, 60%); margin-left: -2px">00100</span
><span style="border: solid 2px hsl(120, 90%, 60%); margin-left: -2px">00100</span
><span style="border: solid 2px hsl( 90, 90%, 60%); margin-left: -2px">00011</span
><span style="border: solid 2px hsl( 60, 90%, 60%); margin-left: -2px">00010</span
><span style="border: solid 2px hsl( 30, 90%, 60%); margin-left: -2px">00010</span
><span style="border: solid 2px hsl(  0, 90%, 60%); margin:    0 -2px">00001</span
></code></br>
`01018A7260F68C87`<code
><span style="border: dashed 2px black;             margin-left: -2px">0000</span
><span style="border: solid 2px hsl(330, 90%, 30%); margin-left: -2px">00010</span
><span style="border: solid 2px hsl(300, 90%, 30%); margin-left: -2px">00000</span
><span style="border: solid 2px hsl(270, 90%, 30%); margin-left: -2px">01100</span
><span style="border: solid 2px hsl(240, 90%, 30%); margin-left: -2px">01010</span
><span style="border: solid 2px hsl(210, 90%, 30%); margin-left: -2px">01110</span
><span style="border: solid 2px hsl(180, 90%, 30%); margin-left: -2px">01001</span
><span style="border: solid 2px hsl(150, 90%, 30%); margin-left: -2px">10000</span
><span style="border: solid 2px hsl(120, 90%, 30%); margin-left: -2px">01111</span
><span style="border: solid 2px hsl( 90, 90%, 30%); margin-left: -2px">01101</span
><span style="border: solid 2px hsl( 60, 90%, 30%); margin-left: -2px">00011</span
><span style="border: solid 2px hsl( 30, 90%, 30%); margin-left: -2px">00100</span
><span style="border: solid 2px hsl(  0, 90%, 30%); margin:    0 -2px">00111</span
></code>

## Tips and notes

There are several things that can make it easier to implement this format.

- Servers do <em>not</em> need to implement the palette initially (instead always using 15 bits per block), although it is an important optimization later on.
- The Notchian server implementation does not send values that are out of bounds for the palette.  If such a value is received, the format is being parsed incorrectly.  In particular, if you're reading a number with all bits set (15, 31, etc), you might be reading skylight data (or you may have a sign error and you're reading negative numbers).
- The Notchian client generally does not render chunks that lack neighbors.  (As of 1.20.2 such chunks appear to sporadically become visible anyway, and do so consistently when interacted with.)  This means that if you only send a fixed set of chunks with no empty chunks around them, then some of them will not be visible, although you can still interact with them.  This is intended behavior, so that lighting and connected blocks can be handled correctly.

## Sample implementations

> 🔄 **Update (section 1):** This sample code is missing the heightmap, biome changes and the changes from 1.16

How the chunk format can be implemented varies largely by how you want to read/write it.  It is often easier to read/write the data long-by-long instead of pre-create the data to write; however, storing the chunk data arrays in their packed form can be far more efficient memory- and performance-wise.  These implementations are simple versions that can work as a base (especially for dealing with the bit shifting), but are not ideal.

### Shared code

This is some basic pseudocode that shows the various types of palettes.  It does not handle actually populating the palette based on data in a chunk section; handling this is left as for the implementer since there are many ways of doing so.  (This does not apply for the direct version).

```csharp
private uint GetGlobalPaletteIDFromState(BlockState state) {
    // Implementation left to the user; see Data Generators for more info on the values
}

private BlockState GetStateFromGlobalPaletteID(uint value) {
    // Implementation left to the user; see Data Generators for more info on the values
}

public interface Palette {
    uint IdForState(BlockState state);
    BlockState StateForId(uint id);
    byte GetBitsPerBlock();
    void Read(Buffer data);
    void Write(Buffer data);
}

public class IndirectPalette : Palette {
    Map<uint, BlockState> idToState;
    Map<BlockState, uint> stateToId;
    byte bitsPerBlock;

    public IndirectPalette(byte palBitsPerBlock) {
        bitsPerBlock = palBitsPerBlock;
    }

    public uint IdForState(BlockState state) {
        return stateToId.Get(state);
    }

    public BlockState StateForId(uint id) {
        return idToState.Get(id);
    }

    public byte GetBitsPerBlock() {
        return bitsPerBlock;
    }

    public void Read(Buffer data) {
        idToState = new Map<>();
        stateToId = new Map<>();
        // Palette Length
        int length = ReadVarInt();
        // Palette
        for (int id = 0; id < length; id++) {
            uint stateId = ReadVarInt();
            BlockState state = GetStateFromGlobalPaletteID(stateId);
            idToState.Set(id, state);
            stateToId.Set(state, id);
        }
    }

    public void Write(Buffer data) {
        Assert(idToState.Size() == stateToId.Size()); // both should be equivalent
        // Palette Length
        WriteVarInt(idToState.Size());
        // Palette
        for (int id = 0; id < idToState.Size(); id++) {
            BlockState state = idToState.Get(id);
            uint stateId = GetGlobalPaletteIDFromState(state);
            WriteVarInt(stateId);
        }
    }
}

public class DirectPalette : Palette {
    public uint IdForState(BlockState state) {
        return GetGlobalPaletteIDFromState(state);
    }

    public BlockState StateForId(uint id) {
        return GetStateFromGlobalPaletteID(id);
    }

    public byte GetBitsPerBlock() {
        return Ceil(Log2(BlockState.TotalNumberOfStates)); // currently 15
    }

    public void Read(Buffer data) {
        // No Data
    }

    public void Write(Buffer data) {
        // No Data
    }
}

public Palette ChoosePalette(byte bitsPerBlock) {
    if (bitsPerBlock <= 4) {
        return new IndirectPalette(4);
    } else if (bitsPerBlock <= 8) {
        return new IndirectPalette(bitsPerBlock);
    } else {
        return new DirectPalette();
    }
}
```

### Deserializing

When deserializing, it is easy to read to a buffer (since length information is present).  A basic example:

```csharp
public Chunk ReadChunkDataPacket(Buffer data) {
    int x = ReadInt(data);
    int z = ReadInt(data);
    bool full = ReadBool(data);
    Chunk chunk;
    if (full) {
        chunk = new Chunk(x, z);
    } else {
        chunk = GetExistingChunk(x, z);
    }
    int mask = ReadVarInt(data);
    int size = ReadVarInt(data);
    ReadChunkColumn(chunk, full, mask, data.ReadByteArray(size));

    int blockEntityCount = ReadVarInt(data);
    for (int i = 0; i < blockEntityCount; i++) {
        CompoundTag tag = ReadCompoundTag(data);
        chunk.AddBlockEntity(tag.GetInt("x"), tag.GetInt("y"), tag.GetInt("z"), tag);
    }

    return chunk;
}

private void ReadChunkColumn(Chunk chunk, bool full, int mask, Buffer data) {
    for (int sectionY = 0; sectionY < (CHUNK_HEIGHT / SECTION_HEIGHT); y++) {
        if ((mask & (1 << sectionY)) != 0) {  // Is the given bit set in the mask?
            byte bitsPerBlock = ReadByte(data);
            Palette palette = ChoosePalette(bitsPerBlock);
            palette.Read(data);

            // A bitmask that contains bitsPerBlock set bits
            uint individualValueMask = (uint)((1 << bitsPerBlock) - 1);

            int dataArrayLength = ReadVarInt(data);
            UInt64[] dataArray = ReadUInt64Array(data, dataArrayLength);

            ChunkSection section = new ChunkSection();

            for (int y = 0; y < SECTION_HEIGHT; y++) {
                for (int z = 0; z < SECTION_WIDTH; z++) {
                    for (int x = 0; x < SECTION_WIDTH; x++) {
                        int blockNumber = (((y * SECTION_HEIGHT) + z) * SECTION_WIDTH) + x;
                        int startLong = (blockNumber * bitsPerBlock) / 64;
                        int startOffset = (blockNumber * bitsPerBlock) % 64;
                        int endLong = ((blockNumber + 1) * bitsPerBlock - 1) / 64;

                        uint data;
                        if (startLong == endLong) {
                            data = (uint)(dataArray[startLong] >> startOffset);
                        } else {
                            int endOffset = 64 - startOffset;
                            data = (uint)(dataArray[startLong] >> startOffset | dataArray[endLong] << endOffset);
                        }
                        data &= individualValueMask;

                        // data should always be valid for the palette
                        // If you're reading a power of 2 minus one (15, 31, 63, 127, etc...) that's out of bounds,
                        // you're probably reading light data instead

                        BlockState state = palette.StateForId(data);
                        section.SetState(x, y, z, state);
                    }
                }
            }

            for (int y = 0; y < SECTION_HEIGHT; y++) {
                for (int z = 0; z < SECTION_WIDTH; z++) {
                    for (int x = 0; x < SECTION_WIDTH; x += 2) {
                        // Note: x += 2 above; we read 2 values along x each time
                        byte value = ReadByte(data);

                        section.SetBlockLight(x, y, z, value & 0xF);
                        section.SetBlockLight(x + 1, y, z, (value >> 4) & 0xF);
                    }
                }
            }

            if (currentDimension.HasSkylight()) { // IE, current dimension is overworld / 0
                for (int y = 0; y < SECTION_HEIGHT; y++) {
                    for (int z = 0; z < SECTION_WIDTH; z++) {
                        for (int x = 0; x < SECTION_WIDTH; x += 2) {
                            // Note: x += 2 above; we read 2 values along x each time
                            byte value = ReadByte(data);

                            section.SetSkyLight(x, y, z, value & 0xF);
                            section.SetSkyLight(x + 1, y, z, (value >> 4) & 0xF);
                        }
                    }
                }
            }

            // May replace an existing section or a null one
            chunk.Sections[SectionY] = section;
        }
    }

    for (int z = 0; z < SECTION_WIDTH; z++) {
        for (int x = 0; x < SECTION_WIDTH; x++) {
            chunk.SetBiome(x, z, ReadInt(data));
        }
    }
}
```

### Serializing

Serializing the packet is more complicated, because of the palette.  It is easy to implement with the full bits per block value; implementing it with a compacting palette is much harder since algorithms to generate and resize the palette must be written.  As such, this example <strong>does not generate a palette</strong>.  The palette is a good performance improvement (as it can significantly reduce the amount of data sent), but managing that is much harder and there are a variety of ways of implementing it.

Also note that this implementation doesn't handle situations where full is false (ie, making a large change to one section); it's only good for serializing a full chunk.

```csharp
public void WriteChunkDataPacket(Chunk chunk, Buffer data) {
    WriteInt(data, chunk.GetX());
    WriteInt(data, chunk.GetZ());
    WriteBool(true);  // Full

    int mask = 0;
    Buffer columnBuffer = new Buffer();
    for (int sectionY = 0; sectionY < (CHUNK_HEIGHT / SECTION_HEIGHT); y++) {
        if (!chunk.IsSectionEmpty(sectionY)) {
            mask |= (1 << chunkY);  // Set that bit to true in the mask
            WriteChunkSection(chunk.Sections[sectionY], columnBuffer);
        }
    }
    for (int z = 0; z < SECTION_WIDTH; z++) {
        for (int x = 0; x < SECTION_WIDTH; x++) {
            WriteInt(columnBuffer, chunk.GetBiome(x, z));  // Use 127 for 'void' if your server doesn't support biomes
        }
    }

    WriteVarInt(data, mask);
    WriteVarInt(data, columnBuffer.Size);
    WriteByteArray(data, columnBuffer);

    // If you don't support block entities yet, use 0
    // If you need to implement it by sending block entities later with the update block entity packet,
    // do it that way and send 0 as well.  (Note that 1.10.1 (not 1.10 or 1.10.2) will not accept that)

    WriteVarInt(data, chunk.BlockEntities.Length);
    foreach (CompoundTag tag in chunk.BlockEntities) {
        WriteCompoundTag(data, tag);
    }
}

private void WriteChunkSection(ChunkSection section, Buffer buf) {
    Palette palette = section.palette;
    byte bitsPerBlock = palette.GetBitsPerBlock();

    WriteByte(bitsPerBlock);
    palette.Write(buf);

    int dataLength = (16*16*16) * bitsPerBlock / 64; // See tips section for an explanation of this calculation
    UInt64[] data = new UInt64[dataLength];

    // A bitmask that contains bitsPerBlock set bits
    uint individualValueMask = (uint)((1 << bitsPerBlock) - 1);

    for (int y = 0; y < SECTION_HEIGHT; y++) {
        for (int z = 0; z < SECTION_WIDTH; z++) {
            for (int x = 0; x < SECTION_WIDTH; x++) {
                int blockNumber = (((y * SECTION_HEIGHT) + z) * SECTION_WIDTH) + x;
                int startLong = (blockNumber * bitsPerBlock) / 64;
                int startOffset = (blockNumber * bitsPerBlock) % 64;
                int endLong = ((blockNumber + 1) * bitsPerBlock - 1) / 64;

                BlockState state = section.GetState(x, y, z);

                UInt64 value = palette.IdForState(state);
                value &= individualValueMask;

                data[startLong] |= (value << startOffset);

                if (startLong != endLong) {
                    data[endLong] = (value >> (64 - startOffset));
                }
            }
        }
    }

    WriteVarInt(dataLength);
    WriteLongArray(data);

    for (int y = 0; y < SECTION_HEIGHT; y++) {
        for (int z = 0; z < SECTION_WIDTH; z++) {
            for (int x = 0; x < SECTION_WIDTH; x += 2) {
                // Note: x += 2 above; we read 2 values along x each time
                byte value = section.GetBlockLight(x, y, z) | (section.GetBlockLight(x + 1, y, z) << 4);
                WriteByte(data, value);
            }
        }
    }

    if (currentDimension.HasSkylight()) { // IE, current dimension is overworld / 0
        for (int y = 0; y < SECTION_HEIGHT; y++) {
            for (int z = 0; z < SECTION_WIDTH; z++) {
                for (int x = 0; x < SECTION_WIDTH; x += 2) {
                    // Note: x += 2 above; we read 2 values along x each time
                    byte value = section.GetSkyLight(x, y, z) | (section.GetSkyLight(x + 1, y, z) << 4);
                    WriteByte(data, value);
                }
            }
        }
    }
}
```

## Full implementations

- [Java, 1.12.2, writing only, with palette](https://github.com/GlowstoneMC/Glowstone/blob/dev/src/main/java/net/glowstone/chunk/ChunkSection.java)
- [Rust, 1.16.5, with palette](https://github.com/feather-rs/feather/blob/main/feather/base/src/chunk.rs)
- [Java, 1.9, both sides](https://github.com/Steveice10/MCProtocolLib/blob/4ed72deb75f2acb0a81d641717b7b8074730f701/src/main/java/org/spacehq/mc/protocol/data/game/chunk/BlockStorage.java#L42)
- [Python, 1.7 through 1.13](https://github.com/barneygale/quarry). Read/write, paletted/unpaletted, [packets](https://github.com/barneygale/quarry/blob/master/quarry/types/buffer/v1_7.py#L403)/[arrays](https://github.com/barneygale/quarry/blob/master/quarry/types/chunk.py)
- [Python, 1.9, reading only](https://github.com/SpockBotMC/SpockBot/blob/0535c31/spockbot/plugins/tools/smpmap.py#L144-L183)
- [C, 1.9, reading only](https://github.com/Protryon/Osmium/blob/fdd61b9/MinecraftClone/src/ingame.c#L512-L632)
- [C, 1.11.2, writing only](https://github.com/Protryon/Basin/blob/master/basin/src/packet.c#L1124)
- [C++, 1.12.2, writing only](https://github.com/cuberite/cuberite/blob/master/src/Protocol/ChunkDataSerializer.cpp#L190)
- [Node.js, 1.8->1.18](https://github.com/PrismarineJS/prismarine-chunk)

## Sample data

- [some sample data](https://gist.github.com/Pokechu22/0b89f928b381dede0387fe5f88faf8c0) from 1.13.2, with both complete packets and just the data structures
- [prismarine test data](https://github.com/PrismarineJS/prismarine-chunk/tree/master/test) chunks from 1.8 to 1.20 used as testing data, generated using automated [chunk-dumper](https://github.com/PrismarineJS/minecraft-chunk-dumper)

### Old format

The following implement the [previous](https://web.archive.org/https://wiki.vg/index.php?title=SMP_Map_Format&oldid=7164) (before 1.9) format:

- [Java, 1.8](https://github.com/GlowstoneMC/Glowstone/blob/d3ed79ea7d284df1d2cd1945bf53d5652962a34f/src/main/java/net/glowstone/GlowChunk.java#L640)
- [Python, 1.4](https://github.com/barneygale/smpmap)


[Category:Protocol Details](category-protocol-details.md)
[Category:Java Edition protocol](category-java-edition-protocol.md)
_Content is licensed under wiki.vg terms._
