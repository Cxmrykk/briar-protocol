**Resource locations**<ref>Officially named **resource location** {{in|java}}. However, this name isn't used {{in|bedrock}}.</ref> (also known as **namespaced IDs**, **namespaced identifiers**, **resource identifiers**,<ref>{{snap|19w39a|September 27, 2019}}</ref> or **namespaced strings**<ref>[DataFixerUpper/NamespacedStringType.java at 8b5f82ab78b30ff5813b3a7f3906cd3f4f732acf · Mojang/DataFixerUpper](https://github.com/Mojang/DataFixerUpper/blob/8b5f82ab78b30ff5813b3a7f3906cd3f4f732acf/src/main/java/com/mojang/datafixers/types/constant/NamespacedStringType.java) – GitHub</ref>) are a way to declare and specify game objects in *Minecraft*, which can identify built-in and user-defined objects without potential ambiguity or conflicts.

## Introduction

Resource locations are used as plain strings to reference [block](block.md)s, [item](item.md)s, [entity types](entity.md#types-of-entities), and various other objects in vanilla *Minecraft*.

A valid resource location has a format of `namespace:path`, where only certain characters can be used.

### Legal characters

#### Java Edition

The namespace and the path of a resource location should only contain the following symbols:

- `0123456789` Numbers
- `abcdefghijklmnopqrstuvwxyz` Lowercase letters
- `_` Underscore
- `-` Hyphen/minus
- `.` Dot

The following characters are illegal in the namespace, but acceptable in the path:
- `/` Forward slash (directory separator)

The preferred naming convention for either namespace or path is `snake_case`.

#### Bedrock Edition

The namespace and the path of an namespaced ID can contain all symbols with the exception of slashes and colons.

The following characters are illegal in the namespace, but acceptable in the path of **loot tables and functions**.
- `/` Forward slash (directory separator)

The preferred naming convention for either namespace or path is `snake_case`.

### Conversion to string
A resource location is converted to a string by concatenating its namespace with a `:` (colon) and its path.

Examples:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Namespace</th>
      <th>Path</th>
      <th>String representation</th>
    </tr>
    <tr>
      <td>`minecraft`</td>
      <td>`diamond`</td>
      <td>`minecraft:diamond`</td>
    </tr>
    <tr>
      <td>`foo`</td>
      <td>`bar.baz`</td>
      <td>`foo:bar.baz`</td>
    </tr>
    <tr>
      <td>`minecraftwiki`</td>
      <td>`commands/minecraft_wiki`</td>
      <td>`minecraftwiki:commands/minecraft_wiki`</td>
    </tr>
  </tbody>
</table>

### Conversion from string

All resource locations can be converted to strings; however, not all strings can be converted to resource locations.

For a string to be converted, it must follow these restrictions:
- The string may have at most one `:` (colon) character
- The rest of the string must fulfill the requirement for [[#Legal characters|legal characters]]. This includes disallowing `/` (forward slash) characters before the `:`, if a `:` is present

When the `:` is present, the part of the string before the `:` becomes the namespace, and the part of the string after the `:` becomes the path.

{{IN|java}}, and in some cases {{in|bedrock}}, when the `:` is absent, [[#minecraft namespace|`minecraft`]] becomes the namespace and the whole string becomes the path.

It is recommended to always include a `:` in the string format of resource locations.

;Examples
<table class="wikitable">
  <tbody>
    <tr>
      <th>String</th>
      <th>Resolved namespace</th>
      <th>Resolved path</th>
      <th>What the game converts it back to</th>
    </tr>
    <tr>
      <td>`bar:code`</td>
      <td>`bar`</td>
      <td>`code`</td>
      <td>`bar:code`</td>
    </tr>
    <tr>
      <td>`minecraft:zombie`</td>
      <td>`minecraft`</td>
      <td>`zombie`</td>
      <td>`minecraft:zombie`</td>
    </tr>
    <tr>
      <td>`diamond`</td>
      <td>`minecraft`{{only|java}}<br>None{{only|bedrock}}</td>
      <td>`diamond`</td>
      <td>`minecraft:diamond`{{only|java}}<br>`diamond`{{only|bedrock}}</td>
    </tr>
    <tr>
      <td>`:dirt`</td>
      <td>`minecraft`</td>
      <td>`dirt`</td>
      <td>`minecraft:dirt`{{needs testing|bedrock=1}}</td>
    </tr>
    <tr>
      <td>`minecraft:`</td>
      <td>`minecraft`</td>
      <td>None</td>
      <td>`minecraft:`{{needs testing|bedrock=1}}</td>
    </tr>
    <tr>
      <td>`:`</td>
      <td>`minecraft`</td>
      <td>None</td>
      <td>`minecraft:`{{needs testing|bedrock=1}}</td>
    </tr>
    <tr>
      <td>Empty String</td>
      <td>`minecraft`</td>
      <td>None</td>
      <td>`minecraft:`{{needs testing|bedrock=1}}</td>
    </tr>
    <tr>
      <td>`foo/bar:coal`</td>
      <td>Invalid character `/`</td>
      <td></td>
      <td></td>
    </tr>
    <tr>
      <td>`minecraft/villager`</td>
      <td>`minecraft`{{only|java}}<br>None{{only|bedrock}}</td>
      <td>`minecraft/villager`</td>
      <td>`minecraft:minecraft/villager`{{only|java}}<br>`minecraft/villager`{{only|bedrock}}</td>
    </tr>
    <tr>
      <td>`mypack_recipe`</td>
      <td>`minecraft`{{only|java}}<br>None{{only|bedrock}}</td>
      <td>`mypack_recipe`</td>
      <td>`minecraft:mypack_recipe`{{only|java}}<br>`mypack_recipe`{{only|bedrock}}</td>
    </tr>
    <tr>
      <td>`mymap:schrödingers_var`</td>
      <td>`mymap`</td>
      <td>Invalid character `ö`{{only|java}}<br>`schrödingers_var`{{only|bedrock}}</td>
      <td>`mymap:schrödingers_var`{{only|bedrock}}</td>
    </tr>
    <tr>
      <td>`custom_pack:Capital`</td>
      <td>`custom_pack`</td>
      <td>Invalid character `C`{{only|java}}<br>`Capital`{{only|bedrock}}</td>
      <td>`custom_pack:Capital`{{only|bedrock}}</td>
    </tr>
  </tbody>
</table>

## Usage
Here list all places that use resource locations: <!-- Todo add more, incomplete-->

### *Java Edition*
{{IN|java}}, resource locations act mainly as main keys of objects in registries, or file paths of contents in packs. Besides, some customizable or hardcoded contents also use resource locations.

#### Registries and registry objects
Each registry and each object in registries has a resource location to represent it.

There's a root registry with resource location of {{cd|minecraft:root}}. Other registries are registered into the root registry as its entries.

The following is the list of registries and their resource locations:

; Root Registry：{{cd|minecraft:root}}
:* Attribute: {{cd|minecraft:attribute}}
:* Block: {{cd|minecraft:block}}
:* Block entity type: {{cd|minecraft:block_entity_type}}
:* Chunk status: {{cd|minecraft:chunk_status}}
:* Command argument type: {{cd|minecraft:command_argument_type}}
:* Dimension and Level stem: {{cd|minecraft:dimension}}
:* Dimension type: {{cd|minecraft:dimension_type}}
:* Enchantment: {{cd|minecraft:enchantment}}
:* Entity type: {{cd|minecraft:entity_type}}
:* Fluid: {{cd|minecraft:fluid}}
:* Game event: {{cd|minecraft:game_event}}
:* Position source type (used by game events): {{cd|minecraft:position_source_type}}
:* Item: {{cd|minecraft:item}}
:* Menu type: {{cd|minecraft:menu}}
:* Mob effect: {{cd|minecraft:mob_effect}}
:* Particle type: {{cd|minecraft:particle_type}}
:* Potion: {{cd|minecraft:potion}}
:* Recipe serializer: {{cd|minecraft:recipe_serializer}}
:* Recipe type: {{cd|minecraft:recipe_type}}
:* Sound event: {{cd|minecraft:sound_event}}
:* Statistics type: {{cd|minecraft:stat_type}}
:* Custom Statistics: {{cd|minecraft:custom_stat}}
:* Entity data registries
:** Entity schedule activity: {{cd|minecraft:activity}}
:** Entity memory module type: {{cd|minecraft:memory_module_type}}
:** Entity schedule: {{cd|minecraft:schedule}}
:** Entity AI sensor type: {{cd|minecraft:sensor_type}}
:** Painting motive: {{cd|minecraft:motive}}
:** Villager profession: {{cd|minecraft:villager_profession}}
:** Villager type: {{cd|minecraft:villager_type}}
:** Poi type: {{cd|minecraft:point_of_interest_type}}
:* Loot table serializer registries:
:** Loot condition type: {{cd|minecraft:loot_condition_type}}
:** Loot function type: {{cd|minecraft:loot_function_type}}
:** Loot nbt provider type: {{cd|minecraft:loot_nbt_provider_type}}
:** Loot number provider type: {{cd|minecraft:loot_number_provider_type}}
:** Loot pool entry type: {{cd|minecraft:loot_pool_entry_type}}
:** Loot score provider type: {{cd|minecraft:loot_score_provider_type}}
:* Json file value provider registries:
:** Float provider type: {{cd|minecraft:float_provider_type}}
:** Int provider type: {{cd|minecraft:int_provider_type}}
:** Height provider type: {{cd|minecraft:height_provider_type}}
:* World generator registries:
:** Block predicate type: {{cd|minecraft:block_predicate_type}}
:** Structure featrue rule test type: {{cd|minecraft:rule_test}}
:** Structure featrue position rule test type: {{cd|minecraft:pos_rule_test}}
:** World carver: {{cd|minecraft:worldgen/carver}}
:** Configured world carver: {{cd|minecraft:worldgen/configured_carver}}
:** Feature: {{cd|minecraft:worldgen/feature}}
:** Configured feature: {{cd|minecraft:worldgen/configured_feature}}
:** Structure set: {{cd|minecraft:worldgen/structure_set}}
:** Structure processor type: {{cd|minecraft:worldgen/structure_processor}}
:** Structure processor list: {{cd|minecraft:worldgen/processor_list}}
:** Structure pool element type: {{cd|minecraft:worldgen/structure_pool_element}}
:** Structure template pool: {{cd|minecraft:worldgen/template_pool}}
:** Structure piece type: {{cd|minecraft:worldgen/structure_piece}}
:** Structure feature: {{cd|minecraft:worldgen/structure_type}}
:** Configured structure feature: {{cd|minecraft:worldgen/structure}}
:** Structure placement type: {{cd|minecraft:worldgen/structure_placement}}
:** Placement modifier type: {{cd|minecraft:worldgen/placement_modifier_type}}
:** Placed feature: {{cd|minecraft:worldgen/placed_feature}}
:** Biome: {{cd|minecraft:worldgen/biome}}
:** Biome source: {{cd|minecraft:worldgen/biome_source}}
:** Normal noise: {{cd|minecraft:worldgen/noise}}
:** Noise generator settings: {{cd|minecraft:worldgen/noise_settings}}
:** Density function: {{cd|minecraft:worldgen/density_function}}
:** Density function type: {{cd|minecraft:worldgen/density_function_type}}
:** World preset: {{cd|minecraft:worldgen/world_preset}}
:** Flat world generator preset: {{cd|minecraft:worldgen/flat_level_generator_preset}}
:** Chunk generator: {{cd|minecraft:worldgen/chunk_generator}}
:** Surface condition source: {{cd|minecraft:worldgen/material_condition}}
:** Surface rule source: {{cd|minecraft:worldgen/material_rule}}
:** Block state provider type: {{cd|minecraft:worldgen/block_state_provider_type}}
:** Foliage placer type: {{cd|minecraft:worldgen/foliage_placer_type}}
:** Trunk placer type: {{cd|minecraft:worldgen/trunk_placer_type}}
:** Tree decorator type: {{cd|minecraft:worldgen/tree_decorator_type}}
:** Feature size type: {{cd|minecraft:worldgen/feature_size_type}}

#### Pack contents
Resource locations are also used to represent files' paths in data pack or resource pack.

; Data pack
:* Tags
:* Advancements
:* Recipes
:* Predicates
:* Loot tables
:* Item modifier
:* Functions
:* Structure files
:* Dimensions
:* Dimension types
:* *World generator contents*
:** Biomes
:** Configured carvers
:** Configured features
:** Configured structure features
:** Placed features
:** Structures
:** Structure sets
:** Processor lists
:** Template pools
:** Noise
:** Noise generator settings
:** Density functions
:** Flat level generator presets
:** World presets

; Resource pack
:* Block states
:* Models
:* Textures
:* Sounds
:* Fonts
:* Font resource files
:* Particles
:* shaders

#### = Locating contents in packs =
Given objects from resource packs and data packs are files, the resource locations represent corresponding paths.

Though the locations vary by object type and the pack type the object type belongs to, there is a pattern to follow. In general, the location is in the fashion of pack_type/namespace/object_type/name.suffix, where all the / (forward slash) symbol (may be part of object_type or name) is replaced by operating system-dependent directory separator.

Given the type of content we want to locate, we can find out the corresponding {{cd|*pack_type*}}, {{cd|*object_type*}}, and {{cd|*suffix*}}. Then, we can substitute in and find out the final file location of the content.

<div class="collapsible collapsed collapsetoggle-inline" data-expandtext="show" data-collapsetext="hide">
Examples
<!-- TODO: Add more?-->
<div class="collapsible-content">
<table class="wikitable">
  <tbody>
    <tr>
      <th>Resource location</th>
      <th>Content Type</th>
      <th>{{cd|*pack_type*}}</th>
      <th>{{cd|*object_type*}}</th>
      <th>{{cd|*suffix*}}</th>
      <th>Final Location</th>
    </tr>
    <tr>
      <td>{{cd|my_texture_pack:diamonds}}</td>
      <td>[Texture](resource-pack.md#textures)</td>
      <td>{{cd|assets}}</td>
      <td>{{cd|textures}}</td>
      <td>{{cd|png}}</td>
      <td>{{cd|assets/my_texture_pack/textures/diamonds.png}}</td>
    </tr>
    <tr>
      <td>{{cd|abc:run_game}}</td>
      <td>[Function](function-java-edition.md)</td>
      <td>{{cd|data}}</td>
      <td>{{cd|functions}}</td>
      <td>{{cd|mcfunction}}</td>
      <td>{{cd|data/abc/functions/run_game.mcfunction}}</td>
    </tr>
    <tr>
      <td>{{cd|block/torch}}<br>(same as {{cd|minecraft:block/torch}})</td>
      <td>[Model](model.md)</td>
      <td>{{cd|assets}}</td>
      <td>{{cd|models}}</td>
      <td>{{cd|json}}</td>
      <td>{{cd|assets/minecraft/models/block/torch.json}}</td>
    </tr>
    <tr>
      <td>{{cd|load}}<br>(same as {{cd|minecraft:load}})</td>
      <td>[Function Tag](tag.md#function-tags)</td>
      <td>{{cd|data}}</td>
      <td>{{cd|tags/functions}}</td>
      <td>{{cd|json}}</td>
      <td>{{cd|data/minecraft/tags/functions/load.json}}</td>
    </tr>
    <tr>
      <td>{{cd|rocket_pack:industry/start_of_story}}</td>
      <td>[Advancement](advancement.md)</td>
      <td>{{cd|data}}</td>
      <td>{{cd|advancements}}</td>
      <td>{{cd|json}}</td>
      <td>{{cd|data/rocket_pack/advancements/industry/start_of_story.json}}</td>
    </tr>
  </tbody>
</table>
</div></div>

#### = Registered pack contents =
A registried pack content refers to pack content that is registered into a registry when the pack is loaded. For a registried pack content, its resource location works as both main key of registry entry and path of its resource file.

<div class="collapsible collapsed collapsetoggle-inline" data-expandtext="show" data-collapsetext="hide">
List of registered pack contents
<div class="collapsible-content">
<table class="wikitable">
  <tbody>
    <tr>
      <th>Content Type</th>
      <th>Registered into</th>
      <th>Folder</th>
      <th>Suffix</th>
    </tr>
    <tr>
      <td>Dimensions</td>
      <td>{{cd|minecraft:dimension}}</td>
      <td>{{cd|data/*namespace*/dimension}}</td>
      <td>{{cd|json}}</td>
    </tr>
    <tr>
      <td>Dimension types</td>
      <td>{{cd|minecraft:dimension_type}}</td>
      <td>{{cd|data/*namespace*/dimension_type}}</td>
      <td>{{cd|json}}</td>
    </tr>
    <tr>
      <td>Configured carvers</td>
      <td>{{cd|minecraft:worldgen/configured_carver}}</td>
      <td>{{cd|data/*namespace*/worldgen/configured_carver}}</td>
      <td>{{cd|json}}</td>
    </tr>
    <tr>
      <td>Configured features</td>
      <td>{{cd|minecraft:worldgen/configured_feature}}</td>
      <td>{{cd|data/*namespace*/worldgen/configured_feature}}</td>
      <td>{{cd|json}}</td>
    </tr>
    <tr>
      <td>Configured structure features</td>
      <td>{{cd|minecraft:worldgen/structure}}</td>
      <td>{{cd|data/*namespace*/worldgen/structure}}</td>
      <td>{{cd|json}}</td>
    </tr>
    <tr>
      <td>Structure sets</td>
      <td>{{cd|minecraft:worldgen/structure_set}}</td>
      <td>{{cd|data/*namespace*/worldgen/structure_set}}</td>
      <td>{{cd|json}}</td>
    </tr>
    <tr>
      <td>Processor lists</td>
      <td>{{cd|minecraft:worldgen/processor_list}}</td>
      <td>{{cd|data/*namespace*/worldgen/processor_list}}</td>
      <td>{{cd|json}}</td>
    </tr>
    <tr>
      <td>Template pools</td>
      <td>{{cd|minecraft:worldgen/template_pool}}</td>
      <td>{{cd|data/*namespace*/worldgen/template_pool}}</td>
      <td>{{cd|json}}</td>
    </tr>
    <tr>
      <td>Placed features</td>
      <td>{{cd|minecraft:worldgen/placed_feature}}</td>
      <td>{{cd|data/*namespace*/worldgen/placed_feature}}</td>
      <td>{{cd|json}}</td>
    </tr>
    <tr>
      <td>Biomes</td>
      <td>{{cd|minecraft:worldgen/biome}}</td>
      <td>{{cd|data/*namespace*/worldgen/biome}}</td>
      <td>{{cd|json}}</td>
    </tr>
    <tr>
      <td>Noise</td>
      <td>{{cd|minecraft:worldgen/noise}}</td>
      <td>{{cd|data/*namespace*/worldgen/noise}}</td>
      <td>{{cd|json}}</td>
    </tr>
    <tr>
      <td>Noise generator settings</td>
      <td>{{cd|minecraft:worldgen/noise_settings}}</td>
      <td>{{cd|data/*namespace*/worldgen/noise_settings}}</td>
      <td>{{cd|json}}</td>
    </tr>
    <tr>
      <td>Density functions</td>
      <td>{{cd|minecraft:worldgen/density_function}}</td>
      <td>{{cd|data/*namespace*/worldgen/density_function}}</td>
      <td>{{cd|json}}</td>
    </tr>
    <tr>
      <td>Flat level generator presets</td>
      <td>{{cd|minecraft:worldgen/flat_level_generator_preset}}</td>
      <td>{{cd|data/*namespace*/worldgen/flat_level_generator_preset}}</td>
      <td>{{cd|json}}</td>
    </tr>
    <tr>
      <td>World presets</td>
      <td>{{cd|minecraft:worldgen/world_preset}}</td>
      <td>{{cd|data/*namespace*/worldgen/world_preset}}</td>
      <td>{{cd|json}}</td>
    </tr>
  </tbody>
</table>
</div></div>

#### Other contents
; Customizable contents
:* Boss bars
:* Command storages

; Hardcoded contents
:* Cat types for predicates (e.g. textures/entity/cat/tabby.png, textures/entity/cat/jellie.png)
:* Criteria triggers
:* Item properties (i.e. item predicates in models. e.g. angle, custom_model_data)
:* Loot context param sets (i.e. types of loot table. e.g. barter, generic)
:* Unaccessible contents:
:** Suggestion providers for autocompletion of commands (e.g. summonable_entities, all_recipes)
:** Entity models
:** Loot context params (e.g. this_entity, origin, tool)

----

### Bedrock Edition
Unlike *Java Edition*, where there is a unified standard and handling methods of resource location, namespaced identifiers are usually treated as normal strings in Bedrock Edition. Moreover, namespaced identifiers are even not required in some cases (e.g. recipe's identifier). However, for content creators, it is recommended to always use namespaced identifiers no matter whether required or not.

The following is a list of all places that use namespaced identifiers: <!-- Todo add more, incomplete-->

#### Build-in contents
:* Vanilla blocks, items, entities, status effects, dimensions, biomes, structures, features, etc.
:* Entity attributes
:* Item components for commands
:* Components for block, entity, etc. used in add-on files
:* Json schemas for addons
:* Gametest script enabled components

#### Registried add-on entries
A registried add-on entry refers to add-on content that is registered with an identifier which is declared in add-on files.

Here is a list of registried add-on entries whose identifiers can be namespaced.

; Behavior pack contents
:* Blocks
:* Entities
:* Items
:* Spawn rules
:* Biomes
:* Features
:* Feature rules
:* Volumes
:* Recipes
:* Structures
:* Gametests
:* Diolog scenes
:* Spawn groups

; Resource pack contents
:* Attachables
:* Cameras
:* Particle effects
:* Fog settings

Some custom fields in add-on files can also be namespaced, such as custom block properties and entity component groups, which aren't listed here.

#### Others

:* Structures saved with structure block

## Namespaces
{{quote|This isn't a new concept, but I thought I should reiterate what a "namespace" is. Most things in the game has a namespace, so that if we add {{cd|something}} and a mod (or map, or whatever) adds {{cd|something}}, they're both different {{cd|something}}s. Whenever you're asked to name something, for example a loot table, you're expected to also provide what namespace that thing comes from. If you don't specify the namespace, we default to {{cd|minecraft}}. This means that {{cd|something}} and {{cd|minecraft:something}} are the same thing.|[Dinnerbone](dinnerbone.md)|namespaces<ref>{{snap|17w43a}}</ref>|Nathan Adams Mojang avatar.png}}

A namespace is a domain for content. It is to prevent potential content conflicts or unintentional overrides of objects of the same name.

For example, two data packs add two minigame mechanisms to Minecraft; both have a function named {{cd|start}}. Without namespaces, these two functions would clash and the minigames would be broken. When they have different namespaces of {{cd|minigame_one}} and {{cd|minigame_two}}, the functions would become {{cd|minigame_one:start}} and {{cd|minigame_two:start}}, which no longer conflict.

### {{cd|minecraft}} namespace
Minecraft reserves the {{cd|minecraft}} namespace. When a namespace is not specified, a resource location falls back to {{cd|minecraft}}{{only|java}}. As a result, the {{cd|minecraft}} namespace should only be used by content creators when the content needs to overwrite or modify existing Minecraft data, such as adding a function to the {{cd|minecraft:load}} function tag.

### Custom namespace
The namespace should be distinct for different projects or content creations (e.g. a data pack, a resource pack, a mod, backing data/resource packs for a custom map, etc.)

To prevent potential clashes, the namespace should be as specific as possible.

- Avoid [alphabet soups](wikipedia-alphabet-soup-linguistics.md). For example, a project named "nuclear craft" should not use the namespace {{cd|nc}}, as this is too ambiguous.
- Avoid words that are too vague. {{cd|battle_royale}} would not be informative to look up as well, but {{cd|*player_name*_battle_royale}} would be much better.

In either case, these poorly chosen namespaces reduce the exposure of a project and bring difficulties for debugging when there are multiple content creations applied to the game.

### Other built-in namespaces
> **Note:** This content is exclusive to the Java Edition.
The vanilla Minecraft resource pack declares Realms-oriented language files in the {{cd|realms}} namespace (located at assets/realms/lang/.json) and game-related language files in the {{cd|minecraft}} namespace, even though translation keys are not resource locations. The realms jar itself also declares its en_us.json language file and its various textures in the {{cd|realms}} namespace.

In the IDs of command argument types, a {{cd|brigadier}} namespace also appears for command argument types that are native to Brigadier.

## History
{{HistoryTable
|{{HistoryLine|java}}
|{{HistoryLine||1.6.1|dev=13w21a|Added resource locations alongside the {{cd|minecraft}} prefix for identifying assets.}}
|{{HistoryLine||1.7.2|dev=13w37a|Commands now accept name IDs aside from numerical IDs.}}
|{{HistoryLine||1.11|dev=16w32a|Resource locations now have a character restriction.
|Disallowed uppercase characters in resource locations.}}
|{{HistoryLine||1.13|dev=17w47a|After the [flattening](flattening.md), resource locations are the only accepted form of identifiers.}}
|{{HistoryLine|||dev=pre4|Resource locations are now used to identify plugin message channels.<ref>[Protocol History](https://wiki.vg/Protocol_History#1.13-pre4) – wiki.vg</ref>}}
|{{HistoryLine||1.14.4|dev=pre1|The <samp>realms</samp> namespace is added to the [client jar](client.jar.md)'s builtin resource pack.}}
|{{HistoryLine||1.16|dev=20w14a|[Attribute](attribute.md)s are now resource locations.}}

|{{HistoryLine|pocket alpha}}
|{{HistoryLine||v0.16.0|dev=build 1|Added [commands](commands.md), which supported string IDs. However, these identifiers were not namespaced yet.}}
|{{HistoryLine|||dev=build 4|All entity [attribute](attribute.md)s are now namespaced.}}

|{{HistoryLine|bedrock}}
|{{HistoryLine||1.6.0|dev=beta 1.6.0.5|In the save files for worlds, items now use namespaced IDs instead of numeric IDs.}}
|{{HistoryLine||1.12.0|dev=beta 1.12.0.2|IDs are now namespaced using the {{cd|minecraft}} prefix, to support custom items being added through [add-on](add-on.md)s.}}
}}

## See also

- [Java Edition data values](java-edition-data-values.md)
- [Bedrock Edition data values](bedrock-edition-data-values.md)
- [Resource pack](resource-pack.md)
- [Data pack](data-pack.md)
- [Add-on](add-on.md)

## References
{{reflist}}

## External links
- Namespaces, as explained in {{snap|17w43a}}.

## Navigation
{{Navbox Java Edition technical|general}}
{{Navbox Bedrock Edition}}

[de:Namensraum](de-namensraum.md)
[es:Ubicación de recurso](es-ubicacin-de-recurso.md)
[fr:Emplacement de ressource](fr-emplacement-de-ressource.md)
[ja:名前空間ID](ja-id.md)
[ko:리소스 위치](ko.md)
[pt:Localização de recurso](pt-localizao-de-recurso.md)
[ru:Пространство имён идентификаторов](ru.md)
[uk:Простір імен ідентифікаторів](uk.md)
[zh:命名空间ID](zh-id.md)
