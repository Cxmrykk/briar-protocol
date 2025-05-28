All data sent over the network (except for VarInt and VarLong) is [big-endian](wikipedia-endianness.md#big-endian), that is the bytes are sent from most significant byte to least significant byte. The majority of everyday computers are little-endian, therefore it may be necessary to change the endianness before sending data over the network.



<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Size (bytes)</th>
      <th>Encodes</th>
      <th>Notes</th>
    </tr>
    <tr>
      <th>id=Type:Boolean | `Boolean`</th>
      <td>1</td>
      <td>Either false or true</td>
      <td>True is encoded as `0x01`, false as `0x00`.</td>
    </tr>
    <tr>
      <th>id=Type:Byte | `Byte`</th>
      <td>1</td>
      <td>An integer between -128 and 127</td>
      <td>Signed 8-bit integer, [two's complement](wikipedia-twos-complement.md)</td>
    </tr>
    <tr>
      <th>id=Type:Unsigned_Byte | `Unsigned Byte`</th>
      <td>1</td>
      <td>An integer between 0 and 255</td>
      <td>Unsigned 8-bit integer</td>
    </tr>
    <tr>
      <th>id=Type:Short | `Short`</th>
      <td>2</td>
      <td>An integer between -32768 and 32767</td>
      <td>Signed 16-bit integer, two's complement</td>
    </tr>
    <tr>
      <th>id=Type:Unsigned_Short | `Unsigned Short`</th>
      <td>2</td>
      <td>An integer between 0 and 65535</td>
      <td>Unsigned 16-bit integer</td>
    </tr>
    <tr>
      <th>id=Type:Int | `Int`</th>
      <td>4</td>
      <td>An integer between -2147483648 and 2147483647</td>
      <td>Signed 32-bit integer, two's complement</td>
    </tr>
    <tr>
      <th>id=Type:Long | `Long`</th>
      <td>8</td>
      <td>An integer between -9223372036854775808 and 9223372036854775807</td>
      <td>Signed 64-bit integer, two's complement</td>
    </tr>
    <tr>
      <th>id=Type:Float | `Float`</th>
      <td>4</td>
      <td>A [single-precision 32-bit IEEE 754 floating point number](wikipedia-single-precision-floating-point-format.md)</td>
      <td></td>
    </tr>
    <tr>
      <th>id=Type:Double | `Double`</th>
      <td>8</td>
      <td>A [double-precision 64-bit IEEE 754 floating point number](wikipedia-double-precision-floating-point-format.md)</td>
      <td></td>
    </tr>
    <tr>
      <th>id=Type:String | `String` (n)</th>
      <td>≥ 1 <br />≤ (n&times;3) + 3</td>
      <td>A sequence of [Unicode](wikipedia-unicode.md) [scalar values](http://unicode.org/glossary/#unicode_scalar_value)</td>
      <td>[UTF-8](wikipedia-utf-8.md) string prefixed with its size in bytes as a VarInt.  Maximum length of `n` characters, which varies by context.  The encoding used on the wire is regular UTF-8, *not* [Java's "slight modification"](https://docs.oracle.com/en/java/javase/18/docs/api/java.base/java/io/DataInput.html#modified-utf-8).  However, the length of the string for purposes of the length limit is its number of [UTF-16](wikipedia-utf-16.md) code units, that is, scalar values > U+FFFF are counted as two. Up to `n &times; 3` bytes can be used to encode a UTF-8 string comprising `n` code units when converted to UTF-16, and both of those limits are checked.  Maximum `n` value is 32767.  The + 3 is due to the max size of a valid length VarInt.</td>
    </tr>
    <tr>
      <th>id=Type:Text_Component | `Text Component`</th>
      <td>Varies</td>
      <td>See [Text component format](text-component-format.md)</td>
      <td>Encoded as a [NBT Tag](nbt.md), with the type of tag used depending on the case:
* As a [String Tag](nbt.md#specificationstringtag): For components only containing text (no styling, no events etc.).
* As a [Compound Tag](nbt.md#specificationcompoundtag): Every other case.</td>
    </tr>
    <tr>
      <th>id=Type:JSON_Text_Component | `JSON Text Component`</th>
      <td>≥ 1 <br />≤ (262144&times;3) + 3</td>
      <td>See [Text component format](text-component-format.md)</td>
      <td>The maximum permitted length when decoding is 262144, but the vanilla server since 1.20.3 refuses to encode longer than 32767. This may be a bug.</td>
    </tr>
    <tr>
      <th>id=Type:Identifier | `Identifier`</th>
      <td>≥ 1 <br />≤ (32767&times;3) + 3</td>
      <td>See [[#Identifier|Identifier]] below</td>
      <td>Encoded as a String with max length of 32767.</td>
    </tr>
    <tr>
      <th>id=Type:VarInt | `VarInt`</th>
      <td>≥ 1 <br />≤ 5</td>
      <td>An integer between -2147483648 and 2147483647</td>
      <td>Variable-length data encoding a two's complement signed 32-bit integer; more info in [[#VarInt and VarLong|their section]]</td>
    </tr>
    <tr>
      <th>id=Type:VarLong | `VarLong`</th>
      <td>≥ 1 <br />≤ 10</td>
      <td>An integer between -9223372036854775808 and 9223372036854775807</td>
      <td>Variable-length data encoding a two's complement signed 64-bit integer; more info in [[#VarInt and VarLong|their section]]</td>
    </tr>
    <tr>
      <th>id=Type:Entity_Metadata | `Entity Metadata`</th>
      <td>Varies</td>
      <td>Miscellaneous information about an entity</td>
      <td>See [Entity metadata#Entity Metadata Format](entity-metadata.md#entity-metadata-format)</td>
    </tr>
    <tr>
      <th>id=Type:Slot | `Slot`</th>
      <td>Varies</td>
      <td>An item stack in an inventory or container</td>
      <td>See [Slot Data](slot-data.md)</td>
    </tr>
    <tr>
      <th>id=Type:Hashed_Slot | `Hashed Slot`</th>
      <td>Varies</td>
      <td>Similar to Slot, but with the data component values being sent as a hash instead of their actual contents</td>
      <td>See [Slot Data#Hashed Format](slot-data.md#hashed-format)</td>
    </tr>
    <tr>
      <th>id=Type:NBT | `NBT`</th>
      <td>Varies</td>
      <td>Depends on context</td>
      <td>See [NBT](nbt.md)</td>
    </tr>
    <tr>
      <th>id=Type:Position | `Position`</th>
      <td>8</td>
      <td>An integer/block position: x (-33554432 to 33554431), z (-33554432 to 33554431), y (-2048 to 2047)</td>
      <td>x as a 26-bit integer, followed by z as a 26-bit integer, followed by y as a 12-bit integer (all signed, two's complement). See also [[#Position|the section below]].</td>
    </tr>
    <tr>
      <th>id=Type:Angle | `Angle`</th>
      <td>1</td>
      <td>A rotation angle in steps of 1/256 of a full turn</td>
      <td>Whether or not this is signed does not matter, since the resulting angles are the same.</td>
    </tr>
    <tr>
      <th>id=Type:UUID | `UUID`</th>
      <td>16</td>
      <td>A [UUID](wikipedia-universally_unique_identifier.md)</td>
      <td>Encoded as an unsigned 128-bit integer (or two unsigned 64-bit integers: the most significant 64 bits and then the least significant 64 bits)</td>
    </tr>
    <tr>
      <th>id=Type:BitSet | `BitSet`</th>
      <td>Varies</td>
      <td>See [#BitSet](bitset.md) below</td>
      <td>A length-prefixed bit set.</td>
    </tr>
    <tr>
      <th>id=Type:Fixed_BitSet | `Fixed BitSet` (n)</th>
      <td>ceil(n / 8)</td>
      <td>See [#Fixed BitSet](fixed-bitset.md) below</td>
      <td>A bit set with a fixed length of <var>n</var> bits.</td>
    </tr>
    <tr>
      <th>id=Type:Optional | `Optional` X</th>
      <td>0 or size of X</td>
      <td>A field of type X, or nothing</td>
      <td>Whether or not the field is present must be known from the context.</td>
    </tr>
    <tr>
      <th>id=Type:Prefixed_Optional | `Prefixed Optional` X</th>
      <td>size of `Boolean` + (is present [?](wikipedia-ternary-conditional-operator.md) Size of X : 0)</td>
      <td>A boolean and if present, a field of type X</td>
      <td>The boolean is true if the field is present.</td>
    </tr>
    <tr>
      <th>id=Type:Array | `Array` of X</th>
      <td>length times size of X</td>
      <td>Zero or more fields of type X</td>
      <td>The length must be known from the context.</td>
    </tr>
    <tr>
      <th>id=Type:Prefixed_Array | `Prefixed Array` of X</th>
      <td>size of `VarInt` + size of X * length</td>
      <td>See [#Prefixed Array](prefixed-array.md) below</td>
      <td>A length-prefixed array.</td>
    </tr>
    <tr>
      <th>id=Type:Enum | X `Enum`</th>
      <td>size of X</td>
      <td>A specific value from a given list</td>
      <td>The list of possible values and how each is encoded as an X must be known from the context. An invalid value sent by either side will usually result in the client being disconnected with an error or even crashing.</td>
    </tr>
    <tr>
      <th>id=Type:EnumSet | `EnumSet` (n)</th>
      <td>ceil(n / 8)</td>
      <td>id=Type:Fixed_BitSet | `Fixed BitSet` (n)</td>
      <td>A bitset associated to an enum where each bit corresponds to an enum variant. The number of enum variants <var>n</var> must be known from the context.</td>
    </tr>
    <tr>
      <th>id=Type:Byte_Array | `Byte Array`</th>
      <td>Varies</td>
      <td>Depends on context</td>
      <td>This is just a sequence of zero or more bytes, its meaning should be explained somewhere else, e.g. in the packet description. The length must also be known from the context.</td>
    </tr>
    <tr>
      <th>id=Type:ID_or | `ID or` X</th>
      <td>size of `VarInt` + (size of X or 0)</td>
      <td>See [#ID or X](id-or-x.md) below</td>
      <td>Either a registry ID or an inline data definition of type X.</td>
    </tr>
    <tr>
      <th>id=Type:ID_Set | `ID Set`</th>
      <td>Varies</td>
      <td>See [#ID Set](id-set.md) below</td>
      <td>Set of registry IDs specified either inline or as a reference to a tag.</td>
    </tr>
    <tr>
      <th>id=Type:Sound_Event | `Sound Event`</th>
      <td>Varies</td>
      <td>See [#Sound Event](sound-event.md) below</td>
      <td>Parameters for a sound event.</td>
    </tr>
    <tr>
      <th>id=Type:Chat_Type | `Chat Type`</th>
      <td>Varies</td>
      <td>See [#Chat Type](chat-type.md) below</td>
      <td>Parameters for a direct chat type.</td>
    </tr>
    <tr>
      <th>id=Type:Teleport_Flags | `Teleport Flags`</th>
      <td>4</td>
      <td>See [#Teleport Flags](teleport-flags.md) below</td>
      <td>Bit field specifying how a teleportation is to be applied on each axis.</td>
    </tr>
    <tr>
      <th>id=Type:Recipe_Display | `Recipe Display`</th>
      <td>Varies</td>
      <td>See [Recipes#Recipe Display structure](recipes.md#recipe-display-structure)</td>
      <td>Description of a recipe for use for use by the client.</td>
    </tr>
    <tr>
      <th>id=Type:Slot_Display | `Slot Display`</th>
      <td>Varies</td>
      <td>See [Recipes#Slot Display structure](recipes.md#slot-display-structure)</td>
      <td>Description of a recipe ingredient slot for use for use by the client.</td>
    </tr>
    <tr>
      <th>id=Type:Chunk_Data | `Chunk Data`</th>
      <td>Varies</td>
      <td>See [#Chunk Data](chunk-data.md) below</td>
      <td></td>
    </tr>
    <tr>
      <th>id=Type:Light_Data | `Light Data`</th>
      <td>Varies</td>
      <td>See [#Light Data](light-data.md) below</td>
      <td></td>
    </tr>
    <tr>
      <th>id=Type:or | X `or` Y</th>
      <td>size of `Boolean` + (isX ? size of X : size of Y)</td>
      <td>A boolean and X or Y</td>
      <td>The boolean is true if X is encoded and false if Y is encoded.</td>
    </tr>
  </tbody>
</table>

### Identifier

Identifiers are a namespaced location, in the form of `minecraft:thing`.  If the namespace is not provided, it defaults to `minecraft` (i.e. `thing` is `minecraft:thing`).  Custom content should always be in its own namespace, not the default one.  Both the namespace and value can use all lowercase alphanumeric characters (a-z and 0-9), dot (`.`), dash (`-`), and underscore (`_`). In addition, values can use slash (`/`). The naming convention is `lower_case_with_underscores`.  [More information](https://minecraft.net/en-us/article/minecraft-snapshot-17w43a).  
For ease of determining whether a namespace or value is valid, here are regular expressions for each:
- Namespace: `[a-z0-9.-_]`
- Value: `[a-z0-9.-_/]`

### VarInt and VarLong

{{:Minecraft Wiki:Projects/wiki.vg merge/VarInt_And_VarLong}}

### Position

<b>Note:</b> What you are seeing here is the latest version of the [Data types](data-types.md) article, but the position type was [different before 1.14](https://wiki.vg/index.php?title=Data_types&oldid=14345#Position).

64-bit value split into three **signed** integer parts:

- x: 26 MSBs
- z: 26 middle bits
- y: 12 LSBs

For example, a 64-bit position can be broken down as follows:

Example value (big endian): `<span style="outline: solid 2px rgb(255, 0, 0)">01000110000001110110001100</span> <span style="outline: solid 2px rgb(0, 0, 255)">10110000010101101101001000</span> <span style="outline: solid 2px rgb(0, 255, 0)">001100111111</span>`<br>
- The red value is the X coordinate, which is `18357644` in this example.<br>
- The blue value is the Z coordinate, which is `-20882616` in this example.<br>
- The green value is the Y coordinate, which is `831` in this example.<br>

Encoded as follows:

 ((x & 0x3FFFFFF) << 38) | ((z & 0x3FFFFFF) << 12) | (y & 0xFFF)

And decoded as:

 val = read_long();
 x = val >> 38;
 y = val << 52 >> 52;
 z = val << 26 >> 38;

Note: The above assumes that the right shift operator sign extends the value (this is called an [arithmetic shift](https://en.wikipedia.org/wiki/Arithmetic_shift)), so that the signedness of the coordinates is preserved. In many languages, this requires the integer type of `val` to be signed. In the absence of such an operator, the following may be useful:

 if x >= 1 << 25 { x -= 1 << 26 }
 if y >= 1 << 11 { y -= 1 << 12 }
 if z >= 1 << 25 { z -= 1 << 26 }

### Fixed-point numbers

Some fields may be stored as [fixed-point numbers](https://en.wikipedia.org/wiki/Fixed-point_arithmetic), where a certain number of bits represent the signed integer part (number to the left of the decimal point) and the rest represent the fractional part (to the right). Floating point numbers (float and double), in contrast, keep the number itself (mantissa) in one chunk, while the location of the decimal point (exponent) is stored beside it. Essentially, while fixed-point numbers have lower range than floating point numbers, their fractional precision is greater for higher values.

Prior to version 1.9 a fixed-point format with 5 fraction bits and 27 integer bits was used to send entity positions to the client. Some uses of fixed point remain in modern versions, but they differ from that format.

Most programming languages lack support for fractional integers directly, but you can represent them as integers. The following C or Java-like pseudocode converts a double to a fixed-point integer with <var>n</var> fraction bits:

  x_fixed = (int)(x_double * (1 << n));

And back again:

  x_double = (double)x_fixed / (1 << n);

### Arrays

The types `Array` and `Prefixed Array` represent a collection of X in a specified order.

#### Array

Represents a list where the length is not encoded. The length must be known from the context. If the array is empty nothing will be encoded.

A `String` Array with the values ["Hello", "World!"] has the following data when encoded:

<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Value</th>
    </tr>
    <tr>
      <td>First element</td>
      <td>`String`</td>
      <td>Hello</td>
    </tr>
    <tr>
      <td>Second element</td>
      <td>`String`</td>
      <td>World!</td>
    </tr>
  </tbody>
</table>

#### Prefixed Array

Represents an array prefixed by its length. If the array is empty the length will still be encoded.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
    </tr>
    <tr>
      <td>Length</td>
      <td>`VarInt`</td>
    </tr>
    <tr>
      <td>Data</td>
      <td>`Array` of X</td>
    </tr>
  </tbody>
</table>

### Bit sets

The types `BitSet` and `Fixed BitSet` represent packed lists of bits. The vanilla implementation uses Java's [`BitSet`](https://docs.oracle.com/javase/8/docs/api/java/util/BitSet.html) class.

#### BitSet

Bit sets of type BitSet are prefixed by their length in longs.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Meaning</th>
    </tr>
    <tr>
      <td>Length</td>
      <td>`VarInt`</td>
      <td>Number of longs in the following array.  May be 0 (if no bits are set).</td>
    </tr>
    <tr>
      <td>Data</td>
      <td>`Array` of `Long`</td>
      <td>A packed representation of the bit set as created by [`BitSet.toLongArray`](https://docs.oracle.com/javase/8/docs/api/java/util/BitSet.html#toLongArray--).</td>
    </tr>
  </tbody>
</table>

The <var>i</var>th bit is set when `(Data[i / 64] & (1 << (i % 64))) != 0`, where <var>i</var> starts at 0.

#### Fixed BitSet

Bit sets of type Fixed BitSet (n) have a fixed length of <var>n</var> bits, encoded as `ceil(n / 8)` bytes. Note that this is different from BitSet, which uses longs.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Meaning</th>
    </tr>
    <tr>
      <td>Data</td>
      <td>`Byte Array` (n)</td>
      <td>A packed representation of the bit set as created by [`BitSet.toByteArray`](https://docs.oracle.com/javase/8/docs/api/java/util/BitSet.html#toByteArray--), padded with zeroes at the end to fit the specified length.</td>
    </tr>
  </tbody>
</table>

The <var>i</var>th bit is set when `(Data[i / 8] & (1 << (i % 8))) != 0`, where <var>i</var> starts at 0. This encoding is *not* equivalent to the long array in BitSet.

### Registry references

#### ID or X

Represents a data record of type X, either inline, or by reference to a registry implied by context.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Meaning</th>
    </tr>
    <tr>
      <td>ID</td>
      <td>`VarInt`</td>
      <td>0 if value of type X is given inline; otherwise registry ID + 1.</td>
    </tr>
    <tr>
      <td>Value</td>
      <td>`Optional` X</td>
      <td>Only present if ID is 0.</td>
    </tr>
  </tbody>
</table>

#### ID Set

Represents a set of IDs in a certain registry (implied by context), either directly (enumerated IDs) or indirectly (tag name).

<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Meaning</th>
    </tr>
    <tr>
      <td>Type</td>
      <td>`VarInt`</td>
      <td>Value used to determine the data that follows. It can be either:
* 0 - Represents a named set of IDs defined by a tag.
* Anything else - Represents an ad-hoc set of IDs enumerated inline.</td>
    </tr>
    <tr>
      <td>Tag Name</td>
      <td>`Optional` `Identifier`</td>
      <td>The registry tag defining the ID set. Only present if Type is 0.</td>
    </tr>
    <tr>
      <td>IDs</td>
      <td>`Optional` `Array` of `VarInt`</td>
      <td>An array of registry IDs. Only present if Type is not 0.<br>The size of the array is equal to `Type - 1`.</td>
    </tr>
  </tbody>
</table>

### Registry data

These types are commonly used in conjuction with `ID or` X to specify custom data inline.

#### Sound Event

Describes a sound that can be played.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Sound Name</td>
      <td>`Identifier`</td>
      <td></td>
    </tr>
    <tr>
      <td>Has Fixed Range</td>
      <td>`Boolean`</td>
      <td>Whether this sound has a fixed range, as opposed to a variable volume based on distance.</td>
    </tr>
    <tr>
      <td>Fixed Range</td>
      <td>`Optional` `Float`</td>
      <td>The maximum range of the sound. Only present if Has Fixed Range is true.</td>
    </tr>
  </tbody>
</table>

#### Chat Type

Describes a direct chat type that a message can be sent with.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Chat</td>
      <td>(See below)</td>
      <td></td>
    </tr>
    <tr>
      <td>Narration</td>
      <td>(See below)</td>
      <td></td>
    </tr>
  </tbody>
</table>

The chat type decorations look like:

<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Translation Key</td>
      <td>`String`</td>
      <td></td>
    </tr>
    <tr>
      <td>Parameters</td>
      <td>`Prefixed Array` of `VarInt` `Enum`</td>
      <td>0: sender, 1: target, 2: content</td>
    </tr>
    <tr>
      <td>Style</td>
      <td>`NBT`</td>
      <td></td>
    </tr>
  </tbody>
</table>

### Teleport Flags

A bit field represented as an `Int`, specifying how a teleportation is to be applied on each axis.

In the lower 8 bits of the bit field, a set bit means the teleportation on the corresponding axis is relative, and an unset bit that it is absolute.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Hex Mask</th>
      <th>Field</th>
    </tr>
    <tr>
      <td>0x0001</td>
      <td>Relative X</td>
    </tr>
    <tr>
      <td>0x0002</td>
      <td>Relative Y</td>
    </tr>
    <tr>
      <td>0x0004</td>
      <td>Relative Z</td>
    </tr>
    <tr>
      <td>0x0008</td>
      <td>Relative Yaw</td>
    </tr>
    <tr>
      <td>0x0010</td>
      <td>Relative Pitch</td>
    </tr>
    <tr>
      <td>0x0020</td>
      <td>Relative Velocity X</td>
    </tr>
    <tr>
      <td>0x0040</td>
      <td>Relative Velocity Y</td>
    </tr>
    <tr>
      <td>0x0080</td>
      <td>Relative Velocity Z</td>
    </tr>
    <tr>
      <td>0x0100</td>
      <td>Rotate velocity according to the change in rotation, *before* applying the velocity change in this packet. Combining this with absolute rotation works as expected&mdash;the difference in rotation is still used.</td>
    </tr>
  </tbody>
</table>

### Chunk Data
