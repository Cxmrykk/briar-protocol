{{DISPLAYTITLE:*Java Edition* protocol/Packets}}
> _About: the protocol for a stable release of {{JE_|the protocol used in development versions of {{JE}}|Java Edition protocol/Development version|the protocol used in {{BE}}|Bedrock Edition protocol|the protocol used in old *[Pocket Edition](pocket-edition.md)* versions|Pocket Edition protocol}}
See also:
  * [Protocol FAQ](./faq.md)
> **Note:** This content is exclusive to the Java Edition.
> ℹ️ While you may use the contents of this page without restriction to create servers, clients, bots, etc; keep in mind that the contents of this page are distributed under the terms of [CC BY-SA 3.0 Unported](https://creativecommons.org/licenses/by-sa/3.0/). Reproductions and derivative works must be distributed accordingly.

This article presents a dissection of the current {{JE}} **protocol** for [1.21.5, protocol 770](protocol-version-numbers.md).

The changes between versions may be viewed at [Protocol History](protocol-history.md).

## Definitions

The Minecraft server accepts connections from TCP clients and communicates with them using *packets*. A packet is a sequence of bytes sent over the TCP connection. The meaning of a packet depends both on its packet ID and the current state of the connection. The initial state of each connection is [[#Handshaking|Handshaking]], and state is switched using the packets [[#Handshake|Handshake]] and [[#Login Success|Login Success]].

### Data types

{{:Java Edition protocol/Data types}} <!-- Transcluded contents of Data types article in here — go to that page if you want to edit it -->

### Other definitions

<table class="wikitable">
  <tbody>
    <tr>
      <th>Term</th>
      <th>Definition</th>
    </tr>
    <tr>
      <td>Player</td>
      <td>When used in the singular, Player always refers to the client connected to the server.</td>
    </tr>
    <tr>
      <td>Entity</td>
      <td>Entity refers to any item, player, mob, minecart or boat etc. See [the Minecraft Wiki article](entity.md) for a full list.</td>
    </tr>
    <tr>
      <td>EID</td>
      <td>An EID — or Entity ID — is a 4-byte sequence used to identify a specific entity. An entity's EID is unique on the entire server.</td>
    </tr>
    <tr>
      <td>XYZ</td>
      <td>In this document, the axis names are the same as those shown in the debug screen (F3). Y points upwards, X points east, and Z points south.</td>
    </tr>
    <tr>
      <td>Meter</td>
      <td>The meter is Minecraft's base unit of length, equal to the length of a vertex of a solid block. The term “block” may be used to mean “meter” or “cubic meter”.</td>
    </tr>
    <tr>
      <td>Registry</td>
      <td>A table describing static, gameplay-related objects of some kind, such as the types of entities, block states or biomes. The entries of a registry are typically associated with textual or numeric identifiers, or both.

Minecraft has a unified registry system used to implement most of the registries, including blocks, items, entities, biomes and dimensions. These "ordinary" registries associate entries with both namespaced textual identifiers (see [#Identifier](identifier.md)), and signed (positive) 32-bit numeric identifiers. There is also a registry of registries listing all of the registries in the registry system. Some other registries, most notably the [block state registry](chunk-format.md#block-state-registry), are however implemented in a more ad-hoc fashion.

Some registries, such as biomes and dimensions, can be customized at runtime by the server (see [Registry Data](registry-data.md)), while others, such as blocks, items and entities, are hardcoded. The contents of the hardcoded registries can be extracted via the built-in [Data Generators](data-generators.md) system.</td>
    </tr>
    <tr>
      <td>Block state</td>
      <td>Each block in Minecraft has 0 or more properties, which in turn may have any number of possible values. These represent, for example, the orientations of blocks, poweredness states of redstone components, and so on. Each of the possible permutations of property values for a block is a distinct block state. The block state registry assigns a numeric identifier to every block state of every block.

A current list of properties and state ID ranges is found on [burger](https://pokechu22.github.io/Burger/1.21.html).

Alternatively, the vanilla server now includes an option to export the current block state ID mapping, by running `java -DbundlerMainClass=net.minecraft.data.Main -jar minecraft_server.jar --reports`.  See [Data Generators](data-generators.md) for more information.</td>
    </tr>
    <tr>
      <td>Vanilla</td>
      <td>The official implementation of Minecraft as developed and released by Mojang.</td>
    </tr>
    <tr>
      <td>Sequence</td>
      <td>The action number counter for local block changes, incremented by one when clicking a block with a hand, right clicking an item, or starting or finishing digging a block. Counter handles latency to avoid applying outdated block changes to the local world.  Also is used to revert ghost blocks created when placing blocks, using buckets, or breaking blocks.</td>
    </tr>
  </tbody>
</table>

## Packet format

Packets cannot be larger than 2<sup>21</sup> &minus; 1 or 2097151 bytes (the maximum that can be sent in a 3-byte `VarInt`). Moreover, the length field must not be longer than 3 bytes, even if the encoded value is within the limit. Unnecessarily long encodings at 3 bytes or below are still allowed.  For compressed packets, this applies to the Packet Length field, i.e. the compressed length.

### Without compression

<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>Length</td>
      <td>`VarInt`</td>
      <td>Length of Packet ID + Data</td>
    </tr>
    <tr>
      <td>Packet ID</td>
      <td>`VarInt`</td>
      <td>Corresponds to `protocol_id` from [the server's packet report](data-generators.md#packets-report)</td>
    </tr>
    <tr>
      <td>Data</td>
      <td>`Byte Array`</td>
      <td>Depends on the connection state and packet ID, see the sections below</td>
    </tr>
  </tbody>
</table>

### With compression

Once a [[#Set Compression|Set Compression]] packet (with a non-negative threshold) is sent, [zlib](wikipedia-zlib.md) compression is enabled for all following packets. The format of a packet changes slightly to include the size of the uncompressed packet.

<table>
  <tbody>
    <tr>
      <th>Present?</th>
      <th>Compressed?</th>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>always</td>
      <td>No</td>
      <td>Packet Length</td>
      <td>`VarInt`</td>
      <td>Length of (Data Length) + length of compressed (Packet ID + Data)</td>
    </tr>
    <tr>
      <td rowspan="3">if size >= threshold</td>
      <td>No</td>
      <td>Data Length</td>
      <td>`VarInt`</td>
      <td>Length of uncompressed (Packet ID + Data)</td>
    </tr>
    <tr>
      <td rowspan="2">Yes</td>
      <td>Packet ID</td>
      <td>`VarInt`</td>
      <td>zlib compressed packet ID (see the sections below)</td>
    </tr>
    <tr>
      <td>Data</td>
      <td>`Byte Array`</td>
      <td>zlib compressed packet data (see the sections below)</td>
    </tr>
    <tr>
      <td rowspan="3">if size < threshold</td>
      <td rowspan="3">No</td>
      <td>Data Length</td>
      <td>`VarInt`</td>
      <td>0 to indicate uncompressed</td>
    </tr>
    <tr>
      <td>Packet ID</td>
      <td>`VarInt`</td>
      <td>packet ID (see the sections below)</td>
    </tr>
    <tr>
      <td>Data</td>
      <td>`Byte Array`</td>
      <td>packet data (see the sections below)</td>
    </tr>
  </tbody>
</table>

For serverbound packets, the uncompressed length of (Packet ID + Data) must not be greater than 2<sup>23</sup> or 8388608 bytes. Note that a length equal to 2<sup>23</sup> is permitted, which differs from the compressed length limit. The vanilla client, on the other hand, has no limit for the uncompressed length of incoming compressed packets.

If the size of the buffer containing the packet data and ID (as a `VarInt`) is smaller than the threshold specified in the packet [[#Set Compression|Set Compression]]. It will be sent as uncompressed. This is done by setting the data length as 0. (Comparable to sending a non-compressed format with an extra 0 between the length, and packet data).

If it's larger than or equal to the threshold, then it follows the regular compressed protocol format.

The vanilla server (but not client) rejects compressed packets smaller than the threshold. Uncompressed packets exceeding the threshold, however, are accepted.

Compression can be disabled by sending the packet [[#Set Compression|Set Compression]] with a negative Threshold, or not sending the Set Compression packet at all.

## Handshaking

### Clientbound

There are no clientbound packets in the Handshaking state, since the protocol immediately switches to a different state after the client sends the first packet.

### Serverbound

#### Handshake

This packet causes the server to switch into the target state. It should be sent right after opening the TCP connection to prevent the server from disconnecting.

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
      <td rowspan="4">*protocol:*<br/>`0x00`<br/><br/>*resource:*<br/>`intention`</td>
      <td rowspan="4">Handshaking</td>
      <td rowspan="4">Server</td>
      <td>Protocol Version</td>
      <td>`VarInt`</td>
      <td>See [protocol version numbers](protocol-version-numbers.md) (currently 770 in Minecraft 1.21.5).</td>
    </tr>
    <tr>
      <td>Server Address</td>
      <td>`String` (255)</td>
      <td>Hostname or IP, e.g. localhost or 127.0.0.1, that was used to connect. The vanilla server does not use this information. Note that SRV records are a simple redirect, e.g. if _minecraft._tcp.example.com points to mc.example.org, users connecting to example.com will provide example.org as server address in addition to connecting to it.</td>
    </tr>
    <tr>
      <td>Server Port</td>
      <td>`Unsigned Short`</td>
      <td>Default is 25565. The vanilla server does not use this information.</td>
    </tr>
    <tr>
      <td>Intent</td>
      <td>`VarInt` `Enum`</td>
      <td>1 for [[#Status|Status]], 2 for [[#Login|Login]], 3 for [[#Login|Transfer]].</td>
    </tr>
  </tbody>
</table>

#### Legacy Server List Ping

> ⚠️ **Warning:** This packet uses a nonstandard format. It is never length-prefixed, and the packet ID is an `Unsigned Byte instead of a {{Type|VarInt`.}}

While not technically part of the current protocol, (legacy) clients may send this packet to initiate [Server List Ping](server-list-ping.md), and modern servers should handle it correctly.
The format of this packet is a remnant of the pre-Netty age, before the switch to Netty in 1.7 brought the standard format that is recognized now. This packet merely exists to inform legacy clients that they can't join our modern server.

Modern clients (tested with 1.21.5 + 1.21.4) also send this packet when the server does not send any response within a 30 seconds time window or when the connection is immediately closed.
{{Warning|The client does not close the connection with the legacy packet on its own!
It only gets closed when the Minecraft client is closed.}}
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
      <td>0xFE</td>
      <td>Handshaking</td>
      <td>Server</td>
      <td>Payload</td>
      <td>`Unsigned Byte`</td>
      <td>always 1 (`0x01`).</td>
    </tr>
  </tbody>
</table>

See [Server List Ping#1.6](server-list-ping.md#16) for the details of the protocol that follows this packet.
## Status
_Main article: [Minecraft Wiki:Projects/wiki.vg merge/Server List Ping](./server-list-ping.md)_

### Clientbound

#### Status Response

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
      <td>*protocol:*<br/>`0x00`<br/><br/>*resource:*<br/>`status_response`</td>
      <td>Status</td>
      <td>Client</td>
      <td>JSON Response</td>
      <td>`String` (32767)</td>
      <td>See [Server List Ping#Status Response](server-list-ping.md#status-response); as with all strings this is prefixed by its length as a `VarInt`.</td>
    </tr>
  </tbody>
</table>

#### Pong Response (status)

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
      <td>*protocol:*<br/>`0x01`<br/><br/>*resource:*<br/>`pong_response`</td>
      <td>Status</td>
      <td>Client</td>
      <td>Timestamp</td>
      <td>`Long`</td>
      <td>Should match the one sent by the client.</td>
    </tr>
  </tbody>
</table>

### Serverbound

#### Status Request

The status can only be requested once immediately after the handshake, before any ping. The server won't respond otherwise.

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
      <td>*protocol:*<br/>`0x00`<br/><br/>*resource:*<br/>`status_request`</td>
      <td>Status</td>
      <td>Server</td>
      <td colspan="3">*no fields*</td>
    </tr>
  </tbody>
</table>

#### Ping Request (status)

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
      <td>*protocol:*<br/>`0x01`<br/><br/>*resource:*<br/>`ping_request`</td>
      <td>Status</td>
      <td>Server</td>
      <td>Timestamp</td>
      <td>`Long`</td>
      <td>May be any number, but vanilla clients will always use the timestamp in milliseconds.</td>
    </tr>
  </tbody>
</table>

## Login

The login process is as follows:

1. C→S: [[#Handshake|Handshake]] with intent set to 2 (login)
1. C→S: [[#Login Start|Login Start]]
1. S→C: [[#Encryption Request|Encryption Request]]
1. Client auth (if enabled)
1. C→S: [[#Encryption Response|Encryption Response]]
1. Server auth (if enabled)
1. Both enable encryption
1. S→C: [[#Set Compression|Set Compression]] (optional)
1. S→C: [[#Login Success|Login Success]]
1. C→S: [[#Login Acknowledged|Login Acknowledged]]

Set Compression, if present, must be sent before Login Success. Note that anything sent after Set Compression must use the [[#With compression|Post Compression packet format]].

Three modes of operation are possible depending on how the packets are sent:
- Online-mode with encryption
- Offline-mode with encryption
- Offline-mode without encryption

For online-mode servers (the ones with authentication enabled), encryption is always mandatory, and the entire process described above needs to be followed.

For offline-mode servers (the ones with authentication disabled), encryption is optional, and part of the process can be skipped. In that case [[#Login Start|Login Start]] is directly followed by [[#Login Success|Login Success]]. The vanilla server only uses UUID v3 for offline player UUIDs, deriving it from the string `OfflinePlayer:<player's name>` For example, Notch’s offline UUID would be chosen from the string `OfflinePlayer:Notch`. This is not a requirement however, the UUID can be set to anything.

As of 1.21, the vanilla server never uses encryption in offline mode.

See [protocol encryption](protocol-encryption.md) for details.

### Clientbound

#### Disconnect (login)

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
      <td>*protocol:*<br/>`0x00`<br/><br/>*resource:*<br/>`login_disconnect`</td>
      <td>Login</td>
      <td>Client</td>
      <td>Reason</td>
      <td>`JSON Text Component`</td>
      <td>The reason why the player was disconnected.</td>
    </tr>
  </tbody>
</table>

#### Encryption Request

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
      <td rowspan="4">*protocol:*<br/>`0x01`<br/><br/>*resource:*<br/>`hello`</td>
      <td rowspan="4">Login</td>
      <td rowspan="4">Client</td>
      <td>Server ID</td>
      <td>`String` (20)</td>
      <td>Always empty when sent by the vanilla server.</td>
    </tr>
    <tr>
      <td>Public Key</td>
      <td>`Prefixed Array` of `Byte`</td>
      <td>The server's public key, in bytes.</td>
    </tr>
    <tr>
      <td>Verify Token</td>
      <td>`Prefixed Array` of `Byte`</td>
      <td>A sequence of random bytes generated by the server.</td>
    </tr>
    <tr>
      <td>Should authenticate</td>
      <td>`Boolean`</td>
      <td>Whether the client should attempt to [authenticate through mojang servers](protocol_encryption.md#authentication).</td>
    </tr>
  </tbody>
</table>

See [protocol encryption](protocol-encryption.md) for details.

#### Login Success

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>State</th>
      <th>Bound To</th>
      <th colspan="2">Field Name</th>
      <th colspan="2">Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="5">*protocol:*<br/>`0x02`<br/><br/>*resource:*<br/>`login_finished`</td>
      <td rowspan="5">Login</td>
      <td rowspan="5">Client</td>
      <td colspan="2">UUID</td>
      <td colspan="2">`UUID`</td>
      <td colspan="2"></td>
    </tr>
    <tr>
      <td colspan="2">Username</td>
      <td colspan="2">`String` (16)</td>
      <td colspan="2"></td>
    </tr>
    <tr>
      <td rowspan="3">Property</td>
      <td>Name</td>
      <td rowspan="3">`Prefixed Array` (16)</td>
      <td>`String` (64)</td>
      <td colspan="2"></td>
    </tr>
    <tr>
      <td>Value</td>
      <td>`String` (32767)</td>
      <td colspan="1"></td>
    </tr>
    <tr>
      <td>Signature</td>
      <td>`Prefixed Optional` `String` (1024)</td>
      <td></td>
    </tr>
  </tbody>
</table>

The Property field looks like response of [Mojang API#UUID to Profile and Skin/Cape](mojang-api.md#uuid-to-profile-and-skincape), except using the protocol format instead of JSON. That is, each player will usually have one property with Name being “textures” and Value being a base64-encoded JSON string, as documented at [Mojang API#UUID to Profile and Skin/Cape](mojang-api.md#uuid-to-profile-and-skincape). An empty properties array is also acceptable, and will cause clients to display the player with one of the two default skins depending their UUID (again, see the Mojang API page).

#### Set Compression

Enables compression.  If compression is enabled, all following packets are encoded in the [[#With compression|compressed packet format]].  Negative values will disable compression, meaning the packet format should remain in the [[#Without compression|uncompressed packet format]].  However, this packet is entirely optional, and if not sent, compression will also not be enabled (the vanilla server does not send the packet when compression is disabled).

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
      <td>*protocol:*<br/>`0x03`<br/><br/>*resource:*<br/>`login_compression`</td>
      <td>Login</td>
      <td>Client</td>
      <td>Threshold</td>
      <td>`VarInt`</td>
      <td>Maximum size of a packet before it is compressed.</td>
    </tr>
  </tbody>
</table>

#### Login Plugin Request

Used to implement a custom handshaking flow together with [[#Login Plugin Response|Login Plugin Response]].

Unlike plugin messages in "play" mode, these messages follow a lock-step request/response scheme, where the client is expected to respond to a request indicating whether it understood. The vanilla client always responds that it hasn't understood, and sends an empty payload.

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
      <td rowspan="3">*protocol:*<br/>`0x04`<br/><br/>*resource:*<br/>`custom_query`</td>
      <td rowspan="3">Login</td>
      <td rowspan="3">Client</td>
      <td>Message ID</td>
      <td>`VarInt`</td>
      <td>Generated by the server - should be unique to the connection.</td>
    </tr>
    <tr>
      <td>Channel</td>
      <td>`Identifier`</td>
      <td>Name of the [plugin channel](plugin-channels.md) used to send the data.</td>
    </tr>
    <tr>
      <td>Data</td>
      <td>`Byte Array` (1048576)</td>
      <td>Any data, depending on the channel. The length of this array must be inferred from the packet length.</td>
    </tr>
  </tbody>
</table>

#### Cookie Request (login)

Requests a cookie that was previously stored.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>State</th>
      <th>Bound To</th>
      <th colspan="2">Field Name</th>
      <th colspan="2">Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="1">*protocol:*<br/>`0x05`<br/><br/>*resource:*<br/>`cookie_request`</td>
      <td rowspan="1">Login</td>
      <td rowspan="1">Client</td>
      <td colspan="2">Key</td>
      <td colspan="2">`Identifier`</td>
      <td>The identifier of the cookie.</td>
    </tr>
  </tbody>
</table>

### Serverbound

#### Login Start

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
      <td rowspan="2">*protocol:*<br/>`0x00`<br/><br/>*resource:*<br/>`hello`</td>
      <td rowspan="2">Login</td>
      <td rowspan="2">Server</td>
      <td>Name</td>
      <td>`String` (16)</td>
      <td>Player's Username.</td>
    </tr>
    <tr>
      <td>Player UUID</td>
      <td>`UUID`</td>
      <td>The `UUID` of the player logging in. Unused by the vanilla server.</td>
    </tr>
  </tbody>
</table>

#### Encryption Response

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
      <td rowspan="2">*protocol:*<br/>`0x01`<br/><br/>*resource:*<br/>`key`</td>
      <td rowspan="2">Login</td>
      <td rowspan="2">Server</td>
      <td>Shared Secret</td>
      <td>`Prefixed Array` of `Byte`</td>
      <td>Shared Secret value, encrypted with the server's public key.</td>
    </tr>
    <tr>
      <td>Verify Token</td>
      <td>`Prefixed Array` of `Byte`</td>
      <td>Verify Token value, encrypted with the same public key as the shared secret.</td>
    </tr>
  </tbody>
</table>

See [protocol encryption](protocol-encryption.md) for details.

#### Login Plugin Response

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
      <td rowspan="2">*protocol:*<br/>`0x02`<br/><br/>*resource:*<br/>`custom_query_answer`</td>
      <td rowspan="2">Login</td>
      <td rowspan="2">Server</td>
      <td>Message ID</td>
      <td>`VarInt`</td>
      <td>Should match ID from server.</td>
    </tr>
    <tr>
      <td>Data</td>
      <td>`Prefixed Optional` `Byte Array` (1048576)</td>
      <td>Any data, depending on the channel. The length of this array must be inferred from the packet length. Only present if the client understood the request.</td>
    </tr>
  </tbody>
</table>

#### Login Acknowledged

Acknowledgement to the [Login Success](java-edition-protocol.md#loginsuccess) packet sent by the server.

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
      <td>*protocol:*<br/>`0x03`<br/><br/>*resource:*<br/>`login_acknowledged`</td>
      <td>Login</td>
      <td>Server</td>
      <td colspan="3">*no fields*</td>
    </tr>
  </tbody>
</table>

This packet switches the connection state to [[#Configuration|configuration]].

#### Cookie Response (login)

Response to a [[#Cookie_Request_(login)|Cookie Request (login)]] from the server. The vanilla server only accepts responses of up to 5 kiB in size.

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
      <td rowspan="2">*protocol:*<br/>`0x04`<br/><br/>*resource:*<br/>`cookie_response`</td>
      <td rowspan="2">Login</td>
      <td rowspan="2">Server</td>
      <td>Key</td>
      <td>`Identifier`</td>
      <td>The identifier of the cookie.</td>
    </tr>
    <tr>
      <td>Payload</td>
      <td>`Prefixed Optional` `Prefixed Array` (5120) of `Byte`</td>
      <td>The data of the cookie.</td>
    </tr>
  </tbody>
</table>

## Configuration

### Clientbound

#### Cookie Request (configuration)

Requests a cookie that was previously stored.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>State</th>
      <th>Bound To</th>
      <th colspan="2">Field Name</th>
      <th colspan="2">Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="1">*protocol:*<br/>`0x00`<br/><br/>*resource:*<br/>`cookie_request`</td>
      <td rowspan="1">Configuration</td>
      <td rowspan="1">Client</td>
      <td colspan="2">Key</td>
      <td colspan="2">`Identifier`</td>
      <td>The identifier of the cookie.</td>
    </tr>
  </tbody>
</table>

#### Clientbound Plugin Message (configuration)

_Main article: [Minecraft Wiki:Projects/wiki.vg merge/Plugin channels](./plugin-channels.md)_

Mods and plugins can use this to send their data. Minecraft itself uses several [plugin channels](plugin-channels.md). These internal channels are in the `minecraft` namespace.

More information on how it works on [Dinnerbone's blog](https://web.archive.org/web/20220831140929/https://dinnerbone.com/blog/2012/01/13/minecraft-plugin-channels-messaging/). More documentation about internal and popular registered channels are [here](plugin-channels.md).

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
      <td rowspan="2">*protocol:*<br/>`0x01`<br/><br/>*resource:*<br/>`custom_payload`</td>
      <td rowspan="2">Configuration</td>
      <td rowspan="2">Client</td>
      <td>Channel</td>
      <td>`Identifier`</td>
      <td>Name of the [plugin channel](plugin-channels.md) used to send the data.</td>
    </tr>
    <tr>
      <td>Data</td>
      <td>`Byte Array` (1048576)</td>
      <td>Any data. The length of this array must be inferred from the packet length.</td>
    </tr>
  </tbody>
</table>

In vanilla clients, the maximum data length is 1048576 bytes.

#### Disconnect (configuration)

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
      <td>*protocol:*<br/>`0x02`<br/><br/>*resource:*<br/>`disconnect`</td>
      <td>Configuration</td>
      <td>Client</td>
      <td>Reason</td>
      <td>`Text Component`</td>
      <td>The reason why the player was disconnected.</td>
    </tr>
  </tbody>
</table>

#### Finish Configuration

Sent by the server to notify the client that the configuration process has finished. The client answers with [[#Acknowledge_Finish_Configuration|Acknowledge Finish Configuration]] whenever it is ready to continue.

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
      <td rowspan="1">*protocol:*<br/>`0x03`<br/><br/>*resource:*<br/>`finish_configuration`</td>
      <td rowspan="1">Configuration</td>
      <td rowspan="1">Client</td>
      <td colspan="3">*no fields*</td>
    </tr>
  </tbody>
</table>

This packet switches the connection state to [[#Play|play]].

#### Clientbound Keep Alive (configuration)

The server will frequently send out a keep-alive, each containing a random ID. The client must respond with the same payload (see [[#Serverbound Keep Alive (configuration)|Serverbound Keep Alive]]). If the client does not respond to a Keep Alive packet within 15 seconds after it was sent, the server kicks the client. Vice versa, if the server does not send any keep-alives for 20 seconds, the client will disconnect and yields a "Timed out" exception.

The vanilla server uses a system-dependent time in milliseconds to generate the keep alive ID value.

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
      <td>*protocol:*<br/>`0x04`<br/><br/>*resource:*<br/>`keep_alive`</td>
      <td>Configuration</td>
      <td>Client</td>
      <td>Keep Alive ID</td>
      <td>`Long`</td>
      <td></td>
    </tr>
  </tbody>
</table>

#### Ping (configuration)

Packet is not used by the vanilla server. When sent to the client, client responds with a [[#Pong (configuration)|Pong]] packet with the same id.

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
      <td>*protocol:*<br/>`0x05`<br/><br/>*resource:*<br/>`ping`</td>
      <td>Configuration</td>
      <td>Client</td>
      <td>ID</td>
      <td>`Int`</td>
      <td></td>
    </tr>
  </tbody>
</table>

#### Reset Chat

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
      <td>*protocol:*<br/>`0x06`<br/><br/>*resource:*<br/>`reset_chat`</td>
      <td>Configuration</td>
      <td>Client</td>
      <td colspan="3">*no fields*</td>
    </tr>
  </tbody>
</table>

#### Registry Data

Represents certain registries that are sent from the server and are applied on the client.

See [Registry Data](registry_data.md) for details.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>State</th>
      <th>Bound To</th>
      <th colspan="2">Field Name</th>
      <th colspan="2">Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="3">*protocol:*<br/>`0x07`<br/><br/>*resource:*<br/>`registry_data`</td>
      <td rowspan="3">Configuration</td>
      <td rowspan="3">Client</td>
      <td colspan="2">Registry ID</td>
      <td colspan="2">`Identifier`</td>
      <td></td>
    </tr>
    <tr>
      <td rowspan="2">Entries</td>
      <td>Entry ID</td>
      <td rowspan="2">`Prefixed Array`</td>
      <td>`Identifier`</td>
      <td></td>
    </tr>
    <tr>
      <td>Data</td>
      <td>`Prefixed Optional` `NBT`</td>
      <td>Entry data.</td>
    </tr>
  </tbody>
</table>

#### Remove Resource Pack (configuration)

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
      <td rowspan="1">*protocol:*<br/>`0x08`<br/><br/>*resource:*<br/>`resource_pack_pop`</td>
      <td rowspan="1">Configuration</td>
      <td rowspan="1">Client</td>
      <td>UUID</td>
      <td>`Prefixed Optional` `UUID`</td>
      <td>The `UUID` of the resource pack to be removed. If not present every resource pack will be removed.</td>
    </tr>
  </tbody>
</table>

#### Add Resource Pack (configuration)

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
      <td rowspan="5">*protocol:*<br/>`0x09`<br/><br/>*resource:*<br/>`resource_pack_push`</td>
      <td rowspan="5">Configuration</td>
      <td rowspan="5">Client</td>
      <td>UUID</td>
      <td>`UUID`</td>
      <td>The unique identifier of the resource pack.</td>
    </tr>
    <tr>
      <td>URL</td>
      <td>`String` (32767)</td>
      <td>The URL to the resource pack.</td>
    </tr>
    <tr>
      <td>Hash</td>
      <td>`String` (40)</td>
      <td>A 40 character hexadecimal, case-insensitive [SHA-1](wikipedia-sha-1.md) hash of the resource pack file.<br />If it's not a 40 character hexadecimal string, the client will not use it for hash verification and likely waste bandwidth.</td>
    </tr>
    <tr>
      <td>Forced</td>
      <td>`Boolean`</td>
      <td>The vanilla client will be forced to use the resource pack from the server. If they decline they will be kicked from the server.</td>
    </tr>
    <tr>
      <td>Prompt Message</td>
      <td>`Prefixed Optional` `Text Component`</td>
      <td>This is shown in the prompt making the client accept or decline the resource pack (only if present).</td>
    </tr>
  </tbody>
</table>

#### Store Cookie (configuration)

Stores some arbitrary data on the client, which persists between server transfers. The vanilla client only accepts cookies of up to 5 kiB in size.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>State</th>
      <th>Bound To</th>
      <th colspan="2">Field Name</th>
      <th colspan="2">Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="2">*protocol:*<br/>`0x0A`<br/><br/>*resource:*<br/>`store_cookie`</td>
      <td rowspan="2">Configuration</td>
      <td rowspan="2">Client</td>
      <td colspan="2">Key</td>
      <td colspan="2">`Identifier`</td>
      <td>The identifier of the cookie.</td>
    </tr>
    <tr>
      <td colspan="2">Payload</td>
      <td colspan="2">`Prefixed Array` (5120) of `Byte`</td>
      <td>The data of the cookie.</td>
    </tr>
  </tbody>
</table>

#### Transfer (configuration)

Notifies the client that it should transfer to the given server. Cookies previously stored are preserved between server transfers.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>State</th>
      <th>Bound To</th>
      <th colspan="2">Field Name</th>
      <th colspan="2">Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="2">*protocol:*<br/>`0x0B`<br/><br/>*resource:*<br/>`transfer`</td>
      <td rowspan="2">Configuration</td>
      <td rowspan="2">Client</td>
      <td colspan="2">Host</td>
      <td colspan="2">`String` (32767)</td>
      <td>The hostname or IP of the server.</td>
    </tr>
    <tr>
      <td colspan="2">Port</td>
      <td colspan="2">`VarInt`</td>
      <td>The port of the server.</td>
    </tr>
  </tbody>
</table>

#### Feature Flags

Used to enable and disable features, generally experimental ones, on the client.

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
      <td rowspan="1">*protocol:*<br/>`0x0C`<br/><br/>*resource:*<br/>`update_enabled_features`</td>
      <td rowspan="1">Configuration</td>
      <td rowspan="1">Client</td>
      <td>Feature Flags</td>
      <td>`Prefixed Array` of `Identifier`</td>
      <td></td>
    </tr>
  </tbody>
</table>

There is one special feature flag, which is in most versions:
- minecraft:vanilla - enables vanilla features

For the other feature flags, which may change between versions, see [Experiments#Java_Edition](experiments.md#javaedition).

#### Update Tags (configuration)

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>State</th>
      <th>Bound To</th>
      <th colspan="2">Field Name</th>
      <th colspan="2">Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="2">*protocol:*<br/>`0x0D`<br/><br/>*resource:*<br/>`update_tags`</td>
      <td rowspan="2">Configuration</td>
      <td rowspan="2">Client</td>
      <td rowspan="2">Array of tags</td>
      <td>Registry</td>
      <td rowspan="2">`Prefixed Array`</td>
      <td>`Identifier`</td>
      <td>Registry identifier (Vanilla expects tags for the registries `minecraft:block`, `minecraft:item`, `minecraft:fluid`, `minecraft:entity_type`, and `minecraft:game_event`)</td>
    </tr>
    <tr>
      <td>Array of Tag</td>
      <td>(See below)</td>
      <td></td>
    </tr>
  </tbody>
</table>

Tag arrays look like:

<table class="wikitable">
  <tbody>
    <tr>
      <th colspan="2">Field Name</th>
      <th colspan="2">Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="2">Tags</td>
      <td>Tag name</td>
      <td rowspan="2">`Prefixed Array`</td>
      <td>`Identifier`</td>
      <td></td>
    </tr>
    <tr>
      <td>Entries</td>
      <td>`Prefixed Array` of `VarInt`</td>
      <td>Numeric IDs of the given type (block, item, etc.). This list replaces the previous list of IDs for the given tag. If some preexisting tags are left unmentioned, a warning is printed.</td>
    </tr>
  </tbody>
</table>

See [Tag](tag.md) on the Minecraft Wiki for more information, including a list of vanilla tags.

#### Clientbound Known Packs

Informs the client of which data packs are present on the server.
The client is expected to respond with its own [[#Serverbound_Known_Packs|Serverbound Known Packs]] packet.
The vanilla server does not continue with Configuration until it receives a response.

The vanilla client requires the `minecraft:core` pack with version `1.21.5` for a normal login sequence. This packet must be sent before the Registry Data packets.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>State</th>
      <th>Bound To</th>
      <th colspan="2">Field Name</th>
      <th colspan="2">Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="3">*protocol:*<br/>`0x0E`<br/><br/>*resource:*<br/>`select_known_packs`</td>
      <td rowspan="3">Configuration</td>
      <td rowspan="3">Client</td>
      <td rowspan="3">Known Packs</td>
      <td>Namespace</td>
      <td rowspan="3">`Prefixed Array`</td>
      <td>`String` (32767)</td>
      <td></td>
    </tr>
    <tr>
      <td>ID</td>
      <td>`String` (32767)</td>
      <td></td>
    </tr>
    <tr>
      <td>Version</td>
      <td>`String` (32767)</td>
      <td></td>
    </tr>
  </tbody>
</table>

#### Custom Report Details (configuration)

Contains a list of key-value text entries that are included in any crash or disconnection report generated during connection to the server.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>State</th>
      <th>Bound To</th>
      <th colspan="2">Field Name</th>
      <th colspan="2">Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="2">*protocol:*<br/>`0x0F`<br/><br/>*resource:*<br/>`custom_report_details`</td>
      <td rowspan="2">Configuration</td>
      <td rowspan="2">Client</td>
      <td rowspan="2">Details</td>
      <td>Title</td>
      <td rowspan="2">`Prefixed Array` (32)</td>
      <td>`String` (128)</td>
      <td></td>
    </tr>
    <tr>
      <td>Description</td>
      <td>`String` (4096)</td>
      <td></td>
    </tr>
  </tbody>
</table>

#### Server Links (configuration)

This packet contains a list of links that the vanilla client will display in the menu available from the pause menu. Link labels can be built-in or custom (i.e., any text).

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>State</th>
      <th>Bound To</th>
      <th colspan="2">Field Name</th>
      <th colspan="2">Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="2">*protocol:*<br/>`0x10`<br/><br/>*resource:*<br/>`server_links`</td>
      <td rowspan="2">Configuration</td>
      <td rowspan="2">Client</td>
      <td rowspan="2">Links</td>
      <td>Label</td>
      <td rowspan="2">`Prefixed Array`</td>
      <td>`VarInt` `Enum` `or` `Text Component`</td>
      <td>Enums are used for built-in labels (see below), text components for custom labels.</td>
    </tr>
    <tr>
      <td>URL</td>
      <td>`String`</td>
      <td>Valid URL.</td>
    </tr>
  </tbody>
</table>


<table class="wikitable">
  <tbody>
    <tr>
      <th>ID</th>
      <th>Name</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>0</td>
      <td>Bug Report</td>
      <td>Displayed on connection error screen; included as a comment in the disconnection report.</td>
    </tr>
    <tr>
      <td>1</td>
      <td>Community Guidelines</td>
      <td></td>
    </tr>
    <tr>
      <td>2</td>
      <td>Support</td>
      <td></td>
    </tr>
    <tr>
      <td>3</td>
      <td>Status</td>
      <td></td>
    </tr>
    <tr>
      <td>4</td>
      <td>Feedback</td>
      <td></td>
    </tr>
    <tr>
      <td>5</td>
      <td>Community</td>
      <td></td>
    </tr>
    <tr>
      <td>6</td>
      <td>Website</td>
      <td></td>
    </tr>
    <tr>
      <td>7</td>
      <td>Forums</td>
      <td></td>
    </tr>
    <tr>
      <td>8</td>
      <td>News</td>
      <td></td>
    </tr>
    <tr>
      <td>9</td>
      <td>Announcements</td>
      <td></td>
    </tr>
  </tbody>
</table>

### Serverbound

#### Client Information (configuration)

Sent when the player connects, or when settings are changed.

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
      <td rowspan="9">*protocol:*<br/>`0x00`<br/><br/>*resource:*<br/>`client_information`</td>
      <td rowspan="9">Configuration</td>
      <td rowspan="9">Server</td>
      <td>Locale</td>
      <td>`String` (16)</td>
      <td>e.g. `en_GB`.</td>
    </tr>
    <tr>
      <td>View Distance</td>
      <td>`Byte`</td>
      <td>Client-side render distance, in chunks.</td>
    </tr>
    <tr>
      <td>Chat Mode</td>
      <td>`VarInt` `Enum`</td>
      <td>0: enabled, 1: commands only, 2: hidden.  See [Chat#Client chat mode](chat.md#client-chat-mode) for more information.</td>
    </tr>
    <tr>
      <td>Chat Colors</td>
      <td>`Boolean`</td>
      <td>“Colors” multiplayer setting. The vanilla server stores this value but does nothing with it (see [MC-64867](https://bugs.mojang.com/browse/MC-64867)). Third-party servers such as Hypixel disable all coloring in chat and system messages when it is false.</td>
    </tr>
    <tr>
      <td>Displayed Skin Parts</td>
      <td>`Unsigned Byte`</td>
      <td>Bit mask, see below.</td>
    </tr>
    <tr>
      <td>Main Hand</td>
      <td>`VarInt` `Enum`</td>
      <td>0: Left, 1: Right.</td>
    </tr>
    <tr>
      <td>Enable text filtering</td>
      <td>`Boolean`</td>
      <td>Enables filtering of text on signs and written book titles. The vanilla client sets this according to the `profanityFilterPreferences.profanityFilterOn` account attribute indicated by the [`/player/attributes` Mojang API endpoint](mojang-api.md#player-attributes). In offline mode it is always false.</td>
    </tr>
    <tr>
      <td>Allow server listings</td>
      <td>`Boolean`</td>
      <td>Servers usually list online players, this option should let you not show up in that list.</td>
    </tr>
    <tr>
      <td>Particle Status</td>
      <td>`VarInt` `Enum`</td>
      <td>0: all, 1: decreased, 2: minimal</td>
    </tr>
  </tbody>
</table>

*Displayed Skin Parts* flags:

- Bit 0 (0x01): Cape enabled
- Bit 1 (0x02): Jacket enabled
- Bit 2 (0x04): Left Sleeve enabled
- Bit 3 (0x08): Right Sleeve enabled
- Bit 4 (0x10): Left Pants Leg enabled
- Bit 5 (0x20): Right Pants Leg enabled
- Bit 6 (0x40): Hat enabled

The most significant bit (bit 7, 0x80) appears to be unused.

#### Cookie Response (configuration)

Response to a [[#Cookie_Request_(configuration)|Cookie Request (configuration)]] from the server. The vanilla server only accepts responses of up to 5 kiB in size.

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
      <td rowspan="2">*protocol:*<br/>`0x01`<br/><br/>*resource:*<br/>`cookie_response`</td>
      <td rowspan="2">Configuration</td>
      <td rowspan="2">Server</td>
      <td>Key</td>
      <td>`Identifier`</td>
      <td>The identifier of the cookie.</td>
    </tr>
    <tr>
      <td>Payload</td>
      <td>`Prefixed Optional` `Prefixed Array` (5120) of `Byte`</td>
      <td>The data of the cookie.</td>
    </tr>
  </tbody>
</table>

#### Serverbound Plugin Message (configuration)

_Main article: [Minecraft Wiki:Projects/wiki.vg merge/Plugin channels](./plugin-channels.md)_

Mods and plugins can use this to send their data. Minecraft itself uses some [plugin channels](plugin-channels.md). These internal channels are in the `minecraft` namespace.

More documentation on this: <https://dinnerbone.com/blog/2012/01/13/minecraft-plugin-channels-messaging/>(https://dinnerbone.com/blog/2012/01/13/minecraft-plugin-channels-messaging/)

Note that the length of Data is known only from the packet length, since the packet has no length field of any kind.

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
      <td rowspan="2">*protocol:*<br/>`0x02`<br/><br/>*resource:*<br/>`custom_payload`</td>
      <td rowspan="2">Configuration</td>
      <td rowspan="2">Server</td>
      <td>Channel</td>
      <td>`Identifier`</td>
      <td>Name of the [plugin channel](plugin-channels.md) used to send the data.</td>
    </tr>
    <tr>
      <td>Data</td>
      <td>`Byte Array` (32767)</td>
      <td>Any data, depending on the channel. `minecraft:` channels are documented [here](plugin-channels.md). The length of this array must be inferred from the packet length.</td>
    </tr>
  </tbody>
</table>

In vanilla server, the maximum data length is 32767 bytes.

#### Acknowledge Finish Configuration

Sent by the client to notify the server that the configuration process has finished. It is sent in response to the server's [[#Finish_Configuration|Finish Configuration]].

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
      <td rowspan="1">*protocol:*<br/>`0x03`<br/><br/>*resource:*<br/>`finish_configuration`</td>
      <td rowspan="1">Configuration</td>
      <td rowspan="1">Server</td>
      <td colspan="3">*no fields*</td>
    </tr>
  </tbody>
</table>

This packet switches the connection state to [[#Play|play]].

#### Serverbound Keep Alive (configuration)

The server will frequently send out a keep-alive (see [[#Clientbound Keep Alive (configuration)|Clientbound Keep Alive]]), each containing a random ID. The client must respond with the same packet.

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
      <td>*protocol:*<br/>`0x04`<br/><br/>*resource:*<br/>`keep_alive`</td>
      <td>Configuration</td>
      <td>Server</td>
      <td>Keep Alive ID</td>
      <td>`Long`</td>
      <td></td>
    </tr>
  </tbody>
</table>

#### Pong (configuration)

Response to the clientbound packet ([[#Ping (configuration)|Ping]]) with the same id.

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
      <td>*protocol:*<br/>`0x05`<br/><br/>*resource:*<br/>`pong`</td>
      <td>Configuration</td>
      <td>Server</td>
      <td>ID</td>
      <td>`Int`</td>
      <td></td>
    </tr>
  </tbody>
</table>

#### Resource Pack Response (configuration)

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
      <td rowspan="2">*protocol:*<br/>`0x06`<br/><br/>*resource:*<br/>`resource_pack`</td>
      <td rowspan="2">Configuration</td>
      <td rowspan="2">Server</td>
      <td>UUID</td>
      <td>`UUID`</td>
      <td>The unique identifier of the resource pack received in the [[#Add_Resource_Pack_(configuration)|Add Resource Pack (configuration)]] request.</td>
    </tr>
    <tr>
      <td>Result</td>
      <td>`VarInt` `Enum`</td>
      <td>Result ID (see below).</td>
    </tr>
  </tbody>
</table>

Result can be one of the following values:

<table class="wikitable">
  <tbody>
    <tr>
      <th>ID</th>
      <th>Result</th>
    </tr>
    <tr>
      <td>0</td>
      <td>Successfully downloaded</td>
    </tr>
    <tr>
      <td>1</td>
      <td>Declined</td>
    </tr>
    <tr>
      <td>2</td>
      <td>Failed to download</td>
    </tr>
    <tr>
      <td>3</td>
      <td>Accepted</td>
    </tr>
    <tr>
      <td>4</td>
      <td>Downloaded</td>
    </tr>
    <tr>
      <td>5</td>
      <td>Invalid URL</td>
    </tr>
    <tr>
      <td>6</td>
      <td>Failed to reload</td>
    </tr>
    <tr>
      <td>7</td>
      <td>Discarded</td>
    </tr>
  </tbody>
</table>

#### Serverbound Known Packs

Informs the server of which data packs are present on the client. The client sends this in response to [[#Clientbound_Known_Packs|Clientbound Known Packs]].

If the client specifies a pack in this packet, the server should omit its contained data from the [[#Registry_Data_2|Registry Data]] packet.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>State</th>
      <th>Bound To</th>
      <th colspan="2">Field Name</th>
      <th colspan="2">Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="3">*protocol:*<br/>`0x07`<br/><br/>*resource:*<br/>`select_known_packs`</td>
      <td rowspan="3">Configuration</td>
      <td rowspan="3">Server</td>
      <td rowspan="3">Known Packs</td>
      <td>Namespace</td>
      <td rowspan="3">`Prefixed Array`</td>
      <td>`String`</td>
      <td></td>
    </tr>
    <tr>
      <td>ID</td>
      <td>`String`</td>
      <td></td>
    </tr>
    <tr>
      <td>Version</td>
      <td>`String`</td>
      <td></td>
    </tr>
  </tbody>
</table>

## Play

### Clientbound

#### Bundle Delimiter

The delimiter for a bundle of packets. When received, the client should store every subsequent packet it receives, and wait until another delimiter is received. Once that happens, the client is guaranteed to process every packet in the bundle on the same tick, and the client should stop storing packets.

As of 1.20.6, the vanilla server only uses this to ensure [[#Spawn_Entity|Spawn Entity]] and associated packets used to configure the entity happen on the same tick. Each entity gets a separate bundle.

The vanilla client doesn't allow more than 4096 packets in the same bundle.

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
      <td>*protocol:*<br/>`0x00`<br/><br/>*resource:*<br/>`bundle_delimiter`</td>
      <td>Play</td>
      <td>Client</td>
      <td colspan="3">*no fields*</td>
    </tr>
  </tbody>
</table>

#### Spawn Entity

Sent by the server when an entity (aside from [[#Spawn_Experience_Orb|Experience Orb]]) is created.

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
      <td rowspan="13">*protocol:*<br/>`0x01`<br/><br/>*resource:*<br/>`add_entity`</td>
      <td rowspan="13">Play</td>
      <td rowspan="13">Client</td>
      <td>Entity ID</td>
      <td>`VarInt`</td>
      <td>A unique integer ID mostly used in the protocol to identify the entity.</td>
    </tr>
    <tr>
      <td>Entity UUID</td>
      <td>`UUID`</td>
      <td>A unique identifier that is mostly used in persistence and places where the uniqueness matters more.</td>
    </tr>
    <tr>
      <td>Type</td>
      <td>`VarInt`</td>
      <td>ID in the `minecraft:entity_type` registry (see "type" field in [Entity metadata#Entities](entity-metadata.md#entities)).</td>
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
      <td>Pitch</td>
      <td>`Angle`</td>
      <td>To get the real pitch, you must divide this by (256.0F / 360.0F)</td>
    </tr>
    <tr>
      <td>Yaw</td>
      <td>`Angle`</td>
      <td>To get the real yaw, you must divide this by (256.0F / 360.0F)</td>
    </tr>
    <tr>
      <td>Head Yaw</td>
      <td>`Angle`</td>
      <td>Only used by living entities, where the head of the entity may differ from the general body rotation.</td>
    </tr>
    <tr>
      <td>Data</td>
      <td>`VarInt`</td>
      <td>Meaning dependent on the value of the Type field, see [Object Data](object-data.md) for details.</td>
    </tr>
    <tr>
      <td>Velocity X</td>
      <td>`Short`</td>
      <td rowspan="3">Same units as [[#Set Entity Velocity|Set Entity Velocity]].</td>
    </tr>
    <tr>
      <td>Velocity Y</td>
      <td>`Short`</td>
    </tr>
    <tr>
      <td>Velocity Z</td>
      <td>`Short`</td>
    </tr>
  </tbody>
</table>

> ⚠️ **Warning:** The points listed below should be considered when this packet is used to spawn a player entity.
When in [online mode](server.properties.md#online-mode), the UUIDs must be valid and have valid skin blobs.
In offline mode, the vanilla server uses [UUID v3](wikipedia-universally-unique-identifier.md#versions-3-and-5-namespace-name-based) and chooses the player's UUID by using the String `OfflinePlayer:&lt;player name&gt;`, encoding it in UTF-8 (and case-sensitive), then processes it with `[UUID.nameUUIDFromBytes](https://github.com/AdoptOpenJDK/openjdk-jdk8u/blob/9a91972c76ddda5c1ce28b50ca38cbd8a30b7a72/jdk/src/share/classes/java/util/UUID.java#L153-L175)`.

For NPCs UUID v2 should be used. Note:

 <+Grum> i will never confirm this as a feature you know that :)

In an example UUID, `xxxxxxxx-xxxx-Yxxx-xxxx-xxxxxxxxxxxx`, the UUID version is specified by `Y`. So, for UUID v3, `Y` will always be `3`, and for UUID v2, `Y` will always be `2`.

#### Entity Animation

Sent whenever an entity should change animation.

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
      <td rowspan="2">*protocol:*<br/>`0x02`<br/><br/>*resource:*<br/>`animate`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Client</td>
      <td>Entity ID</td>
      <td>`VarInt`</td>
      <td>Player ID.</td>
    </tr>
    <tr>
      <td>Animation</td>
      <td>`Unsigned Byte`</td>
      <td>Animation ID (see below).</td>
    </tr>
  </tbody>
</table>

Animation can be one of the following values:

<table class="wikitable">
  <tbody>
    <tr>
      <th>ID</th>
      <th>Animation</th>
    </tr>
    <tr>
      <td>0</td>
      <td>Swing main arm</td>
    </tr>
    <tr>
      <td>2</td>
      <td>Leave bed</td>
    </tr>
    <tr>
      <td>3</td>
      <td>Swing offhand</td>
    </tr>
    <tr>
      <td>4</td>
      <td>Critical effect</td>
    </tr>
    <tr>
      <td>5</td>
      <td>Magic critical effect</td>
    </tr>
  </tbody>
</table>

#### Award Statistics

Sent as a response to [[#Client Status|Client Status]] (id 1). Will only send the changed values if previously requested.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>State</th>
      <th>Bound To</th>
      <th colspan="2">Field Name</th>
      <th colspan="2">Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="3">*protocol:*<br/>`0x03`<br/><br/>*resource:*<br/>`award_stats`</td>
      <td rowspan="3">Play</td>
      <td rowspan="3">Client</td>
      <td rowspan="3">Statistics</td>
      <td>Category ID</td>
      <td rowspan="3">`Prefixed Array`</td>
      <td>`VarInt`</td>
      <td>See below.</td>
    </tr>
    <tr>
      <td>Statistic ID</td>
      <td>`VarInt`</td>
      <td>See below.</td>
    </tr>
    <tr>
      <td>Value</td>
      <td>`VarInt`</td>
      <td>The amount to set it to.</td>
    </tr>
  </tbody>
</table>

Categories (these are namespaced, but with `:` replaced with `.`):

<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>ID</th>
      <th>Registry</th>
    </tr>
    <tr>
      <td>`minecraft.mined`</td>
      <td>0</td>
      <td>Blocks</td>
    </tr>
    <tr>
      <td>`minecraft.crafted`</td>
      <td>1</td>
      <td>Items</td>
    </tr>
    <tr>
      <td>`minecraft.used`</td>
      <td>2</td>
      <td>Items</td>
    </tr>
    <tr>
      <td>`minecraft.broken`</td>
      <td>3</td>
      <td>Items</td>
    </tr>
    <tr>
      <td>`minecraft.picked_up`</td>
      <td>4</td>
      <td>Items</td>
    </tr>
    <tr>
      <td>`minecraft.dropped`</td>
      <td>5</td>
      <td>Items</td>
    </tr>
    <tr>
      <td>`minecraft.killed`</td>
      <td>6</td>
      <td>Entities</td>
    </tr>
    <tr>
      <td>`minecraft.killed_by`</td>
      <td>7</td>
      <td>Entities</td>
    </tr>
    <tr>
      <td>`minecraft.custom`</td>
      <td>8</td>
      <td>Custom</td>
    </tr>
  </tbody>
</table>

Blocks, Items, and Entities use block (not block state), item, and entity ids.

Custom has the following (unit only matters for clients):

<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>ID</th>
      <th>Unit</th>
    </tr>
    <tr>
      <td>`minecraft.leave_game`</td>
      <td>0</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.play_time`</td>
      <td>1</td>
      <td>Time</td>
    </tr>
    <tr>
      <td>`minecraft.total_world_time`</td>
      <td>2</td>
      <td>Time</td>
    </tr>
    <tr>
      <td>`minecraft.time_since_death`</td>
      <td>3</td>
      <td>Time</td>
    </tr>
    <tr>
      <td>`minecraft.time_since_rest`</td>
      <td>4</td>
      <td>Time</td>
    </tr>
    <tr>
      <td>`minecraft.sneak_time`</td>
      <td>5</td>
      <td>Time</td>
    </tr>
    <tr>
      <td>`minecraft.walk_one_cm`</td>
      <td>6</td>
      <td>Distance</td>
    </tr>
    <tr>
      <td>`minecraft.crouch_one_cm`</td>
      <td>7</td>
      <td>Distance</td>
    </tr>
    <tr>
      <td>`minecraft.sprint_one_cm`</td>
      <td>8</td>
      <td>Distance</td>
    </tr>
    <tr>
      <td>`minecraft.walk_on_water_one_cm`</td>
      <td>9</td>
      <td>Distance</td>
    </tr>
    <tr>
      <td>`minecraft.fall_one_cm`</td>
      <td>10</td>
      <td>Distance</td>
    </tr>
    <tr>
      <td>`minecraft.climb_one_cm`</td>
      <td>11</td>
      <td>Distance</td>
    </tr>
    <tr>
      <td>`minecraft.fly_one_cm`</td>
      <td>12</td>
      <td>Distance</td>
    </tr>
    <tr>
      <td>`minecraft.walk_under_water_one_cm`</td>
      <td>13</td>
      <td>Distance</td>
    </tr>
    <tr>
      <td>`minecraft.minecart_one_cm`</td>
      <td>14</td>
      <td>Distance</td>
    </tr>
    <tr>
      <td>`minecraft.boat_one_cm`</td>
      <td>15</td>
      <td>Distance</td>
    </tr>
    <tr>
      <td>`minecraft.pig_one_cm`</td>
      <td>16</td>
      <td>Distance</td>
    </tr>
    <tr>
      <td>`minecraft.horse_one_cm`</td>
      <td>17</td>
      <td>Distance</td>
    </tr>
    <tr>
      <td>`minecraft.aviate_one_cm`</td>
      <td>18</td>
      <td>Distance</td>
    </tr>
    <tr>
      <td>`minecraft.swim_one_cm`</td>
      <td>19</td>
      <td>Distance</td>
    </tr>
    <tr>
      <td>`minecraft.strider_one_cm`</td>
      <td>20</td>
      <td>Distance</td>
    </tr>
    <tr>
      <td>`minecraft.jump`</td>
      <td>21</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.drop`</td>
      <td>22</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.damage_dealt`</td>
      <td>23</td>
      <td>Damage</td>
    </tr>
    <tr>
      <td>`minecraft.damage_dealt_absorbed`</td>
      <td>24</td>
      <td>Damage</td>
    </tr>
    <tr>
      <td>`minecraft.damage_dealt_resisted`</td>
      <td>25</td>
      <td>Damage</td>
    </tr>
    <tr>
      <td>`minecraft.damage_taken`</td>
      <td>26</td>
      <td>Damage</td>
    </tr>
    <tr>
      <td>`minecraft.damage_blocked_by_shield`</td>
      <td>27</td>
      <td>Damage</td>
    </tr>
    <tr>
      <td>`minecraft.damage_absorbed`</td>
      <td>28</td>
      <td>Damage</td>
    </tr>
    <tr>
      <td>`minecraft.damage_resisted`</td>
      <td>29</td>
      <td>Damage</td>
    </tr>
    <tr>
      <td>`minecraft.deaths`</td>
      <td>30</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.mob_kills`</td>
      <td>31</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.animals_bred`</td>
      <td>32</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.player_kills`</td>
      <td>33</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.fish_caught`</td>
      <td>34</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.talked_to_villager`</td>
      <td>35</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.traded_with_villager`</td>
      <td>36</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.eat_cake_slice`</td>
      <td>37</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.fill_cauldron`</td>
      <td>38</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.use_cauldron`</td>
      <td>39</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.clean_armor`</td>
      <td>40</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.clean_banner`</td>
      <td>41</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.clean_shulker_box`</td>
      <td>42</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.interact_with_brewingstand`</td>
      <td>43</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.interact_with_beacon`</td>
      <td>44</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.inspect_dropper`</td>
      <td>45</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.inspect_hopper`</td>
      <td>46</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.inspect_dispenser`</td>
      <td>47</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.play_noteblock`</td>
      <td>48</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.tune_noteblock`</td>
      <td>49</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.pot_flower`</td>
      <td>50</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.trigger_trapped_chest`</td>
      <td>51</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.open_enderchest`</td>
      <td>52</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.enchant_item`</td>
      <td>53</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.play_record`</td>
      <td>54</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.interact_with_furnace`</td>
      <td>55</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.interact_with_crafting_table`</td>
      <td>56</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.open_chest`</td>
      <td>57</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.sleep_in_bed`</td>
      <td>58</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.open_shulker_box`</td>
      <td>59</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.open_barrel`</td>
      <td>60</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.interact_with_blast_furnace`</td>
      <td>61</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.interact_with_smoker`</td>
      <td>62</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.interact_with_lectern`</td>
      <td>63</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.interact_with_campfire`</td>
      <td>64</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.interact_with_cartography_table`</td>
      <td>65</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.interact_with_loom`</td>
      <td>66</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.interact_with_stonecutter`</td>
      <td>67</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.bell_ring`</td>
      <td>68</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.raid_trigger`</td>
      <td>69</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.raid_win`</td>
      <td>70</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.interact_with_anvil`</td>
      <td>71</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.interact_with_grindstone`</td>
      <td>72</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.target_hit`</td>
      <td>73</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft.interact_with_smithing_table`</td>
      <td>74</td>
      <td>None</td>
    </tr>
  </tbody>
</table>
 
Units:

- None: just a normal number (formatted with 0 decimal places)
- Damage: value is 10 times the normal amount
- Distance: a distance in centimeters (hundredths of blocks)
- Time: a time span in ticks

#### Acknowledge Block Change

Acknowledges a user-initiated block change. After receiving this packet, the client will display the block state sent by the server instead of the one predicted by the client.

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
      <td rowspan="1">*protocol:*<br/>`0x04`<br/><br/>*resource:*<br/>`block_changed_ack`</td>
      <td rowspan="1">Play</td>
      <td rowspan="1">Client</td>
      <td>Sequence ID</td>
      <td>`VarInt`</td>
      <td>Represents the sequence to acknowledge, this is used for properly syncing block changes to the client after interactions.</td>
    </tr>
  </tbody>
</table>

#### Set Block Destroy Stage

0–9 are the displayable destroy stages and each other number means that there is no animation on this coordinate.

Block break animations can still be applied on air; the animation will remain visible although there is no block being broken.  However, if this is applied to a transparent block, odd graphical effects may happen, including water losing its transparency.  (An effect similar to this can be seen in normal gameplay when breaking ice blocks)

If you need to display several break animations at the same time you have to give each of them a unique Entity ID. The entity ID does not need to correspond to an actual entity on the client. It is valid to use a randomly generated number.

When removing break animation, you must use the ID of the entity that set it.

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
      <td rowspan="3">*protocol:*<br/>`0x05`<br/><br/>*resource:*<br/>`block_destruction`</td>
      <td rowspan="3">Play</td>
      <td rowspan="3">Client</td>
      <td>Entity ID</td>
      <td>`VarInt`</td>
      <td>The ID of the entity breaking the block.</td>
    </tr>
    <tr>
      <td>Location</td>
      <td>`Position`</td>
      <td>Block Position.</td>
    </tr>
    <tr>
      <td>Destroy Stage</td>
      <td>`Unsigned Byte`</td>
      <td>0–9 to set it, any other value to remove it.</td>
    </tr>
  </tbody>
</table>

#### Block Entity Data

Sets the block entity associated with the block at the given location.

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
      <td rowspan="3">*protocol:*<br/>`0x06`<br/><br/>*resource:*<br/>`block_entity_data`</td>
      <td rowspan="3">Play</td>
      <td rowspan="3">Client</td>
      <td>Location</td>
      <td>`Position`</td>
      <td></td>
    </tr>
    <tr>
      <td>Type</td>
      <td>`VarInt`</td>
      <td>ID in the `minecraft:block_entity_type` registry</td>
    </tr>
    <tr>
      <td>NBT Data</td>
      <td>`NBT`</td>
      <td>Data to set.</td>
    </tr>
  </tbody>
</table>

#### Block Action

This packet is used for a number of actions and animations performed by blocks, usually non-persistent.  The client ignores the provided block type and instead uses the block state in their world.

See [Block Actions](block-actions.md) for a list of values.

> ⚠️ **Warning:** This packet uses a block ID from the `minecraft:block` registry, not a block state.

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
      <td rowspan="4">*protocol:*<br/>`0x07`<br/><br/>*resource:*<br/>`block_event`</td>
      <td rowspan="4">Play</td>
      <td rowspan="4">Client</td>
      <td>Location</td>
      <td>`Position`</td>
      <td>Block coordinates.</td>
    </tr>
    <tr>
      <td>Action ID (Byte 1)</td>
      <td>`Unsigned Byte`</td>
      <td>Varies depending on block — see [Block Actions](block-actions.md).</td>
    </tr>
    <tr>
      <td>Action Parameter (Byte 2)</td>
      <td>`Unsigned Byte`</td>
      <td>Varies depending on block — see [Block Actions](block-actions.md).</td>
    </tr>
    <tr>
      <td>Block Type</td>
      <td>`VarInt`</td>
      <td>ID in the `minecraft:block` registry. This value is unused by the vanilla client, as it will infer the type of block based on the given position.</td>
    </tr>
  </tbody>
</table>

#### Block Update

Fired whenever a block is changed within the render distance.

> ⚠️ **Warning:** Changing a block in a chunk that is not loaded is not a stable action.  The vanilla client currently uses a *shared* empty chunk which is modified for all block changes in unloaded chunks; while in 1.9 this chunk never renders in older versions the changed block will appear in all copies of the empty chunk.  Servers should avoid sending block changes in unloaded chunks and clients should ignore such packets.

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
      <td rowspan="2">*protocol:*<br/>`0x08`<br/><br/>*resource:*<br/>`block_update`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Client</td>
      <td>Location</td>
      <td>`Position`</td>
      <td>Block Coordinates.</td>
    </tr>
    <tr>
      <td>Block ID</td>
      <td>`VarInt`</td>
      <td>The new block state ID for the block as given in the [block state registry](chunk-format.md#block-state-registry).</td>
    </tr>
  </tbody>
</table>

#### Boss Bar

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>State</th>
      <th>Bound To</th>
      <th colspan="2">Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="14">*protocol:*<br/>`0x09`<br/><br/>*resource:*<br/>`boss_event`</td>
      <td rowspan="14">Play</td>
      <td rowspan="14">Client</td>
      <td colspan="2">UUID</td>
      <td>`UUID`</td>
      <td>Unique ID for this bar.</td>
    </tr>
    <tr>
      <td colspan="2">Action</td>
      <td>`VarInt` `Enum`</td>
      <td>Determines the layout of the remaining packet.</td>
    </tr>
    <tr>
      <th>Action</th>
      <th>Field Name</th>
      <th></th>
      <th></th>
    </tr>
    <tr>
      <td rowspan="5">0: add</td>
      <td>Title</td>
      <td>`Text Component`</td>
      <td></td>
    </tr>
    <tr>
      <td>Health</td>
      <td>`Float`</td>
      <td>From 0 to 1. Values greater than 1 do not crash a vanilla client, and start [rendering part of a second health bar](https://i.johni0702.de/nA.png) at around 1.5.</td>
    </tr>
    <tr>
      <td>Color</td>
      <td>`VarInt` `Enum`</td>
      <td>Color ID (see below).</td>
    </tr>
    <tr>
      <td>Division</td>
      <td>`VarInt` `Enum`</td>
      <td>Type of division (see below).</td>
    </tr>
    <tr>
      <td>Flags</td>
      <td>`Unsigned Byte`</td>
      <td>Bit mask. 0x01: should darken sky, 0x02: is dragon bar (used to play end music), 0x04: create fog (previously was also controlled by 0x02).</td>
    </tr>
    <tr>
      <td>1: remove</td>
      <td>*no fields*</td>
      <td>*no fields*</td>
      <td>Removes this boss bar.</td>
    </tr>
    <tr>
      <td>2: update health</td>
      <td>Health</td>
      <td>`Float`</td>
      <td>*as above*</td>
    </tr>
    <tr>
      <td>3: update title</td>
      <td>Title</td>
      <td>`Text Component`</td>
      <td></td>
    </tr>
    <tr>
      <td rowspan="2">4: update style</td>
      <td>Color</td>
      <td>`VarInt` `Enum`</td>
      <td>Color ID (see below).</td>
    </tr>
    <tr>
      <td>Dividers</td>
      <td>`VarInt` `Enum`</td>
      <td>*as above*</td>
    </tr>
    <tr>
      <td>5: update flags</td>
      <td>Flags</td>
      <td>`Unsigned Byte`</td>
      <td>*as above*</td>
    </tr>
  </tbody>
</table>

<table class="wikitable">
  <tbody>
    <tr>
      <th>ID</th>
      <th>Color</th>
    </tr>
    <tr>
      <td>0</td>
      <td>Pink</td>
    </tr>
    <tr>
      <td>1</td>
      <td>Blue</td>
    </tr>
    <tr>
      <td>2</td>
      <td>Red</td>
    </tr>
    <tr>
      <td>3</td>
      <td>Green</td>
    </tr>
    <tr>
      <td>4</td>
      <td>Yellow</td>
    </tr>
    <tr>
      <td>5</td>
      <td>Purple</td>
    </tr>
    <tr>
      <td>6</td>
      <td>White</td>
    </tr>
  </tbody>
</table>

<table class="wikitable">
  <tbody>
    <tr>
      <th>ID</th>
      <th>Type of division</th>
    </tr>
    <tr>
      <td>0</td>
      <td>No division</td>
    </tr>
    <tr>
      <td>1</td>
      <td>6 notches</td>
    </tr>
    <tr>
      <td>2</td>
      <td>10 notches</td>
    </tr>
    <tr>
      <td>3</td>
      <td>12 notches</td>
    </tr>
    <tr>
      <td>4</td>
      <td>20 notches</td>
    </tr>
  </tbody>
</table>

#### Change Difficulty

Changes the difficulty setting in the client's option menu

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
      <td rowspan="2">*protocol:*<br/>`0x0A`<br/><br/>*resource:*<br/>`change_difficulty`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Client</td>
      <td>Difficulty</td>
      <td>`Unsigned Byte` `Enum`</td>
      <td>0: peaceful, 1: easy, 2: normal, 3: hard.</td>
    </tr>
    <tr>
      <td>Difficulty locked?</td>
      <td>`Boolean`</td>
      <td></td>
    </tr>
  </tbody>
</table>

#### Chunk Batch Finished

Marks the end of a chunk batch. The vanilla client marks the time it receives this packet and calculates the elapsed duration since the [[#Chunk Batch Start|beginning of the chunk batch]]. The server uses this duration and the batch size received in this packet to estimate the number of milliseconds elapsed per chunk received. This value is then used to calculate the desired number of chunks per tick through the formula `25 / millisPerChunk`, which is reported to the server through [[#Chunk Batch Received|Chunk Batch Received]]. This likely uses `25` instead of the normal tick duration of `50` so chunk processing will only use half of the client's and network's bandwidth.

The vanilla client uses the samples from the latest 15 batches to estimate the milliseconds per chunk number.

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
      <td rowspan="1">*protocol:*<br/>`0x0B`<br/><br/>*resource:*<br/>`chunk_batch_finished`</td>
      <td rowspan="1">Play</td>
      <td rowspan="1">Client</td>
      <td>Batch size</td>
      <td>`VarInt`</td>
      <td>Number of chunks.</td>
    </tr>
  </tbody>
</table>

#### Chunk Batch Start

Marks the start of a chunk batch. The vanilla client marks and stores the time it receives this packet.

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
      <td>*protocol:*<br/>`0x0C`<br/><br/>*resource:*<br/>`chunk_batch_start`</td>
      <td>Play</td>
      <td>Client</td>
      <td colspan="3">*no fields*</td>
    </tr>
  </tbody>
</table>

#### Chunk Biomes

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>State</th>
      <th>Bound To</th>
      <th colspan="2">Field Name</th>
      <th colspan="2">Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="3">*protocol:*<br/>`0x0D`<br/><br/>*resource:*<br/>`chunks_biomes`</td>
      <td rowspan="3">Play</td>
      <td rowspan="3">Client</td>
      <td rowspan="3">Chunk biome data</td>
      <td>Chunk Z</td>
      <td rowspan="3">`Prefixed Array`</td>
      <td>`Int`</td>
      <td>Chunk coordinate (block coordinate divided by 16, rounded down)</td>
    </tr>
    <tr>
      <td>Chunk X</td>
      <td>`Int`</td>
      <td>Chunk coordinate (block coordinate divided by 16, rounded down)</td>
    </tr>
    <tr>
      <td>Data</td>
      <td>`Prefixed Array` of `Byte`</td>
      <td>Chunk [data structure](chunk-format.md#data-structure), with [sections](chunk-format.md#chunksection) containing only the `Biomes` field</td>
    </tr>
  </tbody>
</table>

Note: The order of X and Z is inverted, because the client reads them as one big-endian `Long`, with Z being the upper 32 bits.

#### Clear Titles

Clear the client's current title information, with the option to also reset it.

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
      <td rowspan="1">*protocol:*<br/>`0x0E`<br/><br/>*resource:*<br/>`clear_titles`</td>
      <td rowspan="1">Play</td>
      <td rowspan="1">Client</td>
      <td>Reset</td>
      <td>`Boolean`</td>
      <td></td>
    </tr>
  </tbody>
</table>

#### Command Suggestions Response

The server responds with a list of auto-completions of the last word sent to it. In the case of regular chat, this is a player username. Command names and parameters are also supported. The client sorts these alphabetically before listing them.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>State</th>
      <th>Bound To</th>
      <th colspan="2">Field Name</th>
      <th colspan="2">Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="5">*protocol:*<br/>`0x0F`<br/><br/>*resource:*<br/>`command_suggestions`</td>
      <td rowspan="5">Play</td>
      <td rowspan="5">Client</td>
      <td colspan="2">ID</td>
      <td colspan="2">`VarInt`</td>
      <td>Transaction ID.</td>
    </tr>
    <tr>
      <td colspan="2">Start</td>
      <td colspan="2">`VarInt`</td>
      <td>Start of the text to replace.</td>
    </tr>
    <tr>
      <td colspan="2">Length</td>
      <td colspan="2">`VarInt`</td>
      <td>Length of the text to replace.</td>
    </tr>
    <tr>
      <td rowspan="2">Matches</td>
      <td>Match</td>
      <td rowspan="2">`Prefixed Array`</td>
      <td>`String` (32767)</td>
      <td>One eligible value to insert, note that each command is sent separately instead of in a single string, hence the need for Count.  Note that for instance this doesn't include a leading `/` on commands.</td>
    </tr>
    <tr>
      <td>Tooltip</td>
      <td>`Prefixed Optional` `Text Component`</td>
      <td>Tooltip to display.</td>
    </tr>
  </tbody>
</table>

#### Commands

Lists all of the commands on the server, and how they are parsed.

This is a directed graph, with one root node.  Each redirect or child node must refer only to nodes that have already been declared.

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
      <td rowspan="2">*protocol:*<br/>`0x10`<br/><br/>*resource:*<br/>`commands`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Client</td>
      <td>Nodes</td>
      <td>`Prefixed Array` of [Node](command-data.md#node-format)</td>
      <td>An array of nodes.</td>
    </tr>
    <tr>
      <td>Root index</td>
      <td>`VarInt`</td>
      <td>Index of the `root` node in the previous array.</td>
    </tr>
  </tbody>
</table>

For more information on this packet, see the [Command Data](command-data.md) article.

#### Close Container

This packet is sent from the server to the client when a window is forcibly closed, such as when a chest is destroyed while it's open. The vanilla client disregards the provided window ID and closes any active window.

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
      <td>*protocol:*<br/>`0x11`<br/><br/>*resource:*<br/>`container_close`</td>
      <td>Play</td>
      <td>Client</td>
      <td>Window ID</td>
      <td>`VarInt`</td>
      <td>This is the ID of the window that was closed. 0 for inventory.</td>
    </tr>
  </tbody>
</table>

#### Set Container Content

![The inventory slots](Inventory-slots.png)

Replaces the contents of a container window. Sent by the server upon initialization of a container window or the player's inventory, and in response to state ID mismatches (see [#Click Container](click-container.md)).

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
      <td rowspan="4">*protocol:*<br/>`0x12`<br/><br/>*resource:*<br/>`container_set_content`</td>
      <td rowspan="4">Play</td>
      <td rowspan="4">Client</td>
      <td>Window ID</td>
      <td>`VarInt`</td>
      <td>The ID of window which items are being sent for. 0 for player inventory. The client ignores any packets targeting a Window ID other than the current one. However, an exception is made for the player inventory, which may be targeted at any time. (The vanilla server does not appear to utilize this special case.)</td>
    </tr>
    <tr>
      <td>State ID</td>
      <td>`VarInt`</td>
      <td>A server-managed sequence number used to avoid desynchronization; see [#Click Container](click-container.md).</td>
    </tr>
    <tr>
      <td>Slot Data</td>
      <td>`Prefixed Array` of `Slot`</td>
    </tr>
    <tr>
      <td>Carried Item</td>
      <td>`Slot`</td>
      <td>Item being dragged with the mouse.</td>
    </tr>
  </tbody>
</table>

See [inventory windows](inventory.md#windows) for further information about how slots are indexed.
Use [[#Open Screen|Open Screen]] to open the container on the client.

#### Set Container Property

This packet is used to inform the client that part of a GUI window should be updated.

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
      <td rowspan="3">*protocol:*<br/>`0x13`<br/><br/>*resource:*<br/>`container_set_data`</td>
      <td rowspan="3">Play</td>
      <td rowspan="3">Client</td>
      <td>Window ID</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
    <tr>
      <td>Property</td>
      <td>`Short`</td>
      <td>The property to be updated, see below.</td>
    </tr>
    <tr>
      <td>Value</td>
      <td>`Short`</td>
      <td>The new value for the property, see below.</td>
    </tr>
  </tbody>
</table>

The meaning of the Property field depends on the type of the window. The following table shows the known combinations of window type and property, and how the value is to be interpreted.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Window type</th>
      <th>Property</th>
      <th>Value</th>
    </tr>
    <tr>
      <td rowspan="4">Furnace</td>
      <td>0: Fire icon (fuel left)</td>
      <td>counting from fuel burn time down to 0 (in-game ticks)</td>
    </tr>
    <tr>
      <td>1: Maximum fuel burn time</td>
      <td>fuel burn time or 0 (in-game ticks)</td>
    </tr>
    <tr>
      <td>2: Progress arrow</td>
      <td>counting from 0 to maximum progress (in-game ticks)</td>
    </tr>
    <tr>
      <td>3: Maximum progress</td>
      <td>always 200 on the vanilla server</td>
    </tr>
    <tr>
      <td rowspan="10">Enchantment Table</td>
      <td>0: Level requirement for top enchantment slot</td>
      <td rowspan="3">The enchantment's xp level requirement</td>
    </tr>
    <tr>
      <td>1: Level requirement for middle enchantment slot</td>
    </tr>
    <tr>
      <td>2: Level requirement for bottom enchantment slot</td>
    </tr>
    <tr>
      <td>3: The enchantment seed</td>
      <td>Used for drawing the enchantment names (in [SGA](wikipedia-standard-galactic-alphabet.md)) clientside.  The same seed *is* used to calculate enchantments, but some of the data isn't sent to the client to prevent easily guessing the entire list (the seed value here is the regular seed bitwise and `0xFFFFFFF0`).</td>
    </tr>
    <tr>
      <td>4: Enchantment ID shown on mouse hover over top enchantment slot</td>
      <td rowspan="3">The enchantment id (set to -1 to hide it), see below for values</td>
    </tr>
    <tr>
      <td>5: Enchantment ID shown on mouse hover over middle enchantment slot</td>
    </tr>
    <tr>
      <td>6: Enchantment ID shown on mouse hover over bottom enchantment slot</td>
    </tr>
    <tr>
      <td>7: Enchantment level shown on mouse hover over the top slot</td>
      <td rowspan="3">The enchantment level (1 = I, 2 = II, 6 = VI, etc.), or -1 if no enchant</td>
    </tr>
    <tr>
      <td>8: Enchantment level shown on mouse hover over the middle slot</td>
    </tr>
    <tr>
      <td>9: Enchantment level shown on mouse hover over the bottom slot</td>
    </tr>
    <tr>
      <td rowspan="3">Beacon</td>
      <td>0: Power level</td>
      <td>0-4, controls what effect buttons are enabled</td>
    </tr>
    <tr>
      <td>1: First potion effect</td>
      <td>[Potion effect ID](data-values.md#status-effects) for the first effect, or -1 if no effect</td>
    </tr>
    <tr>
      <td>2: Second potion effect</td>
      <td>[Potion effect ID](data-values.md#status-effects) for the second effect, or -1 if no effect</td>
    </tr>
    <tr>
      <td>Anvil</td>
      <td>0: Repair cost</td>
      <td>The repair's cost in xp levels</td>
    </tr>
    <tr>
      <td rowspan="2">Brewing Stand</td>
      <td>0: Brew time</td>
      <td>0 – 400, with 400 making the arrow empty, and 0 making the arrow full</td>
    </tr>
    <tr>
      <td>1: Fuel time</td>
      <td>0 - 20, with 0 making the arrow empty, and 20 making the arrow full</td>
    </tr>
    <tr>
      <td>Stonecutter</td>
      <td>0: Selected recipe</td>
      <td>The index of the selected recipe. -1 means none is selected.</td>
    </tr>
    <tr>
      <td>Loom</td>
      <td>0: Selected pattern</td>
      <td>The index of the selected pattern. 0 means none is selected, 0 is also the internal id of the "base" pattern.</td>
    </tr>
    <tr>
      <td>Lectern</td>
      <td>0: Page number</td>
      <td>The current page number, starting from 0.</td>
    </tr>
    <tr>
      <td>Smithing Table</td>
      <td>0: Has recipe error</td>
      <td>True if greater than zero.</td>
    </tr>
  </tbody>
</table>

For an enchanting table, the following numerical IDs are used:

<table class="wikitable">
  <tbody>
    <tr>
      <th>Numerical ID</th>
      <th>Enchantment ID</th>
      <th>Enchantment Name</th>
    </tr>
    <tr>
      <td>0</td>
      <td>minecraft:protection</td>
      <td>Protection</td>
    </tr>
    <tr>
      <td>1</td>
      <td>minecraft:fire_protection</td>
      <td>Fire Protection</td>
    </tr>
    <tr>
      <td>2</td>
      <td>minecraft:feather_falling</td>
      <td>Feather Falling</td>
    </tr>
    <tr>
      <td>3</td>
      <td>minecraft:blast_protection</td>
      <td>Blast Protection</td>
    </tr>
    <tr>
      <td>4</td>
      <td>minecraft:projectile_protection</td>
      <td>Projectile Protection</td>
    </tr>
    <tr>
      <td>5</td>
      <td>minecraft:respiration</td>
      <td>Respiration</td>
    </tr>
    <tr>
      <td>6</td>
      <td>minecraft:aqua_affinity</td>
      <td>Aqua Affinity</td>
    </tr>
    <tr>
      <td>7</td>
      <td>minecraft:thorns</td>
      <td>Thorns</td>
    </tr>
    <tr>
      <td>8</td>
      <td>minecraft:depth_strider</td>
      <td>Depth Strider</td>
    </tr>
    <tr>
      <td>9</td>
      <td>minecraft:frost_walker</td>
      <td>Frost Walker</td>
    </tr>
    <tr>
      <td>10</td>
      <td>minecraft:binding_curse</td>
      <td>Curse of Binding</td>
    </tr>
    <tr>
      <td>11</td>
      <td>minecraft:soul_speed</td>
      <td>Soul Speed</td>
    </tr>
    <tr>
      <td>12</td>
      <td>minecraft:swift_sneak</td>
      <td>Swift Sneak</td>
    </tr>
    <tr>
      <td>13</td>
      <td>minecraft:sharpness</td>
      <td>Sharpness</td>
    </tr>
    <tr>
      <td>14</td>
      <td>minecraft:smite</td>
      <td>Smite</td>
    </tr>
    <tr>
      <td>15</td>
      <td>minecraft:bane_of_arthropods</td>
      <td>Bane of Arthropods</td>
    </tr>
    <tr>
      <td>16</td>
      <td>minecraft:knockback</td>
      <td>Knockback</td>
    </tr>
    <tr>
      <td>17</td>
      <td>minecraft:fire_aspect</td>
      <td>Fire Aspect</td>
    </tr>
    <tr>
      <td>18</td>
      <td>minecraft:looting</td>
      <td>Looting</td>
    </tr>
    <tr>
      <td>19</td>
      <td>minecraft:sweeping_edge</td>
      <td>Sweeping Edge</td>
    </tr>
    <tr>
      <td>20</td>
      <td>minecraft:efficiency</td>
      <td>Efficiency</td>
    </tr>
    <tr>
      <td>21</td>
      <td>minecraft:silk_touch</td>
      <td>Silk Touch</td>
    </tr>
    <tr>
      <td>22</td>
      <td>minecraft:unbreaking</td>
      <td>Unbreaking</td>
    </tr>
    <tr>
      <td>23</td>
      <td>minecraft:fortune</td>
      <td>Fortune</td>
    </tr>
    <tr>
      <td>24</td>
      <td>minecraft:power</td>
      <td>Power</td>
    </tr>
    <tr>
      <td>25</td>
      <td>minecraft:punch</td>
      <td>Punch</td>
    </tr>
    <tr>
      <td>26</td>
      <td>minecraft:flame</td>
      <td>Flame</td>
    </tr>
    <tr>
      <td>27</td>
      <td>minecraft:infinity</td>
      <td>Infinity</td>
    </tr>
    <tr>
      <td>28</td>
      <td>minecraft:luck_of_the_sea</td>
      <td>Luck of the Sea</td>
    </tr>
    <tr>
      <td>29</td>
      <td>minecraft:lure</td>
      <td>Lure</td>
    </tr>
    <tr>
      <td>30</td>
      <td>minecraft:loyalty</td>
      <td>Loyalty</td>
    </tr>
    <tr>
      <td>31</td>
      <td>minecraft:impaling</td>
      <td>Impaling</td>
    </tr>
    <tr>
      <td>32</td>
      <td>minecraft:riptide</td>
      <td>Riptide</td>
    </tr>
    <tr>
      <td>33</td>
      <td>minecraft:channeling</td>
      <td>Channeling</td>
    </tr>
    <tr>
      <td>34</td>
      <td>minecraft:multishot</td>
      <td>Multishot</td>
    </tr>
    <tr>
      <td>35</td>
      <td>minecraft:quick_charge</td>
      <td>Quick Charge</td>
    </tr>
    <tr>
      <td>36</td>
      <td>minecraft:piercing</td>
      <td>Piercing</td>
    </tr>
    <tr>
      <td>37</td>
      <td>minecraft:density</td>
      <td>Density</td>
    </tr>
    <tr>
      <td>38</td>
      <td>minecraft:breach</td>
      <td>Breach</td>
    </tr>
    <tr>
      <td>39</td>
      <td>minecraft:wind_burst</td>
      <td>Wind Burst</td>
    </tr>
    <tr>
      <td>40</td>
      <td>minecraft:mending</td>
      <td>Mending</td>
    </tr>
    <tr>
      <td>41</td>
      <td>minecraft:vanishing_curse</td>
      <td>Curse of Vanishing</td>
    </tr>
  </tbody>
</table>

#### Set Container Slot

Sent by the server when an item in a slot (in a window) is added/removed.

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
      <td rowspan="4">*protocol:*<br/>`0x14`<br/><br/>*resource:*<br/>`container_set_slot`</td>
      <td rowspan="4">Play</td>
      <td rowspan="4">Client</td>
      <td>Window ID</td>
      <td>`VarInt`</td>
      <td>The window which is being updated. 0 for player inventory. The client ignores any packets targeting a Window ID other than the current one; see below for exceptions.</td>
    </tr>
    <tr>
      <td>State ID</td>
      <td>`VarInt`</td>
      <td>A server-managed sequence number used to avoid desynchronization; see [#Click Container](click-container.md).</td>
    </tr>
    <tr>
      <td>Slot</td>
      <td>`Short`</td>
      <td>The slot that should be updated.</td>
    </tr>
    <tr>
      <td>Slot Data</td>
      <td>`Slot`</td>
      <td></td>
    </tr>
  </tbody>
</table>

If Window ID is 0, the hotbar and offhand slots (slots 36 through 45) may be updated even when a different container window is open. (The vanilla server does not appear to utilize this special case.) Updates are also restricted to those slots when the player is looking at a creative inventory tab other than the survival inventory. (The vanilla server does *not* handle this restriction in any way, leading to [MC-242392](https://bugs.mojang.com/browse/MC-242392).)

If Window ID is -1, the item being dragged with the mouse is set. In this case, State ID and Slot are ignored.

If Window ID is -2, any slot in the player's inventory can be updated irrespective of the current container window. In this case, State ID is ignored, and the vanilla server uses a bogus value of 0. Used by the vanilla server to implement the [#Pick Item](pick-item.md) functionality.

When a container window is open, the server never sends updates targeting Window ID 0&mdash;all of the [window types](inventory.md) include slots for the player inventory. The client must automatically apply changes targeting the inventory portion of a container window to the main inventory; the server does not resend them for ID 0 when the window is closed. However, since the armor and offhand slots are only present on ID 0, updates to those slots occurring while a window is open must be deferred by the server until the window's closure.

#### Cookie Request (play)

Requests a cookie that was previously stored.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>State</th>
      <th>Bound To</th>
      <th colspan="2">Field Name</th>
      <th colspan="2">Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="1">*protocol:*<br/>`0x15`<br/><br/>*resource:*<br/>`cookie_request`</td>
      <td rowspan="1">Play</td>
      <td rowspan="1">Client</td>
      <td colspan="2">Key</td>
      <td colspan="2">`Identifier`</td>
      <td>The identifier of the cookie.</td>
    </tr>
  </tbody>
</table>

#### Set Cooldown

Applies a cooldown period to all items with the given type.  Used by the vanilla server with enderpearls.  This packet should be sent when the cooldown starts and also when the cooldown ends (to compensate for lag), although the client will end the cooldown automatically. Can be applied to any item, note that interactions still get sent to the server with the item but the client does not play the animation nor attempt to predict results (i.e block placing).

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
      <td rowspan="2">*protocol:*<br/>`0x16`<br/><br/>*resource:*<br/>`cooldown`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Client</td>
      <td>Cooldown Group</td>
      <td>`Identifier`</td>
      <td>Identifier of the item (minecraft:stone) or the cooldown group ("use_cooldown" item component)</td>
    </tr>
    <tr>
      <td>Cooldown Ticks</td>
      <td>`VarInt`</td>
      <td>Number of ticks to apply a cooldown for, or 0 to clear the cooldown.</td>
    </tr>
  </tbody>
</table>

#### Chat Suggestions

Unused by the vanilla server. Likely provided for custom servers to send chat message completions to clients.

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
      <td rowspan="2">*protocol:*<br/>`0x17`<br/><br/>*resource:*<br/>`custom_chat_completions`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Client</td>
      <td>Action</td>
      <td>`VarInt` `Enum`</td>
      <td>0: Add, 1: Remove, 2: Set</td>
    </tr>
    <tr>
      <td>Entries</td>
      <td>`Prefixed Array` of `String` (32767)</td>
      <td></td>
    </tr>
  </tbody>
</table>

#### Clientbound Plugin Message (play)

_Main article: [Minecraft Wiki:Projects/wiki.vg merge/Plugin channels](./plugin-channels.md)_

Mods and plugins can use this to send their data. Minecraft itself uses several [plugin channels](plugin-channels.md). These internal channels are in the `minecraft` namespace.

More information on how it works on [Dinnerbone's blog](https://dinnerbone.com/blog/2012/01/13/minecraft-plugin-channels-messaging/). More documentation about internal and popular registered channels are [here](plugin-channels.md).

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
      <td rowspan="2">*protocol:*<br/>`0x18`<br/><br/>*resource:*<br/>`custom_payload`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Client</td>
      <td>Channel</td>
      <td>`Identifier`</td>
      <td>Name of the [plugin channel](plugin-channels.md) used to send the data.</td>
    </tr>
    <tr>
      <td>Data</td>
      <td>`Byte Array` (1048576)</td>
      <td>Any data. The length of this array must be inferred from the packet length.</td>
    </tr>
  </tbody>
</table>

In vanilla clients, the maximum data length is 1048576 bytes.

#### Damage Event

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>State</th>
      <th>Bound To</th>
      <th colspan="2">Field Name</th>
      <th colspan="2">Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="8">*protocol:*<br/>`0x19`<br/><br/>*resource:*<br/>`damage_event`</td>
      <td rowspan="8">Play</td>
      <td rowspan="8">Client</td>
    </tr>
    <tr>
      <td colspan="2">Entity ID</td>
      <td colspan="2">`VarInt`</td>
      <td>The ID of the entity taking damage</td>
    </tr>
    <tr>
      <td colspan="2">Source Type ID</td>
      <td colspan="2">`VarInt`</td>
      <td>The type of damage in the `minecraft:damage_type` registry, defined by the [Registry Data](java-edition-protocol.md#registrydata) packet.</td>
    </tr>
    <tr>
      <td colspan="2">Source Cause ID</td>
      <td colspan="2">`VarInt`</td>
      <td>The ID + 1 of the entity responsible for the damage, if present. If not present, the value is 0</td>
    </tr>
    <tr>
      <td colspan="2">Source Direct ID</td>
      <td colspan="2">`VarInt`</td>
      <td>The ID + 1 of the entity that directly dealt the damage, if present. If not present, the value is 0. If this field is present:
* and damage was dealt indirectly, such as by the use of a projectile, this field will contain the ID of such projectile;
* and damage was dealt dirctly, such as by manually attacking, this field will contain the same value as Source Cause ID.</td>
    </tr>
    <tr>
      <td rowspan="3">Source Position</td>
      <td>X</td>
      <td rowspan="3">`Prefixed Optional`</td>
      <td>`Double`</td>
      <td rowspan="3">The vanilla server sends the Source Position when the damage was dealt by the /damage command and a position was specified</td>
    </tr>
    <tr>
      <td>Y</td>
      <td>`Double`</td>
    </tr>
    <tr>
      <td>Z</td>
      <td>`Double`</td>
    </tr>
  </tbody>
</table>

#### Debug Sample

Sample data that is sent periodically after the client has subscribed with [[#Debug_Sample_Subscription|Debug Sample Subscription]].

The vanilla server only sends debug samples to players that are server operators.

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
      <td rowspan="2">*protocol:*<br/>`0x1A`<br/><br/>*resource:*<br/>`debug_sample`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Client</td>
      <td>Sample</td>
      <td>`Prefixed Array` of `Long`</td>
      <td>Array of type-dependent samples.</td>
    </tr>
    <tr>
      <td>Sample Type</td>
      <td>`VarInt` `Enum`</td>
      <td>See below.</td>
    </tr>
  </tbody>
</table>

Types:

<table class="wikitable">
  <tbody>
    <tr>
      <th>Id</th>
      <th>Name</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>0</td>
      <td>Tick time</td>
      <td>Four different tick-related metrics, each one represented by one long on the array.
They are measured in nano-seconds, and are as follows:
* 0: Full tick time: Aggregate of the three times below;
* 1: Server tick time: Main server tick logic;
* 2: Tasks time: Tasks scheduled to execute after the main logic;
* 3: Idle time: Time idling to complete the full 50ms tick cycle.
Note that the vanilla client calculates the timings used for min/max/average display by subtracting the idle time from the full tick time. This can cause the displayed values to go negative if the idle time is (nonsensically) greater than the full tick time.</td>
    </tr>
  </tbody>
</table>

#### Delete Message

Removes a message from the client's chat. This only works for messages with signatures, system messages cannot be deleted with this packet.

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
      <td rowspan="2">*protocol:*<br/>`0x1B`<br/><br/>*resource:*<br/>`delete_chat`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Client</td>
      <td>Message ID</td>
      <td>`VarInt`</td>
      <td>The message Id + 1, used for validating message signature. The next field is present only when value of this field is equal to 0.</td>
    </tr>
    <tr>
      <td>Signature</td>
      <td>`Optional` `Byte Array` (256)</td>
      <td>The previous message's signature. Always 256 bytes and not length-prefixed.</td>
    </tr>
  </tbody>
</table>

#### Disconnect (play)

Sent by the server before it disconnects a client. The client assumes that the server has already closed the connection by the time the packet arrives.

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
      <td>*protocol:*<br/>`0x1C`<br/><br/>*resource:*<br/>`disconnect`</td>
      <td>Play</td>
      <td>Client</td>
      <td>Reason</td>
      <td>`Text Component`</td>
      <td>Displayed to the client when the connection terminates.</td>
    </tr>
  </tbody>
</table>

#### Disguised Chat Message

_Main article: [Minecraft_Wiki:Projects/wiki.vg_merge/Chat](./minecraft_wiki-projects-wiki.vg_merge-chat.md)_

Sends the client a chat message, but without any message signing information.

The vanilla server uses this packet when the console is communicating with players through commands, such as `/say`, `/tell`, `/me`, among others.

<table>
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
      <td rowspan="4">*protocol:*<br/>`0x1D`<br/><br/>*resource:*<br/>`disguised_chat`</td>
      <td rowspan="4">Play</td>
      <td rowspan="4">Client</td>
      <td>Message</td>
      <td>`Text Component`</td>
      <td>This is used as the `content` parameter when formatting the message on the client.</td>
    </tr>
    <tr>
      <td>Chat Type</td>
      <td>`ID or` `Chat Type`</td>
      <td>Either the type of chat in the `minecraft:chat_type` registry, defined by the [Registry Data](java-edition-protocol.md#registrydata) packet, or an inline definition.</td>
    </tr>
    <tr>
      <td>Sender Name</td>
      <td>`Text Component`</td>
      <td>The name of the one sending the message, usually the sender's display name.
This is used as the `sender` parameter when formatting the message on the client.</td>
    </tr>
    <tr>
      <td>Target Name</td>
      <td>`Prefixed Optional` `Text Component`</td>
      <td>The name of the one receiving the message, usually the receiver's display name.
This is used as the `target` parameter when formatting the message on the client.</td>
    </tr>
  </tbody>
</table>

#### Entity Event

Entity statuses generally trigger an animation for an entity.  The available statuses vary by the entity's type (and are available to subclasses of that type as well).

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
      <td rowspan="2">*protocol:*<br/>`0x1E`<br/><br/>*resource:*<br/>`entity_event`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Client</td>
      <td>Entity ID</td>
      <td>`Int`</td>
      <td></td>
    </tr>
    <tr>
      <td>Entity Status</td>
      <td>`Byte` `Enum`</td>
      <td>See [Entity statuses](entity-statuses.md) for a list of which statuses are valid for each type of entity.</td>
    </tr>
  </tbody>
</table>

#### Teleport Entity

> ⚠️ **Warning:** The Mojang-specified name of this packet was changed in 1.21.2 from `teleport_entity` to `entity_position_sync`. There is a new `teleport_entity`, which this document more appropriately calls [[#Synchronize Vehicle Position|Synchronize Vehicle Position]]. That packet has a different function and will lead to confusing results if used in place of this one.

This packet is sent by the server when an entity moves more than 8 blocks. 

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>State</th>
      <th>Bound To

Java Edition is one of the two updated versions of Minecraft which require a paid account to download, update and play. Most of the new development projects focus on either creating entirely new programs from scratch that interoperate with Minecraft (such as a bot or server) or modding projects that wrap the client or server and provide bug fixes, new features and enhancements to existing features.
Documentation

There are ongoing efforts to keep reverse engineered documentation updated, but it isn't as easy as it sounds. The protocol generally changes slightly with each release, and both the Client and Server classes get rearranged on each release. Below are links to the current documentation segments, which may or may not be completely up to date.
Protocol

    Protocol FAQ
        Normal login sequence for a client
        Normal ping sequence to a server
    Current protocol specification
        Data types
        Server List Ping
        Encryption
        Plugin channels
        Registry data
        Command data
        Chat
        Inventory
        Slot data
        Chunk format
        Block actions
        Object data
        Entity metadata
        Entity statuses
        Particles
    Development version protocol specification
    Protocol version numbers
    Protocol history
    Proxies
    Minecraft Forge handshake specification

Mojang APIs

    Authentication
        Microsoft Authentication Scheme
        Legacy Mojang Authentication Scheme
        Legacy Minecraft Authentication Scheme
    Mojang API
    Game files
    Realms API
    Snoop

Map Format

    Map Format Specification
        Region Files

Vanilla Implementation

    Launching the game
    Debugging
    Data Generators

Miscellaneous

    NBT
    Text formatting
    RCON and Query protocol specifications

Tools & Mods

    Clients - third-party Java Edition clients
    Servers - third-party Java Edition servers
    Libraries - libraries to interface with Minecraft data files or network protocols
    Utilities - tools that interface with a client, server, or data files, such as proxies, bots, or inventory editors
    Wrappers - mods that override features in the client or server
    Generators - tools that extract data from Mojang to a readable format
    Decompilers - tools for decompiling Java Edition
    Burger - a tool that generates information for arbitrary Java Edition versions
        Pokechu22's fork - where new version development is mostly done
        Burger Vitrine - shows differences in data and protocol between arbitrary versions
        PAaaS - shows differences in protocol and sounds for newer versions (1.8 and above)
    Code Snippets

Communities

    Minecraft Protocol (via Discord)
    #mcdevs (via irc.libera.chat).

For more info, see the Java Edition protocol category.
</th>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="10">*protocol:*<br/>`0x1F`<br/><br/>*resource:*<br/>`entity_position_sync`</td>
      <td rowspan="10">Play</td>
      <td rowspan="10">Client</td>
      <td>Entity ID</td>
      <td>`VarInt`</td>
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
      <td>Velocity X</td>
      <td>`Double`</td>
      <td></td>
    </tr>
    <tr>
      <td>Velocity Y</td>
      <td>`Double`</td>
      <td></td>
    </tr>
    <tr>
      <td>Velocity Z</td>
      <td>`Double`</td>
      <td></td>
    </tr>
    <tr>
      <td>Yaw</td>
      <td>`Float`</td>
      <td>Rotation on the X axis, in degrees.</td>
    </tr>
    <tr>
      <td>Pitch</td>
      <td>`Float`</td>
      <td>Rotation on the Y axis, in degrees.</td>
    </tr>
    <tr>
      <td>On Ground</td>
      <td>`Boolean`</td>
      <td></td>
    </tr>
  </tbody>
</table>

#### Explosion

Sent when an explosion occurs (creepers, TNT, and ghast fireballs).

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>State</th>
      <th>Bound To</th>
      <th colspan="2">Field Name</th>
      <th colspan="2">Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="9">*protocol:*<br/>`0x20`<br/><br/>*resource:*<br/>`explode`</td>
      <td rowspan="9">Play</td>
      <td rowspan="9">Client</td>
      <td colspan="2">X</td>
      <td colspan="2">`Double`</td>
      <td></td>
    </tr>
    <tr>
      <td colspan="2">Y</td>
      <td colspan="2">`Double`</td>
      <td></td>
    </tr>
    <tr>
      <td colspan="2">Z</td>
      <td colspan="2">`Double`</td>
      <td></td>
    </tr>
    <tr>
      <td rowspan="3">Player Delta Velocity</td>
      <td>X</td>
      <td rowspan="3">`Prefixed Optional`</td>
      <td>`Double`</td>
      <td rowspan="3">Velocity difference of the player being pushed by the explosion.</td>
    </tr>
    <tr>
      <td>Y</td>
      <td>`Double`</td>
    </tr>
    <tr>
      <td>Z</td>
      <td>`Double`</td>
    </tr>
    <tr>
      <td colspan="2">Explosion Particle ID</td>
      <td colspan="2">`VarInt`</td>
      <td>The particle ID listed in [Particles](particles.md).</td>
    </tr>
    <tr>
      <td colspan="2">Explosion Particle Data</td>
      <td colspan="2">Varies</td>
      <td>Particle data as specified in [Particles](particles.md).</td>
    </tr>
    <tr>
      <td colspan="2">Explosion Sound</td>
      <td colspan="2">`ID or` `Sound Event`</td>
      <td>ID in the `minecraft:sound_event` registry, or an inline definition.</td>
    </tr>
  </tbody>
</table>

#### Unload Chunk

Tells the client to unload a chunk column.

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
      <td rowspan="2">*protocol:*<br/>`0x21`<br/><br/>*resource:*<br/>`forget_level_chunk`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Client</td>
      <td>Chunk Z</td>
      <td>`Int`</td>
      <td>Block coordinate divided by 16, rounded down.</td>
    </tr>
    <tr>
      <td>Chunk X</td>
      <td>`Int`</td>
      <td>Block coordinate divided by 16, rounded down.</td>
    </tr>
  </tbody>
</table>

Note: The order is inverted, because the client reads this packet as one big-endian `Long`, with Z being the upper 32 bits.

It is legal to send this packet even if the given chunk is not currently loaded.

#### Game Event

Used for a wide variety of game events, from weather to bed use to game mode to demo messages.

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
      <td rowspan="2">*protocol:*<br/>`0x22`<br/><br/>*resource:*<br/>`game_event`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Client</td>
      <td>Event</td>
      <td>`Unsigned Byte`</td>
      <td>See below.</td>
    </tr>
    <tr>
      <td>Value</td>
      <td>`Float`</td>
      <td>Depends on Event.</td>
    </tr>
  </tbody>
</table>

*Events*:

<table class="wikitable">
  <tbody>
    <tr>
      <th>Event</th>
      <th>Effect</th>
      <th>Value</th>
    </tr>
    <tr>
      <td>0</td>
      <td>No respawn block available</td>
      <td>Note: Displays message 'block.minecraft.spawn.not_valid' (You have no home bed or charged respawn anchor, or it was obstructed) to the player.</td>
    </tr>
    <tr>
      <td>1</td>
      <td>Begin raining</td>
      <td></td>
    </tr>
    <tr>
      <td>2</td>
      <td>End raining</td>
      <td></td>
    </tr>
    <tr>
      <td>3</td>
      <td>Change game mode</td>
      <td>0: Survival, 1: Creative, 2: Adventure, 3: Spectator.</td>
    </tr>
    <tr>
      <td>4</td>
      <td>Win game</td>
      <td>0: Just respawn player.<br>1: Roll the credits and respawn player.<br>Note that 1 is only sent by vanilla server when player has not yet achieved advancement "The end?", else 0 is sent.</td>
    </tr>
    <tr>
      <td>5</td>
      <td>Demo event</td>
      <td>0: Show welcome to demo screen.<br>101: Tell movement controls.<br>102: Tell jump control.<br>103: Tell inventory control.<br>104: Tell that the demo is over and print a message about how to take a screenshot.</td>
    </tr>
    <tr>
      <td>6</td>
      <td>Arrow hit player</td>
      <td>Note: Sent when any player is struck by an arrow.</td>
    </tr>
    <tr>
      <td>7</td>
      <td>Rain level change</td>
      <td>Note: Seems to change both sky color and lighting.<br>Rain level ranging from 0 to 1.</td>
    </tr>
    <tr>
      <td>8</td>
      <td>Thunder level change</td>
      <td>Note: Seems to change both sky color and lighting (same as Rain level change, but doesn't start rain). It also requires rain to render by vanilla client.<br>Thunder level ranging from 0 to 1.</td>
    </tr>
    <tr>
      <td>9</td>
      <td>Play pufferfish sting sound</td>
    </tr>
    <tr>
      <td>10</td>
      <td>Play elder guardian mob appearance (effect and sound)</td>
      <td></td>
    </tr>
    <tr>
      <td>11</td>
      <td>Enable respawn screen</td>
      <td>0: Enable respawn screen.<br>1: Immediately respawn (sent when the `doImmediateRespawn` gamerule changes).</td>
    </tr>
    <tr>
      <td>12</td>
      <td>Limited crafting</td>
      <td>0: Disable limited crafting.<br>1: Enable limited crafting (sent when the `doLimitedCrafting` gamerule changes).</td>
    </tr>
    <tr>
      <td>13</td>
      <td>Start waiting for level chunks</td>
      <td>Instructs the client to begin the waiting process for the level chunks.<br>Sent by the server after the level is cleared on the client and is being re-sent (either during the first, or subsequent reconfigurations).</td>
    </tr>
  </tbody>
</table>

#### Open Horse Screen

This packet is used exclusively for opening the horse GUI. [[#Open Screen|Open Screen]] is used for all other GUIs.  The client will not open the inventory if the Entity ID does not point to an horse-like animal.

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
      <td rowspan="3">*protocol:*<br/>`0x23`<br/><br/>*resource:*<br/>`horse_screen_open`</td>
      <td rowspan="3">Play</td>
      <td rowspan="3">Client</td>
      <td>Window ID</td>
      <td>`VarInt`</td>
      <td>Same as the field of [[#Open Screen|Open Screen]].</td>
    </tr>
    <tr>
      <td>Inventory columns count</td>
      <td>`VarInt`</td>
      <td>How many columns of horse inventory slots exist in the GUI, 3 slots per column.</td>
    </tr>
    <tr>
      <td>Entity ID</td>
      <td>`Int`</td>
      <td>The "owner" entity of the GUI. The client should close the GUI if the owner entity dies or is cleared.</td>
    </tr>
  </tbody>
</table>

#### Hurt Animation

Plays a bobbing animation for the entity receiving damage.

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
      <td rowspan="2">*protocol:*<br/>`0x24`<br/><br/>*resource:*<br/>`hurt_animation`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Client</td>
      <td>Entity ID</td>
      <td>`VarInt`</td>
      <td>The ID of the entity taking damage</td>
    </tr>
    <tr>
      <td>Yaw</td>
      <td>`Float`</td>
      <td>The direction the damage is coming from in relation to the entity</td>
    </tr>
  </tbody>
</table>

#### Initialize World Border

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
      <td rowspan="8">*protocol:*<br/>`0x25`<br/><br/>*resource:*<br/>`initialize_border`</td>
      <td rowspan="8">Play</td>
      <td rowspan="8">Client</td>
      <td>X</td>
      <td>`Double`</td>
      <td></td>
    </tr>
    <tr>
      <td>Z</td>
      <td>`Double`</td>
      <td></td>
    </tr>
    <tr>
      <td>Old Diameter</td>
      <td>`Double`</td>
      <td>Current length of a single side of the world border, in meters.</td>
    </tr>
    <tr>
      <td>New Diameter</td>
      <td>`Double`</td>
      <td>Target length of a single side of the world border, in meters.</td>
    </tr>
    <tr>
      <td>Speed</td>
      <td>`VarLong`</td>
      <td>Number of real-time *milli*seconds until New Diameter is reached. It appears that vanilla server does not sync world border speed to game ticks, so it gets out of sync with server lag. If the world border is not moving, this is set to 0.</td>
    </tr>
    <tr>
      <td>Portal Teleport Boundary</td>
      <td>`VarInt`</td>
      <td>Resulting coordinates from a portal teleport are limited to ±value. Usually 29999984.</td>
    </tr>
    <tr>
      <td>Warning Blocks</td>
      <td>`VarInt`</td>
      <td>In meters.</td>
    </tr>
    <tr>
      <td>Warning Time</td>
      <td>`VarInt`</td>
      <td>In seconds as set by `/worldborder warning time`.</td>
    </tr>
  </tbody>
</table>

The vanilla client determines how solid to display the warning by comparing to whichever is higher, the warning distance or whichever is lower, the distance from the current diameter to the target diameter or the place the border will be after warningTime seconds. In pseudocode:

```java
distance = max(min(resizeSpeed * 1000 * warningTime, abs(targetDiameter - currentDiameter)), warningDistance);
if (playerDistance < distance) {
    warning = 1.0 - playerDistance / distance;
} else {
    warning = 0.0;
}
```

#### Clientbound Keep Alive (play)

The server will frequently send out a keep-alive, each containing a random ID. The client must respond with the same payload (see [[#Serverbound Keep Alive (play)|Serverbound Keep Alive]]). If the client does not respond to a Keep Alive packet within 15 seconds after it was sent, the server kicks the client. Vice versa, if the server does not send any keep-alives for 20 seconds, the client will disconnect and yields a "Timed out" exception.

The vanilla server uses a system-dependent time in milliseconds to generate the keep alive ID value.

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
      <td>*protocol:*<br/>`0x26`<br/><br/>*resource:*<br/>`keep_alive`</td>
      <td>Play</td>
      <td>Client</td>
      <td>Keep Alive ID</td>
      <td>`Long`</td>
      <td></td>
    </tr>
  </tbody>
</table>

#### Chunk Data and Update Light

_Main article: [Minecraft Wiki:Projects/wiki.vg merge/Chunk Format](./chunk-format.md)_
See also:
  * [#Unload Chunk](./.md#unload-chunk)

Sent when a chunk comes into the client's view distance, specifying its terrain, lighting and block entities.

The chunk must be within the view area previously specified with [[#Set Center Chunk|Set Center Chunk]]; see that packet for details.

It is not strictly necessary to send all block entities in this packet; it is still legal to send them with [[#Block Entity Data|Block Entity Data]] later.
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
      <td rowspan="4">*protocol:*<br/>`0x27`<br/><br/>*resource:*<br/>`level_chunk_with_light`</td>
      <td rowspan="4">Play</td>
      <td rowspan="4">Client</td>
      <td>Chunk X</td>
      <td>`Int`</td>
      <td>Chunk coordinate (block coordinate divided by 16, rounded down)</td>
    </tr>
    <tr>
      <td>Chunk Z</td>
      <td>`Int`</td>
      <td>Chunk coordinate (block coordinate divided by 16, rounded down)</td>
    </tr>
    <tr>
      <td>Data</td>
      <td>`Chunk Data`</td>
      <td></td>
    </tr>
    <tr>
      <td>Light</td>
      <td>`Light Data`</td>
      <td></td>
    </tr>
  </tbody>
</table>

Unlike the [[#Update Light|Update Light]] packet which uses the same format, setting the bit corresponding to a section to 0 in both of the block light or sky light masks does not appear to be useful, and the results in testing have been highly inconsistent.

#### World Event

Sent when a client is to play a sound or particle effect.

By default, the Minecraft client adjusts the volume of sound effects based on distance. The final boolean field is used to disable this, and instead the effect is played from 2 blocks away in the correct direction. Currently this is only used for effect 1023 (wither spawn), effect 1028 (enderdragon death), and effect 1038 (end portal opening); it is ignored on other effects.

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
      <td rowspan="4">*protocol:*<br/>`0x28`<br/><br/>*resource:*<br/>`level_event`</td>
      <td rowspan="4">Play</td>
      <td rowspan="4">Client</td>
      <td>Event</td>
      <td>`Int`</td>
      <td>The event, see below.</td>
    </tr>
    <tr>
      <td>Location</td>
      <td>`Position`</td>
      <td>The location of the event.</td>
    </tr>
    <tr>
      <td>Data</td>
      <td>`Int`</td>
      <td>Extra data for certain events, see below.</td>
    </tr>
    <tr>
      <td>Disable Relative Volume</td>
      <td>`Boolean`</td>
      <td>See above.</td>
    </tr>
  </tbody>
</table>

Events:

<table class="wikitable">
  <tbody>
    <tr>
      <th>ID</th>
      <th>Name</th>
      <th>Data</th>
    </tr>
    <tr>
      <th colspan="3">Sound</th>
    </tr>
    <tr>
      <td>1000</td>
      <td>Dispenser dispenses</td>
      <td></td>
    </tr>
    <tr>
      <td>1001</td>
      <td>Dispenser fails to dispense</td>
      <td></td>
    </tr>
    <tr>
      <td>1002</td>
      <td>Dispenser shoots</td>
      <td></td>
    </tr>
    <tr>
      <td>1004</td>
      <td>Firework shot</td>
      <td></td>
    </tr>
    <tr>
      <td>1009</td>
      <td>Fire extinguished</td>
      <td></td>
    </tr>
    <tr>
      <td>1010</td>
      <td>Play record</td>
      <td>An ID in the `minecraft:item` registry, corresponding to a [record item](music-disc.md). If the ID doesn't correspond to a record, the packet is ignored. Any record already being played at the given location is overwritten. See [Data Generators](data-generators.md) for information on item IDs.</td>
    </tr>
    <tr>
      <td>1011</td>
      <td>Stop record</td>
      <td></td>
    </tr>
    <tr>
      <td>1015</td>
      <td>Ghast warns</td>
      <td></td>
    </tr>
    <tr>
      <td>1016</td>
      <td>Ghast shoots</td>
      <td></td>
    </tr>
    <tr>
      <td>1017</td>
      <td>Ender dragon shoots</td>
      <td></td>
    </tr>
    <tr>
      <td>1018</td>
      <td>Blaze shoots</td>
      <td></td>
    </tr>
    <tr>
      <td>1019</td>
      <td>Zombie attacks wooden door</td>
      <td></td>
    </tr>
    <tr>
      <td>1020</td>
      <td>Zombie attacks iron door</td>
      <td></td>
    </tr>
    <tr>
      <td>1021</td>
      <td>Zombie breaks wooden door</td>
      <td></td>
    </tr>
    <tr>
      <td>1022</td>
      <td>Wither breaks block</td>
      <td></td>
    </tr>
    <tr>
      <td>1023</td>
      <td>Wither spawned</td>
      <td></td>
    </tr>
    <tr>
      <td>1024</td>
      <td>Wither shoots</td>
      <td></td>
    </tr>
    <tr>
      <td>1025</td>
      <td>Bat takes off</td>
      <td></td>
    </tr>
    <tr>
      <td>1026</td>
      <td>Zombie infects</td>
      <td></td>
    </tr>
    <tr>
      <td>1027</td>
      <td>Zombie villager converted</td>
      <td></td>
    </tr>
    <tr>
      <td>1028</td>
      <td>Ender dragon dies</td>
      <td></td>
    </tr>
    <tr>
      <td>1029</td>
      <td>Anvil destroyed</td>
      <td></td>
    </tr>
    <tr>
      <td>1030</td>
      <td>Anvil used</td>
      <td></td>
    </tr>
    <tr>
      <td>1031</td>
      <td>Anvil lands</td>
      <td></td>
    </tr>
    <tr>
      <td>1032</td>
      <td>Portal travel</td>
      <td></td>
    </tr>
    <tr>
      <td>1033</td>
      <td>Chorus flower grows</td>
      <td></td>
    </tr>
    <tr>
      <td>1034</td>
      <td>Chorus flower dies</td>
      <td></td>
    </tr>
    <tr>
      <td>1035</td>
      <td>Brewing stand brews</td>
      <td></td>
    </tr>
    <tr>
      <td>1038</td>
      <td>End portal created</td>
      <td></td>
    </tr>
    <tr>
      <td>1039</td>
      <td>Phantom bites</td>
      <td></td>
    </tr>
    <tr>
      <td>1040</td>
      <td>Zombie converts to drowned</td>
      <td></td>
    </tr>
    <tr>
      <td>1041</td>
      <td>Husk converts to zombie by drowning</td>
      <td></td>
    </tr>
    <tr>
      <td>1042</td>
      <td>Grindstone used</td>
      <td></td>
    </tr>
    <tr>
      <td>1043</td>
      <td>Book page turned</td>
      <td></td>
    </tr>
    <tr>
      <td>1044</td>
      <td>Smithing table used</td>
      <td></td>
    </tr>
    <tr>
      <td>1045</td>
      <td>Pointed dripstone landing</td>
      <td></td>
    </tr>
    <tr>
      <td>1046</td>
      <td>Lava dripping on cauldron from dripstone</td>
      <td></td>
    </tr>
    <tr>
      <td>1047</td>
      <td>Water dripping on cauldron from dripstone</td>
      <td></td>
    </tr>
    <tr>
      <td>1048</td>
      <td>Skeleton converts to stray</td>
      <td></td>
    </tr>
    <tr>
      <td>1049</td>
      <td>Crafter successfully crafts item</td>
      <td></td>
    </tr>
    <tr>
      <td>1050</td>
      <td>Crafter fails to craft item</td>
      <td></td>
    </tr>
    <tr>
      <th colspan="3">Particle</th>
    </tr>
    <tr>
      <td>1500</td>
      <td>Composter composts</td>
      <td></td>
    </tr>
    <tr>
      <td>1501</td>
      <td>Lava converts block (either water to stone, or removes existing blocks such as torches)</td>
      <td></td>
    </tr>
    <tr>
      <td>1502</td>
      <td>Redstone torch burns out</td>
      <td></td>
    </tr>
    <tr>
      <td>1503</td>
      <td>Ender eye placed in end portal frame</td>
      <td></td>
    </tr>
    <tr>
      <td>1504</td>
      <td>Fluid drips from dripstone</td>
      <td></td>
    </tr>
    <tr>
      <td>1505</td>
      <td>Bone meal particles and sound</td>
      <td>How many particles to spawn.</td>
    </tr>
    <tr>
      <td>2000</td>
      <td>Dispenser activation smoke</td>
      <td>Direction, see below.</td>
    </tr>
    <tr>
      <td>2001</td>
      <td>Block break + block break sound</td>
      <td>Block state ID (see [Chunk Format#Block state registry](chunk-format.md#block-state-registry)).</td>
    </tr>
    <tr>
      <td>2002</td>
      <td>Splash potion. Particle effect + glass break sound.</td>
      <td>RGB color as an integer (e.g. 8364543 for #7FA1FF).</td>
    </tr>
    <tr>
      <td>2003</td>
      <td>Eye of ender entity break animation — particles and sound</td>
      <td></td>
    </tr>
    <tr>
      <td>2004</td>
      <td>Spawner spawns mob: smoke + flames</td>
      <td></td>
    </tr>
    <tr>
      <td>2006</td>
      <td>Dragon breath</td>
      <td></td>
    </tr>
    <tr>
      <td>2007</td>
      <td>Instant splash potion. Particle effect + glass break sound.</td>
      <td>RGB color as an integer (e.g. 8364543 for #7FA1FF).</td>
    </tr>
    <tr>
      <td>2008</td>
      <td>Ender dragon destroys block</td>
      <td></td>
    </tr>
    <tr>
      <td>2009</td>
      <td>Wet sponge vaporizes</td>
      <td></td>
    </tr>
    <tr>
      <td>2010</td>
      <td>Crafter activation smoke</td>
      <td>Direction, see below.</td>
    </tr>
    <tr>
      <td>2011</td>
      <td>Bee fertilizes plant</td>
      <td>How many particles to spawn.</td>
    </tr>
    <tr>
      <td>2012</td>
      <td>Turtle egg placed</td>
      <td>How many particles to spawn.</td>
    </tr>
    <tr>
      <td>2013</td>
      <td>Smash attack (mace)</td>
      <td>How many particles to spawn.</td>
    </tr>
    <tr>
      <td>3000</td>
      <td>End gateway spawns</td>
      <td></td>
    </tr>
    <tr>
      <td>3001</td>
      <td>Ender dragon resurrected</td>
      <td></td>
    </tr>
    <tr>
      <td>3002</td>
      <td>Electric spark</td>
      <td></td>
    </tr>
    <tr>
      <td>3003</td>
      <td>Copper apply wax</td>
      <td></td>
    </tr>
    <tr>
      <td>3004</td>
      <td>Copper remove wax</td>
      <td></td>
    </tr>
    <tr>
      <td>3005</td>
      <td>Copper scrape oxidation</td>
      <td></td>
    </tr>
    <tr>
      <td>3006</td>
      <td>Sculk charge</td>
      <td></td>
    </tr>
    <tr>
      <td>3007</td>
      <td>Sculk shrieker shriek</td>
      <td></td>
    </tr>
    <tr>
      <td>3008</td>
      <td>Block finished brushing</td>
      <td>Block state ID (see [Chunk Format#Block state registry](chunk-format.md#block-state-registry))</td>
    </tr>
    <tr>
      <td>3009</td>
      <td>Sniffer egg cracks</td>
      <td>If 1, 3-6, if any other number, 1-3 particles will be spawned.</td>
    </tr>
    <tr>
      <td>3011</td>
      <td>Trial spawner spawns mob (at spawner)</td>
      <td></td>
    </tr>
    <tr>
      <td>3012</td>
      <td>Trial spawner spawns mob (at spawn location)</td>
      <td></td>
    </tr>
    <tr>
      <td>3013</td>
      <td>Trial spawner detects player</td>
      <td>Number of players nearby</td>
    </tr>
    <tr>
      <td>3014</td>
      <td>Trial spawner ejects item</td>
      <td></td>
    </tr>
    <tr>
      <td>3015</td>
      <td>Vault activates</td>
      <td></td>
    </tr>
    <tr>
      <td>3016</td>
      <td>Vault deactivates</td>
      <td></td>
    </tr>
    <tr>
      <td>3017</td>
      <td>Vault ejects item</td>
      <td></td>
    </tr>
    <tr>
      <td>3018</td>
      <td>Cobweb weaved</td>
      <td></td>
    </tr>
    <tr>
      <td>3019</td>
      <td>Ominous trial spawner detects player</td>
      <td>Number of players nearby</td>
    </tr>
    <tr>
      <td>3020</td>
      <td>Trial spawner turns ominous</td>
      <td>If 0, the sound will be played at 0.3 volume. Otherwise, it is played at full volume.</td>
    </tr>
    <tr>
      <td>3021</td>
      <td>Ominous item spawner spawns item</td>
      <td></td>
    </tr>
  </tbody>
</table>

Smoke directions:

<table class="wikitable">
  <tbody>
    <tr>
      <th>ID</th>
      <th>Direction</th>
    </tr>
    <tr>
      <td>0</td>
      <td>Down</td>
    </tr>
    <tr>
      <td>1</td>
      <td>Up</td>
    </tr>
    <tr>
      <td>2</td>
      <td>North</td>
    </tr>
    <tr>
      <td>3</td>
      <td>South</td>
    </tr>
    <tr>
      <td>4</td>
      <td>West</td>
    </tr>
    <tr>
      <td>5</td>
      <td>East</td>
    </tr>
  </tbody>
</table>

#### Particle

Displays the named particle

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
      <td rowspan="12">*protocol:*<br/>`0x29`<br/><br/>*resource:*<br/>`level_particles`</td>
      <td rowspan="12">Play</td>
      <td rowspan="12">Client</td>
      <td>Long Distance</td>
      <td>`Boolean`</td>
      <td>If true, particle distance increases from 256 to 65536.</td>
    </tr>
    <tr>
      <td>Always Visible</td>
      <td>`Boolean`</td>
      <td>Whether this particle should always be visible.</td>
    </tr>
    <tr>
      <td>X</td>
      <td>`Double`</td>
      <td>X position of the particle.</td>
    </tr>
    <tr>
      <td>Y</td>
      <td>`Double`</td>
      <td>Y position of the particle.</td>
    </tr>
    <tr>
      <td>Z</td>
      <td>`Double`</td>
      <td>Z position of the particle.</td>
    </tr>
    <tr>
      <td>Offset X</td>
      <td>`Float`</td>
      <td>This is added to the X position after being multiplied by `random.nextGaussian()`.</td>
    </tr>
    <tr>
      <td>Offset Y</td>
      <td>`Float`</td>
      <td>This is added to the Y position after being multiplied by `random.nextGaussian()`.</td>
    </tr>
    <tr>
      <td>Offset Z</td>
      <td>`Float`</td>
      <td>This is added to the Z position after being multiplied by `random.nextGaussian()`.</td>
    </tr>
    <tr>
      <td>Max Speed</td>
      <td>`Float`</td>
      <td></td>
    </tr>
    <tr>
      <td>Particle Count</td>
      <td>`Int`</td>
      <td>The number of particles to create.</td>
    </tr>
    <tr>
      <td>Particle ID</td>
      <td>`VarInt`</td>
      <td>The particle ID listed in [Particles](particles.md).</td>
    </tr>
    <tr>
      <td>Data</td>
      <td>Varies</td>
      <td>Particle data as specified in [Particles](particles.md).</td>
    </tr>
  </tbody>
</table>

#### Update Light

Updates light levels for a chunk.  See [Light](light.md) for information on how lighting works in Minecraft.

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
      <td rowspan="3">*protocol:*<br/>`0x2A`<br/><br/>*resource:*<br/>`light_update`</td>
      <td rowspan="3">Play</td>
      <td rowspan="3">Client</td>
      <td>Chunk X</td>
      <td>`VarInt`</td>
      <td>Chunk coordinate (block coordinate divided by 16, rounded down)</td>
    </tr>
    <tr>
      <td>Chunk Z</td>
      <td>`VarInt`</td>
      <td>Chunk coordinate (block coordinate divided by 16, rounded down)</td>
    </tr>
    <tr>
      <td>Data</td>
      <td>`Light Data`</td>
      <td></td>
    </tr>
  </tbody>
</table>

A bit will never be set in both the block light mask and the empty block light mask, though it may be present in neither of them (if the block light does not need to be updated for the corresponding chunk section).  The same applies to the sky light mask and the empty sky light mask.

#### Login (play)

See [protocol encryption](protocol-encryption.md) for information on logging in.

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
      <td rowspan="22">*protocol:*<br/>`0x2B`<br/><br/>*resource:*<br/>`login`</td>
      <td rowspan="22">Play</td>
      <td rowspan="22">Client</td>
      <td>Entity ID</td>
      <td>`Int`</td>
      <td>The player's Entity ID (EID).</td>
    </tr>
    <tr>
      <td>Is hardcore</td>
      <td>`Boolean`</td>
      <td></td>
    </tr>
    <tr>
      <td>Dimension Names</td>
      <td>`Prefixed Array` of `Identifier`</td>
      <td>Identifiers for all dimensions on the server.</td>
    </tr>
    <tr>
      <td>Max Players</td>
      <td>`VarInt`</td>
      <td>Was once used by the client to draw the player list, but now is ignored.</td>
    </tr>
    <tr>
      <td>View Distance</td>
      <td>`VarInt`</td>
      <td>Render distance (2-32).</td>
    </tr>
    <tr>
      <td>Simulation Distance</td>
      <td>`VarInt`</td>
      <td>The distance that the client will process specific things, such as entities.</td>
    </tr>
    <tr>
      <td>Reduced Debug Info</td>
      <td>`Boolean`</td>
      <td>If true, a vanilla client shows reduced information on the [debug screen](debug-screen.md).  For servers in development, this should almost always be false.</td>
    </tr>
    <tr>
      <td>Enable respawn screen</td>
      <td>`Boolean`</td>
      <td>Set to false when the doImmediateRespawn gamerule is true.</td>
    </tr>
    <tr>
      <td>Do limited crafting</td>
      <td>`Boolean`</td>
      <td>Whether players can only craft recipes they have already unlocked. Currently unused by the client.</td>
    </tr>
    <tr>
      <td>Dimension Type</td>
      <td>`VarInt`</td>
      <td>The ID of the type of dimension in the `minecraft:dimension_type` registry, defined by the Registry Data packet.</td>
    </tr>
    <tr>
      <td>Dimension Name</td>
      <td>`Identifier`</td>
      <td>Name of the dimension being spawned into.</td>
    </tr>
    <tr>
      <td>Hashed seed</td>
      <td>`Long`</td>
      <td>First 8 bytes of the SHA-256 hash of the world's seed. Used client side for biome noise</td>
    </tr>
    <tr>
      <td>Game mode</td>
      <td>`Unsigned Byte`</td>
      <td>0: Survival, 1: Creative, 2: Adventure, 3: Spectator.</td>
    </tr>
    <tr>
      <td>Previous Game mode</td>
      <td>`Byte`</td>
      <td>-1: Undefined (null), 0: Survival, 1: Creative, 2: Adventure, 3: Spectator. The previous game mode. Vanilla client uses this for the debug (F3 + N & F3 + F4) game mode switch. (More information needed)</td>
    </tr>
    <tr>
      <td>Is Debug</td>
      <td>`Boolean`</td>
      <td>True if the world is a [debug mode](debug-mode.md) world; debug mode worlds cannot be modified and have predefined blocks.</td>
    </tr>
    <tr>
      <td>Is Flat</td>
      <td>`Boolean`</td>
      <td>True if the world is a [superflat](superflat.md) world; flat worlds have different void fog and a horizon at y=0 instead of y=63.</td>
    </tr>
    <tr>
      <td>Has death location</td>
      <td>`Boolean`</td>
      <td>If true, then the next two fields are present.</td>
    </tr>
    <tr>
      <td>Death dimension name</td>
      <td>`Optional` `Identifier`</td>
      <td>Name of the dimension the player died in.</td>
    </tr>
    <tr>
      <td>Death location</td>
      <td>`Optional` `Position`</td>
      <td>The location that the player died at.</td>
    </tr>
    <tr>
      <td>Portal cooldown</td>
      <td>`VarInt`</td>
      <td>The number of ticks until the player can use the last used portal again. Looks like it's an attempt to fix MC-180.</td>
    </tr>
    <tr>
      <td>Sea level</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
    <tr>
      <td>Enforces Secure Chat</td>
      <td>`Boolean`</td>
      <td></td>
    </tr>
  </tbody>
</table>

#### Map Data

Updates a rectangular area on a [map](map.md) item.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>State</th>
      <th>Bound To</th>
      <th colspan="2">Field Name</th>
      <th colspan="2">Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="13">*protocol:*<br/>`0x2C`<br/><br/>*resource:*<br/>`map_item_data`</td>
      <td rowspan="13">Play</td>
      <td rowspan="13">Client</td>
      <td colspan="2">Map ID</td>
      <td colspan="2">`VarInt`</td>
      <td>Map ID of the map being modified</td>
    </tr>
    <tr>
      <td colspan="2">Scale</td>
      <td colspan="2">`Byte`</td>
      <td>From 0 for a fully zoomed-in map (1 block per pixel) to 4 for a fully zoomed-out map (16 blocks per pixel)</td>
    </tr>
    <tr>
      <td colspan="2">Locked</td>
      <td colspan="2">`Boolean`</td>
      <td>True if the map has been locked in a cartography table</td>
    </tr>
    <tr>
      <td rowspan="5">Icons</td>
      <td>Type</td>
      <td rowspan="5">`Prefixed Optional` `Prefixed Array`</td>
      <td>`VarInt` `Enum`</td>
      <td>See below</td>
    </tr>
    <tr>
      <td>X</td>
      <td>`Byte`</td>
      <td>Map coordinates: -128 for furthest left, +127 for furthest right</td>
    </tr>
    <tr>
      <td>Z</td>
      <td>`Byte`</td>
      <td>Map coordinates: -128 for highest, +127 for lowest</td>
    </tr>
    <tr>
      <td>Direction</td>
      <td>`Byte`</td>
      <td>0-15</td>
    </tr>
    <tr>
      <td>Display Name</td>
      <td>`Prefixed Optional` `Text Component`</td>
      <td></td>
    </tr>
    <tr>
      <td rowspan="5">Color Patch</td>
      <td>Columns</td>
      <td colspan="2">`Unsigned Byte`</td>
      <td>Number of columns updated</td>
    </tr>
    <tr>
      <td>Rows</td>
      <td colspan="2">`Optional` `Unsigned Byte`</td>
      <td>Only if Columns is more than 0; number of rows updated</td>
    </tr>
    <tr>
      <td>X</td>
      <td colspan="2">`Optional` `Unsigned Byte`</td>
      <td>Only if Columns is more than 0; x offset of the westernmost column</td>
    </tr>
    <tr>
      <td>Z</td>
      <td colspan="2">`Optional` `Unsigned Byte`</td>
      <td>Only if Columns is more than 0; z offset of the northernmost row</td>
    </tr>
    <tr>
      <td>Data</td>
      <td colspan="2">`Optional` `Prefixed Array` of `Unsigned Byte`</td>
      <td>Only if Columns is more than 0; see [Map item format](map-item-format.md)</td>
    </tr>
  </tbody>
</table>

For icons, a direction of 0 is a vertical icon and increments by 22.5&deg; (360/16).

Types are based off of rows and columns in `map_icons.png`:

<table class="wikitable">
  <tbody>
    <tr>
      <th>Icon type</th>
      <th>Result</th>
    </tr>
    <tr>
      <td>0</td>
      <td>White arrow (players)</td>
    </tr>
    <tr>
      <td>1</td>
      <td>Green arrow (item frames)</td>
    </tr>
    <tr>
      <td>2</td>
      <td>Red arrow</td>
    </tr>
    <tr>
      <td>3</td>
      <td>Blue arrow</td>
    </tr>
    <tr>
      <td>4</td>
      <td>White cross</td>
    </tr>
    <tr>
      <td>5</td>
      <td>Red pointer</td>
    </tr>
    <tr>
      <td>6</td>
      <td>White circle (off-map players)</td>
    </tr>
    <tr>
      <td>7</td>
      <td>Small white circle (far-off-map players)</td>
    </tr>
    <tr>
      <td>8</td>
      <td>Mansion</td>
    </tr>
    <tr>
      <td>9</td>
      <td>Monument</td>
    </tr>
    <tr>
      <td>10</td>
      <td>White Banner</td>
    </tr>
    <tr>
      <td>11</td>
      <td>Orange Banner</td>
    </tr>
    <tr>
      <td>12</td>
      <td>Magenta Banner</td>
    </tr>
    <tr>
      <td>13</td>
      <td>Light Blue Banner</td>
    </tr>
    <tr>
      <td>14</td>
      <td>Yellow Banner</td>
    </tr>
    <tr>
      <td>15</td>
      <td>Lime Banner</td>
    </tr>
    <tr>
      <td>16</td>
      <td>Pink Banner</td>
    </tr>
    <tr>
      <td>17</td>
      <td>Gray Banner</td>
    </tr>
    <tr>
      <td>18</td>
      <td>Light Gray Banner</td>
    </tr>
    <tr>
      <td>19</td>
      <td>Cyan Banner</td>
    </tr>
    <tr>
      <td>20</td>
      <td>Purple Banner</td>
    </tr>
    <tr>
      <td>21</td>
      <td>Blue Banner</td>
    </tr>
    <tr>
      <td>22</td>
      <td>Brown Banner</td>
    </tr>
    <tr>
      <td>23</td>
      <td>Green Banner</td>
    </tr>
    <tr>
      <td>24</td>
      <td>Red Banner</td>
    </tr>
    <tr>
      <td>25</td>
      <td>Black Banner</td>
    </tr>
    <tr>
      <td>26</td>
      <td>Treasure marker</td>
    </tr>
    <tr>
      <td>27</td>
      <td>Desert Village</td>
    </tr>
    <tr>
      <td>28</td>
      <td>Plains Village</td>
    </tr>
    <tr>
      <td>29</td>
      <td>Savanna Village</td>
    </tr>
    <tr>
      <td>30</td>
      <td>Snowy Village</td>
    </tr>
    <tr>
      <td>31</td>
      <td>Taiga Village</td>
    </tr>
    <tr>
      <td>32</td>
      <td>Jungle Temple</td>
    </tr>
    <tr>
      <td>33</td>
      <td>Swamp Hut</td>
    </tr>
    <tr>
      <td>34</td>
      <td>Trial Chambers</td>
    </tr>
  </tbody>
</table>

#### Merchant Offers

The list of trades a villager NPC is offering.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>State</th>
      <th>Bound To</th>
      <th colspan="2">Field Name</th>
      <th colspan="2">Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="15">*protocol:*<br/>`0x2D`<br/><br/>*resource:*<br/>`merchant_offers`</td>
      <td rowspan="15">Play</td>
      <td rowspan="15">Client</td>
      <td colspan="2">Window ID</td>
      <td colspan="2">`VarInt`</td>
      <td>The ID of the window that is open; this is an int rather than a byte.</td>
    </tr>
    <tr>
      <td rowspan="10">Trades</td>
      <td>Input item 1</td>
      <td rowspan="10">`Prefixed Array`</td>
      <td>Trade Item</td>
      <td>See below. The first item the player has to supply for this villager trade. The count of the item stack is the default "price" of this trade.</td>
    </tr>
    <tr>
      <td>Output item</td>
      <td>`Slot`</td>
      <td>The item the player will receive from this villager trade.</td>
    </tr>
    <tr>
      <td>Input item 2</td>
      <td>`Prefixed Optional` Trade Item</td>
      <td>The second item the player has to supply for this villager trade.</td>
    </tr>
    <tr>
      <td>Trade disabled</td>
      <td>`Boolean`</td>
      <td>True if the trade is disabled; false if the trade is enabled.</td>
    </tr>
    <tr>
      <td>Number of trade uses</td>
      <td>`Int`</td>
      <td>Number of times the trade has been used so far. If equal to the maximum number of trades, the client will display a red X.</td>
    </tr>
    <tr>
      <td>Maximum number of trade uses</td>
      <td>`Int`</td>
      <td>Number of times this trade can be used before it's exhausted.</td>
    </tr>
    <tr>
      <td>XP</td>
      <td>`Int`</td>
      <td>Amount of XP the villager will earn each time the trade is used.</td>
    </tr>
    <tr>
      <td>Special Price</td>
      <td>`Int`</td>
      <td>Can be zero or negative. The number is added to the price when an item is discounted due to player reputation or other effects.</td>
    </tr>
    <tr>
      <td>Price Multiplier</td>
      <td>`Float`</td>
      <td>Can be low (0.05) or high (0.2). Determines how much demand, player reputation, and temporary effects will adjust the price.</td>
    </tr>
    <tr>
      <td>Demand</td>
      <td>`Int`</td>
      <td>If positive, causes the price to increase. Negative values seem to be treated the same as zero.</td>
    </tr>
    <tr>
      <td colspan="2">Villager level</td>
      <td colspan="2">`VarInt`</td>
      <td>Appears on the trade GUI; meaning comes from the translation key `merchant.level.` + level.
1: Novice, 2: Apprentice, 3: Journeyman, 4: Expert, 5: Master.</td>
    </tr>
    <tr>
      <td colspan="2">Experience</td>
      <td colspan="2">`VarInt`</td>
      <td>Total experience for this villager (always 0 for the wandering trader).</td>
    </tr>
    <tr>
      <td colspan="2">Is regular villager</td>
      <td colspan="2">`Boolean`</td>
      <td>True if this is a regular villager; false for the wandering trader.  When false, hides the villager level and some other GUI elements.</td>
    </tr>
    <tr>
      <td colspan="2">Can restock</td>
      <td colspan="2">`Boolean`</td>
      <td>True for regular villagers and false for the wandering trader. If true, the "Villagers restock up to two times per day." message is displayed when hovering over disabled trades.</td>
    </tr>
  </tbody>
</table>

Trade Item:
<table class="wikitable">
  <tbody>
    <tr>
      <th colspan="2">Field Name</th>
      <th colspan="2">Field Type</th>
      <th>Meaning</th>
    </tr>
    <tr>
      <td colspan="2">Item ID</td>
      <td colspan="2">`VarInt`</td>
      <td>The [item ID](java-edition-data-values.md#blocks). Item IDs are distinct from block IDs; see [Data Generators](data-generators.md) for more information.</td>
    </tr>
    <tr>
      <td colspan="2">Item Count</td>
      <td colspan="2">`VarInt`</td>
      <td>The item count.</td>
    </tr>
    <tr>
      <td rowspan="2">Components</td>
      <td>Component type</td>
      <td rowspan="2">`Prefixed Array`</td>
      <td>`VarInt` `Enum`</td>
      <td>The type of component. See [Structured components](java_edition_protocol-slot_data.md#structuredcomponents) for more detail.</td>
    </tr>
    <tr>
      <td>Component data</td>
      <td>Varies</td>
      <td>The component-dependent data. See [Structured components](java_edition_protocol-slot_data.md#structuredcomponents) for more detail.</td>
    </tr>
  </tbody>
</table>

Modifiers can increase or decrease the number of items for the first input slot. The second input slot and the output slot never change the number of items. The number of items may never be less than 1, and never more than the stack size. If special price and demand are both zero, only the default price is displayed. If either is non-zero, then the adjusted price is displayed next to the crossed-out default price. The adjusted prices is calculated as follows:

Adjusted price = default price + floor(default price x multiplier x demand) + special price

![The merchant UI, for reference](1.14-merchant-slots.png)
---

#### Update Entity Position

This packet is sent by the server when an entity moves a small distance. The change in position is represented as a [[#Fixed-point numbers|fixed-point number]] with 12 fraction bits and 4 integer bits. As such, the maximum movement distance along each axis is 8 blocks in the negative direction, or 7.999755859375 blocks in the positive direction. If the movement exceeds these limits, [[#Teleport Entity|Teleport Entity]] should be sent instead.

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
      <td rowspan="5">*protocol:*<br/>`0x2E`<br/><br/>*resource:*<br/>`move_entity_pos`</td>
      <td rowspan="5">Play</td>
      <td rowspan="5">Client</td>
      <td>Entity ID</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
    <tr>
      <td>Delta X</td>
      <td>`Short`</td>
      <td>Change in X position as `currentX * 4096 - prevX * 4096`.</td>
    </tr>
    <tr>
      <td>Delta Y</td>
      <td>`Short`</td>
      <td>Change in Y position as `currentY * 4096 - prevY * 4096`.</td>
    </tr>
    <tr>
      <td>Delta Z</td>
      <td>`Short`</td>
      <td>Change in Z position as `currentZ * 4096 - prevZ * 4096`.</td>
    </tr>
    <tr>
      <td>On Ground</td>
      <td>`Boolean`</td>
      <td></td>
    </tr>
  </tbody>
</table>

#### Update Entity Position and Rotation

This packet is sent by the server when an entity rotates and moves. See [#Update Entity Position](update-entity-position.md) for how the position is encoded.

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
      <td rowspan="7">*protocol:*<br/>`0x2F`<br/><br/>*resource:*<br/>`move_entity_pos_rot`</td>
      <td rowspan="7">Play</td>
      <td rowspan="7">Client</td>
      <td>Entity ID</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
    <tr>
      <td>Delta X</td>
      <td>`Short`</td>
      <td>Change in X position as `currentX * 4096 - prevX * 4096`.</td>
    </tr>
    <tr>
      <td>Delta Y</td>
      <td>`Short`</td>
      <td>Change in Y position as `currentY * 4096 - prevY * 4096`.</td>
    </tr>
    <tr>
      <td>Delta Z</td>
      <td>`Short`</td>
      <td>Change in Z position as `currentZ * 4096 - prevZ * 4096`.</td>
    </tr>
    <tr>
      <td>Yaw</td>
      <td>`Angle`</td>
      <td>New angle, not a delta.</td>
    </tr>
    <tr>
      <td>Pitch</td>
      <td>`Angle`</td>
      <td>New angle, not a delta.</td>
    </tr>
    <tr>
      <td>On Ground</td>
      <td>`Boolean`</td>
      <td></td>
    </tr>
  </tbody>
</table>

#### Move Minecart Along Track

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>State</th>
      <th>Bound To</th>
      <th colspan="2">Field Name</th>
      <th colspan="2">Field Type</th>
      <th colspan="2">Notes</th>
    </tr>
    <tr>
      <td rowspan="10">*protocol:*<br/>`0x30`<br/><br/>*resource:*<br/>`move_minecart_along_track`</td>
      <td rowspan="10">Play</td>
      <td rowspan="10">Client</td>
      <td colspan="2">Entity ID</td>
      <td colspan="2">`VarInt`</td>
      <td></td>
    </tr>
    <tr>
      <td rowspan="9">Steps</td>
      <td>X</td>
      <td rowspan="9">`Prefixed Array`</td>
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
      <td>Velocity X</td>
      <td>`Double`</td>
      <td></td>
    </tr>
    <tr>
      <td>Velocity Y</td>
      <td>`Double`</td>
      <td></td>
    </tr>
    <tr>
      <td>Velocity Z</td>
      <td>`Double`</td>
      <td></td>
    </tr>
    <tr>
      <td>Yaw</td>
      <td>`Angle`</td>
      <td></td>
    </tr>
    <tr>
      <td>Pitch</td>
      <td>`Angle`</td>
      <td></td>
    </tr>
    <tr>
      <td>Weight</td>
      <td>`Float`</td>
    </tr>
  </tbody>
</table>

#### Update Entity Rotation

This packet is sent by the server when an entity rotates.

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
      <td rowspan="4">*protocol:*<br/>`0x31`<br/><br/>*resource:*<br/>`move_entity_rot`</td>
      <td rowspan="4">Play</td>
      <td rowspan="4">Client</td>
      <td>Entity ID</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
    <tr>
      <td>Yaw</td>
      <td>`Angle`</td>
      <td>New angle, not a delta.</td>
    </tr>
    <tr>
      <td>Pitch</td>
      <td>`Angle`</td>
      <td>New angle, not a delta.</td>
    </tr>
    <tr>
      <td>On Ground</td>
      <td>`Boolean`</td>
      <td></td>
    </tr>
  </tbody>
</table>

#### Move Vehicle

Note that all fields use absolute positioning and do not allow for relative positioning.

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
      <td rowspan="5">*protocol:*<br/>`0x32`<br/><br/>*resource:*<br/>`move_vehicle`</td>
      <td rowspan="5">Play</td>
      <td rowspan="5">Client</td>
      <td>X</td>
      <td>`Double`</td>
      <td>Absolute position (X coordinate).</td>
    </tr>
    <tr>
      <td>Y</td>
      <td>`Double`</td>
      <td>Absolute position (Y coordinate).</td>
    </tr>
    <tr>
      <td>Z</td>
      <td>`Double`</td>
      <td>Absolute position (Z coordinate).</td>
    </tr>
    <tr>
      <td>Yaw</td>
      <td>`Float`</td>
      <td>Absolute rotation on the vertical axis, in degrees.</td>
    </tr>
    <tr>
      <td>Pitch</td>
      <td>`Float`</td>
      <td>Absolute rotation on the horizontal axis, in degrees.</td>
    </tr>
  </tbody>
</table>

#### Open Book

Sent when a player right clicks with a signed book. This tells the client to open the book GUI.

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
      <td>*protocol:*<br/>`0x33`<br/><br/>*resource:*<br/>`open_book`</td>
      <td>Play</td>
      <td>Client</td>
      <td>Hand</td>
      <td>`VarInt` `Enum`</td>
      <td>0: Main hand, 1: Off hand .</td>
    </tr>
  </tbody>
</table>

#### Open Screen

This is sent to the client when it should open an inventory, such as a chest, workbench, furnace, or other container. Resending this packet with already existing window id, will update the window title and window type without closing the window.

This message is not sent to clients opening their own inventory, nor do clients inform the server in any way when doing so. From the server's perspective, the inventory is always "open" whenever no other windows are.

For horses, use [[#Open Horse Screen|Open Horse Screen]].

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
      <td rowspan="3">*protocol:*<br/>`0x34`<br/><br/>*resource:*<br/>`open_screen`</td>
      <td rowspan="3">Play</td>
      <td rowspan="3">Client</td>
      <td>Window ID</td>
      <td>`VarInt`</td>
      <td>An identifier for the window to be displayed. vanilla server implementation is a counter, starting at 1. There can only be one window at a time; this is only used to ignore outdated packets targeting already-closed windows. Note also that the Window ID field in most other packets is only a single byte, and indeed, the vanilla server wraps around after 100.</td>
    </tr>
    <tr>
      <td>Window Type</td>
      <td>`VarInt`</td>
      <td>The window type to use for display. Contained in the `minecraft:menu` registry; see [Inventory](inventory.md) for the different values.</td>
    </tr>
    <tr>
      <td>Window Title</td>
      <td>`Text Component`</td>
      <td>The title of the window.</td>
    </tr>
  </tbody>
</table>

#### Open Sign Editor

Sent when the client has placed a sign and is allowed to send [[#Update Sign|Update Sign]].  There must already be a sign at the given location (which the client does not do automatically) - send a [[#Block Update|Block Update]] first.

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
      <td rowspan="2">*protocol:*<br/>`0x35`<br/><br/>*resource:*<br/>`open_sign_editor`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Client</td>
      <td>Location</td>
      <td>`Position`</td>
      <td></td>
    </tr>
    <tr>
      <td>Is Front Text</td>
      <td>`Boolean`</td>
      <td>Whether the opened editor is for the front or on the back of the sign</td>
    </tr>
  </tbody>
</table>

#### Ping (play)

Packet is not used by the vanilla server. When sent to the client, client responds with a [[#Pong (play)|Pong]] packet with the same id.

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
      <td>*protocol:*<br/>`0x36`<br/><br/>*resource:*<br/>`ping`</td>
      <td>Play</td>
      <td>Client</td>
      <td>ID</td>
      <td>`Int`</td>
      <td></td>
    </tr>
  </tbody>
</table>

#### Ping Response (play)

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
      <td>*protocol:*<br/>`0x37`<br/><br/>*resource:*<br/>`pong_response`</td>
      <td>Play</td>
      <td>Client</td>
      <td>Payload</td>
      <td>`Long`</td>
      <td>Should be the same as sent by the client.</td>
    </tr>
  </tbody>
</table>

#### Place Ghost Recipe

Response to the serverbound packet ([[#Place Recipe|Place Recipe]]), with the same recipe ID. Appears to be used to notify the UI.

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
      <td rowspan="2">*protocol:*<br/>`0x38`<br/><br/>*resource:*<br/>`place_ghost_recipe`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Client</td>
      <td>Window ID</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
    <tr>
      <td>Recipe Display</td>
      <td>`Recipe Display`</td>
      <td></td>
    </tr>
  </tbody>
</table>

#### Player Abilities (clientbound)

The latter 2 floats are used to indicate the flying speed and field of view respectively, while the first byte is used to determine the value of 4 booleans.

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
      <td rowspan="3">*protocol:*<br/>`0x39`<br/><br/>*resource:*<br/>`player_abilities`</td>
      <td rowspan="3">Play</td>
      <td rowspan="3">Client</td>
      <td>Flags</td>
      <td>`Byte`</td>
      <td>Bit field, see below.</td>
    </tr>
    <tr>
      <td>Flying Speed</td>
      <td>`Float`</td>
      <td>0.05 by default.</td>
    </tr>
    <tr>
      <td>Field of View Modifier</td>
      <td>`Float`</td>
      <td>Modifies the field of view, like a speed potion. A vanilla server will use the same value as the movement speed sent in the [[#Update Attributes|Update Attributes]] packet, which defaults to 0.1 for players.</td>
    </tr>
  </tbody>
</table>

About the flags:

<table class="wikitable">
  <tbody>
    <tr>
      <th>Field</th>
      <th>Bit</th>
    </tr>
    <tr>
      <td>Invulnerable</td>
      <td>0x01</td>
    </tr>
    <tr>
      <td>Flying</td>
      <td>0x02</td>
    </tr>
    <tr>
      <td>Allow Flying</td>
      <td>0x04</td>
    </tr>
    <tr>
      <td>Creative Mode (Instant Break)</td>
      <td>0x08</td>
    </tr>
  </tbody>
</table>

If Flying is set but Allow Flying is unset, the player is unable to stop flying.

#### Player Chat Message

_Main article: [Minecraft_Wiki:Projects/wiki.vg_merge/Chat](./minecraft_wiki-projects-wiki.vg_merge-chat.md)_

Sends the client a chat message from a player. 

Currently a lot is unknown about this packet, blank descriptions are for those that are unknown

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>State</th>
      <th>Bound To</th>
      <th>Sector</th>
      <th colspan="2">Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="15">*protocol:*<br/>`0x3A`<br/><br/>*resource:*<br/>`player_chat`</td>
      <td rowspan="15">Play</td>
      <td rowspan="15">Client</td>
      <td rowspan="4">Header</td>
      <td colspan="2">Global Index</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
    <tr>
      <td colspan="2">Sender</td>
      <td>`UUID`</td>
      <td>Used by the vanilla client for the disableChat launch option. Setting both longs to 0 will always display the message regardless of the setting.</td>
    </tr>
    <tr>
      <td colspan="2">Index</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
    <tr>
      <td colspan="2">Message Signature bytes</td>
      <td>`Prefixed Optional` `Byte Array` (256)</td>
      <td>Cryptography, the signature consists of the Sender UUID, Session UUID from the [[#Player Session|Player Session]] packet, Index, Salt, Timestamp in epoch seconds, the length of the original chat content, the original content itself, the length of Previous Messages, and all of the Previous message signatures. These values are hashed with [SHA-256](https://en.wikipedia.org/wiki/SHA-2) and signed using the [RSA](https://en.wikipedia.org/wiki/RSA_(cryptosystem)) cryptosystem. Modifying any of these values in the packet will cause this signature to fail. This buffer is always 256 bytes long and it is not length-prefixed.</td>
    </tr>
    <tr>
      <td rowspan="3">Body</td>
      <td colspan="2">Message</td>
      <td>`String` (256)</td>
      <td>Raw (optionally) signed sent message content.
This is used as the `content` parameter when formatting the message on the client.</td>
    </tr>
    <tr>
      <td colspan="2">Timestamp</td>
      <td>`Long`</td>
      <td>Represents the time the message was signed as milliseconds since the [epoch](https://en.wikipedia.org/wiki/Unix_time), used to check if the message was received within 2 minutes of it being sent.</td>
    </tr>
    <tr>
      <td colspan="2">Salt</td>
      <td>`Long`</td>
      <td>Cryptography, used for validating the message signature.</td>
    </tr>
    <tr>
      <td rowspan="2">`Prefixed Array` (20)</td>
      <td>Message ID</td>
      <td>`VarInt`</td>
      <td>The message Id + 1, used for validating message signature. The next field is present only when value of this field is equal to 0.</td>
    </tr>
    <tr>
      <td>Signature</td>
      <td>`Optional` `Byte Array` (256)</td>
      <td>The previous message's signature. Contains the same type of data as `Message Signature bytes` (256 bytes) above. Not length-prefxied.</td>
    </tr>
    <tr>
      <td rowspan="3">Other</td>
      <td colspan="2">Unsigned Content</td>
      <td>`Prefixed Optional` `Text Component`</td>
      <td></td>
    </tr>
    <tr>
      <td colspan="2">Filter Type</td>
      <td>`VarInt` `Enum`</td>
      <td>If the message has been filtered</td>
    </tr>
    <tr>
      <td colspan="2">Filter Type Bits</td>
      <td>`Optional` `BitSet`</td>
      <td>Only present if the Filter Type is Partially Filtered. Specifies the indexes at which characters in the original message string should be replaced with the `#` symbol (i.e. filtered) by the vanilla client</td>
    </tr>
    <tr>
      <td rowspan="3">Chat Formatting</td>
      <td colspan="2">Chat Type</td>
      <td>`ID or` `Chat Type`</td>
      <td>Either the type of chat in the `minecraft:chat_type` registry, defined by the [Registry Data](java-edition-protocol.md#registrydata) packet, or an inline definition.</td>
    </tr>
    <tr>
      <td colspan="2">Sender Name</td>
      <td>`Text Component`</td>
      <td>The name of the one sending the message, usually the sender's display name.
This is used as the `sender` parameter when formatting the message on the client.</td>
    </tr>
    <tr>
      <td colspan="2">Target Name</td>
      <td>`Prefixed Optional` `Text Component`</td>
      <td>The name of the one receiving the message, usually the receiver's display name.
This is used as the `target` parameter when formatting the message on the client.</td>
    </tr>
  </tbody>
</table>
![Player Chat Handling Logic](MinecraftChat.drawio4.png)

Filter Types:

The filter type mask should NOT be specified unless partially filtered is selected

<table class="wikitable">
  <tbody>
    <tr>
      <th>ID</th>
      <th>Name</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>0</td>
      <td>PASS_THROUGH</td>
      <td>Message is not filtered at all</td>
    </tr>
    <tr>
      <td>1</td>
      <td>FULLY_FILTERED</td>
      <td>Message is fully filtered</td>
    </tr>
    <tr>
      <td>2</td>
      <td>PARTIALLY_FILTERED</td>
      <td>Only some characters in the message are filtered</td>
    </tr>
  </tbody>
</table>

#### End Combat

Unused by the vanilla client.  This data was once used for twitch.tv metadata circa 1.8.

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
      <td rowspan="1">*protocol:*<br/>`0x3B`<br/><br/>*resource:*<br/>`player_combat_end`</td>
      <td rowspan="1">Play</td>
      <td rowspan="1">Client</td>
      <td>Duration</td>
      <td>`VarInt`</td>
      <td>Length of the combat in ticks.</td>
    </tr>
  </tbody>
</table>

#### Enter Combat

Unused by the vanilla client.  This data was once used for twitch.tv metadata circa 1.8.

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
      <td rowspan="1">*protocol:*<br/>`0x3C`<br/><br/>*resource:*<br/>`player_combat_enter`</td>
      <td rowspan="1">Play</td>
      <td rowspan="1">Client</td>
      <td colspan="3">*no fields*</td>
    </tr>
  </tbody>
</table>

#### Combat Death

Used to send a respawn screen.

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
      <td rowspan="2">*protocol:*<br/>`0x3D`<br/><br/>*resource:*<br/>`player_combat_kill`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Client</td>
      <td>Player ID</td>
      <td>`VarInt`</td>
      <td>Entity ID of the player that died (should match the client's entity ID).</td>
    </tr>
    <tr>
      <td>Message</td>
      <td>`Text Component`</td>
      <td>The death message.</td>
    </tr>
  </tbody>
</table>

#### Player Info Remove

Used by the server to remove players from the player list.

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
      <td>*protocol:*<br/>`0x3E`<br/><br/>*resource:*<br/>`player_info_remove`</td>
      <td>Play</td>
      <td>Client</td>
      <td>UUIDs</td>
      <td>`Prefixed Array` of `UUID`</td>
      <td>UUIDs of players to remove.</td>
    </tr>
  </tbody>
</table>

#### Player Info Update

Sent by the server to update the user list (<tab> in the client).

> ⚠️ **Warning:** The EnumSet type is only used here and it is currently undocumented

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>State</th>
      <th>Bound To</th>
      <th colspan="2">Field Name</th>
      <th colspan="2">Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="3">*protocol:*<br/>`0x3F`<br/><br/>*resource:*<br/>`player_info_update`</td>
      <td rowspan="3">Play</td>
      <td rowspan="3">Client</td>
      <td colspan="2">Actions</td>
      <td colspan="2">`EnumSet`</td>
      <td>Determines what actions are present.</td>
    </tr>
    <tr>
      <td rowspan="2">Players</td>
      <td>UUID</td>
      <td rowspan="2">`Prefixed Array`</td>
      <td>`UUID`</td>
      <td>The player UUID</td>
    </tr>
    <tr>
      <td>Player Actions</td>
      <td>`Array` of [[#player-info:player-actions|Player&nbsp;Actions]]</td>
      <td>The length of this array is determined by the number of [[#player-info:player-actions|Player Actions]] that give a non-zero value when applying its mask to the actions flag. For example given the decimal number 5, binary 00000101. The masks 0x01 and 0x04 would return a non-zero value, meaning the Player Actions array would include two actions: Add Player and Update Game Mode.</td>
    </tr>
  </tbody>
</table>
 

<table class="wikitable">
  <caption>id="player-info:player-actions" | Player Actions</caption>
  <tbody>
    <tr>
      <th>Action</th>
      <th>Mask</th>
      <th colspan="2">Field Name</th>
      <th colspan="2">Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="4">Add Player</td>
      <td rowspan="4">0x01</td>
      <td colspan="2">Name</td>
      <td colspan="2">`String` (16)</td>
    </tr>
    <tr>
      <td rowspan="3">Property</td>
      <td>Name</td>
      <td rowspan="3">`Prefixed Array` (16)</td>
      <td>`String` (64)</td>
      <td></td>
    </tr>
    <tr>
      <td>Value</td>
      <td>`String` (32767)</td>
      <td></td>
    </tr>
    <tr>
      <td>Signature</td>
      <td>`Prefixed Optional` `String` (1024)</td>
      <td></td>
    </tr>
    <tr>
      <td rowspan="4">Initialize Chat</td>
      <td rowspan="4">0x02</td>
      <td rowspan="4">Data</td>
      <td>Chat session ID</td>
      <td rowspan="4">`Prefixed Optional`</td>
      <td>`UUID`</td>
      <td></td>
    </tr>
    <tr>
      <td>Public key expiry time</td>
      <td>`Long`</td>
      <td>Key expiry time, as a UNIX timestamp in milliseconds. Only sent if Has Signature Data is true.</td>
    </tr>
    <tr>
      <td>Encoded public key</td>
      <td>`Prefixed Array` (512) of `Byte`</td>
      <td>The player's public key, in bytes. Only sent if Has Signature Data is true.</td>
    </tr>
    <tr>
      <td>Public key signature</td>
      <td>`Prefixed Array` (4096) of `Byte`</td>
      <td>The public key's digital signature. Only sent if Has Signature Data is true.</td>
    </tr>
    <tr>
      <td>Update Game Mode</td>
      <td>0x04</td>
      <td colspan="2">Game Mode</td>
      <td colspan="2">`VarInt`</td>
    </tr>
    <tr>
      <td>Update Listed</td>
      <td>0x08</td>
      <td colspan="2">Listed</td>
      <td colspan="2">`Boolean`</td>
      <td>Whether the player should be listed on the player list.</td>
    </tr>
    <tr>
      <td>Update Latency</td>
      <td>0x10</td>
      <td colspan="2">Ping</td>
      <td colspan="2">`VarInt`</td>
      <td>Measured in milliseconds.</td>
    </tr>
    <tr>
      <td>Update Display Name</td>
      <td>0x20</td>
      <td colspan="2">Display Name</td>
      <td colspan="2">`Prefixed Optional` `Text Component`</td>
      <td>Only sent if Has Display Name is true.</td>
    </tr>
    <tr>
      <td>Update List Priority</td>
      <td>0x40</td>
      <td colspan="2">Priority</td>
      <td colspan="2">`VarInt`</td>
      <td>See below.</td>
    </tr>
    <tr>
      <td>Update Hat</td>
      <td>0x80</td>
      <td colspan="2">Visible</td>
      <td colspan="2">`Boolean`</td>
      <td>Whether the player's hat skin layer is shown.</td>
    </tr>
  </tbody>
</table>

The properties included in this packet are the same as in [[#Login Success|Login Success]], for the current player.

Ping values correspond with icons in the following way:
- A ping that negative (i.e. not known to the server yet) will result in the no connection icon.
- A ping under 150 milliseconds will result in 5 bars
- A ping under 300 milliseconds will result in 4 bars
- A ping under 600 milliseconds will result in 3 bars
- A ping under 1000 milliseconds (1 second) will result in 2 bars
- A ping greater than or equal to 1 second will result in 1 bar.

The order of players in the player list is determined as follows:
- Players with higher priorities are sorted before those with lower priorities.
- Among players of equal priorities, spectators are sorted after non-spectators.
- Within each of those groups, players are sorted into teams. The teams are ordered case-sensitively by team name in ascending order. Players with no team are listed first.
- The players of each team (and non-team) are sorted case-insensitively by name in ascending order.

#### Look At

Used to rotate the client player to face the given location or entity (for `/teleport [<targets>] <x> <y> <z> facing`).

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
      <td rowspan="8">*protocol:*<br/>`0x40`<br/><br/>*resource:*<br/>`player_look_at`</td>
      <td rowspan="8">Play</td>
      <td rowspan="8">Client</td>
    </tr>
    <tr>
      <td>Feet/eyes</td>
      <td>`VarInt` `Enum`</td>
      <td>Values are feet=0, eyes=1.  If set to eyes, aims using the head position; otherwise aims using the feet position.</td>
    </tr>
    <tr>
      <td>Target x</td>
      <td>`Double`</td>
      <td>x coordinate of the point to face towards.</td>
    </tr>
    <tr>
      <td>Target y</td>
      <td>`Double`</td>
      <td>y coordinate of the point to face towards.</td>
    </tr>
    <tr>
      <td>Target z</td>
      <td>`Double`</td>
      <td>z coordinate of the point to face towards.</td>
    </tr>
    <tr>
      <td>Is entity</td>
      <td>`Boolean`</td>
      <td>If true, additional information about an entity is provided.</td>
    </tr>
    <tr>
      <td>Entity ID</td>
      <td>`Optional` `VarInt`</td>
      <td>Only if is entity is true &mdash; the entity to face towards.</td>
    </tr>
    <tr>
      <td>Entity feet/eyes</td>
      <td>`Optional` `VarInt` `Enum`</td>
      <td>Whether to look at the entity's eyes or feet.  Same values and meanings as before, just for the entity's head/feet.</td>
    </tr>
  </tbody>
</table>

If the entity given by entity ID cannot be found, this packet should be treated as if is entity was false.

#### Synchronize Player Position

Teleports the client, e.g. during login, when using an ender pearl, in response to invalid move packets, etc.

Due to latency, the server may receive outdated movement packets sent before the client was aware of the teleport. To account for this, the server ignores all movement packets from the client until a [[#Confirm Teleportation|Confirm Teleportation]] packet with an ID matching the one sent in the teleport packet is received.

Yaw is measured in degrees, and does not follow classical trigonometry rules. The unit circle of yaw on the XZ-plane starts at (0, 1) and turns counterclockwise, with 90 at (-1, 0), 180 at (0, -1) and 270 at (1, 0). Additionally, yaw is not clamped to between 0 and 360 degrees; any number is valid, including negative numbers and numbers greater than 360 (see [MC-90097](https://bugs.mojang.com/browse/MC-90097)).

Pitch is measured in degrees, where 0 is looking straight ahead, -90 is looking straight up, and 90 is looking straight down.

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
      <td rowspan="10">*protocol:*<br/>`0x41`<br/><br/>*resource:*<br/>`player_position`</td>
      <td rowspan="10">Play</td>
      <td rowspan="10">Client</td>
      <td>Teleport ID</td>
      <td>`VarInt`</td>
      <td>Client should confirm this packet with [[#Confirm Teleportation|Confirm Teleportation]] containing the same Teleport ID.</td>
    </tr>
    <tr>
      <td>X</td>
      <td>`Double`</td>
      <td>Absolute or relative position, depending on Flags.</td>
    </tr>
    <tr>
      <td>Y</td>
      <td>`Double`</td>
      <td>Absolute or relative position, depending on Flags.</td>
    </tr>
    <tr>
      <td>Z</td>
      <td>`Double`</td>
      <td>Absolute or relative position, depending on Flags.</td>
    </tr>
    <tr>
      <td>Velocity X</td>
      <td>`Double`</td>
      <td></td>
    </tr>
    <tr>
      <td>Velocity Y</td>
      <td>`Double`</td>
      <td></td>
    </tr>
    <tr>
      <td>Velocity Z</td>
      <td>`Double`</td>
      <td></td>
    </tr>
    <tr>
      <td>Yaw</td>
      <td>`Float`</td>
      <td>Absolute or relative rotation on the X axis, in degrees.</td>
    </tr>
    <tr>
      <td>Pitch</td>
      <td>`Float`</td>
      <td>Absolute or relative rotation on the Y axis, in degrees.</td>
    </tr>
    <tr>
      <td>Flags</td>
      <td>`Teleport Flags`</td>
      <td></td>
    </tr>
  </tbody>
</table>

#### Player Rotation

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
      <td rowspan="2">*protocol:*<br/>`0x42`<br/><br/>*resource:*<br/>`player_rotation`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Client</td>
      <td>Yaw</td>
      <td>`Float`</td>
      <td>Rotation on the X axis, in degrees.</td>
    </tr>
    <tr>
      <td>Pitch</td>
      <td>`Float`</td>
      <td>Rotation on the Y axis, in degrees.</td>
    </tr>
  </tbody>
</table>

#### Recipe Book Add

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>State</th>
      <th>Bound To</th>
      <th colspan="2">Field Name</th>
      <th colspan="2">Field Type</th>
      <th colspan="2">Notes</th>
    </tr>
    <tr>
      <td rowspan="7">*protocol:*<br/>`0x43`<br/><br/>*resource:*<br/>`recipe_book_add`</td>
      <td rowspan="7">Play</td>
      <td rowspan="7">Client</td>
      <td rowspan="6">Recipes</td>
      <td>Recipe ID</td>
      <td rowspan="6">`Prefixed Array`</td>
      <td>`VarInt`</td>
      <td>ID to assign to the recipe.</td>
    </tr>
    <tr>
      <td>Display</td>
      <td>`Recipe Display`</td>
      <td></td>
    </tr>
    <tr>
      <td>Group ID</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
    <tr>
      <td>Category ID</td>
      <td>`VarInt`</td>
      <td>ID in the `minecraft:recipe_book_category` registry.</td>
    </tr>
    <tr>
      <td>Ingredients</td>
      <td>`Prefixed Optional` `Prefixed Array` of `ID Set`</td>
      <td>IDs in the `minecraft:item` registry, or an inline definition.</td>
    </tr>
    <tr>
      <td>Flags</td>
      <td>`Byte`</td>
      <td>0x01: show notification; 0x02: highlight as new</td>
    </tr>
    <tr>
      <td colspan="2">Replace</td>
      <td colspan="2">`Boolean`</td>
      <td>Replace or Add to known recipes</td>
    </tr>
  </tbody>
</table>

#### Recipe Book Remove

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
      <td>*protocol:*<br/>`0x44`<br/><br/>*resource:*<br/>`recipe_book_remove`</td>
      <td>Play</td>
      <td>Client</td>
      <td>Recipes</td>
      <td>`Prefixed Array` of `VarInt`</td>
      <td>IDs of recipes to remove.</td>
    </tr>
  </tbody>
</table>

#### Recipe Book Settings

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
      <td rowspan="8">*protocol:*<br/>`0x45`<br/><br/>*resource:*<br/>`recipe_book_settings`</td>
      <td rowspan="8">Play</td>
      <td rowspan="8">Client</td>
      <td>Crafting Recipe Book Open</td>
      <td>`Boolean`</td>
      <td>If true, then the crafting recipe book will be open when the player opens its inventory.</td>
    </tr>
    <tr>
      <td>Crafting Recipe Book Filter Active</td>
      <td>`Boolean`</td>
      <td>If true, then the filtering option is active when the players opens its inventory.</td>
    </tr>
    <tr>
      <td>Smelting Recipe Book Open</td>
      <td>`Boolean`</td>
      <td>If true, then the smelting recipe book will be open when the player opens its inventory.</td>
    </tr>
    <tr>
      <td>Smelting Recipe Book Filter Active</td>
      <td>`Boolean`</td>
      <td>If true, then the filtering option is active when the players opens its inventory.</td>
    </tr>
    <tr>
      <td>Blast Furnace Recipe Book Open</td>
      <td>`Boolean`</td>
      <td>If true, then the blast furnace recipe book will be open when the player opens its inventory.</td>
    </tr>
    <tr>
      <td>Blast Furnace Recipe Book Filter Active</td>
      <td>`Boolean`</td>
      <td>If true, then the filtering option is active when the players opens its inventory.</td>
    </tr>
    <tr>
      <td>Smoker Recipe Book Open</td>
      <td>`Boolean`</td>
      <td>If true, then the smoker recipe book will be open when the player opens its inventory.</td>
    </tr>
    <tr>
      <td>Smoker Recipe Book Filter Active</td>
      <td>`Boolean`</td>
      <td>If true, then the filtering option is active when the players opens its inventory.</td>
    </tr>
  </tbody>
</table>

#### Remove Entities

Sent by the server when an entity is to be destroyed on the client.

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
      <td>*protocol:*<br/>`0x46`<br/><br/>*resource:*<br/>`remove_entities`</td>
      <td>Play</td>
      <td>Client</td>
      <td>Entity IDs</td>
      <td>`Prefixed Array` of `VarInt`</td>
      <td>The list of entities to destroy.</td>
    </tr>
  </tbody>
</table>

#### Remove Entity Effect

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
      <td rowspan="2">*protocol:*<br/>`0x47`<br/><br/>*resource:*<br/>`remove_mob_effect`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Client</td>
      <td>Entity ID</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
    <tr>
      <td>Effect ID</td>
      <td>`VarInt`</td>
      <td>See [this table](status-effect.md#effect-list).</td>
    </tr>
  </tbody>
</table>

#### Reset Score

This is sent to the client when it should remove a scoreboard item.

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
      <td rowspan="2">*protocol:*<br/>`0x48`<br/><br/>*resource:*<br/>`reset_score`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Client</td>
      <td>Entity Name</td>
      <td>`String` (32767)</td>
      <td>The entity whose score this is. For players, this is their username; for other entities, it is their UUID.</td>
    </tr>
    <tr>
      <td>Objective Name</td>
      <td>`Prefixed Optional` `String` (32767)</td>
      <td>The name of the objective the score belongs to.</td>
    </tr>
  </tbody>
</table>

#### Remove Resource Pack (play)

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
      <td>*protocol:*<br/>`0x49`<br/><br/>*resource:*<br/>`resource_pack_pop`</td>
      <td>Play</td>
      <td>Client</td>
      <td>UUID</td>
      <td>`Optional` `UUID`</td>
      <td>The UUID of the resource pack to be removed.</td>
    </tr>
  </tbody>
</table>

#### Add Resource Pack (play)

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
      <td rowspan="5">*protocol:*<br/>`0x4A`<br/><br/>*resource:*<br/>`resource_pack_push`</td>
      <td rowspan="5">Play</td>
      <td rowspan="5">Client</td>
      <td>UUID</td>
      <td>`UUID`</td>
      <td>The unique identifier of the resource pack.</td>
    </tr>
    <tr>
      <td>URL</td>
      <td>`String` (32767)</td>
      <td>The URL to the resource pack.</td>
    </tr>
    <tr>
      <td>Hash</td>
      <td>`String` (40)</td>
      <td>A 40 character hexadecimal, case-insensitive [SHA-1](wikipedia-sha-1.md) hash of the resource pack file.<br />If it's not a 40 character hexadecimal string, the client will not use it for hash verification and likely waste bandwidth.</td>
    </tr>
    <tr>
      <td>Forced</td>
      <td>`Boolean`</td>
      <td>The vanilla client will be forced to use the resource pack from the server. If they decline they will be kicked from the server.</td>
    </tr>
    <tr>
      <td>Prompt Message</td>
      <td>`Prefixed Optional` `Text Component`</td>
      <td>This is shown in the prompt making the client accept or decline the resource pack.</td>
    </tr>
  </tbody>
</table>

#### Respawn

> ❓ **Missing info (section):** Although the number of portal cooldown ticks is included in this packet, the whole portal usage process is still dictated entirely by the server. What kind of effect does this value have on the client, if any?

To change the player's dimension (overworld/nether/end), send them a respawn packet with the appropriate dimension, followed by prechunks/chunks for the new dimension, and finally a position and look packet. You do not need to unload chunks, the client will do it automatically.

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
      <td rowspan="13">*protocol:*<br/>`0x4B`<br/><br/>*resource:*<br/>`respawn`</td>
      <td rowspan="13">Play</td>
      <td rowspan="13">Client</td>
      <td>Dimension Type</td>
      <td>`VarInt`</td>
      <td>The ID of type of dimension in the `minecraft:dimension_type` registry, defined by the [Registry Data](java-edition-protocol.md#registrydata) packet.</td>
    </tr>
    <tr>
      <td>Dimension Name</td>
      <td>`Identifier`</td>
      <td>Name of the dimension being spawned into.</td>
    </tr>
    <tr>
      <td>Hashed seed</td>
      <td>`Long`</td>
      <td>First 8 bytes of the SHA-256 hash of the world's seed. Used client side for biome noise</td>
    </tr>
    <tr>
      <td>Game mode</td>
      <td>`Unsigned Byte`</td>
      <td>0: Survival, 1: Creative, 2: Adventure, 3: Spectator.</td>
    </tr>
    <tr>
      <td>Previous Game mode</td>
      <td>`Byte`</td>
      <td>-1: Undefined (null), 0: Survival, 1: Creative, 2: Adventure, 3: Spectator. The previous game mode. Vanilla client uses this for the debug (F3 + N & F3 + F4) game mode switch. (More information needed)</td>
    </tr>
    <tr>
      <td>Is Debug</td>
      <td>`Boolean`</td>
      <td>True if the world is a [debug mode](debug-mode.md) world; debug mode worlds cannot be modified and have predefined blocks.</td>
    </tr>
    <tr>
      <td>Is Flat</td>
      <td>`Boolean`</td>
      <td>True if the world is a [superflat](superflat.md) world; flat worlds have different void fog and a horizon at y=0 instead of y=63.</td>
    </tr>
    <tr>
      <td>Has death location</td>
      <td>`Boolean`</td>
      <td>If true, then the next two fields are present.</td>
    </tr>
    <tr>
      <td>Death dimension Name</td>
      <td>`Optional` `Identifier`</td>
      <td>Name of the dimension the player died in.</td>
    </tr>
    <tr>
      <td>Death location</td>
      <td>`Optional` `Position`</td>
      <td>The location that the player died at.</td>
    </tr>
    <tr>
      <td>Portal cooldown</td>
      <td>`VarInt`</td>
      <td>The number of ticks until the player can use the portal again.</td>
    </tr>
    <tr>
      <td>Sea level</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
    <tr>
      <td>Data kept</td>
      <td>`Byte`</td>
      <td>Bit mask. 0x01: Keep attributes, 0x02: Keep metadata. Tells which data should be kept on the client side once the player has respawned.
In the vanilla implementation, this is context dependent:
* normal respawns (after death) keep no data;
* exiting the end poem/credits keeps the attributes;
* other dimension changes (portals or teleports) keep all data.</td>
    </tr>
  </tbody>
</table>

{{warning|Avoid changing player's dimension to same dimension they were already in unless they are dead. If you change the dimension to one they are already in, weird bugs can occur, such as the player being unable to attack other players in new world (until they die and respawn).

Before 1.16, if you must respawn a player in the same dimension without killing them, send two respawn packets, one to a different world and then another to the world you want. You do not need to complete the first respawn; it only matters that you send two packets.}}

#### Set Head Rotation

Changes the direction an entity's head is facing.

While sending the Entity Look packet changes the vertical rotation of the head, sending this packet appears to be necessary to rotate the head horizontally.

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
      <td rowspan="2">*protocol:*<br/>`0x4C`<br/><br/>*resource:*<br/>`rotate_head`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Client</td>
      <td>Entity ID</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
    <tr>
      <td>Head Yaw</td>
      <td>`Angle`</td>
      <td>New angle, not a delta.</td>
    </tr>
  </tbody>
</table>

#### Update Section Blocks

Fired whenever 2 or more blocks are changed within the same chunk on the same tick.

> ⚠️ **Warning:** Changing blocks in chunks not loaded by the client is unsafe (see note on [[#Block Update|Block Update]]).

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
      <td rowspan="2">*protocol:*<br/>`0x4D`<br/><br/>*resource:*<br/>`section_blocks_update`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Client</td>
      <td>Chunk section position</td>
      <td>`Long`</td>
      <td>Chunk section coordinate (encoded chunk x and z with each 22 bits, and section y with 20 bits, from left to right).</td>
    </tr>
    <tr>
      <td>Blocks</td>
      <td>`Prefixed Array` of `VarLong`</td>
      <td>Each entry is composed of the block state id, shifted left by 12, and the relative block position in the chunk section (4 bits for x, z, and y, from left to right).</td>
    </tr>
  </tbody>
</table>

Chunk section position is encoded:
```java
((sectionX & 0x3FFFFF) << 42) | (sectionY & 0xFFFFF) | ((sectionZ & 0x3FFFFF) << 20);
```
and decoded:
```java
sectionX = long >> 42;
sectionY = long << 44 >> 44;
sectionZ = long << 22 >> 42;
```

Blocks are encoded:
```java
blockStateId << 12 | (blockLocalX << 8 | blockLocalZ << 4 | blockLocalY)
//Uses the local position of the given block position relative to its respective chunk section
```
and decoded:
```java
blockStateId = long >> 12;
blockLocalX = (long >> 8) & 0xF;
blockLocalY = long & 0xF;
blockLocalZ = (long >> 4) & 0xF;
```

#### Select Advancements Tab

Sent by the server to indicate that the client should switch advancement tab. Sent either when the client switches tab in the GUI or when an advancement in another tab is made.

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
      <td>*protocol:*<br/>`0x4E`<br/><br/>*resource:*<br/>`select_advancements_tab`</td>
      <td>Play</td>
      <td>Client</td>
      <td>Identifier</td>
      <td>`Prefixed Optional` `Identifier`</td>
      <td>See below.</td>
    </tr>
  </tbody>
</table>

The `Identifier` must be one of the following if no custom data pack is loaded:

<table class="wikitable">
  <tbody>
    <tr>
      <th>Identifier</th>
    </tr>
    <tr>
      <td>minecraft:story/root</td>
    </tr>
    <tr>
      <td>minecraft:nether/root</td>
    </tr>
    <tr>
      <td>minecraft:end/root</td>
    </tr>
    <tr>
      <td>minecraft:adventure/root</td>
    </tr>
    <tr>
      <td>minecraft:husbandry/root</td>
    </tr>
  </tbody>
</table>

If no or an invalid identifier is sent, the client will switch to the first tab in the GUI.

#### Server Data

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
      <td rowspan="2">*protocol:*<br/>`0x4F`<br/><br/>*resource:*<br/>`server_data`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Client</td>
      <td>MOTD</td>
      <td>`Text Component`</td>
      <td></td>
    </tr>
    <tr>
      <td>Icon</td>
      <td>`Prefixed Optional` `Prefixed Array` of `Byte`</td>
      <td>Icon bytes in the PNG format.</td>
    </tr>
  </tbody>
</table>

#### Set Action Bar Text

Displays a message above the hotbar. Equivalent to [[#System Chat Message|System Chat Message]] with Overlay set to true, except that [chat message blocking](chat.md#social-interactions-blocking) isn't performed. Used by the vanilla server only to implement the `/title` command.

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
      <td rowspan="1">*protocol:*<br/>`0x50`<br/><br/>*resource:*<br/>`set_action_bar_text`</td>
      <td rowspan="1">Play</td>
      <td rowspan="1">Client</td>
      <td>Action bar text</td>
      <td>`Text Component`</td>
    </tr>
  </tbody>
</table>

#### Set Border Center

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
      <td rowspan="2">*protocol:*<br/>`0x51`<br/><br/>*resource:*<br/>`set_border_center`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Client</td>
      <td>X</td>
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

#### Set Border Lerp Size

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
      <td rowspan="3">*protocol:*<br/>`0x52`<br/><br/>*resource:*<br/>`set_border_lerp_size`</td>
      <td rowspan="3">Play</td>
      <td rowspan="3">Client</td>
      <td>Old Diameter</td>
      <td>`Double`</td>
      <td>Current length of a single side of the world border, in meters.</td>
    </tr>
    <tr>
      <td>New Diameter</td>
      <td>`Double`</td>
      <td>Target length of a single side of the world border, in meters.</td>
    </tr>
    <tr>
      <td>Speed</td>
      <td>`VarLong`</td>
      <td>Number of real-time *milli*seconds until New Diameter is reached. It appears that vanilla server does not sync world border speed to game ticks, so it gets out of sync with server lag. If the world border is not moving, this is set to 0.</td>
    </tr>
  </tbody>
</table>

#### Set Border Size

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
      <td rowspan="1">*protocol:*<br/>`0x53`<br/><br/>*resource:*<br/>`set_border_size`</td>
      <td rowspan="1">Play</td>
      <td rowspan="1">Client</td>
      <td>Diameter</td>
      <td>`Double`</td>
      <td>Length of a single side of the world border, in meters.</td>
    </tr>
  </tbody>
</table>

#### Set Border Warning Delay

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
      <td rowspan="1">*protocol:*<br/>`0x54`<br/><br/>*resource:*<br/>`set_border_warning_delay`</td>
      <td rowspan="1">Play</td>
      <td rowspan="1">Client</td>
      <td>Warning Time</td>
      <td>`VarInt`</td>
      <td>In seconds as set by `/worldborder warning time`.</td>
    </tr>
  </tbody>
</table>

#### Set Border Warning Distance

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
      <td rowspan="1">*protocol:*<br/>`0x55`<br/><br/>*resource:*<br/>`set_border_warning_distance`</td>
      <td rowspan="1">Play</td>
      <td rowspan="1">Client</td>
      <td>Warning Blocks</td>
      <td>`VarInt`</td>
      <td>In meters.</td>
    </tr>
  </tbody>
</table>

#### Set Camera

Sets the entity that the player renders from. This is normally used when the player left-clicks an entity while in spectator mode.

The player's camera will move with the entity and look where it is looking. The entity is often another player, but can be any type of entity.  The player is unable to move this entity (move packets will act as if they are coming from the other entity).

If the given entity is not loaded by the player, this packet is ignored.  To return control to the player, send this packet with their entity ID.

The vanilla server resets this (sends it back to the default entity) whenever the spectated entity is killed or the player sneaks, but only if they were spectating an entity. It also sends this packet whenever the player switches out of spectator mode (even if they weren't spectating an entity).

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
      <td>*protocol:*<br/>`0x56`<br/><br/>*resource:*<br/>`set_camera`</td>
      <td>Play</td>
      <td>Client</td>
      <td>Camera ID</td>
      <td>`VarInt`</td>
      <td>ID of the entity to set the client's camera to.</td>
    </tr>
  </tbody>
</table>

The vanilla client also loads certain shaders for given entities:

- Creeper &rarr; `shaders/post/creeper.json`
- Spider (and cave spider) &rarr; `shaders/post/spider.json`
- Enderman &rarr; `shaders/post/invert.json`
- Anything else &rarr; the current shader is unloaded

#### Set Center Chunk

Sets the center position of the client's chunk loading area. The area is square-shaped, spanning 2 &times; server view distance + 7 chunks on both axes (width, not radius!). Since the area's width is always an odd number, there is no ambiguity as to which chunk is the center.

The vanilla client ignores attempts to send chunks located outside the loading area, and immediately unloads any existing chunks no longer inside it.

The center chunk is normally the chunk the player is in, but apart from the implications on chunk loading, the (vanilla) client takes no issue with this not being the case. Indeed, as long as chunks are sent only within the default loading area centered on the world origin, it is not necessary to send this packet at all. This may be useful for servers with small bounded worlds, such as minigames, since it ensures chunks never need to be resent after the client has joined, saving on bandwidth.

The vanilla server sends this packet whenever the player moves across a chunk border horizontally, and also (according to testing) for any integer change in the vertical axis, even if it doesn't go across a chunk section border.

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
      <td rowspan="2">*protocol:*<br/>`0x57`<br/><br/>*resource:*<br/>`set_chunk_cache_center`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Client</td>
      <td>Chunk X</td>
      <td>`VarInt`</td>
      <td>Chunk X coordinate of the loading area center.</td>
    </tr>
    <tr>
      <td>Chunk Z</td>
      <td>`VarInt`</td>
      <td>Chunk Z coordinate of the loading area center.</td>
    </tr>
  </tbody>
</table>

#### Set Render Distance

Sent by the integrated singleplayer server when changing render distance.  This packet is sent by the server when the client reappears in the overworld after leaving the end.

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
      <td>*protocol:*<br/>`0x58`<br/><br/>*resource:*<br/>`set_chunk_cache_radius`</td>
      <td>Play</td>
      <td>Client</td>
      <td>View Distance</td>
      <td>`VarInt`</td>
      <td>Render distance (2-32).</td>
    </tr>
  </tbody>
</table>

#### Set Cursor Item

Replaces or sets the inventory item that's being dragged with the mouse.

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
      <td>*protocol:*<br/>`0x59`<br/><br/>*resource:*<br/>`set_cursor_item`</td>
      <td>Play</td>
      <td>Client</td>
      <td>Carried item</td>
      <td>`Slot`</td>
      <td></td>
    </tr>
  </tbody>
</table>

#### Set Default Spawn Position

Sent by the server after login to specify the coordinates of the spawn point (the point at which players spawn at, and which the compass points to). It can be sent at any time to update the point compasses point at.

The client uses this as the default position of the player upon spawning, though it's a good idea to always override this default by sending [[#Synchronize Player Position|Synchronize Player Position]]. When converting the position to floating point, 0.5 is added to the x and z coordinates and 1.0 to the y coordinate, so as to place the player centered on top of the specified block position.

Before receiving this packet, the client uses the default position 8, 64, 8, and angle 0.0 (resulting in a default player spawn position of 8.5, 65.0, 8.5).

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
      <td rowspan="2">*protocol:*<br/>`0x5A`<br/><br/>*resource:*<br/>`set_default_spawn_position`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Client</td>
      <td>Location</td>
      <td>`Position`</td>
      <td>Spawn location.</td>
    </tr>
    <tr>
      <td>Angle</td>
      <td>`Float`</td>
      <td>The angle at which to respawn at.</td>
    </tr>
  </tbody>
</table>

#### Display Objective

This is sent to the client when it should display a scoreboard.

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
      <td rowspan="2">*protocol:*<br/>`0x5B`<br/><br/>*resource:*<br/>`set_display_objective`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Client</td>
      <td>Position</td>
      <td>`VarInt`</td>
      <td>The position of the scoreboard. 0: list, 1: sidebar, 2: below name, 3 - 18: team specific sidebar, indexed as 3 + team color.</td>
    </tr>
    <tr>
      <td>Score Name</td>
      <td>`String` (32767)</td>
      <td>The unique name for the scoreboard to be displayed.</td>
    </tr>
  </tbody>
</table>

#### Set Entity Metadata

Updates one or more [metadata](entity_metadata.md#entity-metadata-format) properties for an existing entity. Any properties not included in the Metadata field are left unchanged.

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
      <td rowspan="2">*protocol:*<br/>`0x5C`<br/><br/>*resource:*<br/>`set_entity_data`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Client</td>
      <td>Entity ID</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
    <tr>
      <td>Metadata</td>
      <td>[Entity Metadata](entity_metadata.md#entity-metadata-format)</td>
      <td></td>
    </tr>
  </tbody>
</table>

#### Link Entities

This packet is sent when an entity has been [leashed](lead.md) to another entity.

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
      <td rowspan="2">*protocol:*<br/>`0x5D`<br/><br/>*resource:*<br/>`set_entity_link`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Client</td>
      <td>Attached Entity ID</td>
      <td>`Int`</td>
      <td>Attached entity's EID.</td>
    </tr>
    <tr>
      <td>Holding Entity ID</td>
      <td>`Int`</td>
      <td>ID of the entity holding the lead. Set to -1 to detach.</td>
    </tr>
  </tbody>
</table>

#### Set Entity Velocity

Velocity is in units of 1/8000 of a block per server tick (50ms); for example, -1343 would move (-1343 / 8000) = −0.167875 blocks per tick (or −3.3575 blocks per second).

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
      <td rowspan="4">*protocol:*<br/>`0x5E`<br/><br/>*resource:*<br/>`set_entity_motion`</td>
      <td rowspan="4">Play</td>
      <td rowspan="4">Client</td>
      <td>Entity ID</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
    <tr>
      <td>Velocity X</td>
      <td>`Short`</td>
      <td>Velocity on the X axis.</td>
    </tr>
    <tr>
      <td>Velocity Y</td>
      <td>`Short`</td>
      <td>Velocity on the Y axis.</td>
    </tr>
    <tr>
      <td>Velocity Z</td>
      <td>`Short`</td>
      <td>Velocity on the Z axis.</td>
    </tr>
  </tbody>
</table>

#### Set Equipment

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>State</th>
      <th>Bound To</th>
      <th colspan="2">Field Name</th>
      <th colspan="2">Field Type</th>
      <th colspan="2">Notes</th>
    </tr>
    <tr>
      <td rowspan="3">*protocol:*<br/>`0x5F`<br/><br/>*resource:*<br/>`set_equipment`</td>
      <td rowspan="3">Play</td>
      <td rowspan="3">Client</td>
      <td colspan="2">Entity ID</td>
      <td colspan="2">`VarInt`</td>
      <td colspan="2">Entity's ID.</td>
    </tr>
    <tr>
      <td rowspan="2">Equipment</td>
      <td>Slot</td>
      <td rowspan="2">`Array`</td>
      <td>`Byte` `Enum`</td>
      <td rowspan="2">The length of the array is unknown, it must be read until the most significant bit is 1 ((Slot >>> 7 & 1) == 1)</td>
      <td>Equipment slot (see below).  Also has the top bit set if another entry follows, and otherwise unset if this is the last item in the array.</td>
    </tr>
    <tr>
      <td>Item</td>
      <td>`Slot`</td>
      <td></td>
    </tr>
  </tbody>
</table>

Equipment slot can be one of the following:

<table class="wikitable">
  <tbody>
    <tr>
      <th>ID</th>
      <th>Equipment slot</th>
    </tr>
    <tr>
      <td>0</td>
      <td>Main hand</td>
    </tr>
    <tr>
      <td>1</td>
      <td>Off hand</td>
    </tr>
    <tr>
      <td>2</td>
      <td>Boots</td>
    </tr>
    <tr>
      <td>3</td>
      <td>Leggings</td>
    </tr>
    <tr>
      <td>4</td>
      <td>Chestplate</td>
    </tr>
    <tr>
      <td>5</td>
      <td>Helmet</td>
    </tr>
    <tr>
      <td>6</td>
      <td>Body</td>
    </tr>
  </tbody>
</table>

#### Set Experience

Sent by the server when the client should change experience levels.

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
      <td rowspan="3">*protocol:*<br/>`0x60`<br/><br/>*resource:*<br/>`set_experience`</td>
      <td rowspan="3">Play</td>
      <td rowspan="3">Client</td>
      <td>Experience bar</td>
      <td>`Float`</td>
      <td>Between 0 and 1.</td>
    </tr>
    <tr>
      <td>Level</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
    <tr>
      <td>Total Experience</td>
      <td>`VarInt`</td>
      <td>See [Experience#Leveling up](experience.md#leveling-up) on the Minecraft Wiki for Total Experience to Level conversion.</td>
    </tr>
  </tbody>
</table>

#### Set Health

Sent by the server to set the health of the player it is sent to.

Food [saturation](food.md#hunger-and-saturation) acts as a food “overcharge”. Food values will not decrease while the saturation is over zero. New players logging in or respawning automatically get a saturation of 5.0. Eating food increases the saturation as well as the food bar.

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
      <td rowspan="3">*protocol:*<br/>`0x61`<br/><br/>*resource:*<br/>`set_health`</td>
      <td rowspan="3">Play</td>
      <td rowspan="3">Client</td>
      <td>Health</td>
      <td>`Float`</td>
      <td>0 or less = dead, 20 = full HP.</td>
    </tr>
    <tr>
      <td>Food</td>
      <td>`VarInt`</td>
      <td>0–20.</td>
    </tr>
    <tr>
      <td>Food Saturation</td>
      <td>`Float`</td>
      <td>Seems to vary from 0.0 to 5.0 in integer increments.</td>
    </tr>
  </tbody>
</table>

#### Set Held Item (clientbound)

Sent to change the player's slot selection.

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
      <td>*protocol:*<br/>`0x62`<br/><br/>*resource:*<br/>`set_held_slot`</td>
      <td>Play</td>
      <td>Client</td>
      <td>Slot</td>
      <td>`VarInt`</td>
      <td>The slot which the player has selected (0–8).</td>
    </tr>
  </tbody>
</table>

#### Update Objectives

This is sent to the client when it should create a new [scoreboard](scoreboard.md) objective or remove one.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>State</th>
      <th>Bound To</th>
      <th colspan="2">Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="10">*protocol:*<br/>`0x63`<br/><br/>*resource:*<br/>`set_objective`</td>
      <td rowspan="10">Play</td>
      <td rowspan="10">Client</td>
      <td colspan="2">Objective Name</td>
      <td>`String` (32767)</td>
      <td>A unique name for the objective.</td>
    </tr>
    <tr>
      <td colspan="2">Mode</td>
      <td>`Byte`</td>
      <td>0 to create the scoreboard. 1 to remove the scoreboard. 2 to update the display text.</td>
    </tr>
    <tr>
      <td colspan="2">Objective Value</td>
      <td>`Optional` `Text Component`</td>
      <td>Only if mode is 0 or 2.The text to be displayed for the score.</td>
    </tr>
    <tr>
      <td colspan="2">Type</td>
      <td>`Optional` `VarInt` `Enum`</td>
      <td>Only if mode is 0 or 2. 0 = "integer", 1 = "hearts".</td>
    </tr>
    <tr>
      <td colspan="2">Has Number Format</td>
      <td>`Optional` `Boolean`</td>
      <td>Only if mode is 0 or 2. Whether this objective has a set number format for the scores.</td>
    </tr>
    <tr>
      <td colspan="2">Number Format</td>
      <td>`Optional` `VarInt` `Enum`</td>
      <td>Only if mode is 0 or 2 and the previous boolean is true. Determines how the score number should be formatted.</td>
    </tr>
    <tr>
      <th>Number Format</th>
      <th>Field Name</th>
      <th></th>
      <th></th>
    </tr>
    <tr>
      <td>0: blank</td>
      <td colspan="2">*no fields*</td>
      <td>Show nothing.</td>
    </tr>
    <tr>
      <td>1: styled</td>
      <td>Styling</td>
      <td>[Compound Tag](nbt.md#specificationcompoundtag)</td>
      <td>The styling to be used when formatting the score number. Contains the [text component styling fields](text-formatting.md#styling-fields).</td>
    </tr>
    <tr>
      <td>2: fixed</td>
      <td>Content</td>
      <td>`Text Component`</td>
      <td>The text to be used as placeholder.</td>
    </tr>
  </tbody>
</table>

#### Set Passengers

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
      <td rowspan="2">*protocol:*<br/>`0x64`<br/><br/>*resource:*<br/>`set_passengers`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Client</td>
      <td>Entity ID</td>
      <td>`VarInt`</td>
      <td>Vehicle's EID.</td>
    </tr>
    <tr>
      <td>Passengers</td>
      <td>`Prefixed Array` of `VarInt`</td>
      <td>EIDs of entity's passengers.</td>
    </tr>
  </tbody>
</table>

#### Set Player Inventory Slot

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
      <td rowspan="2">*protocol:*<br/>`0x65`<br/><br/>*resource:*<br/>`set_player_inventory`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Client</td>
      <td>Slot</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
    <tr>
      <td>Slot Data</td>
      <td>`Slot`</td>
      <td></td>
    </tr>
  </tbody>
</table>

#### Update Teams

Creates and updates teams.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>State</th>
      <th>Bound To</th>
      <th colspan="2">Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="20">*protocol:*<br/>`0x66`<br/><br/>*resource:*<br/>`set_player_team`</td>
      <td rowspan="20">Play</td>
      <td rowspan="20">Client</td>
      <td colspan="2">Team Name</td>
      <td>`String` (32767)</td>
      <td>A unique name for the team. (Shared with scoreboard).</td>
    </tr>
    <tr>
      <td colspan="2">Method</td>
      <td>`Byte`</td>
      <td>Determines the layout of the remaining packet.</td>
    </tr>
    <tr>
      <td rowspan="8">0: create team</td>
      <td>Team Display Name</td>
      <td>`Text Component`</td>
      <td></td>
    </tr>
    <tr>
      <td>Friendly Flags</td>
      <td>`Byte`</td>
      <td>Bit mask. 0x01: Allow friendly fire, 0x02: can see invisible players on same team.</td>
    </tr>
    <tr>
      <td>Name Tag Visibility</td>
      <td>`VarInt` `Enum`</td>
      <td>0 = ALWAYS, 1 = NEVER, 2 = HIDE_FOR_OTHER_TEAMS, 3 = HIDE_FOR_OWN_TEAMS</td>
    </tr>
    <tr>
      <td>Collision Rule</td>
      <td>`VarInt` `Enum`</td>
      <td>0 = ALWAYS, 1 = NEVER, 2 = PUSH_OTHER_TEAMS, 3 = PUSH_OWN_TEAM</td>
    </tr>
    <tr>
      <td>Team Color</td>
      <td>`VarInt` `Enum`</td>
      <td>Used to color the name of players on the team; see below.</td>
    </tr>
    <tr>
      <td>Team Prefix</td>
      <td>`Text Component`</td>
      <td>Displayed before the names of players that are part of this team.</td>
    </tr>
    <tr>
      <td>Team Suffix</td>
      <td>`Text Component`</td>
      <td>Displayed after the names of players that are part of this team.</td>
    </tr>
    <tr>
      <td>Entities</td>
      <td>`Prefixed Array` of `String` (32767)</td>
      <td>Identifiers for the entities in this team.  For players, this is their username; for other entities, it is their UUID.</td>
    </tr>
    <tr>
      <td>1: remove team</td>
      <td>*no fields*</td>
      <td>*no fields*</td>
      <td></td>
    </tr>
    <tr>
      <td rowspan="7">2: update team info</td>
      <td>Team Display Name</td>
      <td>`Text Component`</td>
      <td></td>
    </tr>
    <tr>
      <td>Friendly Flags</td>
      <td>`Byte`</td>
      <td>Bit mask. 0x01: Allow friendly fire, 0x02: can see invisible entities on same team.</td>
    </tr>
    <tr>
      <td>Name Tag Visibility</td>
      <td>`VarInt` `Enum`</td>
      <td>0 = ALWAYS, 1 = NEVER, 2 = HIDE_FOR_OTHER_TEAMS, 3 = HIDE_FOR_OWN_TEAMS</td>
    </tr>
    <tr>
      <td>Collision Rule</td>
      <td>`VarInt` `Enum`</td>
      <td>0 = ALWAYS, 1 = NEVER, 2 = PUSH_OTHER_TEAMS, 3 = PUSH_OWN_TEAM</td>
    </tr>
    <tr>
      <td>Team Color</td>
      <td>`VarInt` `Enum`</td>
      <td>Used to color the name of players on the team; see below.</td>
    </tr>
    <tr>
      <td>Team Prefix</td>
      <td>`Text Component`</td>
      <td>Displayed before the names of players that are part of this team.</td>
    </tr>
    <tr>
      <td>Team Suffix</td>
      <td>`Text Component`</td>
      <td>Displayed after the names of players that are part of this team.</td>
    </tr>
    <tr>
      <td>3: add entities to team</td>
      <td>Entities</td>
      <td>`Prefixed Array` of `String` (32767)</td>
      <td>Identifiers for the added entities.  For players, this is their username; for other entities, it is their UUID.</td>
    </tr>
    <tr>
      <td>4: remove entities from team</td>
      <td>Entities</td>
      <td>`Prefixed Array` of `String` (32767)</td>
      <td>Identifiers for the removed entities.  For players, this is their username; for other entities, it is their UUID.</td>
    </tr>
  </tbody>
</table>

Team Color: The color of a team defines how the names of the team members are visualized; any formatting code can be used. The following table lists all the possible values.

<table class="wikitable">
  <tbody>
    <tr>
      <th>ID</th>
      <th>Formatting</th>
    </tr>
    <tr>
      <td>0-15</td>
      <td>Color formatting, same values as in [Text formatting#Colors](text-formatting.md#colors).</td>
    </tr>
    <tr>
      <td>16</td>
      <td>Obfuscated</td>
    </tr>
    <tr>
      <td>17</td>
      <td>Bold</td>
    </tr>
    <tr>
      <td>18</td>
      <td>Strikethrough</td>
    </tr>
    <tr>
      <td>19</td>
      <td>Underlined</td>
    </tr>
    <tr>
      <td>20</td>
      <td>Italic</td>
    </tr>
    <tr>
      <td>21</td>
      <td>Reset</td>
    </tr>
  </tbody>
</table>

#### Update Score

This is sent to the client when it should update a scoreboard item.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>State</th>
      <th>Bound To</th>
      <th colspan="2">Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="9">*protocol:*<br/>`0x67`<br/><br/>*resource:*<br/>`set_score`</td>
      <td rowspan="9">Play</td>
      <td rowspan="9">Client</td>
      <td colspan="2">Entity Name</td>
      <td>`String` (32767)</td>
      <td>The entity whose score this is. For players, this is their username; for other entities, it is their UUID.</td>
    </tr>
    <tr>
      <td colspan="2">Objective Name</td>
      <td>`String` (32767)</td>
      <td>The name of the objective the score belongs to.</td>
    </tr>
    <tr>
      <td colspan="2">Value</td>
      <td>`VarInt`</td>
      <td>The score to be displayed next to the entry.</td>
    </tr>
    <tr>
      <td colspan="2">Display Name</td>
      <td>`Prefixed Optional` `Text Component`</td>
      <td>The custom display name.</td>
    </tr>
    <tr>
      <td colspan="2">Number Format</td>
      <td>`Prefixed Optional` `VarInt` `Enum`</td>
      <td>Determines how the score number should be formatted.</td>
    </tr>
    <tr>
      <th>Number Format</th>
      <th>Field Name</th>
      <th></th>
      <th></th>
    </tr>
    <tr>
      <td>0: blank</td>
      <td colspan="2">*no fields*</td>
      <td>Show nothing.</td>
    </tr>
    <tr>
      <td>1: styled</td>
      <td>Styling</td>
      <td>[Compound Tag](nbt.md#specificationcompoundtag)</td>
      <td>The styling to be used when formatting the score number. Contains the [text component styling fields](text-formatting.md#styling-fields).</td>
    </tr>
    <tr>
      <td>2: fixed</td>
      <td>Content</td>
      <td>`Text Component`</td>
      <td>The text to be used as placeholder.</td>
    </tr>
  </tbody>
</table>

#### Set Simulation Distance

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
      <td>*protocol:*<br/>`0x68`<br/><br/>*resource:*<br/>`set_simulation_distance`</td>
      <td>Play</td>
      <td>Client</td>
      <td>Simulation Distance</td>
      <td>`VarInt`</td>
      <td>The distance that the client will process specific things, such as entities.</td>
    </tr>
  </tbody>
</table>

#### Set Subtitle Text

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
      <td rowspan="1">*protocol:*<br/>`0x69`<br/><br/>*resource:*<br/>`set_subtitle_text`</td>
      <td rowspan="1">Play</td>
      <td rowspan="1">Client</td>
      <td>Subtitle Text</td>
      <td>`Text Component`</td>
      <td></td>
    </tr>
  </tbody>
</table>

#### Update Time

Time is based on ticks, where 20 ticks happen every second. There are 24000 ticks in a day, making Minecraft days exactly 20 minutes long.

The time of day is based on the timestamp modulo 24000. 0 is sunrise, 6000 is noon, 12000 is sunset, and 18000 is midnight.

The default SMP server increments the time by `20` every second.

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
      <td rowspan="3">*protocol:*<br/>`0x6A`<br/><br/>*resource:*<br/>`set_time`</td>
      <td rowspan="3">Play</td>
      <td rowspan="3">Client</td>
      <td>World Age</td>
      <td>`Long`</td>
      <td>In ticks; not changed by server commands.</td>
    </tr>
    <tr>
      <td>Time of day</td>
      <td>`Long`</td>
      <td>The world (or region) time, in ticks.</td>
    </tr>
    <tr>
      <td>Time of day increasing</td>
      <td>`Boolean`</td>
      <td>If true, the client should automatically advance the time of day according to its ticking rate.</td>
    </tr>
  </tbody>
</table>

#### Set Title Text

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
      <td rowspan="1">*protocol:*<br/>`0x6B`<br/><br/>*resource:*<br/>`set_title_text`</td>
      <td rowspan="1">Play</td>
      <td rowspan="1">Client</td>
      <td>Title Text</td>
      <td>`Text Component`</td>
      <td></td>
    </tr>
  </tbody>
</table>

#### Set Title Animation Times

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
      <td rowspan="3">*protocol:*<br/>`0x6C`<br/><br/>*resource:*<br/>`set_titles_animation`</td>
      <td rowspan="3">Play</td>
      <td rowspan="3">Client</td>
      <td>Fade In</td>
      <td>`Int`</td>
      <td>Ticks to spend fading in.</td>
    </tr>
    <tr>
      <td>Stay</td>
      <td>`Int`</td>
      <td>Ticks to keep the title displayed.</td>
    </tr>
    <tr>
      <td>Fade Out</td>
      <td>`Int`</td>
      <td>Ticks to spend fading out, not when to start fading out.</td>
    </tr>
  </tbody>
</table>

#### Entity Sound Effect

Plays a sound effect from an entity, either by hardcoded ID or Identifier. Sound IDs and names can be found [here](https://pokechu22.github.io/Burger/1.21.html#sounds).

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
      <td rowspan="6">*protocol:*<br/>`0x6D`<br/><br/>*resource:*<br/>`sound_entity`</td>
      <td rowspan="6">Play</td>
      <td rowspan="6">Client</td>
      <td>Sound Event</td>
      <td>`ID or` `Sound Event`</td>
      <td>ID in the `minecraft:sound_event` registry, or an inline definition.</td>
    </tr>
    <tr>
      <td>Sound Category</td>
      <td>`VarInt` `Enum`</td>
      <td>The category that this sound will be played from ([current categories](https://gist.github.com/konwboj/7c0c380d3923443e9d55)).</td>
    </tr>
    <tr>
      <td>Entity ID</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
    <tr>
      <td>Volume</td>
      <td>`Float`</td>
      <td>1.0 is 100%, capped between 0.0 and 1.0 by vanilla clients.</td>
    </tr>
    <tr>
      <td>Pitch</td>
      <td>`Float`</td>
      <td>Float between 0.5 and 2.0 by vanilla clients.</td>
    </tr>
    <tr>
      <td>Seed</td>
      <td>`Long`</td>
      <td>Seed used to pick sound variant.</td>
    </tr>
  </tbody>
</table>

#### Sound Effect

Plays a sound effect at the given location, either by hardcoded ID or Identifier. Sound IDs and names can be found [here](https://pokechu22.github.io/Burger/1.21.html#sounds).

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
      <td rowspan="8">*protocol:*<br/>`0x6E`<br/><br/>*resource:*<br/>`sound`</td>
      <td rowspan="8">Play</td>
      <td rowspan="8">Client</td>
      <td>Sound Event</td>
      <td>`ID or` `Sound Event`</td>
      <td>ID in the `minecraft:sound_event` registry, or an inline definition.</td>
    </tr>
    <tr>
      <td>Sound Category</td>
      <td>`VarInt` `Enum`</td>
      <td>The category that this sound will be played from ([current categories](https://gist.github.com/konwboj/7c0c380d3923443e9d55)).</td>
    </tr>
    <tr>
      <td>Effect Position X</td>
      <td>`Int`</td>
      <td>Effect X multiplied by 8 ([fixed-point number](data-types.md#fixed-point-numbers) with only 3 bits dedicated to the fractional part).</td>
    </tr>
    <tr>
      <td>Effect Position Y</td>
      <td>`Int`</td>
      <td>Effect Y multiplied by 8 ([fixed-point number](data-types.md#fixed-point-numbers) with only 3 bits dedicated to the fractional part).</td>
    </tr>
    <tr>
      <td>Effect Position Z</td>
      <td>`Int`</td>
      <td>Effect Z multiplied by 8 ([fixed-point number](data-types.md#fixed-point-numbers) with only 3 bits dedicated to the fractional part).</td>
    </tr>
    <tr>
      <td>Volume</td>
      <td>`Float`</td>
      <td>1.0 is 100%, capped between 0.0 and 1.0 by vanilla clients.</td>
    </tr>
    <tr>
      <td>Pitch</td>
      <td>`Float`</td>
      <td>Float between 0.5 and 2.0 by vanilla clients.</td>
    </tr>
    <tr>
      <td>Seed</td>
      <td>`Long`</td>
      <td>Seed used to pick sound variant.</td>
    </tr>
  </tbody>
</table>

#### Start Configuration

Sent during gameplay in order to redo the configuration process. The client must respond with [[#Acknowledge Configuration|Acknowledge Configuration]] for the process to start.

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
      <td rowspan="1">*protocol:*<br/>`0x6F`<br/><br/>*resource:*<br/>`start_configuration`</td>
      <td rowspan="1">Play</td>
      <td rowspan="1">Client</td>
      <td colspan="3">*no fields*</td>
    </tr>
  </tbody>
</table>

This packet switches the connection state to [[#Configuration|configuration]].

#### Stop Sound

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
      <td rowspan="3">*protocol:*<br/>`0x70`<br/><br/>*resource:*<br/>`stop_sound`</td>
      <td rowspan="3">Play</td>
      <td rowspan="3">Client</td>
      <td>Flags</td>
      <td>`Byte`</td>
      <td>Controls which fields are present.</td>
    </tr>
    <tr>
      <td>Source</td>
      <td>`Optional` `VarInt` `Enum`</td>
      <td>Only if flags is 3 or 1 (bit mask 0x1). See below. If not present, then sounds from all sources are cleared.</td>
    </tr>
    <tr>
      <td>Sound</td>
      <td>`Optional` `Identifier`</td>
      <td>Only if flags is 2 or 3 (bit mask 0x2).  A sound effect name, see [[#Custom Sound Effect|Custom Sound Effect]]. If not present, then all sounds are cleared.</td>
    </tr>
  </tbody>
</table>

Categories:

<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Value</th>
    </tr>
    <tr>
      <td>master</td>
      <td>0</td>
    </tr>
    <tr>
      <td>music</td>
      <td>1</td>
    </tr>
    <tr>
      <td>record</td>
      <td>2</td>
    </tr>
    <tr>
      <td>weather</td>
      <td>3</td>
    </tr>
    <tr>
      <td>block</td>
      <td>4</td>
    </tr>
    <tr>
      <td>hostile</td>
      <td>5</td>
    </tr>
    <tr>
      <td>neutral</td>
      <td>6</td>
    </tr>
    <tr>
      <td>player</td>
      <td>7</td>
    </tr>
    <tr>
      <td>ambient</td>
      <td>8</td>
    </tr>
    <tr>
      <td>voice</td>
      <td>9</td>
    </tr>
  </tbody>
</table>

#### Store Cookie (play)

Stores some arbitrary data on the client, which persists between server transfers. The vanilla client only accepts cookies of up to 5 kiB in size.

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
      <td rowspan="2">*protocol:*<br/>`0x71`<br/><br/>*resource:*<br/>`store_cookie`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Client</td>
      <td>Key</td>
      <td>`Identifier`</td>
      <td>The identifier of the cookie.</td>
    </tr>
    <tr>
      <td>Payload</td>
      <td>`Prefixed Array` (5120) of `Byte`</td>
      <td>The data of the cookie.</td>
    </tr>
  </tbody>
</table>

#### System Chat Message

_Main article: [Minecraft_Wiki:Projects/wiki.vg_merge/Chat](./minecraft_wiki-projects-wiki.vg_merge-chat.md)_

Sends the client a raw system message.

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
      <td rowspan="2">*protocol:*<br/>`0x72`<br/><br/>*resource:*<br/>`system_chat`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Client</td>
      <td>Content</td>
      <td>`Text Component`</td>
      <td>Limited to 262144 bytes.</td>
    </tr>
    <tr>
      <td>Overlay</td>
      <td>`Boolean`</td>
      <td>Whether the message is an actionbar or chat message. See also [#Set Action Bar Text](set-action-bar-text.md).</td>
    </tr>
  </tbody>
</table>

#### Set Tab List Header And Footer

This packet may be used by custom servers to display additional information above/below the player list. It is never sent by the vanilla server.

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
      <td rowspan="2">*protocol:*<br/>`0x73`<br/><br/>*resource:*<br/>`tab_list`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Client</td>
      <td>Header</td>
      <td>`Text Component`</td>
      <td>To remove the header, send a empty text component: `{"text":""}`.</td>
    </tr>
    <tr>
      <td>Footer</td>
      <td>`Text Component`</td>
      <td>To remove the footer, send a empty text component: `{"text":""}`.</td>
    </tr>
  </tbody>
</table>

#### Tag Query Response

Sent in response to [[#Query Block Entity Tag|Query Block Entity Tag]] or [[#Query Entity Tag|Query Entity Tag]].

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
      <td rowspan="2">*protocol:*<br/>`0x74`<br/><br/>*resource:*<br/>`tag_query`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Client</td>
      <td>Transaction ID</td>
      <td>`VarInt`</td>
      <td>Can be compared to the one sent in the original query packet.</td>
    </tr>
    <tr>
      <td>NBT</td>
      <td>`NBT`</td>
      <td>The NBT of the block or entity.  May be a TAG_END (0) in which case no NBT is present.</td>
    </tr>
  </tbody>
</table>

#### Pickup Item

Sent by the server when someone picks up an item lying on the ground — its sole purpose appears to be the animation of the item flying towards you. It doesn't destroy the entity in the client memory, and it doesn't add it to your inventory. The server only checks for items to be picked up after each [[#Set Player Position|Set Player Position]] (and [[#Set Player Position And Rotation|Set Player Position And Rotation]]) packet sent by the client. The collector entity can be any entity; it does not have to be a player. The collected entity also can be any entity, but the vanilla server only uses this for items, experience orbs, and the different varieties of arrows.

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
      <td rowspan="3">*protocol:*<br/>`0x75`<br/><br/>*resource:*<br/>`take_item_entity`</td>
      <td rowspan="3">Play</td>
      <td rowspan="3">Client</td>
      <td>Collected Entity ID</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
    <tr>
      <td>Collector Entity ID</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
    <tr>
      <td>Pickup Item Count</td>
      <td>`VarInt`</td>
      <td>Seems to be 1 for XP orbs, otherwise the number of items in the stack.</td>
    </tr>
  </tbody>
</table>

#### Synchronize Vehicle Position

Teleports the entity on the client without changing the reference point of movement deltas in future [[#Update Entity Position|Update Entity Position]] packets. Seems to be used to make relative adjustments to vehicle positions; more information needed.

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
      <td rowspan="11">*protocol:*<br/>`0x76`<br/><br/>*resource:*<br/>`teleport_entity`</td>
      <td rowspan="11">Play</td>
      <td rowspan="11">Client</td>
      <td>Entity ID</td>
      <td>`VarInt`</td>
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
      <td>Velocity X</td>
      <td>`Double`</td>
      <td></td>
    </tr>
    <tr>
      <td>Velocity Y</td>
      <td>`Double`</td>
      <td></td>
    </tr>
    <tr>
      <td>Velocity Z</td>
      <td>`Double`</td>
      <td></td>
    </tr>
    <tr>
      <td>Yaw</td>
      <td>`Float`</td>
      <td>Rotation on the Y axis, in degrees.</td>
    </tr>
    <tr>
      <td>Pitch</td>
      <td>`Float`</td>
      <td>Rotation on the Y axis, in degrees.</td>
    </tr>
    <tr>
      <td>Flags</td>
      <td>`Teleport Flags`</td>
      <td></td>
    </tr>
    <tr>
      <td>On Ground</td>
      <td>`Boolean`</td>
      <td></td>
    </tr>
  </tbody>
</table>

#### Test Instance Block Status

Updates the status of the currently open [Test Instance Block](test-instance-block.md) screen, if any.

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
      <td rowspan="5">*protocol:*<br/>`0x77`<br/><br/>*resource:*<br/>`test_instance_block_status`</td>
      <td rowspan="5">Play</td>
      <td rowspan="5">Client</td>
      <td>Status</td>
      <td>`Text Component`</td>
      <td></td>
    </tr>
    <tr>
      <td>Has Size</td>
      <td>`Boolean`</td>
      <td></td>
    </tr>
    <tr>
      <td>Size X</td>
      <td>`Optional` `Double`</td>
      <td>Only present if Has Size is true.</td>
    </tr>
    <tr>
      <td>Size Y</td>
      <td>`Optional` `Double`</td>
      <td>Only present if Has Size is true.</td>
    </tr>
    <tr>
      <td>Size Z</td>
      <td>`Optional` `Double`</td>
      <td>Only present if Has Size is true.</td>
    </tr>
  </tbody>
</table>

#### Set Ticking State

Used to adjust the ticking rate of the client, and whether it's frozen.

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
      <td rowspan="2">*protocol:*<br/>`0x78`<br/><br/>*resource:*<br/>`ticking_state`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Client</td>
      <td>Tick rate</td>
      <td>`Float`</td>
      <td></td>
    </tr>
    <tr>
      <td>Is frozen</td>
      <td>`Boolean`</td>
      <td></td>
    </tr>
  </tbody>
</table>

#### Step Tick

Advances the client processing by the specified number of ticks. Has no effect unless client ticking is frozen.

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
      <td>*protocol:*<br/>`0x79`<br/><br/>*resource:*<br/>`ticking_step`</td>
      <td>Play</td>
      <td>Client</td>
      <td>Tick steps</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
  </tbody>
</table>

#### Transfer (play)

Notifies the client that it should transfer to the given server. Cookies previously stored are preserved between server transfers.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>State</th>
      <th>Bound To</th>
      <th colspan="2">Field Name</th>
      <th colspan="2">Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="2">*protocol:*<br/>`0x7A`<br/><br/>*resource:*<br/>`transfer`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Client</td>
      <td colspan="2">Host</td>
      <td colspan="2">`String`</td>
      <td>The hostname or IP of the server.</td>
    </tr>
    <tr>
      <td colspan="2">Port</td>
      <td colspan="2">`VarInt`</td>
      <td>The port of the server.</td>
    </tr>
  </tbody>
</table>

#### Update Advancements

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>State</th>
      <th>Bound To</th>
      <th colspan="2">Field Name</th>
      <th colspan="2">Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="7">*protocol:*<br/>`0x7B`<br/><br/>*resource:*<br/>`update_advancements`</td>
      <td rowspan="7">Play</td>
      <td rowspan="7">Client</td>
      <td colspan="2">Reset/Clear</td>
      <td colspan="2">`Boolean`</td>
      <td>Whether to reset/clear the current advancements.</td>
    </tr>
    <tr>
      <td rowspan="2">Advancement mapping</td>
      <td>Key</td>
      <td rowspan="2">`Prefixed Array`</td>
      <td>`Identifier`</td>
      <td>The identifier of the advancement.</td>
    </tr>
    <tr>
      <td>Value</td>
      <td>Advancement</td>
      <td>See below</td>
    </tr>
    <tr>
      <td colspan="2">Identifiers</td>
      <td colspan="2">`Prefixed Array` of `Identifier`</td>
      <td>The identifiers of the advancements that should be removed.</td>
    </tr>
    <tr>
      <td rowspan="2">Progress mapping</td>
      <td>Key</td>
      <td rowspan="2">`Prefixed Array`</td>
      <td>`Identifier`</td>
      <td>The identifier of the advancement.</td>
    </tr>
    <tr>
      <td>Value</td>
      <td>Advancement progress</td>
      <td>See below.</td>
    </tr>
    <tr>
      <td colspan="2">Show advancements</td>
      <td colspan="2">`Boolean`</td>
      <td></td>
    </tr>
  </tbody>
</table>

Advancement structure:

<table class="wikitable">
  <tbody>
    <tr>
      <th colspan="2">Field Name</th>
      <th colspan="2">Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td colspan="2">Parent id</td>
      <td colspan="2">`Prefixed Optional` `Identifier`</td>
      <td>The identifier of the parent advancement.</td>
    </tr>
    <tr>
      <td colspan="2">Display data</td>
      <td colspan="2">`Prefixed Optional` Advancement display</td>
      <td>See below.</td>
    </tr>
    <tr>
      <td colspan="2">Nested requirements</td>
      <td>`Prefixed Array`</td>
      <td>`Prefixed Array` of `String` (32767)</td>
      <td>Array with a sub-array of criteria. To check if the requirements are met, each sub-array must be tested and mapped with the OR operator, resulting in a boolean array.
These booleans must be mapped with the AND operator to get the result.</td>
    </tr>
    <tr>
      <td colspan="2">Sends telemetry data</td>
      <td colspan="2">`Boolean`</td>
      <td>Whether the client should include this achievement in the telemetry data when it's completed.
The vanilla client only sends data for advancements on the `minecraft` namespace.</td>
    </tr>
  </tbody>
</table>

Advancement display:

<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>Title</td>
      <td>`Text Component`</td>
      <td></td>
    </tr>
    <tr>
      <td>Description</td>
      <td>`Text Component`</td>
      <td></td>
    </tr>
    <tr>
      <td>Icon</td>
      <td>`Slot`</td>
      <td></td>
    </tr>
    <tr>
      <td>Frame type</td>
      <td>`VarInt` `Enum`</td>
      <td>0 = `task`, 1 = `challenge`, 2 = `goal`.</td>
    </tr>
    <tr>
      <td>Flags</td>
      <td>`Int`</td>
      <td>0x01: has background texture; 0x02: `show_toast`; 0x04: `hidden`.</td>
    </tr>
    <tr>
      <td>Background texture</td>
      <td>`Optional` `Identifier`</td>
      <td>Background texture location.  Only if flags indicates it.</td>
    </tr>
    <tr>
      <td>X coord</td>
      <td>`Float`</td>
      <td></td>
    </tr>
    <tr>
      <td>Y coord</td>
      <td>`Float`</td>
      <td></td>
    </tr>
  </tbody>
</table>

Advancement progress:

<table class="wikitable">
  <tbody>
    <tr>
      <th colspan="2">Field Name</th>
      <th colspan="2">Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="2">Criteria</td>
      <td>Criterion identifier</td>
      <td rowspan="2">`Prefixed Array`</td>
      <td>`Identifier`</td>
      <td>The identifier of the criterion.</td>
    </tr>
    <tr>
      <td>Date of achieving</td>
      <td>`Prefixed Optional` `Long`</td>
      <td>Present if achieved. As returned by [`Date.getTime`](https://docs.oracle.com/javase/6/docs/api/java/util/Date.html#getTime()).</td>
    </tr>
  </tbody>
</table>

#### Update Attributes

Sets [attributes](attribute.md) on the given entity.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>State</th>
      <th>Bound To</th>
      <th colspan="2">Field Name</th>
      <th colspan="2">Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="4">*protocol:*<br/>`0x7C`<br/><br/>*resource:*<br/>`update_attributes`</td>
      <td rowspan="4">Play</td>
      <td rowspan="4">Client</td>
      <td colspan="2">Entity ID</td>
      <td colspan="2">`VarInt`</td>
      <td></td>
    </tr>
    <tr>
      <td rowspan="3">Property</td>
      <td>Id</td>
      <td rowspan="3">`Prefixed Array`</td>
      <td>`VarInt`</td>
      <td>ID in the `minecraft:attribute` registry. See also [Attribute#Attributes](attribute.md#attributes).</td>
    </tr>
    <tr>
      <td>Value</td>
      <td>`Double`</td>
      <td>See below.</td>
    </tr>
    <tr>
      <td>Modifiers</td>
      <td>`Prefixed Array` of Modifier Data</td>
      <td>See [Attribute#Modifiers](attribute.md#modifiers). Modifier Data defined below.</td>
    </tr>
  </tbody>
</table>

*Modifier Data* structure:

<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>Id</td>
      <td>`Identifier`</td>
      <td></td>
    </tr>
    <tr>
      <td>Amount</td>
      <td>`Double`</td>
      <td>May be positive or negative.</td>
    </tr>
    <tr>
      <td>Operation</td>
      <td>`Byte`</td>
      <td>See below.</td>
    </tr>
  </tbody>
</table>

The operation controls how the base value of the modifier is changed.

- 0: Add/subtract amount
- 1: Add/subtract amount percent of the current value
- 2: Multiply by amount percent

All of the 0's are applied first, and then the 1's, and then the 2's.

#### Entity Effect

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
      <td rowspan="5">*protocol:*<br/>`0x7D`<br/><br/>*resource:*<br/>`update_mob_effect`</td>
      <td rowspan="5">Play</td>
      <td rowspan="5">Client</td>
      <td>Entity ID</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
    <tr>
      <td>Effect ID</td>
      <td>`VarInt`</td>
      <td>See [this table](status-effect.md#effect-list).</td>
    </tr>
    <tr>
      <td>Amplifier</td>
      <td>`VarInt`</td>
      <td>Vanilla client displays effect level as Amplifier + 1.</td>
    </tr>
    <tr>
      <td>Duration</td>
      <td>`VarInt`</td>
      <td>Duration in ticks. (-1 for infinite)</td>
    </tr>
    <tr>
      <td>Flags</td>
      <td>`Byte`</td>
      <td>Bit field, see below.</td>
    </tr>
  </tbody>
</table>

> ❓ **Missing info (section):** What exact effect does the blend bit flag have on the client? What happens if it is used on effects besides DARKNESS?

Within flags:

- 0x01: Is ambient - was the effect spawned from a beacon?  All beacon-generated effects are ambient.  Ambient effects use a different icon in the HUD (blue border rather than gray).  If all effects on an entity are ambient, the ["Is potion effect ambient" living metadata field](entity_metadata.md#living-entity) should be set to true.  Usually should not be enabled.
- 0x02: Show particles - should all particles from this effect be hidden?  Effects with particles hidden are not included in the calculation of the effect color, and are not rendered on the HUD (but are still rendered within the inventory).  Usually should be enabled.
- 0x04: Show icon - should the icon be displayed on the client?  Usually should be enabled.
- 0x08: Blend - should the effect's hard-coded blending be applied?  Currently only used in the DARKNESS effect to apply extra void fog and adjust the gamma value for lighting.

#### Update Recipes

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>State</th>
      <th>Bound To</th>
      <th colspan="2">Field Name</th>
      <th colspan="2">Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="4">*protocol:*<br/>`0x7E`<br/><br/>*resource:*<br/>`update_recipes`</td>
      <td rowspan="4">Play</td>
      <td rowspan="4">Client</td>
      <td rowspan="2">Property Sets</td>
      <td>Property Set ID</td>
      <td rowspan="2">`Prefixed Array`</td>
      <td>`Identifier`</td>
      <td></td>
    </tr>
    <tr>
      <td>Items</td>
      <td>`Prefixed Array` of `VarInt`</td>
      <td>IDs in the `minecraft:item` registry.</td>
    </tr>
    <tr>
      <td rowspan="2">Stonecutter Recipes</td>
      <td>Ingredients</td>
      <td rowspan="2">`Prefixed Array`</td>
      <td>`ID Set`</td>
      <td></td>
    </tr>
    <tr>
      <td>Slot Display</td>
      <td>`Slot Display`</td>
      <td></td>
    </tr>
  </tbody>
</table>

#### Update Tags (play)

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>State</th>
      <th>Bound To</th>
      <th colspan="2">Field Name</th>
      <th colspan="2">Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="2">*protocol:*<br/>`0x7F`<br/><br/>*resource:*<br/>`update_tags`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Client</td>
      <td rowspan="2">Registry to tags map</td>
      <td>Registry</td>
      <td rowspan="2">`Prefixed Array`</td>
      <td>`Identifier`</td>
      <td>Registry identifier (Vanilla expects tags for the registries `minecraft:block`, `minecraft:item`, `minecraft:fluid`, `minecraft:entity_type`, and `minecraft:game_event`)</td>
    </tr>
    <tr>
      <td>Tags</td>
      <td>`Prefixed Array` of Tag (See below)</td>
      <td></td>
    </tr>
  </tbody>
</table>

A tag looks like this:

<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>Tag name</td>
      <td>`Identifier`</td>
      <td></td>
    </tr>
    <tr>
      <td>Entries</td>
      <td>`Prefixed Array` of `VarInt`</td>
      <td>Numeric IDs of the given type (block, item, etc.). This list replaces the previous list of IDs for the given tag. If some preexisting tags are left unmentioned, a warning is printed.</td>
    </tr>
  </tbody>
</table>

See [Tag](tag.md) on the Minecraft Wiki for more information, including a list of vanilla tags.

#### Projectile Power

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
      <td rowspan="2">*protocol:*<br/>`0x80`<br/><br/>*resource:*<br/>`projectile_power`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Client</td>
      <td>Entity ID</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
    <tr>
      <td>Power</td>
      <td>`Double`</td>
      <td></td>
    </tr>
  </tbody>
</table>

#### Custom Report Details

Contains a list of key-value text entries that are included in any crash or disconnection report generated during connection to the server.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>State</th>
      <th>Bound To</th>
      <th colspan="2">Field Name</th>
      <th colspan="2">Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="2">*protocol:*<br/>`0x81`<br/><br/>*resource:*<br/>`custom_report_details`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Client</td>
      <td rowspan="2">Details</td>
      <td>Title</td>
      <td rowspan="2">`Prefixed Array` (32)</td>
      <td>`String` (128)</td>
      <td></td>
    </tr>
    <tr>
      <td>Description</td>
      <td>`String` (4096)</td>
      <td></td>
    </tr>
  </tbody>
</table>

#### Server Links

This packet contains a list of links that the vanilla client will display in the menu available from the pause menu. Link labels can be built-in or custom (i.e., any text).

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>State</th>
      <th>Bound To</th>
      <th colspan="2">Field Name</th>
      <th colspan="2">Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="3">*protocol:*<br/>`0x82`<br/><br/>*resource:*<br/>`server_links`</td>
      <td rowspan="3">Play</td>
      <td rowspan="3">Client</td>
      <td rowspan="3">Links</td>
      <td>Is built-in</td>
      <td rowspan="3">`Prefixed Array`</td>
      <td>`Boolean`</td>
      <td>Determines if the following label is built-in (from enum) or custom (text component).</td>
    </tr>
    <tr>
      <td>Label</td>
      <td>`VarInt` `Enum` / `Text Component`</td>
      <td>See below.</td>
    </tr>
    <tr>
      <td>URL</td>
      <td>`String`</td>
      <td>Valid URL.</td>
    </tr>
  </tbody>
</table>

<table class="wikitable">
  <tbody>
    <tr>
      <th>ID</th>
      <th>Name</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>0</td>
      <td>Bug Report</td>
      <td>Displayed on connection error screen; included as a comment in the disconnection report.</td>
    </tr>
    <tr>
      <td>1</td>
      <td>Community Guidelines</td>
      <td></td>
    </tr>
    <tr>
      <td>2</td>
      <td>Support</td>
      <td></td>
    </tr>
    <tr>
      <td>3</td>
      <td>Status</td>
      <td></td>
    </tr>
    <tr>
      <td>4</td>
      <td>Feedback</td>
      <td></td>
    </tr>
    <tr>
      <td>5</td>
      <td>Community</td>
      <td></td>
    </tr>
    <tr>
      <td>6</td>
      <td>Website</td>
      <td></td>
    </tr>
    <tr>
      <td>7</td>
      <td>Forums</td>
      <td></td>
    </tr>
    <tr>
      <td>8</td>
      <td>News</td>
      <td></td>
    </tr>
    <tr>
      <td>9</td>
      <td>Announcements</td>
      <td></td>
    </tr>
  </tbody>
</table>

### Serverbound

#### Confirm Teleportation

Sent by client as confirmation of [[#Synchronize Player Position|Synchronize Player Position]].

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
      <td>*protocol:*<br/>`0x00`<br/><br/>*resource:*<br/>`accept_teleportation`</td>
      <td>Play</td>
      <td>Server</td>
      <td>Teleport ID</td>
      <td>`VarInt`</td>
      <td>The ID given by the [[#Synchronize Player Position|Synchronize Player Position]] packet.</td>
    </tr>
  </tbody>
</table>

#### Query Block Entity Tag

Used when <kbd>F3</kbd>+<kbd>I</kbd> is pressed while looking at a block.

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
      <td rowspan="2">*protocol:*<br/>`0x01`<br/><br/>*resource:*<br/>`block_entity_tag_query`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Server</td>
      <td>Transaction ID</td>
      <td>`VarInt`</td>
      <td>An incremental ID so that the client can verify that the response matches.</td>
    </tr>
    <tr>
      <td>Location</td>
      <td>`Position`</td>
      <td>The location of the block to check.</td>
    </tr>
  </tbody>
</table>

#### Bundle Item Selected

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
      <td rowspan="2">*protocol:*<br/>`0x02`<br/><br/>*resource:*<br/>`bundle_item_selected`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Server</td>
      <td>Slot of Bundle</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
    <tr>
      <td>Slot in Bundle</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
  </tbody>
</table>

#### Change Difficulty

Must have at least op level 2 to use.  Appears to only be used on singleplayer; the difficulty buttons are still disabled in multiplayer.

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
      <td rowspan="1">*protocol:*<br/>`0x03`<br/><br/>*resource:*<br/>`change_difficulty`</td>
      <td rowspan="1">Play</td>
      <td rowspan="1">Server</td>
      <td>New difficulty</td>
      <td>`Unsigned Byte` `Enum`</td>
      <td>0: peaceful, 1: easy, 2: normal, 3: hard.</td>
    </tr>
  </tbody>
</table>

#### Acknowledge Message

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
      <td rowspan="1">*protocol:*<br/>`0x04`<br/><br/>*resource:*<br/>`chat_ack`</td>
      <td rowspan="1">Play</td>
      <td rowspan="1">Server</td>
      <td>Message Count</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
  </tbody>
</table>

#### Chat Command

_Main article: [Minecraft_Wiki:Projects/wiki.vg_merge/Chat](./minecraft_wiki-projects-wiki.vg_merge-chat.md)_

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>State</th>
      <th>Bound To</th>
      <th colspan="2">Field Name</th>
      <th colspan="2">Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="1">*protocol:*<br/>`0x05`<br/><br/>*resource:*<br/>`chat_command`</td>
      <td rowspan="1">Play</td>
      <td rowspan="1">Server</td>
      <td colspan="2">Command</td>
      <td colspan="2">`String` (32767)</td>
      <td colspan="2">The command typed by the client.</td>
    </tr>
  </tbody>
</table>

#### Signed Chat Command

_Main article: [Minecraft_Wiki:Projects/wiki.vg_merge/Chat](./minecraft_wiki-projects-wiki.vg_merge-chat.md)_

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>State</th>
      <th>Bound To</th>
      <th colspan="2">Field Name</th>
      <th colspan="2">Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="8">*protocol:*<br/>`0x06`<br/><br/>*resource:*<br/>`chat_command_signed`</td>
      <td rowspan="8">Play</td>
      <td rowspan="8">Server</td>
      <td colspan="2">Command</td>
      <td colspan="2">`String` (32767)</td>
      <td colspan="2">The command typed by the client.</td>
    </tr>
    <tr>
      <td colspan="2">Timestamp</td>
      <td colspan="2">`Long`</td>
      <td colspan="2">The timestamp that the command was executed.</td>
    </tr>
    <tr>
      <td colspan="2">Salt</td>
      <td colspan="2">`Long`</td>
      <td colspan="2">The salt for the following argument signatures.</td>
    </tr>
    <tr>
      <td rowspan="2">Array of argument signatures</td>
      <td>Argument name</td>
      <td rowspan="2">`Prefixed Array` (8)</td>
      <td>`String` (16)</td>
      <td>The name of the argument that is signed by the following signature.</td>
    </tr>
    <tr>
      <td>Signature</td>
      <td>`Byte Array` (256)</td>
      <td>The signature that verifies the argument. Always 256 bytes and is not length-prefixed.</td>
    </tr>
    <tr>
      <td colspan="2">Message Count</td>
      <td colspan="2">`VarInt`</td>
      <td colspan="2"></td>
    </tr>
    <tr>
      <td colspan="2">Acknowledged</td>
      <td colspan="2">`Fixed BitSet` (20)</td>
      <td colspan="2"></td>
    </tr>
    <tr>
      <td colspan="2">Checksum</td>
      <td colspan="2">`Byte`</td>
      <td colspan="2"></td>
    </tr>
  </tbody>
</table>

#### Chat Message

_Main article: [Minecraft_Wiki:Projects/wiki.vg_merge/Chat](./minecraft_wiki-projects-wiki.vg_merge-chat.md)_

Used to send a chat message to the server.  The message may not be longer than 256 characters or else the server will kick the client.

The server will broadcast a [[#Player Chat Message|Player Chat Message]] packet with Chat Type `minecraft:chat` to all players that haven't disabled chat (including the player that sent the message). See [Chat#Processing chat](chat.md#processing-chat) for more information.

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
      <td rowspan="7">*protocol:*<br/>`0x07`<br/><br/>*resource:*<br/>`chat`</td>
      <td rowspan="7">Play</td>
      <td rowspan="7">Server</td>
      <td>Message</td>
      <td>`String` (256)</td>
      <td>Content of the message</td>
    </tr>
    <tr>
      <td>Timestamp</td>
      <td>`Long`</td>
      <td>Number of milliseconds since the epoch (1 Jan 1970, midnight, UTC)</td>
    </tr>
    <tr>
      <td>Salt</td>
      <td>`Long`</td>
      <td>The salt used to verify the signature hash. Randomly generated by the client</td>
    </tr>
    <tr>
      <td>Signature</td>
      <td>`Prefixed Optional` `Byte Array` (256)
 </td>
      <td>The signature used to verify the chat message's authentication. When present, always 256 bytes and not length-prefixed.
This is a SHA256 with RSA digital signature computed over the following:

* The number 1 as a 4-byte int. Always 00 00 00 01.
* The player's 16 byte UUID.
* The chat session (a 16 byte UUID generated randomly generated by the client).
* The index of the message within this chat session as a 4-byte int. First message is 0, next message is 1, etc. Incremented each time the client sends a chat message.
* The salt (from above) as a 8-byte long.
* The timestamp (from above) converted from millisecods to seconds, so divide by 1000, as a 8-byte long.
* The length of the message in bytes (from above) as a 4-byte int.
* The message bytes.
* The number of messages in the last seen set, as a 4-byte int. Always in the range [0,20].
* For each message in the last seen set, from oldest to newest, the 256 byte signature of that message.


The client's chat private key is used for the message signature.</td>
    </tr>
    <tr>
      <td>Message Count</td>
      <td>`VarInt`</td>
      <td>Number of signed clientbound chat messages the client has seen from the server since the last serverbound chat message from this client. The server will use this to update its last seen list for the client.</td>
    </tr>
    <tr>
      <td>Acknowledged</td>
      <td>`Fixed BitSet` (20)</td>
      <td>
Bitmask of which message signatures from the last seen set were used to sign this message. The most recent is the highest bit. If there are less than 20 messages in the last seen set, the lower bits will be zeros.</td>
    </tr>
    <tr>
      <td>Checksum</td>
      <td>`Byte`</td>
      <td></td>
    </tr>
  </tbody>
</table>

#### Player Session

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>State</th>
      <th>Bound To</th>
      <th colspan="2">Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="4">*protocol:*<br/>`0x08`<br/><br/>*resource:*<br/>`chat_session_update`</td>
      <td rowspan="4">Play</td>
      <td rowspan="4">Server</td>
      <td colspan="2">Session Id</td>
      <td>`UUID`</td>
      <td></td>
    </tr>
    <tr>
      <td rowspan="3">Public Key</td>
      <td>Expires At</td>
      <td>`Long`</td>
      <td>The time the play session key expires in [epoch](https://en.wikipedia.org/wiki/Unix_time) milliseconds.</td>
    </tr>
    <tr>
      <td>Public Key</td>
      <td>`Prefixed Array` (512) of `Byte`</td>
      <td>A byte array of an X.509-encoded public key.</td>
    </tr>
    <tr>
      <td>Key Signature</td>
      <td>`Prefixed Array` (4096) of `Byte`</td>
      <td>The signature consists of the player UUID, the key expiration timestamp, and the public key data. These values are hashed using [SHA-1](https://en.wikipedia.org/wiki/SHA-1) and signed using Mojang's private [RSA](https://en.wikipedia.org/wiki/RSA_(cryptosystem)) key.</td>
    </tr>
  </tbody>
</table>

#### Chunk Batch Received

Notifies the server that the chunk batch has been received by the client. The server uses the value sent in this packet to adjust the number of chunks to be sent in a batch.

The vanilla server will stop sending further chunk data until the client acknowledges the sent chunk batch. After the first acknowledgement, the server adjusts this number to allow up to 10 unacknowledged batches.

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
      <td rowspan="1">*protocol:*<br/>`0x09`<br/><br/>*resource:*<br/>`chunk_batch_received`</td>
      <td rowspan="1">Play</td>
      <td rowspan="1">Server</td>
      <td>Chunks per tick</td>
      <td>`Float`</td>
      <td>Desired chunks per tick.</td>
    </tr>
  </tbody>
</table>

#### Client Status

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
      <td rowspan="1">*protocol:*<br/>`0x0A`<br/><br/>*resource:*<br/>`client_command`</td>
      <td rowspan="1">Play</td>
      <td rowspan="1">Server</td>
      <td>Action ID</td>
      <td>`VarInt` `Enum`</td>
      <td>See below</td>
    </tr>
  </tbody>
</table>

*Action ID* values:

<table class="wikitable">
  <tbody>
    <tr>
      <th>Action ID</th>
      <th>Action</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>0</td>
      <td>Perform respawn</td>
      <td>Sent when the client is ready to respawn after death.</td>
    </tr>
    <tr>
      <td>1</td>
      <td>Request stats</td>
      <td>Sent when the client opens the Statistics menu.</td>
    </tr>
  </tbody>
</table>

#### Client Tick End

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
      <td>*protocol:*<br/>`0x0B`<br/><br/>*resource:*<br/>`client_tick_end`</td>
      <td>Play</td>
      <td>Server</td>
      <td colspan="3">*no fields*</td>
    </tr>
  </tbody>
</table>

#### Client Information (play)

Sent when the player connects, or when settings are changed.

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
      <td rowspan="9">*protocol:*<br/>`0x0C`<br/><br/>*resource:*<br/>`client_information`</td>
      <td rowspan="9">Play</td>
      <td rowspan="9">Server</td>
      <td>Locale</td>
      <td>`String` (16)</td>
      <td>e.g. `en_GB`.</td>
    </tr>
    <tr>
      <td>View Distance</td>
      <td>`Byte`</td>
      <td>Client-side render distance, in chunks.</td>
    </tr>
    <tr>
      <td>Chat Mode</td>
      <td>`VarInt` `Enum`</td>
      <td>0: enabled, 1: commands only, 2: hidden.  See [Chat#Client chat mode](chat.md#client-chat-mode) for more information.</td>
    </tr>
    <tr>
      <td>Chat Colors</td>
      <td>`Boolean`</td>
      <td>“Colors” multiplayer setting. The vanilla server stores this value but does nothing with it (see [MC-64867](https://bugs.mojang.com/browse/MC-64867)). Third-party servers such as Hypixel disable all coloring in chat and system messages when it is false.</td>
    </tr>
    <tr>
      <td>Displayed Skin Parts</td>
      <td>`Unsigned Byte`</td>
      <td>Bit mask, see below.</td>
    </tr>
    <tr>
      <td>Main Hand</td>
      <td>`VarInt` `Enum`</td>
      <td>0: Left, 1: Right.</td>
    </tr>
    <tr>
      <td>Enable text filtering</td>
      <td>`Boolean`</td>
      <td>Enables filtering of text on signs and written book titles. The vanilla client sets this according to the `profanityFilterPreferences.profanityFilterOn` account attribute indicated by the [`/player/attributes` Mojang API endpoint](mojang-api.md#player-attributes). In offline mode it is always false.</td>
    </tr>
    <tr>
      <td>Allow server listings</td>
      <td>`Boolean`</td>
      <td>Servers usually list online players, this option should let you not show up in that list.</td>
    </tr>
    <tr>
      <td>Particle Status</td>
      <td>`VarInt` `Enum`</td>
      <td>0: all, 1: decreased, 2: minimal</td>
    </tr>
  </tbody>
</table>

*Displayed Skin Parts* flags:

- Bit 0 (0x01): Cape enabled
- Bit 1 (0x02): Jacket enabled
- Bit 2 (0x04): Left Sleeve enabled
- Bit 3 (0x08): Right Sleeve enabled
- Bit 4 (0x10): Left Pants Leg enabled
- Bit 5 (0x20): Right Pants Leg enabled
- Bit 6 (0x40): Hat enabled

The most significant bit (bit 7, 0x80) appears to be unused.

#### Command Suggestions Request

Sent when the client needs to tab-complete a `minecraft:ask_server` suggestion type.

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
      <td rowspan="2">*protocol:*<br/>`0x0D`<br/><br/>*resource:*<br/>`command_suggestion`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Server</td>
      <td>Transaction Id</td>
      <td>`VarInt`</td>
      <td>The id of the transaction that the server will send back to the client in the response of this packet. Client generates this and increments it each time it sends another tab completion that doesn't get a response.</td>
    </tr>
    <tr>
      <td>Text</td>
      <td>`String` (32500)</td>
      <td>All text behind the cursor without the `/` (e.g. to the left of the cursor in left-to-right languages like English).</td>
    </tr>
  </tbody>
</table>

#### Acknowledge Configuration

Sent by the client upon receiving a [[#Start Configuration|Start Configuration]] packet from the server.

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
      <td rowspan="1">*protocol:*<br/>`0x0E`<br/><br/>*resource:*<br/>`configuration_acknowledged`</td>
      <td rowspan="1">Play</td>
      <td rowspan="1">Server</td>
      <td colspan="3">*no fields*</td>
    </tr>
  </tbody>
</table>

This packet switches the connection state to [[#Configuration|configuration]].

#### Click Container Button

Used when clicking on window buttons. Until 1.14, this was only used by enchantment tables.

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
      <td rowspan="2">*protocol:*<br/>`0x0F`<br/><br/>*resource:*<br/>`container_button_click`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Server</td>
      <td>Window ID</td>
      <td>`VarInt`</td>
      <td>The ID of the window sent by [[#Open Screen|Open Screen]].</td>
    </tr>
    <tr>
      <td>Button ID</td>
      <td>`VarInt`</td>
      <td>Meaning depends on window type; see below.</td>
    </tr>
  </tbody>
</table>

<table class="wikitable">
  <tbody>
    <tr>
      <th>Window type</th>
      <th>ID</th>
      <th>Meaning</th>
    </tr>
    <tr>
      <td rowspan="3">Enchantment Table</td>
      <td>0</td>
      <td>Topmost enchantment.</td>
    </tr>
    <tr>
      <td>1</td>
      <td>Middle enchantment.</td>
    </tr>
    <tr>
      <td>2</td>
      <td>Bottom enchantment.</td>
    </tr>
    <tr>
      <td rowspan="4">Lectern</td>
      <td>1</td>
      <td>Previous page (which does give a redstone output).</td>
    </tr>
    <tr>
      <td>2</td>
      <td>Next page.</td>
    </tr>
    <tr>
      <td>3</td>
      <td>Take Book.</td>
    </tr>
    <tr>
      <td>100+page</td>
      <td>Opened page number - 100 + number.</td>
    </tr>
    <tr>
      <td>Stonecutter</td>
      <td colspan="2">Recipe button number - 4*row + col.  Depends on the item.</td>
    </tr>
    <tr>
      <td>Loom</td>
      <td colspan="2">Recipe button number - 4*row + col.  Depends on the item.</td>
    </tr>
  </tbody>
</table>

#### Click Container

This packet is sent by the client when the player clicks on a slot in a window.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>State</th>
      <th>Bound To</th>
      <th colspan="2">Field Name</th>
      <th colspan="2">Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="8">*protocol:*<br/>`0x10`<br/><br/>*resource:*<br/>`container_click`</td>
      <td rowspan="8">Play</td>
      <td rowspan="8">Server</td>
      <td colspan="2">Window ID</td>
      <td colspan="2">`VarInt`</td>
      <td>The ID of the window which was clicked. 0 for player inventory. The server ignores any packets targeting a Window ID other than the current one, including ignoring 0 when any other window is open.</td>
    </tr>
    <tr>
      <td colspan="2">State ID</td>
      <td colspan="2">`VarInt`</td>
      <td>The last received State ID from either a [[#Set Container Slot|Set Container Slot]] or a [[#Set Container Content|Set Container Content]] packet.</td>
    </tr>
    <tr>
      <td colspan="2">Slot</td>
      <td colspan="2">`Short`</td>
      <td>The clicked slot number, see below.</td>
    </tr>
    <tr>
      <td colspan="2">Button</td>
      <td colspan="2">`Byte`</td>
      <td>The button used in the click, see below.</td>
    </tr>
    <tr>
      <td colspan="2">Mode</td>
      <td colspan="2">`VarInt` `Enum`</td>
      <td>Inventory operation mode, see below.</td>
    </tr>
    <tr>
      <td rowspan="2">Array of changed slots</td>
      <td>Slot number</td>
      <td rowspan="2">`Prefixed Array` (128)</td>
      <td>`Short`</td>
      <td></td>
    </tr>
    <tr>
      <td>Slot data</td>
      <td>`Hashed Slot`</td>
      <td>New data for this slot, in the client's opinion; see below.</td>
    </tr>
    <tr>
      <td colspan="2">Carried item</td>
      <td colspan="2">`Hashed Slot`</td>
      <td>Item carried by the cursor. Has to be empty (item ID = -1) for drop mode, otherwise nothing will happen.</td>
    </tr>
  </tbody>
</table>

See [Inventory](inventory.md) for further information about how slots are indexed.

After performing the action, the server compares the results to the slot change information included in the packet, as applied on top of the server's view of the container's state prior to the action. For any slots that do not match, it sends [[#Set Container Slot|Set Container Slot]] packets containing the correct results. If State ID does not match the last ID sent by the server, it will instead send a full [[#Set Container Content|Set Container Content]] to resynchronize the client.

When right-clicking on a stack of items, half the stack will be picked up and half left in the slot. If the stack is an odd number, the half left in the slot will be smaller of the amounts.

The distinct type of click performed by the client is determined by the combination of the Mode and Button fields.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Mode</th>
      <th>Button</th>
      <th>Slot</th>
      <th>Trigger</th>
    </tr>
    <tr>
      <th rowspan="4">0</th>
      <td>0</td>
      <td>Normal</td>
      <td>Left mouse click</td>
    </tr>
    <tr>
      <td>1</td>
      <td>Normal</td>
      <td>Right mouse click</td>
    </tr>
    <tr>
      <td>0</td>
      <td>-999</td>
      <td>Left click outside inventory (drop cursor stack)</td>
    </tr>
    <tr>
      <td>1</td>
      <td>-999</td>
      <td>Right click outside inventory (drop cursor single item)</td>
    </tr>
    <tr>
      <th rowspan="2">1</th>
      <td>0</td>
      <td>Normal</td>
      <td>Shift + left mouse click</td>
    </tr>
    <tr>
      <td>1</td>
      <td>Normal</td>
      <td>Shift + right mouse click *(identical behavior)*</td>
    </tr>
    <tr>
      <th rowspan="7">2</th>
      <td>0</td>
      <td>Normal</td>
      <td>Number key 1</td>
    </tr>
    <tr>
      <td>1</td>
      <td>Normal</td>
      <td>Number key 2</td>
    </tr>
    <tr>
      <td>2</td>
      <td>Normal</td>
      <td>Number key 3</td>
    </tr>
    <tr>
      <td>⋮</td>
      <td>⋮</td>
      <td>⋮</td>
    </tr>
    <tr>
      <td>8</td>
      <td>Normal</td>
      <td>Number key 9</td>
    </tr>
    <tr>
      <td>⋮</td>
      <td>⋮</td>
      <td>Button is used as the slot index (impossible in vanilla clients)</td>
    </tr>
    <tr>
      <td>40</td>
      <td>Normal</td>
      <td>Offhand swap key F</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2</td>
      <td>Normal</td>
      <td>Middle click, only defined for creative players in non-player inventories.</td>
    </tr>
    <tr>
      <th rowspan="2">4</th>
      <td>0</td>
      <td>Normal</td>
      <td>Drop key (Q)</td>
    </tr>
    <tr>
      <td>1</td>
      <td>Normal</td>
      <td>Control + Drop key (Q)</td>
    </tr>
    <tr>
      <th rowspan="9">5</th>
      <td>0</td>
      <td>-999</td>
      <td>Starting left mouse drag</td>
    </tr>
    <tr>
      <td>4</td>
      <td>-999</td>
      <td>Starting right mouse drag</td>
    </tr>
    <tr>
      <td>8</td>
      <td>-999</td>
      <td>Starting middle mouse drag, only defined for creative players in non-player inventories.</td>
    </tr>
    <tr>
      <td>1</td>
      <td>Normal</td>
      <td>Add slot for left-mouse drag</td>
    </tr>
    <tr>
      <td>5</td>
      <td>Normal</td>
      <td>Add slot for right-mouse drag</td>
    </tr>
    <tr>
      <td>9</td>
      <td>Normal</td>
      <td>Add slot for middle-mouse drag, only defined for creative players in non-player inventories.</td>
    </tr>
    <tr>
      <td>2</td>
      <td>-999</td>
      <td>Ending left mouse drag</td>
    </tr>
    <tr>
      <td>6</td>
      <td>-999</td>
      <td>Ending right mouse drag</td>
    </tr>
    <tr>
      <td>10</td>
      <td>-999</td>
      <td>Ending middle mouse drag, only defined for creative players in non-player inventories.</td>
    </tr>
    <tr>
      <th rowspan="2">6</th>
      <td>0</td>
      <td>Normal</td>
      <td>Double click</td>
    </tr>
    <tr>
      <td>1</td>
      <td>Normal</td>
      <td>Pickup all but check items in reverse order (impossible in vanilla clients)</td>
    </tr>
  </tbody>
</table>

Starting from version 1.5, “painting mode” is available for use in inventory windows. It is done by picking up stack of something (more than 1 item), then holding mouse button (left, right or middle) and dragging held stack over empty (or same type in case of right button) slots. In that case client sends the following to server after mouse button release (omitting first pickup packet which is sent as usual):

1. packet with mode 5, slot -999, button (0 for left | 4 for right);
1. packet for every slot painted on, mode is still 5, button (1 | 5);
1. packet with mode 5, slot -999, button (2 | 6);

If any of the painting packets other than the “progress” ones are sent out of order (for example, a start, some slots, then another start; or a left-click in the middle) the painting status will be reset.

#### Close Container

This packet is sent by the client when closing a window.

vanilla clients send a Close Window packet with Window ID 0 to close their inventory even though there is never an [[#Open Screen|Open Screen]] packet for the inventory.

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
      <td rowspan="1">*protocol:*<br/>`0x11`<br/><br/>*resource:*<br/>`container_close`</td>
      <td rowspan="1">Play</td>
      <td rowspan="1">Server</td>
      <td>Window ID</td>
      <td>`VarInt`</td>
      <td>This is the ID of the window that was closed. 0 for player inventory.</td>
    </tr>
  </tbody>
</table>

#### Change Container Slot State

This packet is sent by the client when toggling the state of a Crafter.

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
      <td rowspan="3">*protocol:*<br/>`0x12`<br/><br/>*resource:*<br/>`container_slot_state_changed`</td>
      <td rowspan="3">Play</td>
      <td rowspan="3">Server</td>
      <td>Slot ID</td>
      <td>`VarInt`</td>
      <td>This is the ID of the slot that was changed.</td>
    </tr>
    <tr>
      <td>Window ID</td>
      <td>`VarInt`</td>
      <td>This is the ID of the window that was changed.</td>
    </tr>
    <tr>
      <td>State</td>
      <td>`Boolean`</td>
      <td>The new state of the slot. True for enabled, false for disabled.</td>
    </tr>
  </tbody>
</table>

#### Cookie Response (play)

Response to a [[#Cookie_Request_(play)|Cookie Request (play)]] from the server. The vanilla server only accepts responses of up to 5 kiB in size.

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
      <td rowspan="2">*protocol:*<br/>`0x13`<br/><br/>*resource:*<br/>`cookie_response`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Server</td>
      <td>Key</td>
      <td>`Identifier`</td>
      <td>The identifier of the cookie.</td>
    </tr>
    <tr>
      <td>Payload</td>
      <td>`Prefixed Optional` `Prefixed Array` (5120) of `Byte`</td>
      <td>The data of the cookie.</td>
    </tr>
  </tbody>
</table>

#### Serverbound Plugin Message (play)

_Main article: [Minecraft Wiki:Projects/wiki.vg merge/Plugin channels](./plugin-channels.md)_

Mods and plugins can use this to send their data. Minecraft itself uses some [plugin channels](plugin-channels.md). These internal channels are in the `minecraft` namespace.

More documentation on this: <https://dinnerbone.com/blog/2012/01/13/minecraft-plugin-channels-messaging/>(https://dinnerbone.com/blog/2012/01/13/minecraft-plugin-channels-messaging/)

Note that the length of Data is known only from the packet length, since the packet has no length field of any kind.

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
      <td rowspan="2">*protocol:*<br/>`0x14`<br/><br/>*resource:*<br/>`custom_payload`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Server</td>
      <td>Channel</td>
      <td>`Identifier`</td>
      <td>Name of the [plugin channel](plugin-channels.md) used to send the data.</td>
    </tr>
    <tr>
      <td>Data</td>
      <td>`Byte Array` (32767)</td>
      <td>Any data, depending on the channel. `minecraft:` channels are documented [here](plugin-channels.md). The length of this array must be inferred from the packet length.</td>
    </tr>
  </tbody>
</table>

In vanilla servers, the maximum data length is 32767 bytes.

#### Debug Sample Subscription

Subscribes to the specified type of debug sample data, which is then sent periodically to the client via [[#Debug_Sample|Debug Sample]].

The subscription is retained for 10 seconds (the vanilla server checks that both 10.001 real-time seconds and 201 ticks have elapsed), after which the client is automatically unsubscribed. The vanilla client resends this packet every 5 seconds to keep up the subscription.

The vanilla server only allows subscriptions from players that are server operators.

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
      <td rowspan="1">*protocol:*<br/>`0x15`<br/><br/>*resource:*<br/>`debug_sample_subscription`</td>
      <td rowspan="1">Play</td>
      <td rowspan="1">Server</td>
      <td>Sample Type</td>
      <td>`VarInt` `Enum`</td>
      <td>The type of debug sample to subscribe to. Can be one of the following:
* 0 - Tick time</td>
    </tr>
  </tbody>
</table>

#### Edit Book

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
      <td rowspan="3">*protocol:*<br/>`0x16`<br/><br/>*resource:*<br/>`edit_book`</td>
      <td rowspan="3">Play</td>
      <td rowspan="3">Server</td>
      <td>Slot</td>
      <td>`VarInt`</td>
      <td>The hotbar slot where the written book is located</td>
    </tr>
    <tr>
      <td>Entries</td>
      <td>`Prefixed Array` (100) of `String` (1024)</td>
      <td>Text from each page. Maximum string length is 1024 chars.</td>
    </tr>
    <tr>
      <td>Title</td>
      <td>`Prefixed Optional` `String` (32)</td>
      <td>Title of book. Present if book is being signed, not present if book is being edited.</td>
    </tr>
  </tbody>
</table>

#### Query Entity Tag

Used when <kbd>F3</kbd>+<kbd>I</kbd> is pressed while looking at an entity.

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
      <td rowspan="2">*protocol:*<br/>`0x17`<br/><br/>*resource:*<br/>`entity_tag_query`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Server</td>
      <td>Transaction ID</td>
      <td>`VarInt`</td>
      <td>An incremental ID so that the client can verify that the response matches.</td>
    </tr>
    <tr>
      <td>Entity ID</td>
      <td>`VarInt`</td>
      <td>The ID of the entity to query.</td>
    </tr>
  </tbody>
</table>

#### Interact

This packet is sent from the client to the server when the client attacks or right-clicks another entity (a player, minecart, etc).

A vanilla server only accepts this packet if the entity being attacked/used is visible without obstruction and within a 4-unit radius of the player's position.

The target X, Y, and Z fields represent the difference between the vector location of the cursor at the time of the packet and the entity's position.

Note that middle-click in creative mode is interpreted by the client and sent as a [[#Set Creative Mode Slot|Set Creative Mode Slot]] packet instead.

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
      <td rowspan="7">*protocol:*<br/>`0x18`<br/><br/>*resource:*<br/>`interact`</td>
      <td rowspan="7">Play</td>
      <td rowspan="7">Server</td>
      <td>Entity ID</td>
      <td>`VarInt`</td>
      <td>The ID of the entity to interact. Note the special case described below.</td>
    </tr>
    <tr>
      <td>Type</td>
      <td>`VarInt` `Enum`</td>
      <td>0: interact, 1: attack, 2: interact at.</td>
    </tr>
    <tr>
      <td>Target X</td>
      <td>`Optional` `Float`</td>
      <td>Only if Type is interact at.</td>
    </tr>
    <tr>
      <td>Target Y</td>
      <td>`Optional` `Float`</td>
      <td>Only if Type is interact at.</td>
    </tr>
    <tr>
      <td>Target Z</td>
      <td>`Optional` `Float`</td>
      <td>Only if Type is interact at.</td>
    </tr>
    <tr>
      <td>Hand</td>
      <td>`Optional` `VarInt` `Enum`</td>
      <td>Only if Type is interact or interact at; 0: main hand, 1: off hand.</td>
    </tr>
    <tr>
      <td>Sneak Key Pressed</td>
      <td>`Boolean`</td>
      <td>If the client is pressing the sneak key. Has the same effect as a Player Command Press/Release sneak key preceding the interaction, and the state is permanently changed.</td>
    </tr>
  </tbody>
</table>

Interaction with the ender dragon is an odd special case characteristic of release deadline&ndash;driven design. 8 consecutive entity IDs following the dragon's ID (<var>id</var> + 1, <var>id</var> + 2, ..., <var>id</var> + 8) are reserved for the 8 hitboxes that make up the dragon:

<table class="wikitable">
  <tbody>
    <tr>
      <th>ID offset</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>0</td>
      <td>The dragon itself (never used in this packet)</td>
    </tr>
    <tr>
      <td>1</td>
      <td>Head</td>
    </tr>
    <tr>
      <td>2</td>
      <td>Neck</td>
    </tr>
    <tr>
      <td>3</td>
      <td>Body</td>
    </tr>
    <tr>
      <td>4</td>
      <td>Tail 1</td>
    </tr>
    <tr>
      <td>5</td>
      <td>Tail 2</td>
    </tr>
    <tr>
      <td>6</td>
      <td>Tail 3</td>
    </tr>
    <tr>
      <td>7</td>
      <td>Wing 1</td>
    </tr>
    <tr>
      <td>8</td>
      <td>Wing 2</td>
    </tr>
  </tbody>
</table>

#### Jigsaw Generate

Sent when Generate is pressed on the [Jigsaw Block](jigsaw-block.md) interface.

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
      <td rowspan="3">*protocol:*<br/>`0x19`<br/><br/>*resource:*<br/>`jigsaw_generate`</td>
      <td rowspan="3">Play</td>
      <td rowspan="3">Server</td>
      <td>Location</td>
      <td>`Position`</td>
      <td>Block entity location.</td>
    </tr>
    <tr>
      <td>Levels</td>
      <td>`VarInt`</td>
      <td>Value of the levels slider/max depth to generate.</td>
    </tr>
    <tr>
      <td>Keep Jigsaws</td>
      <td>`Boolean`</td>
      <td></td>
    </tr>
  </tbody>
</table>

#### Serverbound Keep Alive (play)

The server will frequently send out a keep-alive (see [[#Clientbound Keep Alive (play)|Clientbound Keep Alive]]), each containing a random ID. The client must respond with the same packet.

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
      <td rowspan="1">*protocol:*<br/>`0x1A`<br/><br/>*resource:*<br/>`keep_alive`</td>
      <td rowspan="1">Play</td>
      <td rowspan="1">Server</td>
      <td>Keep Alive ID</td>
      <td>`Long`</td>
      <td></td>
    </tr>
  </tbody>
</table>

#### Lock Difficulty

Must have at least op level 2 to use.  Appears to only be used on singleplayer; the difficulty buttons are still disabled in multiplayer.

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
      <td rowspan="1">*protocol:*<br/>`0x1B`<br/><br/>*resource:*<br/>`lock_difficulty`</td>
      <td rowspan="1">Play</td>
      <td rowspan="1">Server</td>
      <td>Locked</td>
      <td>`Boolean`</td>
      <td></td>
    </tr>
  </tbody>
</table>

#### Set Player Position

Updates the player's XYZ position on the server.

If the player is in a vehicle, the position is ignored (but in case of [[#Set Player Position and Rotation|Set Player Position and Rotation]], the rotation is still used as normal). No validation steps other than value range clamping are performed in this case.

If the player is sleeping, the position (or rotation) is not changed, and a [[#Synchronize Player Position|Synchronize Player Position]] is sent if the received position deviated from the server's view by more than a meter.

The vanilla server silently clamps the x and z coordinates between -30,000,000 and 30,000,000, and the y coordinate between -20,000,000 and 20,000,000. A similar condition has historically caused a kick for "Illegal position"; this is no longer the case. However, infinite or NaN coordinates (or angles) still result in a kick for `multiplayer.disconnect.invalid_player_movement`.

As of 1.20.6, checking for moving too fast is achieved like this (sic):

- Each server tick, the player's current position is stored.
- When the player moves, the offset from the stored position to the requested position is computed (&Delta;x, &Delta;y, &Delta;z).
- The requested movement distance squared is computed as &Delta;x&sup2; + &Delta;y&sup2; + &Delta;z&sup2;.
- The baseline expected movement distance squared is computed based on  the player's server-side velocity as Vx&sup2; + Vy&sup2; + Vz&sup2;. The player's server-side velocity is a somewhat ill-defined quantity that includes among other things gravity, jump velocity and knockback, but *not* regular horizontal movement. A proper description would bring much of Minecraft's physics engine with it. It is accessible as the `Motion` NBT tag on the player entity.
- The maximum permitted movement distance squared is computed as 100 (300 if the player is using an elytra), multiplied by the number of movement packets received since the last tick, including this one, unless that value is greater than 5, in which case no multiplier is applied.
- If the requested movement distance squared minus the baseline distance squared is more than the maximum squared, the player is moving too fast.

If the player is moving too fast, it is logged that "<player> moved too quickly! " followed by the change in x, y, and z, and the player is teleported back to their current (before this packet) server-side position.

Checking for block collisions is achieved like this:

- A temporary collision-checked move of the player is attempted from its current position to the requested one.
- The offset from the resulting position to the requested position is computed. If the absolute value of the offset on the y axis is less than 0.5, it (only the y component) is rounded down to 0.
- If the magnitude of the offset is greater than 0.25 and the player isn't in creative or spectator mode, it is logged that "<player> moved wrongly!", and the player is teleported back to their current (before this packet) server-side position.
- In addition, if the player's hitbox stationary at the requested position would intersect with a block, and they aren't in spectator mode, they are teleported back without a log message.

Checking for illegal flight is achieved like this:

- When a movement packet is received, a flag indicating whether or not the player is floating mid-air is updated. The flag is set if the move test described above detected no collision below the player *and* the y component of the offset from the player's current position to the requested one is greater than -0.5, unless any of various conditions permitting flight (creative mode, elytra, levitation effect, etc., but not jumping) are met.
- Each server tick, it is checked if the flag has been set for more than 80 consecutive ticks. If so, and the player isn't currently sleeping, dead or riding a vehicle, they are kicked for `multiplayer.disconnect.flying`.

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
      <td rowspan="4">*protocol:*<br/>`0x1C`<br/><br/>*resource:*<br/>`move_player_pos`</td>
      <td rowspan="4">Play</td>
      <td rowspan="4">Server</td>
      <td>X</td>
      <td>`Double`</td>
      <td>Absolute position.</td>
    </tr>
    <tr>
      <td>Feet Y</td>
      <td>`Double`</td>
      <td>Absolute feet position, normally Head Y - 1.62.</td>
    </tr>
    <tr>
      <td>Z</td>
      <td>`Double`</td>
      <td>Absolute position.</td>
    </tr>
    <tr>
      <td>Flags</td>
      <td>`Byte`</td>
      <td>Bit field: 0x01: on ground, 0x02: pushing against wall.</td>
    </tr>
  </tbody>
</table>

#### Set Player Position and Rotation

A combination of [[#Set Player Rotation|Move Player Rotation]] and [[#Set Player Position|Move Player Position]].

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
      <td rowspan="6">*protocol:*<br/>`0x1D`<br/><br/>*resource:*<br/>`move_player_pos_rot`</td>
      <td rowspan="6">Play</td>
      <td rowspan="6">Server</td>
      <td>X</td>
      <td>`Double`</td>
      <td>Absolute position.</td>
    </tr>
    <tr>
      <td>Feet Y</td>
      <td>`Double`</td>
      <td>Absolute feet position, normally Head Y - 1.62.</td>
    </tr>
    <tr>
      <td>Z</td>
      <td>`Double`</td>
      <td>Absolute position.</td>
    </tr>
    <tr>
      <td>Yaw</td>
      <td>`Float`</td>
      <td>Absolute rotation on the X Axis, in degrees.</td>
    </tr>
    <tr>
      <td>Pitch</td>
      <td>`Float`</td>
      <td>Absolute rotation on the Y Axis, in degrees.</td>
    </tr>
    <tr>
      <td>Flags</td>
      <td>`Byte`</td>
      <td>Bit field: 0x01: on ground, 0x02: pushing against wall.</td>
    </tr>
  </tbody>
</table>

#### Set Player Rotation

![The unit circle for yaw](Minecraft-trig-yaw.png)
![The unit circle of yaw, redrawn](Yaw.png)

Updates the direction the player is looking in.

Yaw is measured in degrees, and does not follow classical trigonometry rules. The unit circle of yaw on the XZ-plane starts at (0, 1) and turns counterclockwise, with 90 at (-1, 0), 180 at (0,-1) and 270 at (1, 0). Additionally, yaw is not clamped to between 0 and 360 degrees; any number is valid, including negative numbers and numbers greater than 360.

Pitch is measured in degrees, where 0 is looking straight ahead, -90 is looking straight up, and 90 is looking straight down.

The yaw and pitch of player (in degrees), standing at point (x0, y0, z0) and looking towards point (x, y, z) can be calculated with:

 dx = x-x0
 dy = y-y0
 dz = z-z0
 r = sqrt( dx*dx + dy*dy + dz*dz )
 yaw = -atan2(dx,dz)/PI*180
 if yaw < 0 then
     yaw = 360 + yaw
 pitch = -arcsin(dy/r)/PI*180

You can get a unit vector from a given yaw/pitch via:

 x = -cos(pitch) * sin(yaw)
 y = -sin(pitch)
 z =  cos(pitch) * cos(yaw)

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
      <td rowspan="3">*protocol:*<br/>`0x1E`<br/><br/>*resource:*<br/>`move_player_rot`</td>
      <td rowspan="3">Play</td>
      <td rowspan="3">Server</td>
      <td>Yaw</td>
      <td>`Float`</td>
      <td>Absolute rotation on the X Axis, in degrees.</td>
    </tr>
    <tr>
      <td>Pitch</td>
      <td>`Float`</td>
      <td>Absolute rotation on the Y Axis, in degrees.</td>
    </tr>
    <tr>
      <td>Flags</td>
      <td>`Byte`</td>
      <td>Bit field: 0x01: on ground, 0x02: pushing against wall.</td>
    </tr>
  </tbody>
</table>

#### Set Player Movement Flags

This packet as well as [[#Set Player Position|Set Player Position]], [[#Set Player Rotation|Set Player Rotation]], and [[#Set Player Position and Rotation|Set Player Position and Rotation]] are called the “serverbound movement packets”. Vanilla clients will send Move Player Position once every 20 ticks even for a stationary player.

This packet is used to indicate whether the player is on ground (walking/swimming), or airborne (jumping/falling).

When dropping from sufficient height, fall damage is applied when this state goes from false to true. The amount of damage applied is based on the point where it last changed from true to false. Note that there are several movement related packets containing this state.

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
      <td rowspan="1">*protocol:*<br/>`0x1F`<br/><br/>*resource:*<br/>`move_player_status_only`</td>
      <td rowspan="1">Play</td>
      <td rowspan="1">Server</td>
      <td>Flags</td>
      <td>`Byte`</td>
      <td>Bit field: 0x01: on ground, 0x02: pushing against wall.</td>
    </tr>
  </tbody>
</table>

#### Move Vehicle

Sent when a player moves in a vehicle. Fields are the same as in [[#Set Player Position and Rotation|Set Player Position and Rotation]]. Note that all fields use absolute positioning and do not allow for relative positioning.

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
      <td rowspan="6">*protocol:*<br/>`0x20`<br/><br/>*resource:*<br/>`move_vehicle`</td>
      <td rowspan="6">Play</td>
      <td rowspan="6">Server</td>
      <td>X</td>
      <td>`Double`</td>
      <td>Absolute position (X coordinate).</td>
    </tr>
    <tr>
      <td>Y</td>
      <td>`Double`</td>
      <td>Absolute position (Y coordinate).</td>
    </tr>
    <tr>
      <td>Z</td>
      <td>`Double`</td>
      <td>Absolute position (Z coordinate).</td>
    </tr>
    <tr>
      <td>Yaw</td>
      <td>`Float`</td>
      <td>Absolute rotation on the vertical axis, in degrees.</td>
    </tr>
    <tr>
      <td>Pitch</td>
      <td>`Float`</td>
      <td>Absolute rotation on the horizontal axis, in degrees.</td>
    </tr>
    <tr>
      <td>On Ground</td>
      <td>`Boolean`</td>
      <td>*(This value does not seem to exist)*</td>
    </tr>
  </tbody>
</table>

#### Paddle Boat

Used to *visually* update whether boat paddles are turning.  The server will update the [Boat entity metadata](entity_metadata.md#boat) to match the values here.

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
      <td rowspan="2">*protocol:*<br/>`0x21`<br/><br/>*resource:*<br/>`paddle_boat`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Server</td>
      <td>Left paddle turning</td>
      <td>`Boolean`</td>
      <td></td>
    </tr>
    <tr>
      <td>Right paddle turning</td>
      <td>`Boolean`</td>
      <td></td>
    </tr>
  </tbody>
</table>

Right paddle turning is set to true when the left button or forward button is held, left paddle turning is set to true when the right button or forward button is held.

#### Pick Item From Block

Used for pick block functionality (middle click) on blocks to retrieve items from the inventory in survival or creative mode or create them in creative mode.  See [Controls#Pick_Block](controls.md#pickblock) for more information.

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
      <td rowspan="2">*protocol:*<br/>`0x22`<br/><br/>*resource:*<br/>`pick_item_from_block`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Server</td>
      <td>Location</td>
      <td>`Position`</td>
      <td>The location of the block.</td>
    </tr>
    <tr>
      <td>Include Data</td>
      <td>`Boolean`</td>
      <td>Used to tell the server to include block data in the new stack, works only if in creative mode.</td>
    </tr>
  </tbody>
</table>

#### Pick Item From Entity

Used for pick block functionality (middle click) on entities to retrieve items from the inventory in survival or creative mode or create them in creative mode.  See [Controls#Pick_Block](controls.md#pickblock) for more information.

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
      <td rowspan="2">*protocol:*<br/>`0x23`<br/><br/>*resource:*<br/>`pick_item_from_entity`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Server</td>
      <td>Entity ID</td>
      <td>`VarInt`</td>
      <td>The ID of the entity to pick.</td>
    </tr>
    <tr>
      <td>Include Data</td>
      <td>`Boolean`</td>
      <td>Unused by the vanilla server.</td>
    </tr>
  </tbody>
</table>

#### Ping Request (play)

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
      <td rowspan="1">*protocol:*<br/>`0x24`<br/><br/>*resource:*<br/>`ping_request`</td>
      <td rowspan="1">Play</td>
      <td rowspan="1">Server</td>
      <td>Payload</td>
      <td>`Long`</td>
      <td>May be any number. vanilla clients use a system-dependent time value which is counted in milliseconds.</td>
    </tr>
  </tbody>
</table>

#### Place Recipe

This packet is sent when a player clicks a recipe in the crafting book that is craftable (white border).

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
      <td rowspan="3">*protocol:*<br/>`0x25`<br/><br/>*resource:*<br/>`place_recipe`</td>
      <td rowspan="3">Play</td>
      <td rowspan="3">Server</td>
      <td>Window ID</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
    <tr>
      <td>Recipe ID</td>
      <td>`VarInt`</td>
      <td>ID of recipe previously defined in [[#Recipe Book Add|Recipe Book Add]].</td>
    </tr>
    <tr>
      <td>Make all</td>
      <td>`Boolean`</td>
      <td>Affects the amount of items processed; true if shift is down when clicked.</td>
    </tr>
  </tbody>
</table>

#### Player Abilities (serverbound)

The vanilla client sends this packet when the player starts/stops flying with the Flags parameter changed accordingly.

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
      <td rowspan="1">*protocol:*<br/>`0x26`<br/><br/>*resource:*<br/>`player_abilities`</td>
      <td rowspan="1">Play</td>
      <td rowspan="1">Server</td>
      <td>Flags</td>
      <td>`Byte`</td>
      <td>Bit mask. 0x02: is flying.</td>
    </tr>
  </tbody>
</table>

#### Player Action

Sent when the player mines a block. A vanilla server only accepts digging packets with coordinates within a 6-unit radius between the center of the block and the player's eyes.

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
      <td rowspan="4">*protocol:*<br/>`0x27`<br/><br/>*resource:*<br/>`player_action`</td>
      <td rowspan="4">Play</td>
      <td rowspan="4">Server</td>
      <td>Status</td>
      <td>`VarInt` `Enum`</td>
      <td>The action the player is taking against the block (see below).</td>
    </tr>
    <tr>
      <td>Location</td>
      <td>`Position`</td>
      <td>Block position.</td>
    </tr>
    <tr>
      <td>Face</td>
      <td>`Byte` `Enum`</td>
      <td>The face being hit (see below).</td>
    </tr>
    <tr>
      <td>Sequence</td>
      <td>`VarInt`</td>
      <td>Block change sequence number (see [#Acknowledge Block Change](acknowledge-block-change.md)).</td>
    </tr>
  </tbody>
</table>

Status can be one of seven values:

<table class="wikitable">
  <tbody>
    <tr>
      <th>Value</th>
      <th>Meaning</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>0</td>
      <td>Started digging</td>
      <td>Sent when the player starts digging a block. If the block was instamined or the player is in creative mode, the client will *not* send Status = Finished digging, and will assume the server completed the destruction. To detect this, it is necessary to [calculate the block destruction speed](breaking.md#speed) server-side.</td>
    </tr>
    <tr>
      <td>1</td>
      <td>Cancelled digging</td>
      <td>Sent when the player lets go of the Mine Block key (default: left click). Face is always set to -Y.</td>
    </tr>
    <tr>
      <td>2</td>
      <td>Finished digging</td>
      <td>Sent when the client thinks it is finished.</td>
    </tr>
    <tr>
      <td>3</td>
      <td>Drop item stack</td>
      <td>Triggered by using the Drop Item key (default: Q) with the modifier to drop the entire selected stack (default: Control or Command, depending on OS). Location is always set to 0/0/0, Face is always set to -Y. Sequence is always set to 0.</td>
    </tr>
    <tr>
      <td>4</td>
      <td>Drop item</td>
      <td>Triggered by using the Drop Item key (default: Q). Location is always set to 0/0/0, Face is always set to -Y. Sequence is always set to 0.</td>
    </tr>
    <tr>
      <td>5</td>
      <td>Shoot arrow / finish eating</td>
      <td>Indicates that the currently held item should have its state updated such as eating food, pulling back bows, using buckets, etc. Location is always set to 0/0/0, Face is always set to -Y. Sequence is always set to 0.</td>
    </tr>
    <tr>
      <td>6</td>
      <td>Swap item in hand</td>
      <td>Used to swap or assign an item to the second hand. Location is always set to 0/0/0, Face is always set to -Y. Sequence is always set to 0.</td>
    </tr>
  </tbody>
</table>

The Face field can be one of the following values, representing the face being hit:

<table class="wikitable">
  <tbody>
    <tr>
      <th>Value</th>
      <th>Offset</th>
      <th>Face</th>
    </tr>
    <tr>
      <td>0</td>
      <td>-Y</td>
      <td>Bottom</td>
    </tr>
    <tr>
      <td>1</td>
      <td>+Y</td>
      <td>Top</td>
    </tr>
    <tr>
      <td>2</td>
      <td>-Z</td>
      <td>North</td>
    </tr>
    <tr>
      <td>3</td>
      <td>+Z</td>
      <td>South</td>
    </tr>
    <tr>
      <td>4</td>
      <td>-X</td>
      <td>West</td>
    </tr>
    <tr>
      <td>5</td>
      <td>+X</td>
      <td>East</td>
    </tr>
  </tbody>
</table>

#### Player Command

Sent by the client to indicate that it has performed certain actions: sneaking (crouching), sprinting, exiting a bed, jumping with a horse, and opening a horse's inventory while riding it.

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
      <td rowspan="3">*protocol:*<br/>`0x28`<br/><br/>*resource:*<br/>`player_command`</td>
      <td rowspan="3">Play</td>
      <td rowspan="3">Server</td>
      <td>Entity ID</td>
      <td>`VarInt`</td>
      <td>Player ID (ignored by the vanilla server)</td>
    </tr>
    <tr>
      <td>Action ID</td>
      <td>`VarInt` `Enum`</td>
      <td>The ID of the action, see below.</td>
    </tr>
    <tr>
      <td>Jump Boost</td>
      <td>`VarInt`</td>
      <td>Only used by the “start jump with horse” action, in which case it ranges from 0 to 100. In all other cases it is 0.</td>
    </tr>
  </tbody>
</table>

Action ID can be one of the following values:

<table class="wikitable">
  <tbody>
    <tr>
      <th>ID</th>
      <th>Action</th>
    </tr>
    <tr>
      <td>0</td>
      <td>Press sneak key</td>
    </tr>
    <tr>
      <td>1</td>
      <td>Release sneak key</td>
    </tr>
    <tr>
      <td>2</td>
      <td>Leave bed</td>
    </tr>
    <tr>
      <td>3</td>
      <td>Start sprinting</td>
    </tr>
    <tr>
      <td>4</td>
      <td>Stop sprinting</td>
    </tr>
    <tr>
      <td>5</td>
      <td>Start jump with horse</td>
    </tr>
    <tr>
      <td>6</td>
      <td>Stop jump with horse</td>
    </tr>
    <tr>
      <td>7</td>
      <td>Open vehicle inventory</td>
    </tr>
    <tr>
      <td>8</td>
      <td>Start flying with elytra</td>
    </tr>
  </tbody>
</table>

Leave bed is only sent when the “Leave Bed” button is clicked on the sleep GUI, not when waking up in the morning.

Open vehicle inventory is only sent when pressing the inventory key (default: E) while on a horse or chest boat — all other methods of opening such an inventory (involving right-clicking or shift-right-clicking it) do not use this packet.

#### Player Input

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
      <td rowspan="1">*protocol:*<br/>`0x29`<br/><br/>*resource:*<br/>`player_input`</td>
      <td rowspan="1">Play</td>
      <td rowspan="1">Server</td>
      <td>Flags</td>
      <td>`Unsigned Byte`</td>
      <td>Bit mask; see below</td>
    </tr>
  </tbody>
</table>

The flags are as follows:

<table class="wikitable">
  <tbody>
    <tr>
      <th>Hex Mask</th>
      <th>Field</th>
    </tr>
    <tr>
      <td>0x01</td>
      <td>Forward</td>
    </tr>
    <tr>
      <td>0x02</td>
      <td>Backward</td>
    </tr>
    <tr>
      <td>0x04</td>
      <td>Left</td>
    </tr>
    <tr>
      <td>0x08</td>
      <td>Right</td>
    </tr>
    <tr>
      <td>0x10</td>
      <td>Jump</td>
    </tr>
    <tr>
      <td>0x20</td>
      <td>Sneak</td>
    </tr>
    <tr>
      <td>0x40</td>
      <td>Sprint</td>
    </tr>
  </tbody>
</table>

#### Player Loaded

Sent by the client after the server starts sending chunks and the player's chunk has loaded.

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
      <td rowspan="1">*protocol:*<br/>`0x2A`<br/><br/>*resource:*<br/>`player_loaded`</td>
      <td rowspan="1">Play</td>
      <td rowspan="1">Server</td>
      <td colspan="3">*no fields*</td>
    </tr>
  </tbody>
</table>

#### Pong (play)

Response to the clientbound packet ([[#Ping (play)|Ping]]) with the same id.

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
      <td rowspan="1">*protocol:*<br/>`0x2B`<br/><br/>*resource:*<br/>`pong`</td>
      <td rowspan="1">Play</td>
      <td rowspan="1">Server</td>
      <td>ID</td>
      <td>`Int`</td>
      <td>id is the same as the ping packet</td>
    </tr>
  </tbody>
</table>

#### Change Recipe Book Settings

Replaces Recipe Book Data, type 1.

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
      <td rowspan="3">*protocol:*<br/>`0x2C`<br/><br/>*resource:*<br/>`recipe_book_change_settings`</td>
      <td rowspan="3">Play</td>
      <td rowspan="3">Server</td>
      <td>Book ID</td>
      <td>`VarInt` `Enum`</td>
      <td>0: crafting, 1: furnace, 2: blast furnace, 3: smoker.</td>
    </tr>
    <tr>
      <td>Book Open</td>
      <td>`Boolean`</td>
      <td></td>
    </tr>
    <tr>
      <td>Filter Active</td>
      <td>`Boolean`</td>
      <td></td>
    </tr>
  </tbody>
</table>

#### Set Seen Recipe

Sent when recipe is first seen in recipe book. Replaces Recipe Book Data, type 0.

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
      <td rowspan="1">*protocol:*<br/>`0x2D`<br/><br/>*resource:*<br/>`recipe_book_seen_recipe`</td>
      <td rowspan="1">Play</td>
      <td rowspan="1">Server</td>
      <td>Recipe ID</td>
      <td>`VarInt`</td>
      <td>ID of recipe previously defined in Recipe Book Add.</td>
    </tr>
  </tbody>
</table>

#### Rename Item

Sent as a player is renaming an item in an anvil (each keypress in the anvil UI sends a new Rename Item packet). If the new name is empty, then the item loses its custom name (this is different from setting the custom name to the normal name of the item). The item name may be no longer than 50 characters long, and if it is longer than that, then the rename is silently ignored.

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
      <td rowspan="1">*protocol:*<br/>`0x2E`<br/><br/>*resource:*<br/>`rename_item`</td>
      <td rowspan="1">Play</td>
      <td rowspan="1">Server</td>
      <td>Item name</td>
      <td>`String` (32767)</td>
      <td>The new name of the item.</td>
    </tr>
  </tbody>
</table>

#### Resource Pack Response (play)

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
      <td rowspan="2">*protocol:*<br/>`0x2F`<br/><br/>*resource:*<br/>`resource_pack`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Server</td>
      <td>UUID</td>
      <td>`UUID`</td>
      <td>The unique identifier of the resource pack received in the [[#Add_Resource_Pack_(play)|Add Resource Pack (play)]] request.</td>
    </tr>
    <tr>
      <td>Result</td>
      <td>`VarInt` `Enum`</td>
      <td>Result ID (see below).</td>
    </tr>
  </tbody>
</table>

Result can be one of the following values:


<table class="wikitable">
  <tbody>
    <tr>
      <th>ID</th>
      <th>Result</th>
    </tr>
    <tr>
      <td>0</td>
      <td>Successfully downloaded</td>
    </tr>
    <tr>
      <td>1</td>
      <td>Declined</td>
    </tr>
    <tr>
      <td>2</td>
      <td>Failed to download</td>
    </tr>
    <tr>
      <td>3</td>
      <td>Accepted</td>
    </tr>
    <tr>
      <td>4</td>
      <td>Downloaded</td>
    </tr>
    <tr>
      <td>5</td>
      <td>Invalid URL</td>
    </tr>
    <tr>
      <td>6</td>
      <td>Failed to reload</td>
    </tr>
    <tr>
      <td>7</td>
      <td>Discarded</td>
    </tr>
  </tbody>
</table>

#### Seen Advancements

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
      <td rowspan="2">*protocol:*<br/>`0x30`<br/><br/>*resource:*<br/>`seen_advancements`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Server</td>
      <td>Action</td>
      <td>`VarInt` `Enum`</td>
      <td>0: Opened tab, 1: Closed screen.</td>
    </tr>
    <tr>
      <td>Tab ID</td>
      <td>`Optional` `Identifier`</td>
      <td>Only present if action is Opened tab.</td>
    </tr>
  </tbody>
</table>

#### Select Trade

When a player selects a specific trade offered by a villager NPC.

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
      <td rowspan="1">*protocol:*<br/>`0x31`<br/><br/>*resource:*<br/>`select_trade`</td>
      <td rowspan="1">Play</td>
      <td rowspan="1">Server</td>
      <td>Selected slot</td>
      <td>`VarInt`</td>
      <td>The selected slot in the players current (trading) inventory.</td>
    </tr>
  </tbody>
</table>

#### Set Beacon Effect

Changes the effect of the current beacon.

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
      <td rowspan="2">*protocol:*<br/>`0x32`<br/><br/>*resource:*<br/>`set_beacon`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Server</td>
      <td>Primary Effect</td>
      <td>`Prefixed Optional` `VarInt`</td>
      <td>A [Potion ID](https://minecraft.wiki/w/Potion#ID).</td>
    </tr>
    <tr>
      <td>Secondary Effect</td>
      <td>`Prefixed Optional` `VarInt`</td>
      <td>A [Potion ID](https://minecraft.wiki/w/Potion#ID).</td>
    </tr>
  </tbody>
</table>

#### Set Held Item (serverbound)

Sent when the player changes the slot selection.

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
      <td rowspan="1">*protocol:*<br/>`0x33`<br/><br/>*resource:*<br/>`set_carried_item`</td>
      <td rowspan="1">Play</td>
      <td rowspan="1">Server</td>
      <td>Slot</td>
      <td>`Short`</td>
      <td>The slot which the player has selected (0–8).</td>
    </tr>
  </tbody>
</table>

#### Program Command Block

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
      <td rowspan="4">*protocol:*<br/>`0x34`<br/><br/>*resource:*<br/>`set_command_block`</td>
      <td rowspan="4">Play</td>
      <td rowspan="4">Server</td>
      <td>Location</td>
      <td>`Position`</td>
      <td></td>
    </tr>
    <tr>
      <td>Command</td>
      <td>`String` (32767)</td>
      <td></td>
    </tr>
    <tr>
      <td>Mode</td>
      <td>`VarInt` `Enum`</td>
      <td>0: chain, 1: repeating, 2: impulse.</td>
    </tr>
    <tr>
      <td>Flags</td>
      <td>`Byte`</td>
      <td>0x01: Track Output (if false, the output of the previous command will not be stored within the command block); 0x02: Is conditional; 0x04: Automatic.</td>
    </tr>
  </tbody>
</table>

#### Program Command Block Minecart

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
      <td rowspan="3">*protocol:*<br/>`0x35`<br/><br/>*resource:*<br/>`set_command_minecart`</td>
      <td rowspan="3">Play</td>
      <td rowspan="3">Server</td>
      <td>Entity ID</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
    <tr>
      <td>Command</td>
      <td>`String` (32767)</td>
      <td></td>
    </tr>
    <tr>
      <td>Track Output</td>
      <td>`Boolean`</td>
      <td>If false, the output of the previous command will not be stored within the command block.</td>
    </tr>
  </tbody>
</table>

#### Set Creative Mode Slot

While the user is in the standard inventory (i.e., not a crafting bench) in Creative mode, the player will send this packet.

Clicking in the creative inventory menu is quite different from non-creative inventory management. Picking up an item with the mouse actually deletes the item from the server, and placing an item into a slot or dropping it out of the inventory actually tells the server to create the item from scratch. (This can be verified by clicking an item that you don't mind deleting, then severing the connection to the server; the item will be nowhere to be found when you log back in.) As a result of this implementation strategy, the "Destroy Item" slot is just a client-side implementation detail that means "I don't intend to recreate this item.". Additionally, the long listings of items (by category, etc.) are a client-side interface for choosing which item to create. Picking up an item from such listings sends no packets to the server; only when you put it somewhere does it tell the server to create the item in that location.

This action can be described as "set inventory slot". Picking up an item sets the slot to item ID -1. Placing an item into an inventory slot sets the slot to the specified item. Dropping an item (by clicking outside the window) effectively sets slot -1 to the specified item, which causes the server to spawn the item entity, etc.. All other inventory slots are numbered the same as the non-creative inventory (including slots for the 2x2 crafting menu, even though they aren't visible in the vanilla client).

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
      <td rowspan="2">*protocol:*<br/>`0x36`<br/><br/>*resource:*<br/>`set_creative_mode_slot`</td>
      <td rowspan="2">Play</td>
      <td rowspan="2">Server</td>
      <td>Slot</td>
      <td>`Short`</td>
      <td>Inventory slot.</td>
    </tr>
    <tr>
      <td>Clicked Item</td>
      <td>`Slot`</td>
      <td></td>
    </tr>
  </tbody>
</table>

#### Program Jigsaw Block

Sent when Done is pressed on the [Jigsaw Block](jigsaw-block.md) interface.

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
      <td rowspan="8">*protocol:*<br/>`0x37`<br/><br/>*resource:*<br/>`set_jigsaw_block`</td>
      <td rowspan="8">Play</td>
      <td rowspan="8">Server</td>
      <td>Location</td>
      <td>`Position`</td>
      <td>Block entity location</td>
    </tr>
    <tr>
      <td>Name</td>
      <td>`Identifier`</td>
      <td></td>
    </tr>
    <tr>
      <td>Target</td>
      <td>`Identifier`</td>
      <td></td>
    </tr>
    <tr>
      <td>Pool</td>
      <td>`Identifier`</td>
      <td></td>
    </tr>
    <tr>
      <td>Final state</td>
      <td>`String` (32767)</td>
      <td>"Turns into" on the GUI, `final_state` in NBT.</td>
    </tr>
    <tr>
      <td>Joint type</td>
      <td>`String` (32767)</td>
      <td>`rollable` if the attached piece can be rotated, else `aligned`.</td>
    </tr>
    <tr>
      <td>Selection priority</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
    <tr>
      <td>Placement priority</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
  </tbody>
</table>

#### Program Structure Block

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
      <td rowspan="17">*protocol:*<br/>`0x38`<br/><br/>*resource:*<br/>`set_structure_block`</td>
      <td rowspan="17">Play</td>
      <td rowspan="17">Server</td>
    </tr>
    <tr>
      <td>Location</td>
      <td>`Position`</td>
      <td>Block entity location.</td>
    </tr>
    <tr>
      <td>Action</td>
      <td>`VarInt` `Enum`</td>
      <td>An additional action to perform beyond simply saving the given data; see below.</td>
    </tr>
    <tr>
      <td>Mode</td>
      <td>`VarInt` `Enum`</td>
      <td>One of SAVE (0), LOAD (1), CORNER (2), DATA (3).</td>
    </tr>
    <tr>
      <td>Name</td>
      <td>`String` (32767)</td>
      <td></td>
    </tr>
    <tr>
      <td>Offset X</td>
      <td>`Byte`</td>
      <td>Between -48 and 48.</td>
    </tr>
    <tr>
      <td>Offset Y</td>
      <td>`Byte`</td>
      <td>Between -48 and 48.</td>
    </tr>
    <tr>
      <td>Offset Z</td>
      <td>`Byte`</td>
      <td>Between -48 and 48.</td>
    </tr>
    <tr>
      <td>Size X</td>
      <td>`Byte`</td>
      <td>Between 0 and 48.</td>
    </tr>
    <tr>
      <td>Size Y</td>
      <td>`Byte`</td>
      <td>Between 0 and 48.</td>
    </tr>
    <tr>
      <td>Size Z</td>
      <td>`Byte`</td>
      <td>Between 0 and 48.</td>
    </tr>
    <tr>
      <td>Mirror</td>
      <td>`VarInt` `Enum`</td>
      <td>One of NONE (0), LEFT_RIGHT (1), FRONT_BACK (2).</td>
    </tr>
    <tr>
      <td>Rotation</td>
      <td>`VarInt` `Enum`</td>
      <td>One of NONE (0), CLOCKWISE_90 (1), CLOCKWISE_180 (2), COUNTERCLOCKWISE_90 (3).</td>
    </tr>
    <tr>
      <td>Metadata</td>
      <td>`String` (128)</td>
      <td></td>
    </tr>
    <tr>
      <td>Integrity</td>
      <td>`Float`</td>
      <td>Between 0 and 1.</td>
    </tr>
    <tr>
      <td>Seed</td>
      <td>`VarLong`</td>
      <td></td>
    </tr>
    <tr>
      <td>Flags</td>
      <td>`Byte`</td>
      <td>0x01: Ignore entities; 0x02: Show air; 0x04: Show bounding box; 0x08: Strict placement.</td>
    </tr>
  </tbody>
</table>

Possible actions:

- 0 - Update data
- 1 - Save the structure
- 2 - Load the structure
- 3 - Detect size

The vanilla client uses update data to indicate no special action should be taken (i.e. the done button).

#### Set Test Block

Updates the value of the [Test Block](test-block.md) at the given position.

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
      <td rowspan="3">*protocol:*<br/>`0x39`<br/><br/>*resource:*<br/>`set_test_block`</td>
      <td rowspan="3">Play</td>
      <td rowspan="3">Server</td>
      <td>Position</td>
      <td>`Position`</td>
      <td></td>
    </tr>
    <tr>
      <td>Mode</td>
      <td>`VarInt` `Enum`</td>
      <td>0: start, 1: log, 2: fail, 3: accept</td>
    </tr>
    <tr>
      <td>Message</td>
      <td>`String`</td>
      <td></td>
    </tr>
  </tbody>
</table>

#### Update Sign

This message is sent from the client to the server when the “Done” button is pushed after placing a sign.

The server only accepts this packet after [[#Open Sign Editor|Open Sign Editor]], otherwise this packet is silently ignored.

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
      <td rowspan="6">*protocol:*<br/>`0x3A`<br/><br/>*resource:*<br/>`sign_update`</td>
      <td rowspan="6">Play</td>
      <td rowspan="6">Server</td>
      <td>Location</td>
      <td>`Position`</td>
      <td>Block Coordinates.</td>
    </tr>
    <tr>
      <td>Is Front Text</td>
      <td>`Boolean`</td>
      <td>Whether the updated text is in front or on the back of the sign</td>
    </tr>
    <tr>
      <td>Line 1</td>
      <td>`String` (384)</td>
      <td>First line of text in the sign.</td>
    </tr>
    <tr>
      <td>Line 2</td>
      <td>`String` (384)</td>
      <td>Second line of text in the sign.</td>
    </tr>
    <tr>
      <td>Line 3</td>
      <td>`String` (384)</td>
      <td>Third line of text in the sign.</td>
    </tr>
    <tr>
      <td>Line 4</td>
      <td>`String` (384)</td>
      <td>Fourth line of text in the sign.</td>
    </tr>
  </tbody>
</table>

#### Swing Arm

Sent when the player's arm swings.

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
      <td rowspan="1">*protocol:*<br/>`0x3B`<br/><br/>*resource:*<br/>`swing`</td>
      <td rowspan="1">Play</td>
      <td rowspan="1">Server</td>
      <td>Hand</td>
      <td>`VarInt` `Enum`</td>
      <td>Hand used for the animation. 0: main hand, 1: off hand.</td>
    </tr>
  </tbody>
</table>

#### Teleport To Entity

Teleports the player to the given entity.  The player must be in spectator mode.

The vanilla client only uses this to teleport to players, but it appears to accept any type of entity.  The entity does not need to be in the same dimension as the player; if necessary, the player will be respawned in the right world.  If the given entity cannot be found (or isn't loaded), this packet will be ignored.

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
      <td rowspan="1">*protocol:*<br/>`0x3C`<br/><br/>*resource:*<br/>`teleport_to_entity`</td>
      <td rowspan="1">Play</td>
      <td rowspan="1">Server</td>
      <td>Target Player</td>
      <td>`UUID`</td>
      <td>UUID of the player to teleport to (can also be an entity UUID).</td>
    </tr>
  </tbody>
</table>

#### Test Instance Block Action

Tries to perform an action the [Test Instance Block](test-instance-block.md) at the given position.

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
      <td rowspan="10">*protocol:*<br/>`0x3D`<br/><br/>*resource:*<br/>`test_instance_block_action`</td>
      <td rowspan="10">Play</td>
      <td rowspan="10">Server</td>
      <td>Position</td>
      <td>`Position`</td>
      <td></td>
    </tr>
    <tr>
      <td>Action</td>
      <td>`VarInt` `Enum`</td>
      <td>0: init, 1: query, 2: set, 3: reset, 4: save, 5: export, 6: run.</td>
    </tr>
    <tr>
      <td>Test</td>
      <td>`Prefixed Optional` `VarInt`</td>
      <td>ID in the `minecraft:test_instance_kind` registry.</td>
    </tr>
    <tr>
      <td>Size X</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
    <tr>
      <td>Size Y</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
    <tr>
      <td>Size Z</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
    <tr>
      <td>Rotation</td>
      <td>`VarInt` `Enum`</td>
      <td>0: none, 1: clockwise 90&deg;, 2: clockwise 180&deg;, 3: counter-clockwise 90&deg;.</td>
    </tr>
    <tr>
      <td>Ignore Entities</td>
      <td>`Boolean`</td>
      <td></td>
    </tr>
    <tr>
      <td>Status</td>
      <td>`VarInt` `Enum`</td>
      <td>0: cleared, 1: running, 2: finished.</td>
      <td></td>
    </tr>
    <tr>
      <td>Error Message</td>
      <td>`Prefixed Optional` `Text Component`</td>
      <td></td>
    </tr>
  </tbody>
</table>

#### Use Item On

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
      <td rowspan="9">*protocol:*<br/>`0x3E`<br/><br/>*resource:*<br/>`use_item_on`</td>
      <td rowspan="9">Play</td>
      <td rowspan="9">Server</td>
      <td>Hand</td>
      <td>`VarInt` `Enum`</td>
      <td>The hand from which the block is placed; 0: main hand, 1: off hand.</td>
    </tr>
    <tr>
      <td>Location</td>
      <td>`Position`</td>
      <td>Block position.</td>
    </tr>
    <tr>
      <td>Face</td>
      <td>`VarInt` `Enum`</td>
      <td>The face on which the block is placed (as documented at [[#Player Action|Player Action]]).</td>
    </tr>
    <tr>
      <td>Cursor Position X</td>
      <td>`Float`</td>
      <td>The position of the crosshair on the block, from 0 to 1 increasing from west to east.</td>
    </tr>
    <tr>
      <td>Cursor Position Y</td>
      <td>`Float`</td>
      <td>The position of the crosshair on the block, from 0 to 1 increasing from bottom to top.</td>
    </tr>
    <tr>
      <td>Cursor Position Z</td>
      <td>`Float`</td>
      <td>The position of the crosshair on the block, from 0 to 1 increasing from north to south.</td>
    </tr>
    <tr>
      <td>Inside block</td>
      <td>`Boolean`</td>
      <td>True when the player's head is inside of a block.</td>
    </tr>
    <tr>
      <td>World Border Hit</td>
      <td>`Boolean`</td>
      <td>Seems to always be false, even when interacting with blocks around or outside the world border, or while the player is outside the border.</td>
    </tr>
    <tr>
      <td>Sequence</td>
      <td>`VarInt`</td>
      <td>Block change sequence number (see [#Acknowledge Block Change](acknowledge-block-change.md)).</td>
    </tr>
  </tbody>
</table>

Upon placing a block, this packet is sent once.

The Cursor Position X/Y/Z fields (also known as in-block coordinates) are calculated using raytracing. The unit corresponds to sixteen pixels in the default resource pack. For example, let's say a slab is being placed against the south face of a full block. The Cursor Position X will be higher if the player was pointing near the right (east) edge of the face, lower if pointing near the left. The Cursor Position Y will be used to determine whether it will appear as a bottom slab (values 0.0–0.5) or as a top slab (values 0.5-1.0). The Cursor Position Z should be 1.0 since the player was looking at the southernmost part of the block.

Inside block is true when a player's head (specifically eyes) are inside of a block's collision. In 1.13 and later versions, collision is rather complicated and individual blocks can have multiple collision boxes. For instance, a ring of vines has a non-colliding hole in the middle. This value is only true when the player is directly in the box. In practice, though, this value is only used by scaffolding to place in front of the player when sneaking inside of it (other blocks will place behind when you intersect with them -- try with glass for instance).

#### Use Item

Sent when pressing the Use Item key (default: right click) with an item in hand.

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
      <td rowspan="4">*protocol:*<br/>`0x3F`<br/><br/>*resource:*<br/>`use_item`</td>
      <td rowspan="4">Play</td>
      <td rowspan="4">Server</td>
      <td>Hand</td>
      <td>`VarInt` `Enum`</td>
      <td>Hand used for the animation. 0: main hand, 1: off hand.</td>
    </tr>
    <tr>
      <td>Sequence</td>
      <td>`VarInt`</td>
      <td>Block change sequence number (see [#Acknowledge Block Change](acknowledge-block-change.md)).</td>
    </tr>
    <tr>
      <td>Yaw</td>
      <td>`Float`</td>
      <td>Player head rotation along the Y-Axis.</td>
    </tr>
    <tr>
      <td>Pitch</td>
      <td>`Float`</td>
      <td>Player head rotation along the X-Axis.</td>
    </tr>
  </tbody>
</table>

The player's rotation is permanently updated according to the Yaw and Pitch fields before performing the action, unless there is no item in the specified hand.

## Navigation
{{Navbox Java Edition technical|General}}

[Category:Protocol Details](category-protocol-details.md)
[Category:Java Edition protocol](category-java-edition-protocol.md)
_Content is licensed under wiki.vg terms._
