**Server List Ping** (**SLP**) is an interface provided by Minecraft servers which supports querying the MOTD, player count, max players and server version via the usual port. SLP is part of the [protocol](protocol.md), but it can be disabled. The Notchian client uses this interface to display the multiplayer server list, hence the name. The SLP process changed in [Java Edition 1.7](java-edition-1.7.md) in a non-backwards compatible way, but modern clients and servers still support both the [[#Current|new]] and [[#1.6|old]] process.

## Current (1.7+)

This uses the regular client-server protocol. For the general packet format, see the [packets](packets.md) article.

### Handshake

First, the client sends a [Handshake](protocol.md#handshake) packet with its state set to 1.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td rowspan="4">0x00</td>
      <td>Protocol Version</td>
      <td>`VarInt`</td>
      <td>See [protocol version numbers](protocol-version-numbers.md). The version that the client plans on using to connect to the server (which is not important for the ping). If the client is pinging to determine what version to use, by convention `-1` should be set.
{{Warning|Setting invalid (nonexistent) version as the protocol version <i>might</i> cause some servers to close connection after this packet}}<br/>
{{Warning|See [Protocol version numbers](protocol-version-numbers.md) for a list of valid protocol versions.}}</td>
    </tr>
    <tr>
      <td>Server Address</td>
      <td>`String`</td>
      <td>Hostname or IP, e.g. localhost or 127.0.0.1, that was used to connect. The Notchian server does not use this information. Note that SRV records are a complete redirect, e.g. if _minecraft._tcp.example.com points to mc.example.org, users connecting to example.com will provide mc.example.org as server address in addition to connecting to it.</td>
    </tr>
    <tr>
      <td>Server Port</td>
      <td>`Unsigned Short`</td>
      <td>Default is 25565. The Notchian server does not use this information.</td>
    </tr>
    <tr>
      <td>Next state</td>
      <td>`VarInt`</td>
      <td>1 for [status](protocol.md#status), 2 for [login](protocol.md#login), 3 for [transfer](protocol.md#login)</td>
    </tr>
  </tbody>
</table>

### Status Request

The client follows up with a [Status Request](protocol.md#status-request) packet. This packet has no fields.
The client is also able to skip this part entirely and send a [Ping Request](protocol.md#ping-request) instead.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>0x00</td>
      <td colspan="3">*no fields*</td>
    </tr>
  </tbody>
</table>

### Status Response

The server should respond with a [Status Response](protocol.md#status-response) packet. Note that Notchian servers will for unknown reasons wait to receive the following [Ping Request](protocol.md#ping-request) packet for 30 seconds before timing out and sending Response.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>0x00</td>
      <td>JSON Response</td>
      <td>`String`</td>
      <td>See below; as with all strings this is prefixed by its length as a VarInt(3-byte max)</td>
    </tr>
  </tbody>
</table>

The JSON Response field is a [JSON](wikipedia-json.md) object which has the following format:

```json
{
    "version": {
        "name": "1.21.5",
        "protocol": 770
    },
    "players": {
        "max": 100,
        "online": 5,
        "sample": [
            {
                "name": "thinkofdeath",
                "id": "4566e69f-c907-48ee-8d71-d7ba5aa00d20"
            }
        ]
    },
    "description": {
        "text": "Hello, world!"
    },
    "favicon": "data:image/png;base64,<data>",
    "enforcesSecureChat": false
}
```

The *name* field of the *version* object should be considered mandatory. On newer Notchian client versions (1.20+?), it may be omitted and will be treated as though it were the string "Old" if so.

The *description* field is optional. If specified, it should be a [text component](text-formatting.md#text-components). Note that the Notchian server has no way of providing actual text component data; instead section sign-based codes are embedded within the text of the object. However, third-party servers such as Spigot and Paper will return full components, so make sure you can handle both.

The *favicon* field is optional. If specified, it should be a [PNG](wikipedia-portable-network-graphics.md) image that is [Base64](wikipedia-base64.md) encoded (without newlines: `\n`, new lines no longer work since 1.13) and prepended with `data:image/png;base64,`. It should also be noted that the source image must be exactly 64x64 pixels, otherwise the Notchian client will not render the image.

The *players* field is optional. If omitted, "???" will be displayed in dark grey in place of the player count.

The numbers *max* and *online* in the players field have a maximum supported value of 2<sup>31</sup>-1 (2,147,483,647) by the vanilla Minecraft server. Larger values were observed to be set to the default value of 20.

If the *sample* field of the *players* object is present, the player names (but not their UUIDs) will be shown in order in the tooltip when hovering over the player count (or version name if incompatible). If empty, missing, or the wrong type, no tooltip will appear. Notchian servers will omit this field if there are no players on the server or if `hide-online-players` is false. There doesn't appear to be a hard limit on how many players may be specified.

If a client [has "Allow Server Listings" set to "OFF"](protocol.md#clientinformation28configuration29), Notchian servers will report their name as "Anonymous Player" and UUID as "00000000-0000-0000-0000-000000000000". This is not reliable; making a request before the player has fully joined may cause their choice to not be respected.

On most Notchian client versions, UUIDs are mandatory and must be well formed even though it is unused by Notchian clients. Newer versions (1.20+?) will tolerate malformed or missing UUIDs and act as though *sample* was omitted if so.

If the server has No Chat Reports installed and hasn't disabled this feature, an additional field *preventsChatReports* will be added to the end with a value of true causing clients with No Chat Reports to display an icon indicating the server is a "Safe Server".

After receiving the Response packet, the client may send the next packet to help calculate the server's latency, or if it is only interested in the above information it can disconnect here.

If the client does not receive a properly formatted response (e.g. a field is missing or the wrong type), it will close the socket and instead attempt a [legacy ping](server_list_ping.md#16).

### Ping Request

If the process is continued, the client will now send a [Ping Request](protocol.md#ping-request) packet containing some payload which is not important.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>0x01</td>
      <td>Payload</td>
      <td>`Long`</td>
      <td>May be any number. Notchian clients use a system-dependent time value which is counted in milliseconds.</td>
    </tr>
  </tbody>
</table>

### Pong Response

The server will respond with the [Pong Response](protocol.md#pong-response) packet and then close the connection.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet ID</th>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>0x01</td>
      <td>Payload</td>
      <td>`Long`</td>
      <td>Should be the same as sent by the client</td>
    </tr>
  </tbody>
</table>

### Ping via LAN (Open to LAN in Singleplayer)

In Singleplayer there is a function called "Open to LAN". Minecraft (in the serverlist) binds a UDP port and listens for connections to `224.0.2.60:4445` (Yes, that is the actual IP, no matter in what network you are or what your local IP Address is). If you click on "Open to LAN" Minecraft sends a packet every 1.5 seconds to the address: `[MOTD]{motd}[/MOTD][AD]{port}[/AD]`. Minecraft seems to check for the following Strings: `[MOTD]`, `[/MOTD]`, `[AD]`, `[/AD]`. Anything you write outside of each of the tags will be ignored. Color codes may be used in the MOTD. Between `[AD]` and `[/AD]` is the servers port. If it is not numeric, 25565 will be used. If it is out of range, an error is being displayed when trying to connect. The IP Address is the same as the senders one. The string is encoded with UTF-8.

To implement it server side, just send a packet with the text (payload) to `224.0.2.60:4445`. If you are client side, bind a UDP socket and listen for connections. You can use a `MulticastSocket` for that.

### Examples

- [C#](https://gist.github.com/csh/2480d14fbbb33b4bbae3)
- [Java](https://gist.github.com/zh32/7190955)
- [Python](https://gist.github.com/1209061)
- [Rust (Server)](https://github.com/Duckulus/mc-honeypot)
- [MCClient-lib (Python3)](https://github.com/Sch8ill/MCClient-lib)
- [Python3](https://gist.github.com/ewized/97814f57ac85af7128bf)
- [PHP](https://github.com/xPaw/PHP-Minecraft-Query)
- [LAN Server Listener (Java)](https://gitlab.bixilon.de/bixilon/minosoft/-/blob/43d8988ef94b6487e4da0218d87cf66ccf14a1ea/src/main/java/de/bixilon/minosoft/protocol/protocol/LANServerListener.java)
- [LAN Server Listener (Kotlin)](https://gitlab.bixilon.de/bixilon/minosoft/-/blob/master/src/main/java/de/bixilon/minosoft/protocol/protocol/LANServerListener.kt)
- [Swift](https://github.com/stackotter/delta-client/blob/main/Sources/Core/Sources/Network/LANServerEnumerator.swift)
- [Go](https://github.com/dreamscached/minequery)
- [Go](https://github.com/Sch8ill/mclib)
- [Node.js](https://github.com/PauldeKoning/minecraft-server-handshake)
- [C](https://github.com/LhAlant/MinecraftSLP/)
- [Go](https://github.com/mcstatus-io/mcutil/)

## 1.6

This uses a protocol which is compatible with the client-server protocol as it was before the Netty rewrite. Modern servers recognize this protocol by the starting byte of `fe` instead of the usual `00`.

### Client to server

The client initiates a TCP connection to the server on the standard port. Instead of doing auth and logging in (as detailed in [Protocol](protocol.md) and [Protocol Encryption](protocol-encryption.md)), it sends the following data, expressed in hexadecimal:

1. `FE` — packet identifier for a server list ping
1. `01` — server list ping's payload (always 1)
1. `FA` — packet identifier for a plugin message
1. `00 0B` — length of following string, in characters, as a short (always 11)
1. `00 4D 00 43 00 7C 00 50 00 69 00 6E 00 67 00 48 00 6F 00 73 00 74` — the string `MC|PingHost` encoded as a [UTF-16BE](http://en.wikipedia.org/wiki/UTF-16) string
1. `XX XX` — length of the rest of the data, as a short. Compute as `7 + len(hostname)`, where `len(hostname)` is the number of bytes in the UTF-16BE encoded hostname.
1. `XX` — [protocol version](protocol-version-numbers.md#versions-before-the-netty-rewrite), e.g. `4a` for the last version (74)
1. `XX XX` — length of following string, in characters, as a short
1. `...` — hostname the client is connecting to, encoded as a [UTF-16BE](http://en.wikipedia.org/wiki/UTF-16) string
1. `XX XX XX XX` — port the client is connecting to, as an int.

All data types are big-endian.

Example packet dump:

 0000000: fe01 fa00 0b00 4d00 4300 7c00 5000 6900  ......M.C.|.P.i.
 0000010: 6e00 6700 4800 6f00 7300 7400 1949 0009  n.g.H.o.s.t..I..
 0000020: 006c 006f 0063 0061 006c 0068 006f 0073  .l.o.c.a.l.h.o.s
 0000030: 0074 0000 63dd                           .t..c.

**Note: ** All notchian servers only cares about the first 3 bytes. After reading `FE 01 FA`, the response will be sent to the client. For backward compatibility, you could only send these 3 bytes and all legacy servers(<=1.6) will respond correspondingly.

### Server to client

The server responds with a 0xFF kick packet. The packet begins with a single byte identifier `ff`, then a two-byte big endian short giving the length of the following string in characters. You can actually ignore the length because the server closes the connection after the response is sent.

After the first 3 bytes, the packet is a UTF-16BE string. It begins with two characters: `§1`, followed by a null character. On the wire these look like `00 a7 00 31 00 00`.

The remainder is null character (that is `00 00`) delimited fields:

1. Protocol version (e.g. `47`)
1. Minecraft server version (e.g. `1.4.2`)
1. Message of the day (e.g. `A Minecraft Server`)
1. Current player count
1. Max players

The entire packet looks something like this:

                 <---> first character
 0000000: ff00 2300 a700 3100 0000 3400 3700 0000  ....§.1...4.7...
 0000010: 3100 2e00 3400 2e00 3200 0000 4100 2000  1...4...2...A. .
 0000020: 4d00 6900 6e00 6500 6300 7200 6100 6600  M.i.n.e.c.r.a.f.
 0000030: 7400 2000 5300 6500 7200 7600 6500 7200  t. .S.e.r.v.e.r.
 0000040: 0000 3000 0000 3200 30                   ..0...2.0

**Note: ** When using this protocol with servers on version 1.7.x and above, the protocol version (first field) in the response will always be `127` which is not a real protocol number, so older clients will always consider this server incompatible.

### Examples

- [Ruby](https://gist.github.com/6281388)
- [PHP](https://github.com/winny-/mcstat)
- [Rust (Server)](https://github.com/Duckulus/mc-honeypot/blob/1514807e8af7f7cbfd13111fec334b9f4883b605/src/server/legacy.rs)
- [Go](https://github.com/dreamscached/minequery)
- [Go](https://github.com/mcstatus-io/mcutil)

## 1.4 to 1.5

Prior to the Minecraft 1.6, the client to server operation is much simpler, and only sends `FE 01`, with none of the following data.

### Examples

- [Python3 (MCClient-lib)](https://github.com/Sch8ill/MCClient-lib)
- [PHP](https://gist.github.com/5795159)
- [Java](https://gist.github.com/4574114)
- [C#](https://gist.github.com/6223787)
- [Go](https://github.com/dreamscached/minequery)
- [Go](https://github.com/mcstatus-io/mcutil)

## Beta 1.8 to 1.3

Prior to Minecraft 1.4, the client only sends `FE`. 

The server should respond with a kick packet:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>Packet Id</td>
      <td>`Byte`</td>
      <td>The kick packet id: `0xFF`</td>
    </tr>
    <tr>
      <td>Packet Length</td>
      <td>`Short`</td>
      <td>The length of the following string in characters (NOT BYTES). Max is 256.</td>
    </tr>
    <tr>
      <td>MOTD</td>
      <td rowspan="3">A [UTF-16BE](http://en.wikipedia.org/wiki/UTF-16) encoded string</td>
      <td>From here on out, all fields should be separated with `§`, in the same string.</td>
    </tr>
    <tr>
      <td>Online Players</td>
      <td>The count of players currently on the server.</td>
    </tr>
    <tr>
      <td>Max Players</td>
      <td>The maximum amount of players that the server is willing to accept.</td>
    </tr>
  </tbody>
</table>

The entire packet looks something like this on wire:

                 <---> first character
 0000000: ff00 1700 4100 2000 4d00 6900 6e00 6500  ....A. .M.i.n.e.
 0000010: 6300 7200 6100 6600 7400 2000 5300 6500  c.r.a.f.t. .S.e.
 0000020: 7200 7600 6500 7200 a700 3000 a700 3100  r.v.e.r.§.0.§.1.
 0000030: 30                                       0

[Category:Protocol Details](category-protocol-details.md)
[Category:Java Edition protocol](category-java-edition-protocol.md)
_Content is licensed under wiki.vg terms._
