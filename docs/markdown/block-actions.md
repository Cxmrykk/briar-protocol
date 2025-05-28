These block actions are used in the [Block Action](packets.md#block-action) packet.  Depending on the block, different action IDs mean different things: __NOTOC__

<table class="wikitable">
  <tbody>
    <tr>
      <th>Block</th>
      <th>ID</th>
      <th>Section</th>
    </tr>
    <tr>
      <td>[Note Block](note-block.md)</td>
      <td>`minecraft:note_block`</td>
      <td>[[#Note Block|Note Block]]</td>
    </tr>
    <tr>
      <td>[Piston](piston.md)</td>
      <td>`minecraft:piston`</td>
      <td rowspan="2">[[#Piston|Piston]]</td>
    </tr>
    <tr>
      <td>[Sticky Piston](sticky-piston.md)</td>
      <td>`minecraft:sticky_piston`</td>
    </tr>
    <tr>
      <td>[Chest](chest.md)</td>
      <td>`minecraft:chest`</td>
      <td rowspan="3">[[#Chest|Chest]]</td>
    </tr>
    <tr>
      <td>[Trapped Chest](trapped-chest.md)</td>
      <td>`minecraft:trapped_chest`</td>
    </tr>
    <tr>
      <td>[Ender Chest](ender-chest.md)</td>
      <td>`minecraft:ender_chest`</td>
    </tr>
    <tr>
      <td>[Mob Spawner](mob-spawner.md)</td>
      <td>`minecraft:mob_spawner`</td>
      <td>[[#Spawner|Spawner]]</td>
    </tr>
    <tr>
      <td>[End Gateway](end-gateway.md)</td>
      <td>`minecraft:end_gateway`</td>
      <td>[[#End Gateway|End Gateway]]</td>
    </tr>
    <tr>
      <td>[Shulker Box](shulker-box.md)</td>
      <td>`minecraft:shulker_box`
`minecraft:*<color>*_shulker_box`</td>
      <td>[[#Shulker Box|Shulker Box]]</td>
    </tr>
    <tr>
      <td>[Bell](bell.md)</td>
      <td>`minecraft:bell`</td>
      <td>[[#Bell|Bell]]</td>
    </tr>
    <tr>
      <td>[Decorated Pot](decorated-pot.md)</td>
      <td>`minecraft:decorated_pot`</td>
      <td>[[#Decorated Pot|Decorated Pot]]</td>
    </tr>
    <tr>
      <td colspan="2">Anything else</td>
      <td>Ignored</td>
    </tr>
  </tbody>
</table>

## Note Block

Displays a colored note particle and plays the appropriate note sound effect.

In 1.13, the parameters are no longer used to determine what effect to use; instead, the information is obtained from the block state.

More information about how the pitch values correspond to notes in real life and how they correspond to pitch scaling on the sound effects can be found in the [Note Block](note-block.md) article on the Minecraft wiki.

### Action IDs

Ignored, always 0.

### Action Parameters

Ignored, always 0.

## Piston

Controls the state of the piston and affected blocks. Always used on the piston base (either sticky or regular), never on the head.

{{Missing information|The tick logic for moving piston block entities is the roughly the same for both client and server, except that the client will wait an extra 5 ticks before setting the pushed blocks to their new state. Why does this happen? Why does the client even set the new blocks on its own in the first place, if their final state is going to be received by the server anyway? Is it a lag-compensation mechanism?}}

Upon receiving this action, the Notchian client is responsible for:
- Calculating if the action is possible, and which blocks will be affected;
- Changing pushed blocks into `MOVING_PISTON` blocks and their respective moving piston block entities (client-side only);
- Changing the pushed blocks' new block states once the action is finished (action takes 3 ticks, but blocks are set after an extra 5 ticks; client-side only).

On the other hand, the server Notchian server is responsible for:
- Calculating if the action is possible, and which blocks will be affected;
- Initiating the actual action through the [Block Action](protocol.md#blockaction) packet;
- Playing the piston extend/retract sound;
- Changing pushed blocks into `MOVING_PISTON` blocks and their respective moving piston block entities (server-side only);
- Immediately sending updates for blocks that would be destroyed by the piston action (through [Block Update](protocol.md#blockupdate) or [Update Section Blocks](protocol.md#updatesectionblocks));
- Calculate entity collision mid-push/mid-pull and update their position accordingly;
- Changing the pushed blocks' new block states once the action is finished (after 3 ticks, through [Block Update](protocol.md#blockupdate) or [Update Section Blocks](protocol.md#updatesectionblocks)).


{{warning|Some important points to be noted about the Notchian implementations are:
- The calculation for blocks to be pushed/destroyed is the same on both server and client, and they rely on that assumption. Attempting to change the logic in one side may lead to de-sync issues.
- Although the server creates `MOVING_PISTON` blocks and moving piston block entities, they're not sent to the client, and are kept on the server merely to keep track of the action progression (to handle collision, block changes upon completion etc.). The client is responsible for creating such blocks and entities on its side upon receiving [Block Action](protocol.md#blockaction) packet.
- `MOVING_PISTON` blocks and moving piston block entities can be received in a [Chunk Data](protocol.md#chunkdataandupdatelight) packet. However, the block entity data is ignored by the client and `MOVING_PISTON` blocks are set in their default state (empty). This could potentially be intentional, as the piston animation is short (3 ticks long), and the client will subsequently receive updates for the final block states from the server;}}

### Action IDs

**0** to extend the piston, **1** to retract it, and **2** to cancel an ongoing extension.

In Notchian implementations, action ID **2** is defined by when a piston is retracted (e.g.: due to loss of power) mid-extension. The semantics for this action also change based on the type of piston:
- if the piston is a normal one, the action has the same result as a normal retraction;
- if the piston is a sticky one, it will be retracted without pulling any blocks.

> ⚠️ **Warning:** Sending an extension action to an already-extended piston has no effect, but sending retraction actions to an already-retracted piston may cause undesired results, such as the block directly in front of the piston head dissappearing on the client.

### Action Parameters

The direction the piston is facing.

Any value can be sent for piston extension, since the direction is infered from the piston's block state, but it must match the actual direction for piston retractions (action ID **1** and **2**).

> ⚠️ **Warning:** Sending a mismatched direction for piston extension has no effect, but sending a mismatched direction to piston retractions will cause the piston block to assume the new sent direction on the client.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Direction ID</th>
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
      <td>South</td>
    </tr>
    <tr>
      <td>3</td>
      <td>West</td>
    </tr>
    <tr>
      <td>4</td>
      <td>North</td>
    </tr>
    <tr>
      <td>5</td>
      <td>East</td>
    </tr>
  </tbody>
</table>

## Chest

### Action IDs

There is only one action, with ID **1**. It is used to update the number of players who are looking in the chest, which in turn is used to update lid animation.

The Notchian server sends this whenever a player opens or closes the chest, and every 5 ticks (0.25 seconds) while at least one player has the chest open.

### Action Parameters

When the action ID is 1, this is the number of players who have the chest open. If 0, then the chest is closed; if 1 or more the chest is open.

## Spawner

### Action ID

There is only one action, with ID **1**, which resets the delay in the spawner to the minimum spawn delay.

### Action Parameters

Ignored.

## End Gateway

### Action ID

There is only one action, with ID **1**, which triggers the [purple beam](end-gateway-block.md#beam) emitted by the end gateway when an entity passes through it.

### Action Parameters

Ignored.

## Shulker Box

Animates the shulker box's shell opening.

### Action IDs

There are 2 actions: 1, which updates the number of players who are looking in the shulker box, and 0, which indicates the opening or closing of the shulker box.

### Action Parameters

If the action is 1, updates the number of players who have the shulker box open.  If 0, the shulker box enters its closing animation; if 1, the shulker box enters its opening animation.

## Bell

Causes the bell to perform the ring animation.  The ring sound is handled in a separate [Sound Effect](protocol.md#sound-effect) packet.

### Action IDs

There is only one action: 1, which triggers the bell animation.

### Action Parameters

If the action is 1, this is the direction from which the bell was rung (down=0, up=1, north=2, south=3, west=4, east=5).  If the bell was rung by a player, this is the face of the block they clicked on; otherwise, it is based on the bell's facing state.  After 5 ticks, if there are raiders nearby, the bell resonates and 40 ticks later causes them to glow for 60 ticks.  Whether there are raiders nearby will only be recalculated if 60 ticks have passed since the last recalculation.

## Decorated Pot

### Action ID

There is only one action, with ID **1**, which causes the decorated pot to play a wobble animation.

### Action Parameters

The wobble animation is played when inserting items to the pot, the parameter changes the "wobble style", **0** if the interaction is positive, **1** if negative and items could not be inserted.

[Category:Protocol Details](category-protocol-details.md)
[Category:Java Edition protocol](category-java-edition-protocol.md)
_Content is licensed under wiki.vg terms._
