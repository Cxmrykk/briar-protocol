The Named Binary Tag (NBT) file format is an extremely simple and efficient structured binary format used by Minecraft for a variety of things. Due to this, several third-party utilities now also utilize the format. You may find example files at the bottom of this article.

Mojang has released a reference implementation along with their Anvil conversion tool, available from [this archived page](https://web.archive.org/web/20190710093131/https://mojang.com/2012/02/new-minecraft-map-format-anvil/)

## Current Uses
The NBT format is currently used in several places, chiefly:
- In the [Protocol](protocol.md) as part of [Slot Data](slot-data.md)
- Multiplayer saved server list (`servers.dat`).
- Player data (both single player and multiplayer, one file per player). This includes such things as inventory and location.
- Saved worlds (both single player and multiplayer).
** World index file (`level.dat`) that contains general information (spawn point, time of day, etc...)
** Chunk data (see [Region Files](region-files.md))

NBT files you can encounter as a developer will be stored in three different ways, mainly the second variation as per Notch's original specification.
- Uncompressed,
- [gzip'd](wikipedia-gzip.md),
- [zlib'd](wikipedia-zlib.md) (aka DEFLATE with a few bytes extra)

### Libraries

There are many, many libraries for manipulating NBT, written in several languages, and often several per language. For example,

<table class="wikitable sortable">
  <tbody>
    <tr>
      <td>-style="background:#eee"</td>
      <th>Name</th>
      <th>Description</th>
      <th>Language</th>
    </tr>
    <tr>
      <th>[cNBT](https://github.com/nickelpro/cNBT)</th>
      <td>As simple (and, consequently, as fast) as possible NBT file parser.</td>
      <td>{{proglang|C}}</td>
    </tr>
    <tr>
      <th>[libnbt](https://sr.ht/~azbantium/libnbt/)</th>
      <td>A lightweight library to work with NBT, written in C.</td>
      <td>{{proglang|C}}</td>
    </tr>
    <tr>
      <th>[libnbt++](https://github.com/PrismLauncher/libnbtplusplus)</th>
      <td>A free C++ library for Minecraft's file format Named Binary Tag (NBT).</td>
      <td>{{proglang|C++}}</td>
    </tr>
    <tr>
      <th>[cpp-nbt](https://github.com/SpockBotMC/cpp-nbt)</th>
      <td>A C++23 header-only library for reading/writing Minecraft NBT data.</td>
      <td>{{proglang|C++}}</td>
    </tr>
    <tr>
      <th>[Raspite](https://github.com/TheVeryStarlk/Raspite)</th>
      <td>A fast, lightweight, and easy-to-use NBT serialization library.</td>
      <td>{{proglang|C#}}</td>
    </tr>
    <tr>
      <th>[Venom](https://github.com/Bentechy66/venom)</th>
      <td>An NBT decoder written in pure Elixir.</td>
      <td>[Elixir](https://elixir-lang.org/)</td>
    </tr>
    <tr>
      <th>[go-nbt](https://github.com/Tnze/go-mc/tree/master/nbt)</th>
      <td>This package implements the Named Binary Tag format of Minecraft.</td>
      <td>{{proglang|go}}</td>
    </tr>
    <tr>
      <th>[jChatLib](https://github.com/Defective4/jChatLib)</th>
      <td>A simple NBT library made with new text component format in mind</td>
      <td>{{proglang|Java}}</td>
    </tr>
    <tr>
      <th>[BitBuf/nbt](https://github.com/BitBuf/nbt)</th>
      <td>Flexible and intuitive library for reading and writing Minecraft's NBT format.</td>
      <td>{{proglang|Java}}</td>
    </tr>
    <tr>
      <th>[hephaistos](https://github.com/jglrxavpok/hephaistos)</th>
      <td>This library is both a NBT library and a Minecraft Anvil format library.</td>
      <td>{{proglang|Java|Kotlin}}</td>
    </tr>
    <tr>
      <th>[Nedit](https://github.com/TheNullicorn/Nedit)</th>
      <td>A simple, lightweight NBT parsing library</td>
      <td>{{proglang|Java}}</td>
    </tr>
    <tr>
      <th>[NBT.js](https://github.com/sjmulder/nbt-js)</th>
      <td>A JavaScript parser and serializer for NBT archives.</td>
      <td>{{proglang|JavaScript}}</td>
    </tr>
    <tr>
      <th>[NBTify](https://github.com/Offroaders123/NBTify)</th>
      <td>Parser & writer NBT library intended for usage in a web browser.</td>
      <td>{{proglang|JavaScript|TypeScript}}</td>
    </tr>
    <tr>
      <th>[knbt](https://github.com/BenWoodworth/knbt)</th>
      <td>Kotlin NBT library for kotlinx.serialization.</td>
      <td>{{proglang|Kotlin}}</td>
    </tr>
    <tr>
      <th>[KotlinNBT](https://github.com/luizrcs/KotlinNBT)</th>
      <td>With a builder DSL and type-safety</td>
      <td>{{proglang|Kotlin}}</td>
    </tr>
    <tr>
      <th>[simpleNBT](https://gist.github.com/camdenorrb/bec73c5608267f0232bd8f5c42e0784d)</th>
      <td>Streams, ByteBuffer, NIO, Endianness, Zlib, Gzip, Any Input/Output, Examples in Comments.</td>
      <td>{{proglang|Kotlin}}</td>
    </tr>
    <tr>
      <th>[TagForge](https://github.com/Nimberite-Development/TagForge-Nim)</th>
      <td>A library made for the serialisation and deserialisation of MC NBT!</td>
      <td>[Nim](https://nim-lang.org/)</td>
    </tr>
    <tr>
      <th>[php-nbt](https://github.com/aternosorg/php-nbt)</th>
      <td>A full PHP implementation of Minecraft's Named Binary Tag (NBT) format.</td>
      <td>{{proglang|PHP}}</td>
    </tr>
    <tr>
      <th>[NBT](https://github.com/twoolie/NBT)</th>
      <td>This is mainly a Named Binary Tag parser & writer library.</td>
      <td>{{proglang|Python}}</td>
    </tr>
    <tr>
      <th>[HematiteNBT](https://github.com/CorentinPtrl/hematite_nbt)</th>
      <td>A full-featured Rust crate for Minecraft's NBT file format, including Serde support.</td>
      <td>{{proglang|Rust}}</td>
    </tr>
    <tr>
      <th>[Quartz NBT](https://github.com/Rusty-Quartz/quartz_nbt)</th>
      <td>Provides support for encoding and decoding Minecraft's NBT format.</td>
      <td>{{proglang|Rust}}</td>
    </tr>
    <tr>
      <th>[SimdNBT](https://github.com/azalea-rs/simdnbt)</th>
      <td>A very fast NBT serializer and deserializer.</td>
      <td>{{proglang|Rust}}</td>
    </tr>
    <tr>
      <th>[fastnbt](https://github.com/owengage/fastnbt)</th>
      <td>Fast serde serializer and deserializer for Minecraft's NBT and Anvil formats</td>
      <td>{{proglang|Rust}}</td>
    </tr>
    <tr>
      <th>[shen-nbt5](https://github.com/shenjackyuanjie/nbt-rust)</th>
      <td>A Fast NBT parser/writer (warning: lot's of unsafe (from author))</td>
      <td>{{proglang|Rust}}</td>
    </tr>
    <tr>
      <th>[CrabNBT](https://github.com/CrabCraftDev/CrabNBT)</th>
      <td>Up-to-date Rust crate for easy and intuitive working with NBT data.</td>
      <td>{{proglang|Rust}}</td>
    </tr>
    <tr>
      <th>[CraftFlow-NBT](https://crates.io/crates/craftflow-nbt)</th>
      <td>Serde based NBT binary format implementation.</td>
      <td>{{proglang|Rust}}</td>
    </tr>
    <tr>
      <th>[ScalaNBT](https://github.com/drXor/ScalaNBT)</th>
      <td>Scala library for NBT io with some Mojangson support.</td>
      <td>[Scala](https://www.scala-lang.org/)</td>
    </tr>
  </tbody>
</table>

Unless you have specific goals or licence requirements, it is *extremely recommended* to go with one of the existing libraries.

### Utilities
Almost every 3rd-party Minecraft application uses NBT on some level. There also exist several dedicated NBT editors, which will likely be useful to you if you are developing an NBT library of your own. These include:
- [NBTExplorer](https://www.minecraftforum.net/forums/mapping-and-modding-java-edition/minecraft-tools/1262665-nbtexplorer-nbt-editor-for-windows-and-mac) (C#) NBT Directory-tree interface that fully supports the Minecraft .mcr/.mca region files.
- [NEINedit](https://web.archive.org/web/20180428090808/http://gerritg.de/wp/archives/152) (Obj-C), an OS X specific editor.
- [nbt2yaml](https://bitbucket.org/zzzeek/nbt2yaml) (Python), provides command-line editing of NBT via the YAML format, as well as a fast and minimalist NBT parsing/rendering API.
- [nbted](https://github.com/C4K3/nbted) (Rust; CC0), provides command-line editing of NBT files via your $EDITOR
- [unbted](https://git.sleeping.town/unascribed/unbted) (Rust; GPL-v3) Command-line interactive NBT editor
- [nbt2json](https://github.com/midnightfreddie/nbt2json) (Golang; MIT) Command-line utility for NBT to JSON/YAML conversion and back. MCPE-NBT support. Can be used as library.
- [NBT Studio](https://github.com/tryashtar/nbt-studio) (C#) A visual editor similar to NBT-Explorer (A claimed, spiritual successor). Supports Minecraft Bedrock Edition files and SNBT.
- [NBTFS](https://sourceforge.net/projects/nbtfsutils/) (C; MPL-2) Editing NBT as using a file system; supports Minecraft region files.
- [ImNbt](https://github.com/Lenni0451/ImNbt) (Java) ImGui based NBT Directory-tree interface that supports Minecraft Java and Bedrock Edition NBT. Features diffing, searching and exporting in different NBT formats.
- [Dovetail](https://offroaders123.github.io/Dovetail/) (JavaScript) web-based NBT editor for Java and Bedrock Edition.

## Specification
The NBT file format is extremely simple, and writing a library capable of reading/writing it is a simple affair. There are 13 datatypes supported by this format, one of which is used to close compound tags. It is strongly advised to read this entire section or you may run into issues.

> ⚠️ **Warning:** Heads up! Since 1.20.2 NBT sent over the network has a subtle but critical specification change, refer to the Network NBT section below for more information

<table class="wikitable">
  <tbody>
    <tr>
      <th>Type ID</th>
      <th>Type Name</th>
      <th>Payload Size (Bytes)</th>
      <th>Description</th>
      <td>- id=Specification:end_tag</td>
      <td>0</td>
      <td>[[#Specification:end_tag|TAG_End]]</td>
      <td>0</td>
      <td>Signifies the end of a TAG_Compound. It is only ever used inside a TAG_Compound, a TAG_List that has it's type id set to TAG_Compound or as the type for a TAG_List if the length is 0 or negative, and is not named even when in a TAG_Compound</td>
      <td>- id=Specification:byte_tag</td>
      <td>1</td>
      <td>[[#Specification:byte_tag|TAG_Byte]]</td>
      <td>1</td>
      <td>A single signed byte</td>
      <td>- id=Specification:short_tag</td>
      <td>2</td>
      <td>[[#Specification:short_tag|TAG_Short]]</td>
      <td>2</td>
      <td>A single signed, big endian 16 bit integer</td>
      <td>- id=Specification:int_tag</td>
      <td>3</td>
      <td>[[#Specification:int_tag|TAG_Int]]</td>
      <td>4</td>
      <td>A single signed, big endian 32 bit integer</td>
      <td>- id=Specification:long_tag</td>
      <td>4</td>
      <td>[[#Specification:long_tag|TAG_Long]]</td>
      <td>8</td>
      <td>A single signed, big endian 64 bit integer</td>
      <td>- id=Specification:float_tag</td>
      <td>5</td>
      <td>[[#Specification:float_tag|TAG_Float]]</td>
      <td>4</td>
      <td>A single, big endian [IEEE-754](wikipedia-ieee-754-2008.md) single-precision floating point number ([NaN](wikipedia-nan.md) possible)</td>
      <td>- id=Specification:double_tag</td>
      <td>6</td>
      <td>[[#Specification:double_tag|TAG_Double]]</td>
      <td>8</td>
      <td>A single, big endian [IEEE-754](wikipedia-ieee-754-2008.md) double-precision floating point number ([NaN](wikipedia-nan.md) possible)</td>
      <td>- id=Specification:byte_array_tag</td>
      <td>7</td>
      <td>[[#Specification:byte_array_tag|TAG_Byte_Array]]</td>
      <td>...</td>
      <td>A length-prefixed array of **signed** bytes. The prefix is a **signed** integer (thus 4 bytes)</td>
      <td>- id=Specification:string_tag</td>
      <td>8</td>
      <td>[[#Specification:string_tag|TAG_String]]</td>
      <td>...</td>
      <td>A length-prefixed [modified UTF-8](https://docs.oracle.com/javase/8/docs/api/java/io/DataInput.html#modified-utf-8) string. The prefix is an **unsigned** short (thus 2 bytes) signifying the length of the string in bytes</td>
      <td>- id=Specification:list_tag</td>
      <td>9</td>
      <td>[[#Specification:list_tag|TAG_List]]</td>
      <td>...</td>
      <td>A list of **nameless** tags, all of the same type. The list is prefixed with the `Type ID` of the items it contains (thus 1 byte), and the length of the list as a **signed** integer (a further 4 bytes).  If the length of the list is 0 or negative, the type may be 0 (TAG_End) but otherwise it must be any other type.  (The notchian implementation uses TAG_End in that situation, but another reference implementation by Mojang uses 1 instead; parsers should accept any type if the length is <= 0).</td>
      <td>- id=Specification:compound_tag</td>
      <td>10</td>
      <td>[[#Specification:compound_tag|TAG_Compound]]</td>
      <td>...</td>
      <td>Effectively a list of **named** tags. Order is not guaranteed.</td>
      <td>- id=Specification:int_array_tag</td>
      <td>11</td>
      <td>[[#Specification:int_array_tag|TAG_Int_Array]]</td>
      <td>...</td>
      <td>A length-prefixed array of **signed** integers. The prefix is a **signed** integer (thus 4 bytes) and indicates the number of 4 byte integers.</td>
      <td>- id=Specification:long_array_tag</td>
      <td>12</td>
      <td>[[#Specification:long_array_tag|TAG_Long_Array]]</td>
      <td>...</td>
      <td>A length-prefixed array of **signed** longs. The prefix is a **signed** integer (thus 4 bytes) and indicates the number of 8 byte longs.</td>
    </tr>
  </tbody>
</table>

There are a couple of simple things to remember:
- The datatypes representing numbers are in big-endian in Java edition, but Bedrock edition changes things up a bit. See the below section on Bedrock edition
- Every NBT file is a single Named Tag, and that root tag must be a TAG_Compound (except in Bedrock edition, see below)
- The structure of a NBT file is defined by the TAG_List and TAG_Compound types, as such a tag itself will only contain the payload, but depending on what the tag is contained within may contain additional headers. I.e. if it's inside a Compound, then each tag will begin with the TAG_id, and then a [modified UTF-8](https://docs.oracle.com/javase/8/docs/api/java/io/DataInput.html#modified-utf-8) string (the tag's name), and finally the payload. While in a list it will be only the payload, as there is no name and the tag type is given in the beginning of the list.

For example, here's the example layout of a `TAG_Short` on disk:

<table class="wikitable">
  <tbody>
    <tr>
      <td></td>
      <th>Type ID</th>
      <th>Length of Name</th>
      <th>Name</th>
      <th>Payload</th>
    </tr>
    <tr>
      <th>Decoded</th>
      <td>2</td>
      <td>9</td>
      <td>`shortTest`</td>
      <td>`32767`</td>
    </tr>
    <tr>
      <th>On Disk (in hex)</th>
      <td>`02`</td>
      <td>`00 09`</td>
      <td>`73 68 6F 72 74 54 65 73 74`</td>
      <td>`7F FF`</td>
    </tr>
  </tbody>
</table>

If this `TAG_Short` had been in a `TAG_List`, it would have been nothing more than the payload, since the type is implied and tags within the first level of a list are nameless.

### Network NBT (Java Edition)
Since 1.20.2 (Protocol 764) NBT sent over the network has been updated to exclude the name from the root `TAG_COMPOUND`, this essentially boils down to the following.
<table class="wikitable">
  <tbody>
    <tr>
      <td></td>
      <th>Type ID</th>
      <th>Length of Name</th>
      <th>Name</th>
      <th>Payload</th>
    </tr>
    <tr>
      <th>< 1.20.2 (Protocol 764)</th>
      <td>`0x0a`</td>
      <td>`0x00 0x00`</td>
      <td>(Empty name)</td>
      <td>`0x02 0x09`</td>
    </tr>
    <tr>
      <th>>= 1.20.2 (Protocol 764)</th>
      <td>`0x0a`</td>
      <td>N/A</td>
      <td>N/A</td>
      <td>`0x02 0x09`</td>
    </tr>
  </tbody>
</table>
Remember - This only applies to network NBT. Player data, world data, etc... will not be affected.

### Bedrock edition
Bedrock edition makes a couple of significant changes to the NBT format. First of all, root tag of an NBT file can sometimes be a TAG_List instead of a TAG_Compound. Additionally, NBT data is encoded in one of two different formats, a little-endian version intended for writing to disk, and a VarInt version intended for transport over the network.

#### Little-endian
Identical to the big-endian format used by Java edition, but all numbers are encoded in little-endian. This includes the 16-bit length prefix before tag names and TAG_String values, as well as TAG_Float and TAG_Double values.

#### VarInt
This format is a bit more complex than the others. The differences from Java edition's big-endian format are as follows:
- TAG_Short, TAG_Float and TAG_Double values are encoded as their little-endian counterparts
- TAG_Int values and the length prefixes for TAG_List, TAG_Byte_Array, TAG_Int_Array and TAG_Long_Array are encoded as [VarInts with ZigZag encoding](https://developers.google.com/protocol-buffers/docs/encoding#varints)
- TAG_Long values are encoded as [VarLongs with ZigZag encoding](https://developers.google.com/protocol-buffers/docs/encoding#varints)
- All strings (Tag names and TAG_String values) are length-prefixed with a normal [VarInt](minecraft_wiki-projects-wiki.vg_merge-protocol.md#varintandvarlong)

### Examples
There are two defacto example files used for testing your implementation (`test.nbt` & `bigtest.nbt`), originally provided by Markus. The example output provided below was generated using [PyNBT](https://github.com/TkTech/PyNBT)'s *debug-nbt* tool.

#### test.nbt
This first example is an uncompressed ["Hello World"](wikipedia-hello-world-program.md) NBT example. Should you parse it correctly, you will get a structure similar to the following:

```
  TAG_Compound('hello world'): 1 entry
  {
    TAG_String('name'): 'Bananrama'
  }
```

Here is the example explained:
<table class="wikitable">
  <tbody>
    <tr>
      <td></td>
      <th>Type ID of the root compound</th>
      <th>Length of name of the root compound</th>
      <th>Name of the root compound</th>
      <th>Type ID of first element in root compound</th>
      <th>Length of name of first element in root</th>
      <th>Name of first element</th>
      <th>Length of string</th>
      <th>String</th>
      <th>Tag end (of root compound)</th>
    </tr>
    <tr>
      <th>Decoded</th>
      <td>Compound</td>
      <td>11</td>
      <td>*hello world*</td>
      <td>String</td>
      <td>4</td>
      <td>*name*</td>
      <td>9</td>
      <td>*Bananrama*</td>
      <td></td>
    </tr>
    <tr>
      <th>On Disk (in hex)</th>
      <td>`0a`</td>
      <td>`00 0b`</td>
      <td>`68 65 6c 6c 6f 20 77 6f 72 6c 64`</td>
      <td>`08`</td>
      <td>`00 04`</td>
      <td>`6e 61 6d 65`</td>
      <td>`00 09`</td>
      <td>`42 61 6e 61 6e 72 61 6d 61`</td>
      <td>`00`</td>
    </tr>
  </tbody>
</table>

#### bigtest.nbt
This second example is a gzip compressed test of every available tag. If your program can successfully parse this file, then you've done well. Note that the tags under *TAG_List* do not have a name, as mentioned above. 
```
  TAG_Compound('Level'): 11 entries
  {
    TAG_Compound('nested compound test'): 2 entries
    {
      TAG_Compound('egg'): 2 entries
      {
        TAG_String('name'): 'Eggbert'
        TAG_Float('value'): 0.5
      }
      TAG_Compound('ham'): 2 entries
      {
        TAG_String('name'): 'Hampus'
        TAG_Float('value'): 0.75
      }
    }
    TAG_Int('intTest'): 2147483647
    TAG_Byte('byteTest'): 127
    TAG_String('stringTest'): 'HELLO WORLD THIS IS A TEST STRING \xc5\xc4\xd6!'
    TAG_List('listTest (long)'): 5 entries
    {
      TAG_Long(None): 11
      TAG_Long(None): 12
      TAG_Long(None): 13
      TAG_Long(None): 14
      TAG_Long(None): 15
    }
    TAG_Double('doubleTest'): 0.49312871321823148
    TAG_Float('floatTest'): 0.49823147058486938
    TAG_Long('longTest'): 9223372036854775807L
    TAG_List('listTest (compound)'): 2 entries
    {
      TAG_Compound(None): 2 entries
      {
        TAG_Long('created-on'): 1264099775885L
        TAG_String('name'): 'Compound tag #0'
      }
      TAG_Compound(None): 2 entries
      {
        TAG_Long('created-on'): 1264099775885L
        TAG_String('name'): 'Compound tag #1'
      }
    }
    TAG_Byte_Array('byteArrayTest (the first 1000 values of (n*n*255+n*7)%100, starting with n=0 (0, 62, 34, 16, 8, ...))'): [1000 bytes]
    TAG_Short('shortTest'): 32767
  }
```

#### servers.dat
The *servers.dat* file contains a list of multiplayer servers you've added to the game. To mix things up a bit, this file will always be uncompressed. Below is an example of the structure seen in *servers.dat*.
```
  TAG_Compound(<nowiki>''</nowiki>): 1 entry
  {
    TAG_List('servers'): 2 entries
    {
      TAG_Compound(None): 3 entries
      {
        TAG_Byte('acceptTextures'): 1 (Automatically accept resourcepacks from this server)
        TAG_String('ip'): '199.167.132.229:25620'
        TAG_String('name'): 'Dainz1 - Creative'
        
      }
      TAG_Compound(None): 3 entries
      {
        TAG_String('icon'): 'iVBORw0KGgoAAAANUhEUgAAAEAAAABACA...' (The base64-encoded server icon. Trimmed here for the example's sake)
        TAG_String('ip'): '76.127.122.65:25565'
        TAG_String('name'): 'minstarmin4'
        
      }
    }
  }
```

#### level.dat
This final example is of a single player *level.dat*, which is compressed using gzip. Notice the player's inventory and general world details such as spawn position, world name, and the game seed.
```
  TAG_Compound(<nowiki>''</nowiki>): 1 entry
  {
    TAG_Compound('Data'): 17 entries
    {
      TAG_Byte('raining'): 0
      TAG_Long('RandomSeed'): 3142388825013346304L
      TAG_Int('SpawnX'): 0
      TAG_Int('SpawnZ'): 0
      TAG_Long('LastPlayed'): 1323133681772L
      TAG_Int('GameType'): 1
      TAG_Int('SpawnY'): 63
      TAG_Byte('MapFeatures'): 1
      TAG_Compound('Player'): 24 entries
      {
        TAG_Int('XpTotal'): 0
        TAG_Compound('abilities'): 4 entries
        {
          TAG_Byte('instabuild'): 1
          TAG_Byte('flying'): 1
          TAG_Byte('mayfly'): 1
          TAG_Byte('invulnerable'): 1
        }
        TAG_Int('XpLevel'): 0
        TAG_Int('Score'): 0
        TAG_Short('Health'): 20
        TAG_List('Inventory'): 13 entries
        {
          TAG_Compound(None): 4 entries
          {
            TAG_Byte('Count'): 1
            TAG_Byte('Slot'): 0
            TAG_Short('id'): 24
            TAG_Short('Damage'): 0
          }
          TAG_Compound(None): 4 entries
          {
            TAG_Byte('Count'): 1
            TAG_Byte('Slot'): 1
            TAG_Short('id'): 25
            TAG_Short('Damage'): 0
          }
          TAG_Compound(None): 4 entries
          {
            TAG_Byte('Count'): 1
            TAG_Byte('Slot'): 2
            TAG_Short('id'): 326
            TAG_Short('Damage'): 0
          }
          TAG_Compound(None): 4 entries
          {
            TAG_Byte('Count'): 1
            TAG_Byte('Slot'): 3
            TAG_Short('id'): 29
            TAG_Short('Damage'): 0
          }
          TAG_Compound(None): 4 entries
          {
            TAG_Byte('Count'): 10
            TAG_Byte('Slot'): 4
            TAG_Short('id'): 69
            TAG_Short('Damage'): 0
          }
          TAG_Compound(None): 4 entries
          {
            TAG_Byte('Count'): 3
            TAG_Byte('Slot'): 5
            TAG_Short('id'): 33
            TAG_Short('Damage'): 0
          }
          TAG_Compound(None): 4 entries
          {
            TAG_Byte('Count'): 43
            TAG_Byte('Slot'): 6
            TAG_Short('id'): 356
            TAG_Short('Damage'): 0
          }
          TAG_Compound(None): 4 entries
          {
            TAG_Byte('Count'): 64
            TAG_Byte('Slot'): 7
            TAG_Short('id'): 331
            TAG_Short('Damage'): 0
          }
          TAG_Compound(None): 4 entries
          {
            TAG_Byte('Count'): 20
            TAG_Byte('Slot'): 8
            TAG_Short('id'): 76
            TAG_Short('Damage'): 0
          }
          TAG_Compound(None): 4 entries
          {
            TAG_Byte('Count'): 64
            TAG_Byte('Slot'): 9
            TAG_Short('id'): 331
            TAG_Short('Damage'): 0
          }
          TAG_Compound(None): 4 entries
          {
            TAG_Byte('Count'): 1
            TAG_Byte('Slot'): 10
            TAG_Short('id'): 323
            TAG_Short('Damage'): 0
          }
          TAG_Compound(None): 4 entries
          {
            TAG_Byte('Count'): 16
            TAG_Byte('Slot'): 11
            TAG_Short('id'): 331
            TAG_Short('Damage'): 0
          }
          TAG_Compound(None): 4 entries
          {
            TAG_Byte('Count'): 1
            TAG_Byte('Slot'): 12
            TAG_Short('id'): 110
            TAG_Short('Damage'): 0
          }
        }
        TAG_Short('HurtTime'): 0
        TAG_Short('Fire'): -20
        TAG_Float('foodExhaustionLevel'): 0.0
        TAG_Float('foodSaturationLevel'): 5.0
        TAG_Int('foodTickTimer'): 0
        TAG_Short('SleepTimer'): 0
        TAG_Short('DeathTime'): 0
        TAG_List('Rotation'): 2 entries
        {
          TAG_Float(None): 1151.9342041015625
          TAG_Float(None): 32.249679565429688
        }
        TAG_Float('XpP'): 0.0
        TAG_Float('FallDistance'): 0.0
        TAG_Short('Air'): 300
        TAG_List('Motion'): 3 entries
        {
          TAG_Double(None): -2.9778325794951344e-11
          TAG_Double(None): -0.078400001525878907
          TAG_Double(None): 1.1763942772801152e-11
        }
        TAG_Int('Dimension'): 0
        TAG_Byte('OnGround'): 1
        TAG_List('Pos'): 3 entries
        {
          TAG_Double(None): 256.87499499518492
          TAG_Double(None): 112.62000000476837
          TAG_Double(None): -34.578128612797634
        }
        TAG_Byte('Sleeping'): 0
        TAG_Short('AttackTime'): 0
        TAG_Int('foodLevel'): 20
      }
      TAG_Int('thunderTime'): 2724
      TAG_Int('version'): 19132
      TAG_Int('rainTime'): 5476
      TAG_Long('Time'): 128763
      TAG_Byte('thundering'): 1
      TAG_Byte('hardcore'): 0
      TAG_Long('SizeOnDisk'): 0
      TAG_String('LevelName'): 'Sandstone Test World'
    }
  }
```

#### Download
- [test.nbt/hello_world.nbt](https://raw.github.com/Dav1dde/nbd/master/test/hello_world.nbt) (uncompressed),
- [bigtest.nbt](https://raw.github.com/Dav1dde/nbd/master/test/bigtest.nbt) (gzip compressed)
- [NaN-value-double.dat](https://github.com/VADemon/nbd/raw/5de7a3f37569e1ffee11afbc017ae08e2c24523e/test/Player-nan-value.dat) (compressed, origin version unknown)
- [NBT.txt](https://web.archive.org/web/20110723210920/http://www.minecraft.net/docs/NBT.txt) (original NBT specification)

[Category:Protocol Details](category-protocol-details.md)
[Category:File Formats](category-file-formats.md)
_Content is licensed under wiki.vg terms._
