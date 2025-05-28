Registries are repositories of data that contain entries pertaining to certain aspects of the game, such as the world, the player, among others.

The ability for the server to send customized registries to the client was introduced in 1.16.3, which allows for a great deal of customization over certain features of the game.

## Overview

The server sends these registries to the client via [Registry Data](protocol.md#registrydata) packet during the configuration phase.

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
      <td rowspan="3">[Varies](protocol.md#registrydata2)</td>
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


The structure of the entries' data depends on the registry specified in the packet. The structure for each [[#Available_Registries|available registry]] is defined below.

Throughout the configuration phase, the server will send multiple [Registry Data](protocol.md#registrydata) packets, each one pertaining to a different registry.

### Client/Server Exchange

In order to save bandwidth, the server omits the data for entries pertaining to a data pack that is mutually supported by both the client and server. The exchange is as follows:

1. **S**→**C**: [Clientbound Known Packs](protocol.md#clientboundknownpacks)
1. **C**→**S**: [Serverbound Known Packs](protocol.md#serverboundknownpacks)
1. *Server computes the mutually supported data packs*
1. **S**→**C**: Multiple [Registry Data](protocol.md#registrydata) (excluding mutually supported data)

> ⚠️ **Warning:** The ordering in which the entries of a registry are sent defines the numeric ID that they will be assigned to. It is essential to maintain consistency between server and client, since many parts of the protocol reference these entries by their ID. The client will disconnect upon receiving a reference to a non-existing entry.

## Available Registries

The current release specification allows for nine different registries to be sent to the client. A brief explanation of each of them is presented below, along with the format of their entries' element field.

**Fields marked in <span style="border: solid 1px black; background: #d4ecfc; color: #d4ecfc;">__</span> blue represent data for server-side exclusive operations, and thus have no visible impact on the client.**

### Armor Trim Material

The `minecraft:trim_material` registry. It defines various visual properties of trim materials in armors. 

<table class="wikitable">
  <tbody>
    <tr>
      <th colspan="3">Name</th>
      <th colspan="2">Type</th>
      <th colspan="2">Meaning</th>
      <th colspan="2">Values</th>
    </tr>
    <tr>
      <td colspan="3">asset_name</td>
      <td colspan="2">[String Tag](nbt.md#specificationstringtag)</td>
      <td colspan="2">The trim color model to be rendered on top of the armor.
The Notchian client uses the corresponding asset located at `trims/color_palettes`.</td>
      <td colspan="2">Example: "minecraft:amethyst".</td>
    </tr>
    <tr>
      <td colspan="3">ingredient</td>
      <td colspan="2">[String Tag](nbt.md#specificationstringtag)</td>
      <td colspan="2">The ingredient used.
This has the visual effect of showing the trimmed armor model on the Smithing Table when the correct item is placed.</td>
      <td colspan="2">Example: "minecraft:copper_ingot".</td>
    </tr>
    <tr>
      <td colspan="3">item_model_index</td>
      <td colspan="2">[Float Tag](nbt.md#specificationfloattag)</td>
      <td colspan="2">Color index of the trim on the armor item when in the inventory.</td>
      <td colspan="2">Default values vary between 0.1 and 1.0.</td>
    </tr>
    <tr>
      <td colspan="3">override_armor_materials</td>
      <td colspan="2">Optional [Compound Tag](nbt.md#specificationcompoundtag)</td>
      <td colspan="2">Asset for different types of armor materials, which overrides the value specified in the asset_name field.
The Notchian client uses this to give a darker color shade when a trim material is applied to armor of the same material, such as iron applied to iron armor.</td>
      <td colspan="2">The key can be either:
* `leather`
* `chainmail`
* `iron`
* `gold`
* `diamond`
* `turtle`
* `netherite`
The value accepts the same values as asset_name.</td>
    </tr>
    <tr>
      <td colspan="3">description</td>
      <td colspan="2">[Compound Tag](nbt.md#specificationcompoundtag) or [String Tag](nbt.md#specificationstringtag)</td>
      <td colspan="2">The name of the trim material to be displayed on the armor tool-tip.
Any styling used in this component is also applied to the trim pattern description.</td>
      <td colspan="2">See [Text formatting](text-formatting.md).</td>
    </tr>
  </tbody>
</table>

### Armor Trim Pattern

The `minecraft:trim_pattern` registry. It defines various visual properties of trim patterns in armors.

> ❓ **Missing info (section):** The `decal` field seems to exist to prevent overlapping between the armor model and the trim model. What exact effect does it have?

<table class="wikitable">
  <tbody>
    <tr>
      <th colspan="3">Name</th>
      <th colspan="2">Type</th>
      <th colspan="2">Meaning</th>
      <th colspan="2">Values</th>
    </tr>
    <tr>
      <td colspan="3">asset_id</td>
      <td colspan="2">[String Tag](nbt.md#specificationstringtag)</td>
      <td colspan="2">The trim pattern model to be rendered on top of the armor.
The Notchian client uses the corresponding asset located at `trims/models/armor`.</td>
      <td colspan="2">Example: "minecraft:coast".</td>
    </tr>
    <tr>
      <td colspan="3">template_item</td>
      <td colspan="2">[String Tag](nbt.md#specificationstringtag)</td>
      <td colspan="2">The template item used for this trim.
This has the visual effect of showing the trimmed armor model on the Smithing Table when the correct item is placed.</td>
      <td colspan="2">Example: "minecraft:coast_armor_trim_smithing_template".</td>
    </tr>
    <tr>
      <td colspan="3">description</td>
      <td colspan="2">[Compound Tag](nbt.md#specificationcompoundtag) or [String Tag](nbt.md#specificationstringtag)</td>
      <td colspan="2">The name of the trim pattern to be displayed on the armor tool-tip.</td>
      <td colspan="2">See [Text formatting](text-formatting.md).</td>
    </tr>
    <tr>
      <td colspan="3">decal</td>
      <td colspan="2">[Byte Tag](nbt.md#specificationbytetag)</td>
      <td colspan="2">Whether this trim is a decal.</td>
      <td colspan="2">1: true, 0: false.</td>
    </tr>
  </tbody>
</table>

### Banner Pattern

The `minecraft:banner_pattern` registry. It defines the textures for different banner patterns. 

<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Meaning</th>
      <th>Values</th>
    </tr>
    <tr>
      <td>asset_id</td>
      <td>[String Tag](nbt.md#specificationstringtag)</td>
      <td>The texture of the pattern.
The Notchian client uses the corresponding asset located at `textures/entity/banner` or `textures/entity/shield`, depending on the case.</td>
      <td>Example: "minecraft:diagonal_left".</td>
    </tr>
    <tr>
      <td>translation_key</td>
      <td>[String Tag](nbt.md#specificationstringtag)</td>
      <td>The translation key representing the banner pattern, shown in the item's tooltip.
It is appended to the banner color when used, resulting in `<translation_key>.<color>`.</td>
      <td>Example: "block.minecraft.banner.diagonal_left.blue", which translates to "Blue Per Bend Sinister".</td>
    </tr>
  </tbody>
</table>

### Biome

The `minecraft:worldgen/biome` registry. It defines several aesthetic characteristics of the biomes present in the game.

Biome entries are referenced in the [Chunk Biomes](protocol.md#chunkbiomes) and [Chunk Data and Update Light](protocol.md#chunkdataandupdatelight) packets.

<table class="wikitable">
  <tbody>
    <tr>
      <th colspan="3">Name</th>
      <th colspan="2">Type</th>
      <th colspan="2">Meaning</th>
      <th colspan="2">Values</th>
    </tr>
    <tr>
      <td colspan="3">has_precipitation</td>
      <td colspan="2">[Byte Tag](nbt.md#specificationbytetag)</td>
      <td colspan="2">Determines whether or not the biome has precipitation.</td>
      <td colspan="2">1: true, 0: false.</td>
    </tr>
    <tr>
      <td colspan="3">temperature</td>
      <td colspan="2">[Float Tag](nbt.md#specificationfloattag)</td>
      <td colspan="2">The temperature factor of the biome.
Affects foliage and grass color if they are not explicitly set.</td>
      <td colspan="2">The default values vary between -0.5 and 2.0.</td>
    </tr>
    <tr>
      <td colspan="3">temperature_modifier</td>
      <td colspan="2">Optional [String Tag](nbt.md#specificationstringtag)</td>
      <td colspan="2">Modifier that affects the resulting temperature.</td>
      <td colspan="2">Can be either:
* `none`, for a static temperature throughout the biome (aside from variations depending on the height).
* `frozen`, for pockets of warm temperature (0.2) to be randomly distributed throughout the biome. This is used on frozen ocean variants in the Notchian client to simulate spots of unfrozen water, where it always rains instead of snowing.</td>
    </tr>
    <tr>
      <td colspan="3">downfall</td>
      <td colspan="2">[Float Tag](nbt.md#specificationfloattag)</td>
      <td colspan="2">The downfall factor of the biome.
Affects foliage and grass color if they are not explicitly set.</td>
      <td colspan="2">The default values vary between 0.0 and 1.0.</td>
    </tr>
    <tr>
      <td colspan="3">effects</td>
      <td colspan="2">[Compound Tag](nbt.md#specificationcompoundtag)</td>
      <td colspan="2">Biome special effects.</td>
      <td colspan="2">See [[#Effects|Effects]].</td>
    </tr>
  </tbody>
</table>

#### Effects

<table class="wikitable">
  <tbody>
    <tr>
      <th colspan="3">Name</th>
      <th colspan="2">Type</th>
      <th colspan="2">Meaning</th>
      <th colspan="2">Values</th>
    </tr>
    <tr>
      <td colspan="3">fog_color</td>
      <td colspan="2">[Int Tag](nbt.md#specificationinttag)</td>
      <td colspan="2">The color of the fog effect when looking past the view distance.</td>
      <td colspan="2">Example: 8364543, which is #7FA1FF in RGB.</td>
    </tr>
    <tr>
      <td colspan="3">water_color</td>
      <td colspan="2">[Int Tag](nbt.md#specificationinttag)</td>
      <td colspan="2">The tint color of the water blocks.</td>
      <td colspan="2">Example: 8364543, which is #7FA1FF in RGB.</td>
    </tr>
    <tr>
      <td colspan="3">water_fog_color</td>
      <td colspan="2">[Int Tag](nbt.md#specificationinttag)</td>
      <td colspan="2">The color of the fog effect when looking past the view distance when underwater.</td>
      <td colspan="2">Example: 8364543, which is #7FA1FF in RGB.</td>
    </tr>
    <tr>
      <td colspan="3">sky_color</td>
      <td colspan="2">[Int Tag](nbt.md#specificationinttag)</td>
      <td colspan="2">The color of the sky.</td>
      <td colspan="2">Example: 8364543, which is #7FA1FF in RGB.</td>
    </tr>
    <tr>
      <td colspan="3">foliage_color</td>
      <td colspan="2">Optional [Int Tag](nbt.md#specificationinttag)</td>
      <td colspan="2">The tint color of leaves.
If not specified, the foliage color is calculated based on biome `temperature` and `downfall`.</td>
      <td colspan="2">Example: 8364543, which is #7FA1FF in RGB.</td>
    </tr>
    <tr>
      <td colspan="3">grass_color</td>
      <td colspan="2">Optional [Int Tag](nbt.md#specificationinttag)</td>
      <td colspan="2">The tint color of the grass.
If not specified, the grass color is calculated based on biome `temperature` and `downfall`.</td>
      <td colspan="2">Example: 8364543, which is #7FA1FF in RGB.</td>
    </tr>
    <tr>
      <td colspan="3">grass_color_modifier</td>
      <td colspan="2">Optional [String Tag](nbt.md#specificationstringtag)</td>
      <td colspan="2">Modifier that affects the resulting grass color.</td>
      <td colspan="2">Can be either:
* `none`, for a static grass color throughout the biome.
* `dark_forest`, for a darker, and less saturated shade of the color.
* `swamp`, for overriding it with two fixed colors (#4C763C and #6A7039), randomly distributed throughout the biome.</td>
    </tr>
    <tr>
      <td colspan="3">particle</td>
      <td colspan="2">Optional [Compound Tag](nbt.md#specificationcompoundtag)</td>
      <td colspan="2">Ambient visual particles.</td>
      <td colspan="2">See [[#Particle|Particle]].</td>
    </tr>
    <tr>
      <td colspan="3">ambient_sound</td>
      <td colspan="2">Optional [String Tag](nbt.md#specificationstringtag) or [Compound Tag](nbt.md#specificationcompoundtag)</td>
      <td colspan="2">Ambient soundtrack that starts playing when entering the biome, and fades out when exiting it.</td>
      <td colspan="2">Can be either:
* as a [String Tag](nbt.md#specificationstringtag): the ID of a soundtrack, such as "minecraft:ambient.basalt_deltas.loop".
* as a [Compound Tag](nbt.md#specificationcompoundtag): see [[#Ambient sound|Ambient sound]].</td>
    </tr>
    <tr>
      <td colspan="3">mood_sound</td>
      <td colspan="2">Optional [Compound Tag](nbt.md#specificationcompoundtag)</td>
      <td colspan="2">Additional ambient sound that plays in moody situations. Moodiness increases when blocks around the player are at both sky and block light level zero, and decreases otherwise.
The moodiness calculation happens once per tick, and after reaching a certain value, the ambient mood sound is played.</td>
      <td colspan="2">See [[#Mood sound|Mood sound]].</td>
    </tr>
    <tr>
      <td colspan="3">additions_sound</td>
      <td colspan="2">Optional [Compound Tag](nbt.md#specificationcompoundtag)</td>
      <td colspan="2">Additional ambient sound that has a chance of playing randomly every tick.</td>
      <td colspan="2">See [[#Additions sound|Additions sound]].</td>
    </tr>
    <tr>
      <td colspan="3">music</td>
      <td colspan="2">Optional [Compound Tag](nbt.md#specificationcompoundtag)</td>
      <td colspan="2">Music properties for the biome.</td>
      <td colspan="2">See [[#Music|Music]].</td>
    </tr>
  </tbody>
</table>

#### Particle

<table class="wikitable">
  <tbody>
    <tr>
      <th colspan="3">Name</th>
      <th colspan="2">Type</th>
      <th colspan="2">Meaning</th>
      <th colspan="2">Values</th>
    </tr>
    <tr>
      <td colspan="3">options</td>
      <td colspan="2">[Compound Tag](nbt.md#specificationcompoundtag)</td>
      <td colspan="2">Particle type and related options.</td>
      <td colspan="2">See [[#Particle options|Particle options]].</td>
    </tr>
    <tr>
      <td colspan="3">probability</td>
      <td colspan="2">[Float Tag](nbt.md#specificationfloattag)</td>
      <td colspan="2">The chance for the particle to be spawned. Ambient particles are attempted to be spawned multiple times every tick.</td>
      <td colspan="2">The default values vary between 0.0 and 1.0.</td>
    </tr>
  </tbody>
</table>

### Particle options

> ❓ **Missing info (section):** The extra data specified in the [Particle](protocol.md#particle) definitions is missing information to allow the particle to be successfully serialized as NBT.<br>Is it here the best place to define them, or somewhere else?

<table class="wikitable">
  <tbody>
    <tr>
      <th colspan="3">Name</th>
      <th colspan="2">Type</th>
      <th colspan="2">Meaning</th>
      <th colspan="2">Values</th>
    </tr>
    <tr>
      <td colspan="3">type</td>
      <td colspan="2">[String Tag](nbt.md#specificationstringtag)</td>
      <td colspan="2">The name of the particle.</td>
      <td colspan="2">See [protocol particle data](protocol.md#particle).</td>
    </tr>
    <tr>
      <td colspan="3">value</td>
      <td colspan="2">Optional Varies</td>
      <td colspan="2">Any necessary extra data to fully define the particle.</td>
      <td colspan="2">See [protocol particle data](protocol.md#particle).</td>
    </tr>
  </tbody>
</table>

#### Ambient sound

<table class="wikitable">
  <tbody>
    <tr>
      <th colspan="3">Name</th>
      <th colspan="2">Type</th>
      <th colspan="2">Meaning</th>
      <th colspan="2">Values</th>
    </tr>
    <tr>
      <td colspan="3">sound_id</td>
      <td colspan="2">[String Tag](nbt.md#specificationstringtag)</td>
      <td colspan="2">The ID of a soundtrack</td>
      <td colspan="2">Example: "minecraft:ambient.basalt_deltas.loop"</td>
    </tr>
    <tr>
      <td colspan="3">range</td>
      <td colspan="2">Optional [Float Tag](nbt.md#specificationfloattag)</td>
      <td colspan="2">The range of the sound. If not specified, the volume is used to calculate the effective range.</td>
      <td colspan="2"></td>
    </tr>
  </tbody>
</table>

#### Mood sound

<table class="wikitable">
  <tbody>
    <tr>
      <th colspan="3">Name</th>
      <th colspan="2">Type</th>
      <th colspan="2">Meaning</th>
      <th colspan="2">Values</th>
    </tr>
    <tr>
      <td colspan="3">sound</td>
      <td colspan="2">[String Tag](nbt.md#specificationstringtag)</td>
      <td colspan="2">The ID of a soundtrack.</td>
      <td colspan="2">Example: "minecraft:ambient.basalt_deltas.mood"</td>
    </tr>
    <tr>
      <td colspan="3">tick_delay</td>
      <td colspan="2">[Int Tag](nbt.md#specificationinttag)</td>
      <td colspan="2">Defines the rate at which the moodiness increase, and also the minimum time between plays.</td>
      <td colspan="2">The default value is always 6000.</td>
    </tr>
    <tr>
      <td colspan="3">block_search_extent</td>
      <td colspan="2">[Int Tag](nbt.md#specificationinttag)</td>
      <td colspan="2">The radius used for the block search around the player during moodiness calculation.</td>
      <td colspan="2">The default value is always 8.</td>
    </tr>
    <tr>
      <td colspan="3">offset</td>
      <td colspan="2">[Double Tag](nbt.md#specificationdoubletag)</td>
      <td colspan="2">The distance offset from the player when playing the sound.
The sound plays in the direction of the selected block during moodiness calculation, and is magnified by the offset.</td>
      <td colspan="2">The default value is always 2.0.</td>
    </tr>
  </tbody>
</table>

#### Additions sound

<table class="wikitable">
  <tbody>
    <tr>
      <th colspan="3">Name</th>
      <th colspan="2">Type</th>
      <th colspan="2">Meaning</th>
      <th colspan="2">Values</th>
    </tr>
    <tr>
      <td colspan="3">sound</td>
      <td colspan="2">[String Tag](nbt.md#specificationstringtag)</td>
      <td colspan="2">The ID of a soundtrack.</td>
      <td colspan="2">Example: "minecraft:ambient.basalt_deltas.additions"</td>
    </tr>
    <tr>
      <td colspan="3">tick_chance</td>
      <td colspan="2">[Double Tag](nbt.md#specificationdoubletag)</td>
      <td colspan="2">The chance of the sound playing during the tick.</td>
      <td colspan="2">The default value is always 0.0111.</td>
    </tr>
  </tbody>
</table>

#### Music

<table class="wikitable">
  <tbody>
    <tr>
      <th colspan="3">Name</th>
      <th colspan="2">Type</th>
      <th colspan="2">Meaning</th>
      <th colspan="2">Values</th>
    </tr>
    <tr>
      <td colspan="3">sound</td>
      <td colspan="2">[String Tag](nbt.md#specificationstringtag)</td>
      <td colspan="2">The ID of a soundtrack.</td>
      <td colspan="2">Example: "minecraft:music.nether.basalt_deltas"</td>
    </tr>
    <tr>
      <td colspan="3">min_delay</td>
      <td colspan="2">[Int Tag](nbt.md#specificationinttag)</td>
      <td colspan="2">The minimum time in ticks since the last music finished for this music to be able to play.</td>
      <td colspan="2">The default value is always 12000.</td>
    </tr>
    <tr>
      <td colspan="3">max_delay</td>
      <td colspan="2">[Int Tag](nbt.md#specificationinttag)</td>
      <td colspan="2">The maximum time in ticks since the last music finished for this music to be able to play.</td>
      <td colspan="2">The default value is always 24000.</td>
    </tr>
    <tr>
      <td colspan="3">replace_current_music</td>
      <td colspan="2">[Byte Tag](nbt.md#specificationbytetag)</td>
      <td colspan="2">Whether this music can replace the current one.</td>
      <td colspan="2">1: true, 0: false.</td>
    </tr>
  </tbody>
</table>

### Chat Type

The `minecraft:chat_type` registry. It defines the different types of in-game chat and how they're formatted.

Chat type entries are referenced in the [Disguised Chat Message](protocol.md#disguisedchatmessage) and [Player Chat Message](protocol.md#playerchatmessage) packets.

<table class="wikitable">
  <tbody>
    <tr>
      <th colspan="3">Name</th>
      <th colspan="2">Type</th>
      <th colspan="2">Meaning</th>
      <th colspan="2">Values</th>
    </tr>
    <tr>
      <td colspan="3">chat</td>
      <td colspan="2">[Compound Tag](nbt.md#specificationcompoundtag)</td>
      <td colspan="2">The chat decoration.</td>
      <td colspan="2">See [[#Decoration|Decoration]].</td>
    </tr>
    <tr>
      <td colspan="3">narration</td>
      <td colspan="2">[Compound Tag](nbt.md#specificationcompoundtag)</td>
      <td colspan="2">The narration decoration.</td>
      <td colspan="2">See [[#Decoration|Decoration]].</td>
    </tr>
  </tbody>
</table>

#### Decoration

<table class="wikitable">
  <tbody>
    <tr>
      <th colspan="3">Name</th>
      <th colspan="2">Type</th>
      <th colspan="2">Meaning</th>
      <th colspan="2">Values</th>
    </tr>
    <tr>
      <td colspan="3">translation_key</td>
      <td colspan="2">[String Tag](nbt.md#specificationstringtag)</td>
      <td colspan="2">The translation key representing the chat format. It can also be a formatting string directly.</td>
      <td colspan="2">Example: "chat.type.text", which translates to "<%s> %s".</td>
    </tr>
    <tr>
      <td colspan="3">style</td>
      <td colspan="2">Optional [Compound Tag](nbt.md#specificationcompoundtag)</td>
      <td colspan="2">Optional styling to be applied on the final message.
Not present in the narration decoration.</td>
      <td colspan="2">See [Text formatting#Styling fields](text-formatting.md#styling-fields).</td>
    </tr>
    <tr>
      <td colspan="3">parameters</td>
      <td colspan="2">[List Tag](nbt.md#specificationlisttag) of [String Tag](nbt.md#specificationstringtag)</td>
      <td colspan="2">Placeholders used when formatting the string given by the translation_key field.</td>
      <td colspan="2">Can be either:
* `sender`, for the name of the player sending the message.
* `target`, for the name of the player receiving the message, which may be empty.
* `content`, for the actual message.</td>
    </tr>
  </tbody>
</table>

### Damage Type

The `minecraft:damage_type` registry. It defines the different types of damage an entity can sustain.

Damage type entries are referenced in the [Damage Event](protocol.md#damageevent) packet.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Meaning</th>
      <th>Values</th>
      <td>- style="background: #d4ecfc;"</td>
      <td>message_id</td>
      <td>[String Tag](nbt.md#specificationstringtag)</td>
      <td>Id of the death message. The full message is displayed as `death.attack.<message_id>`.</td>
      <td>Example: "onFire".</td>
      <td>- style="background: #d4ecfc;"</td>
      <td>scaling</td>
      <td>[String Tag](nbt.md#specificationstringtag)</td>
      <td>Whether the damage taken scales with the difficulty.</td>
      <td>Can be either:
* `never`
* `when_caused_by_living_non_player`
* `always`</td>
      <td>- style="background: #d4ecfc;"</td>
      <td>exhaustion</td>
      <td>[Float Tag](nbt.md#specificationfloattag)</td>
      <td>The amount of exhaustion caused when suffering this type of damage.</td>
      <td>Default values are either 0.0 or 0.1.</td>
    </tr>
    <tr>
      <td>effects</td>
      <td>Optional [String Tag](nbt.md#specificationstringtag)</td>
      <td>Effect played when the player suffers this damage, including the sound that is played.</td>
      <td>Can be either:
* `hurt`
* `thorns`
* `drowning`
* `burning`
* `poking`
* `freezing`</td>
      <td>- style="background: #d4ecfc;"</td>
      <td>death_message_type</td>
      <td>Optional [String Tag](nbt.md#specificationstringtag)</td>
      <td>Defines how the death message is constructed.</td>
      <td>Can be either:
* `default`, for the message to be built normally.
* `fall_variants`, for the most significant fall damage to be considered.
* `intentional_game_design`, for [MCPE-28723](https://bugs.mojang.com/browse/MCPE-28723) to be considered as an argument when translating the message.</td>
    </tr>
  </tbody>
</table>

### Dimension Type

The `minecraft:dimension_type` registry. It defines the types of dimension that can be attributed to a world, along with all their characteristics.

Dimension type entries are referenced in the [Login (play)](protocol.md#loginplay) and [Respawn](protocol.md#respawn) packets.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Meaning</th>
      <th>Values</th>
      <td>- style="background: #d4ecfc;"</td>
      <td>fixed_time</td>
      <td>Optional [Long Tag](nbt.md#specificationlongtag)</td>
      <td>If set, the time of the day fixed to the specified value.</td>
      <td>Allowed values vary between 0 and 24000.</td>
    </tr>
    <tr>
      <td>has_skylight</td>
      <td>[Byte Tag](nbt.md#specificationbytetag)</td>
      <td>Whether the dimension has skylight access or not.</td>
      <td>1: true, 0: false.</td>
      <td>- style="background: #d4ecfc;"</td>
      <td>has_ceiling</td>
      <td>[Byte Tag](nbt.md#specificationbytetag)</td>
      <td>Whether the dimension has a bedrock ceiling or not. When true, causes lava to spread faster.</td>
      <td>1: true, 0: false.</td>
      <td>- style="background: #d4ecfc;"</td>
      <td>ultrawarm</td>
      <td>[Byte Tag](nbt.md#specificationbytetag)</td>
      <td>Whether the dimensions behaves like the nether (water evaporates and sponges dry) or not. Also causes lava to spread thinner.</td>
      <td>1: true, 0: false.</td>
    </tr>
    <tr>
      <td>natural</td>
      <td>[Byte Tag](nbt.md#specificationbytetag)</td>
      <td>When false, compasses spin randomly. When true, nether portals can spawn zombified piglins.</td>
      <td>1: true, 0: false.</td>
      <td>- style="background: #d4ecfc;"</td>
      <td>coordinate_scale</td>
      <td>[Double Tag](nbt.md#specificationdoubletag)</td>
      <td>The multiplier applied to coordinates when traveling to the dimension.</td>
      <td>Allowed values vary between 1e-5 (0.00001) and 3e7 (30000000).</td>
      <td>- style="background: #d4ecfc;"</td>
      <td>bed_works</td>
      <td>[Byte Tag](nbt.md#specificationbytetag)</td>
      <td>Whether players can use a bed to sleep.</td>
      <td>1: true, 0: false.</td>
      <td>- style="background: #d4ecfc;"</td>
      <td>respawn_anchor_works</td>
      <td>[Byte Tag](nbt.md#specificationbytetag)</td>
      <td>Whether players can charge and use respawn anchors.</td>
      <td>1: true, 0: false.</td>
    </tr>
    <tr>
      <td>min_y</td>
      <td>[Int Tag](nbt.md#specificationinttag)</td>
      <td>The minimum Y level.</td>
      <td>Allowed values vary between -2032 and 2031, and must also be a multiple of 16.
{{warning|min_y + height cannot exceed 2032.}}</td>
    </tr>
    <tr>
      <td>height</td>
      <td>[Int Tag](nbt.md#specificationinttag)</td>
      <td>The maximum height.</td>
      <td>Allowed values vary between 16 and 4064, and must also be a multiple of 16.
{{warning|min_y + height cannot exceed 2032.}}</td>
      <td>- style="background: #d4ecfc;"</td>
      <td>logical_height</td>
      <td>[Int Tag](nbt.md#specificationinttag)</td>
      <td>The maximum height to which chorus fruits and nether portals can bring players within this dimension. (Must be lower than height)</td>
      <td>Allowed values vary between 0 and 4064, and must also be a multiple of 16.
{{warning|logical_height cannot exceed the height.}}</td>
      <td>- style="background: #d4ecfc;"</td>
      <td>infiniburn</td>
      <td>[String Tag](nbt.md#specificationstringtag)</td>
      <td>A resource location defining what block tag to use for infiniburn.</td>
      <td>"#" or minecraft resource "#minecraft:...".</td>
    </tr>
    <tr>
      <td>effects</td>
      <td>[String Tag](nbt.md#specificationstringtag)</td>
      <td>Defines special dimensional effects, which includes:
* Cloud level: Height at which clouds appear, if at all.
* Sky type: Whether it's the normal sky with sun and moon; the low-visibility, foggy sky of the nether; or the static sky of the end.
* Forced light map: Whether a bright light map is forced, siimilar to the night vision effect.
* Constant ambient light: Whether blocks have shade on their faces.</td>
      <td>Can be either:
* `minecraft:overworld`, for clouds at 192, normal sky type, normal light map and normal ambient light.
* `minecraft:the_nether`, for **no clouds**, nether sky type, normal light map and **constant** ambient light.
* `minecraft:the_end`, for **no clouds**, end sky type, **forced** light map and normal ambient light.</td>
    </tr>
    <tr>
      <td>ambient_light</td>
      <td>[Float Tag](nbt.md#specificationfloattag)</td>
      <td>How much light the dimension has. Used as interpolation factor when calculating the brightness generated from sky light.</td>
      <td>The default values are 0.0 and 0.1, 0.1 for the nether and 0.0 for the other dimensions.</td>
    </tr>
    <tr>
      <td>piglin_safe</td>
      <td>[Byte Tag](nbt.md#specificationbytetag)</td>
      <td>Whether piglins shake and transform to zombified piglins.</td>
      <td>1: true, 0: false.</td>
      <td>- style="background: #d4ecfc;"</td>
      <td>has_raids</td>
      <td>[Byte Tag](nbt.md#specificationbytetag)</td>
      <td>Whether players with the Bad Omen effect can cause a raid.</td>
      <td>1: true, 0: false.</td>
      <td>- style="background: #d4ecfc;"</td>
      <td>monster_spawn_light_level</td>
      <td>[Int Tag](nbt.md#specificationinttag) or [Compound Tag](nbt.md#specificationcompoundtag)</td>
      <td>During a monster spawn attempt, this is the maximum allowed light level for it to succeed. It can be either a fixed value, or one of several types of distributions.</td>
      <td>Can be either:
* as a [Int Tag](nbt.md#specificationinttag): Allowed values vary between 0 and 15.
* as a [Compound Tag](nbt.md#specificationcompoundtag): See [here](https://minecraft.wiki/w/Dimension_type).</td>
      <td>- style="background: #d4ecfc;"</td>
      <td>monster_spawn_block_light_limit</td>
      <td>[Int Tag](nbt.md#specificationinttag)</td>
      <td>Maximum allowed block light level monster spawn attempts to happen.</td>
      <td>Allowed values vary between 0 and 15.
The default values are 0 and 15, 15 for the nether (where monsters can spawn anywhere) and 0 for other dimensions (where monsters can only spawn naturally in complete darkness).</td>
    </tr>
  </tbody>
</table>

### Wolf Variant

The `minecraft:wolf_variant` registry. It defines the textures for different wolf variants. 

<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Meaning</th>
      <th>Values</th>
    </tr>
    <tr>
      <td>wild_texture</td>
      <td>[String Tag](nbt.md#specificationstringtag)</td>
      <td>The texture for the wild version of this wolf.
The Notchian client uses the corresponding asset located at `textures`.</td>
      <td>Example: "minecraft:entity/wolf/wolf_ashen".</td>
    </tr>
    <tr>
      <td>tame_texture</td>
      <td>[String Tag](nbt.md#specificationstringtag)</td>
      <td>The texture for the tamed version of this wolf.
The Notchian client uses the corresponding asset located at `textures`.</td>
      <td>Example: "minecraft:entity/wolf/wolf_ashen_tame".</td>
    </tr>
    <tr>
      <td>angry_texture</td>
      <td>[String Tag](nbt.md#specificationstringtag)</td>
      <td>The texture for the angry version of this wolf.
The Notchian client uses the corresponding asset located at `textures`.</td>
      <td>Example: "minecraft:entity/wolf/wolf_ashen_angry".</td>
      <td>- style="background: #d4ecfc;"</td>
      <td>biomes</td>
      <td>[String Tag](nbt.md#specificationstringtag) or [List Tag](nbt.md#specificationlisttag)</td>
      <td>Biomes in which this wolf can spawn in.</td>
      <td>See [here](https://minecraft.wiki/w/Wolf#Wolf_variants).</td>
    </tr>
  </tbody>
</table>

### Painting Variant

The `minecraft:painting_variant` registry. It defines the textures and dimensions for the game's paintings. 

<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Meaning</th>
      <th>Values</th>
    </tr>
    <tr>
      <td>asset_id</td>
      <td>[String Tag](nbt.md#specificationstringtag)</td>
      <td>The texture for the painting.
The Notchian client uses the corresponding asset located at 
`textures/painting`.</td>
      <td>Example: "minecraft:backyard".</td>
    </tr>
    <tr>
      <td>height</td>
      <td>[Int Tag](nbt.md#specificationinttag)</td>
      <td>The height of the painting, in blocks.</td>
      <td>Example: `2`</td>
    </tr>
    <tr>
      <td>width</td>
      <td>[Int Tag](nbt.md#specificationinttag)</td>
      <td>The width of the painting, in blocks.</td>
      <td></td>
    </tr>
    <tr>
      <td>title</td>
      <td>[Compound Tag](nbt.md#specificationcompoundtag) or [String Tag](nbt.md#specificationstringtag)</td>
      <td>The displayed title of the painting. See [Text formatting](text-formatting.md).</td>
      <td>Example: `{"color": "gray", "translate": "painting.minecraft.skeleton.title"}`</td>
    </tr>
    <tr>
      <td>author</td>
      <td>[Compound Tag](nbt.md#specificationcompoundtag) or [String Tag](nbt.md#specificationstringtag)</td>
      <td>The displayed author of the painting. See [Text formatting](text-formatting.md).</td>
      <td>Example: `{"color": "gray", "translate": "painting.minecraft.skeleton.author"}`</td>
    </tr>
  </tbody>
</table>

## Default Registries

The default content of the registries is available in the JSON format for the following versions:
- [1.21](https://gist.github.com/Mansitoh/e6c5cf8bbf17e9faf4e4e75bb3f4789d)
- [1.20.6](https://gist.github.com/WinX64/ab8c7a8df797c273b32d3a3b66522906)
- [1.20.2](https://gist.github.com/WinX64/3675ffee90360e9fc1e45074e49f6ede)
- [1.20.1](https://gist.github.com/WinX64/2d257d3df3c7ab9c4b02dc90be881ab2)
- [1.19.2](https://gist.github.com/nikes/aff59b758a807858da131a1881525b14)
- [1.19](https://gist.github.com/rj00a/f2970a8ce4d09477ec8f16003b9dce86)

[Category:Protocol Details](category-protocol-details.md)
[Category:Java Edition protocol](category-java-edition-protocol.md)

_Content is licensed under wiki.vg terms._
