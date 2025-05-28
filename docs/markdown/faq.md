People very, very often have questions regarding the [*Java Edition* protocol](java-edition-protocol.md), so we'll try to address some of the most common ones on this document. If you're still having trouble, join us on the [Minecraft Wiki's Discord server](mcw-discord.md), the [Minecraft Protocol Discord server](https://discord.gg/Tf4xwK3Ke7) or our IRC channel [ircs://irc.libera.chat:6697/mcdevs #mcdevs on irc.libera.chat].

## Is the protocol documentation complete?
Depending on your definition, *yes*! All packet types are known and their layout documented. Some finer details are missing, but everything you need to make functional programs is present. We also collect information on the [pre-release protocol](development-version.md) changes, allowing us to quickly document new releases.

## What's the normal login sequence for a client?

(This is about joining a Minecraft server. See [Microsoft authentication](microsoft-authentication.md) for how to log in to a Minecraft account, and [protocol encryption](protocol-encryption.md) for details on player authentication during server login.)

The recommended login sequence as of 1.21 looks like this, where **C** is the client and **S** is the server:
1. Client connects to the server
1. **C**→**S**: [Handshake](packets.md#handshake) State=2
1. **C**→**S**: [Login Start](packets.md#login-start)
1. **S**→**C**: [Encryption Request](packets.md#encryption-request) (optional)
1. Client auth (Only if server sent Encryption Request)
1. **C**→**S**: [Encryption Response](packets.md#encryption-response) (Only if server sent Encryption Request)
1. Server auth, both enable encryption (Only if server sent Encryption Request)
1. **S** → **C**: [Set Compression](packets.md#set-compression) (Optional, enables compression)
1. **S** → **C**: [Login Success](packets.md#login-success)
1. **C** → **S**: [Login Acknowledged](packets.md#login-acknowledged)
1. **C** → **S**: [Serverbound Plugin Message](packets.md#serverbound-plugin-message-configuration) (Optional, [`minecraft:brand`](plugin-channel.md#minecraft3abrand) with the client's brand)
1. **C** → **S**: [Client Information](packets.md#client-information-configuration) (Optional)
1. **S** → **C**: [Clientbound Plugin Message](packets.md#clientbound-plugin-message-configuration) (Optional, [`minecraft:brand`](plugin-channel.md#minecraft3abrand) with the server's brand)
1. **S** → **C**: [Feature Flags](packets.md#feature-flags) (Optional)
1. **S** → **C**: [Clientbound Known Packs](packets.md#clientbound-known-packs)
1. **C** → **S**: [Serverbound Known Packs](packets.md#serverbound-known-packs)
1. **S** → **C**: [Registry Data](packets.md#registry-data) (Multiple)
1. **S** → **C**: [Update Tags](packets.md#update-tags-configuration) (Optional)
1. **S** → **C**: [Finish Configuration](packets.md#finish-configuration)
1. **C** → **S**: [Acknowledge Finish Configuration](packets.md#acknowledge-finish-configuration)
1. **S** → **C**: [Login (play)](packets.md#login-play)
1. **S** → **C**: [Change Difficulty](packets.md#change-difficulty) (Optional)
1. **S** → **C**: [Player Abilities](packets.md#player-abilities-clientbound) (Optional)
1. **S** → **C**: [Set Held Item](packets.md#set-held-item-clientbound) (Optional)
1. **S** → **C**: [Update Recipes](packets.md#update-recipes) (Optional)
1. **S** → **C**: [Entity Event](packets.md#entity-event) (Optional, for the [OP permission level](server.properties.md#op-permission-level); see [Entity statuses#Player](entity-statuses.md#player))
1. **S** → **C**: [Commands](packets.md#commands) (Optional)
1. **S** → **C**: [Update Recipe Book](packets.md#update-recipe-book) (Optional)
1. **S** → **C**: [Synchronize Player Position](packets.md#synchronize-player-position)
1. **C** → **S**: [Confirm Teleportation](packets.md#confirm-teleportation)
1. **C** → **S**: [Set Player Position and Rotation](packets.md#set-player-position-and-rotation) (Optional, to confirm the spawn position)
1. **S** → **C**: [Server Data](packets.md#server-data) (Optional)
1. **S** → **C**: [Player Info Update](packets.md#player-info-update) (Add Player action, all players except the one joining (the vanilla server separates these, you don't need to))
1. **S** → **C**: [Player Info Update](packets.md#player-info-update) (Add Player action, joining player)
1. **S** → **C**: [Initialize World Border](packets.md#initialize-world-border) (Optional)
1. **S** → **C**: [Update Time](packets.md#update-time) (Optional)
1. **S** → **C**: [Set Default Spawn Position](packets.md#set-default-spawn-position) (Optional, “home” spawn, not where the client will spawn on login)
1. **S** → **C**: [Game Event](packets.md#game-event) (Start waiting for level chunks event, required for the client to spawn)
1. **S** → **C**: [Set Ticking State](packets.md#set-ticking-state) (Optional)
1. **S** → **C**: [Step Tick](packets.md#step-tick) (Optional, the vanilla server sends this regardless of ticking state)
1. **S** → **C**: [Set Center Chunk](packets.md#set-center-chunk)
1. **S** → **C**: [Chunk Data and Update Light](packets.md#chunk-data-and-update-light) (One sent for each chunk in a circular area centered on the player's position)
1. **S** → **C**: inventory, entities, etc.

### Offline mode
If the vanilla server is in offline mode, it will not send the [Encryption Request](packets.md#encryption-request) packet, and likewise, the client should not send [Encryption Response](packets.md#encryption-response). In this case, encryption is never enabled, and no authentication is performed.

Clients can tell that a server is in offline mode if the server sends a [Login Success](packets.md#login-success) without sending [Encryption Request](packets.md#encryption-request).

Versions 1.20.5 and newer support protocol encryption in offline mode, in which case the [Encryption Request](packets.md#encryption-request) packet can be sent with Should Authenticate set to false, and both the client and server should not authenticate with Mojang. However, it's currently not possible to configure the vanilla server to do this.

## What does the normal status ping sequence look like?
When a vanilla client and server exchange information in a status ping, the exchange of packets will be as follows:

1. **C** → **S**: [Handshake](packets.md#handshake) with Next State set to 1 ([Status](packets.md#status))
1. Client and Server set protocol state to [Status](packets.md#status).
1. **C** → **S**: [Status Request](packets.md#status-request)
1. **S** → **C**: [Status Response](packets.md#status-response)
1. **C** → **S**: [Ping Request](packets.md#ping-request-status)
1. **S** → **C**: [Ping Response](packets.md#ping-response-status)
1. Both sides close the connection

(Note that **C** is the vanilla client and **S** is the vanilla server).

The [Ping Request](packets.md#ping-request-status) packet may be left out, however the client will not receive a [Ping Response](packets.md#ping-response-status) packet and the server won't close the connection.

## I think I've done everything right, but…
### …my player isn't spawning!

The Minecraft client will wait at the "Loading Terrain..." screen until late in the login sequence. As of 1.21.4 (and starting with 1.20.3), in order for the client to spawn, it must have received a [Game Event](packets.md#game-event) packet with event 13 ("Start waiting for level chunks"), and at least one of the following conditions must be met:

- The player is in a loaded chunk (sent via [Chunk Data and Update Light](packets.md#chunk-data-and-update-light)).
- The player is below the minimum world height or above the maximum world height (teleported via [Synchronize Player Position](packets.md#synchronize-player-position)).
- The player is in spectator mode.
- The player is dead (set via [Set Health](packets.md#set-health) or [Combat Death](packets.md#combat-death)).

The client will also spawn after spending 30 seconds in the loading screen, even if it never received Game Event 13.

In past versions, you could either (1.19.3 through 1.20.2) send the default spawn position packet or (pre-1.19.3) send the player position packet. In general, try sending packets that inform the client about the player's position in the world in order to get past the loading terrain screen.

In version 1.21, it became required to send the known packs packet with `minecraft:core` version `1.21`.

As of 1.21.4, the minimum packets that need to be received and sent by the server in order to get the client past the loading terrain screen and into the world appear to be:

1. Receive [Handshake](packets.md#handshake)
1. Receive [Login Start](packets.md#login-start)
1. Send [Login Success](packets.md#login-success)
1. Receive [Login Acknowledged](packets.md#login-acknowledged)
1. Send [Clientbound Known Packs](packets.md#clientbound-known-packs)
1. Receive [Serverbound Known Packs](packets.md#serverbound-known-packs)
1. Send multiple [Registry Data](packets.md#registry-data)
1. Send [Finish Configuration](packets.md#finish-configuration)
1. Receive [Acknowledge Finish Configuration](packets.md#acknowledge-finish-configuration)
1. Send [Login (Play)](packets.md#login-28play29)
1. Send [Game Event](packets.md#game-event), Start waiting for level chunks
1. Send [Chunk Data and Update Light](packets.md#chunk-data-and-update-light) and/or [Synchronize Player Position](packets.md#synchronize-player-position) (see above)

The most difficult part of this may be sending any necessary NBTs in the [Registry Data](java-edition-protocol.md#registrydata) packet. Note that if you tell the vanilla client you have 0 known packs, it will blatantly lie to you, so you will probably need to record one from the standard server and replay it. Or you can find someone who has done that already, for example in [Norbiros' gist](https://gist.github.com/Norbiros/f604ce46821e68c50260a169a9921560). You can also find JSON representation of this packet in [PrismarineJS/minecraft-data repo on GitHub](https://github.com/PrismarineJS/minecraft-data/blob/master/data/pc/1.20.2/loginPacket.json).

### …chunks are randomly showing and disappearing!
The vanilla client only reliably renders chunks surrounded by other loaded chunks on all sides. See [Chunk Format#Tips and notes](chunk-format.md#tips-and-notes).

### …the client is trying to send an invalid packet that begins with 0xFE01
The client is attempting a [legacy ping](server_list_ping.md#16), this happens if your server did not respond to the [Server List Ping](server-list-ping.md) properly, including if it sent malformed JSON.

### …the client disconnects after some time with a "Timed out" error
The server is expected to send a [Keep Alive](packets.md#keep-alive-clientbound) packet every 1-15 seconds (if the server does not send a keep alive within 20 seconds of state change to Play, the client will disconnect from the server for **Timed Out**), and the client should respond with the serverbound version of that packet. If either party does not receive keep alives for some period of time, they will disconnect.

### ...some of the packets I expect to receive seem to be missing or too short

You may be misusing the socket API. In particular, it is invalid to assume that the amount of data returned by calls to `recv` (or equivalent, depending on the API you're using) relates to packet boundaries in any way. There are no "borders" in a [TCP](wikipedia-transmission-control-protocol.md) data stream, only bytes. Regardless of how any two consecutive packets are sent, the receiver may get one packet, then the other, both at once, half of one, then the rest of both, or any other permutation of buffer sizes adding up to the total size of the packets. The only correct way to know where one packet ends and another begins is the packet length field, and you need to be prepared to handle multiple packets in one buffer, packets split across multiple buffers, etc. (as well as length fields split across multiple buffers!)

Similarly, depending on the API being used, a `send` call may also not guarantee that its whole input buffer is sent (consult the relevant documentation for details). This may also cause the connection to appear to hang during the login process, since the server will be left waiting indefinitely for the rest of the packet to arrive.

One reason why packets sent separately may arrive at once is [Nagle's algorithm](wikipedia-nagles-algorithm.md), a feature of many TCP implementations intended to improve efficiency particularly for applications making lots of small `send` calls. It is not the *only* reason, though, and disabling it should not be seen as a solution to the problem discussed here. Nonetheless, the delays it introduces are detrimental to real-time applications like Minecraft, so the vanilla client and server disable it, and you should too. This is typically done by enabling a socket option called `TCP_NODELAY`. Especially when disabling Nagle's algorithm, you should group multiple packets sent during the same tick in one send buffer for the best performance.

## Navigation
{{Navbox Java Edition technical|General}}

[Category:Protocol Details](category-protocol-details.md)
[Category:Java Edition protocol](category-java-edition-protocol.md)
_Content is licensed under wiki.vg terms._
