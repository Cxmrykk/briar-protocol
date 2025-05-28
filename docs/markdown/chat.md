> _Hatnote: This page previously contained documentation on text formatting features, which can now be found at [Text_component_format](text_component_format.md)._

This article details various aspects of Minecraft's chat system. The packets themselves are documented in [Java Edition protocol/Packets](packets.md).

## Client chat mode

The client may use the Chat Mode field of the [Client Information](packets.md#client-information-configuration) packet to indicate that it only wants to receive some types of chat messages.

It is the server's responsibility to not send packets if the client has the given type disabled.  However, it is the client's responsibility to not send incorrect chat packets.

Here's a matrix comparing what packets the server should send to clients based on their chat settings:

<table class="wikitable">
  <tbody>
    <tr>
      <th rowspan="2">Clientbound packet</th>
      <th colspan="3">Client setting</th>
      <th rowspan="2">Usage</th>
    </tr>
    <tr>
      <th>Full</th>
      <th>Commands only</th>
      <th>Hidden</th>
    </tr>
    <tr>
      <td>[Player Chat Message](packets.md#player-chat-message)</td>
      <td>{{tc|yes|✔}}</td>
      <td>{{tc|no|✘}}</td>
      <td>{{tc|no|✘}}</td>
      <td>Player-initiated chat messages, including the commands `/say`, `/me`, `/msg`, `/tell`, `/w` and `/teammsg`.</td>
    </tr>
    <tr>
      <td>[Disguised Chat Message](packets.md#disguised-chat-message)</td>
      <td>{{tc|yes|✔}}</td>
      <td>{{tc|no|✘}}</td>
      <td>{{tc|no|✘}}</td>
      <td>Messages sent by non-players using the commands `/say`, `/me`, `/msg`, `/tell`, `/w` and `/teammsg`.</td>
    </tr>
    <tr>
      <td>[System Chat Message](packets.md#system-chat-message)</td>
      <td>{{tc|yes|✔}}</td>
      <td>{{tc|yes|✔}}</td>
      <td>{{tc|no|✘}}</td>
      <td>Feedback from running a command, such as "Your game mode has been updated to creative."</td>
    </tr>
    <tr>
      <td>[System Chat Message](packets.md#system-chat-message) (overlay)</td>
      <td>{{tc|yes|✔}}</td>
      <td>{{tc|yes|✔}}</td>
      <td>{{tc|yes|✔}}</td>
      <td>Game state information that is displayed above the hot bar, such as "You may not rest now, the bed is too far away".</td>
    </tr>
  </tbody>
</table>

Here's a matrix comparing what the client may send based on its chat setting:

<table class="wikitable">
  <tbody>
    <tr>
      <th rowspan="2">Serverbound packet</th>
      <th colspan="3">Client setting</th>
    </tr>
    <tr>
      <th>Full</th>
      <th>Commands only</th>
      <th>Hidden</th>
    </tr>
    <tr>
      <td>[Chat Message](packets.md#chat-message)</td>
      <td>{{tc|yes|✔}}</td>
      <td>{{tc|partial|✘ (This behavior varies.  The Notchian server <em>previously</em> rejected chat messages, but now allows them to go through (sending them to all players, but they're invisible on the sender's side).  CraftBukkit and derivatives continue to reject this.  See [MC-116824](https://bugs.mojang.com/browse/MC-116824) for more information.) }}</td>
      <td>{{tc|no|✘}}</td>
    </tr>
    <tr>
      <td>[Chat Command](packets.md#chat-command)</td>
      <td>{{tc|yes|✔}}</td>
      <td>{{tc|yes|✔}}</td>
      <td>{{tc|no|✘}}</td>
    </tr>
  </tbody>
</table>

If the client attempts to send a chat message and the server rejects it, the Notchian server will send that client a [System Chat Message](packets.md#system-chat-message) (non-overlay) with a red `chat.disabled.options` translation component (which becomes "Chat disabled in client options.").

## Social Interactions (blocking)

1.16 added a *social interactions screen* that lets players block chat from other players. Blocking takes place clientside by detecting whether a message is from a blocked player.

[Player Chat Message](packets.md#player-chat-message) packets are blocked based on the included sender UUID.

[Disguised Chat Message](packets.md#disguised-chat-message) packets are never blocked.

[System Chat Message](packets.md#system-chat-message) packets (regardless of the Overlay field!) are blocked based on the first occurrence of `<*playername*>` anywhere in the message, including split across multiple text components, where *playername* may be any text, including the empty string or whitespace. If *playername* is the name of a blocked player (matched case-sensitively), the message is blocked. This only occurs if Hide Matched Names is enabled in Chat Settings (the default).

## Notes



[Category:Protocol Details](category-protocol-details.md)
[Category:Java Edition protocol](category-java-edition-protocol.md)
_Content is licensed under wiki.vg terms._
