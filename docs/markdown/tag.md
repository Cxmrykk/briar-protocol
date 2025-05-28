> _About: data pack and behavior pack tags|other uses|Tag (disambiguation)_

**Tags** (also called **registry tags**) in [data pack](data-pack.md)s{{only|je|short=1}} and [behavior pack](behavior-pack.md)s{{only|be|short=1}} allow players to group different game elements together.

## Usage
### Java Edition

Tags are part of the data pack directory structure, highlighted below:

<div class="treeview">
*{{File|archive}}/{{File|directory|{{ph|data pack name}}}}
**{{File|file|[pack.mcmeta](data_pack.md#packmcmeta)}}
**{{File|directory|data}}
***{{File|directory|{{ph|namespace}}}}
****{{File|directory|**tags**}}
*****{{File|directory|**function**}}
******{{File|file|**{{ph|name}}.json**}}: A function tag.
*****{{File|directory|**<[registry name](resource-location.md#registries-and-registry-objects)>**}}
******{{File|file|**{{ph|name}}.json**}}: A tag for the corresponding registry.
****[More directories…](data-pack.md#folderstructure)
</div>

Minecraft defines many tags in the vanilla data pack in the {{cd|minecraft}} namespace. These tags are often referenced by the code or other vanilla data pack files. Modifying those tags through a data pack therefore has a direct effect. For example, vanilla block tags are used for various block behaviors, vanilla item tags are used for various item behaviors, vanilla [advancement](advancement.md) files and vanilla [recipe](recipe.md) files, and vanilla entity type tags are used for various mob behaviors. See {{slink||List of tag types}} section for their usages.

#### Resource location

The resource location of a tag is also in the format of {{cd|{{ph|namespace}}:{{ph|path}}}}, where namespace is the name of the folder that the {{mono|tags}} folder is in, and path is the JSON file's path under the respective tag folder.

For example, JSON file '{{mono|data/wiki/tags/block/foo/example.json}}' defines a block tag with the resource location of {{cd|wiki:foo/example}}.

To distinguish normal contents from tags, a {{cd|#}} is usually required before tag's resource location.

#### JSON format

<div class="treeview">
*{{nbt|compound}} The root object.
**{{nbt|boolean|replace}}: Optional. Whether or not the contents of this tag should completely replace tag contents from different lower priority data packs with the same resource location. When {{cd|false}} the tag's content is appended to the contents of the higher priority data packs, instead. Defaults to {{cd|false}}.
**{{nbt|list|values}}: A list of mix and match of object names and tag names. For tags, recursive reference is possible, but a circular reference causes a loading failure.
***{{nbt|string}}: An object's [resource location](resource-location.md).
***{{nbt|string}}: ID of another tag of the same type, prefixed with a {{cd|#}}.
***{{nbt|compound}}: An entry with additional options.
****{{nbt|string|id}}: A string in one of the string formats above.
****{{nbt|boolean|required}}: Whether or not loading this tag should fail if this entry is not found, true by default (also for the string entries). A tag that fails to load can still be referenced in any data pack and be (re)defined in other data packs. In other words, only the entries in this JSON file are ignored if this entry cannot be found.
</div>

### Bedrock Edition
Tags are defined in the block's, item's, and biome's behavior as follows:

#### JSON format
<div class="treeview">
*{{nbt|compound}} The root object.
**{{nbt|compound|minecraft:{{ph|definition}}}}: The type of definition. Must be a {{cd|block}}, {{cd|item}}, or {{cd|biome}}.
***{{nbt|compound|components}}
****{{nbt|compound|minecraft:tags}} (Biomes and items only)
*****{{nbt|list|tags}}: List of tags.
******{{nbt|string}}: A tag name.
****{{nbt|compound|tag:{{ph|tag name}}}}: (Blocks only) {{cd|{{ph|tag name}}}} is replaced by the name of the tag. Object must be empty.
</div>
A block, item, or biome may have multiple tags. Custom and vanilla tags are authorized.

Tags can be used to run queries in commands and behavior packs.

## List of tag types

This section lists the tag types that are used by the game to affect its behavior in various ways, as well as those that are populated by default, even if the game does not use them to control some behavior.

### Java Edition

It is possible to define tags for any [registry](registry.md). The list below show only the ones used by the game.

- [Block](block-tag-java-edition.md)
- [Item](item-tag-java-edition.md)
- [Function](function-tag-java-edition.md)
- [Fluid](fluid-tag-java-edition.md)
- [Entity type](entity-type-tag-java-edition.md)
- [Game event](game-event-tag-java-edition.md)
- [Biome](biome-tag-java-edition.md)
- [Flat level generator preset](flat-level-generator-preset-tag-java-edition.md)
- [World preset](world_preset-tag-java-edition.md)
- [Structure](structure-tag-java-edition.md)
- [Cat variant](cat_variant-tag-java-edition.md)
- [Point of interest type](point-of-interest-type-tag-java-edition.md)
- [Painting variant](painting-variant-tag-java-edition.md)
- [Banner pattern](banner-pattern-tag-java-edition.md)
- [Instrument](instrument-tag-java-edition.md)
- [Damage type](damage-type-tag-java-edition.md)
- [Enchantment](enchantment-tag-java-edition.md)
- [Dialog](dialog-tag-java-edition.md){{upcoming|je 1.21.6}}

### Bedrock Edition

- [Block](block-tag-bedrock-edition.md)
- [Item](item-tag-bedrock-edition.md)
- [Biome](biome-tag-bedrock-edition.md)

## History
{{HistoryTable
|{{HistoryLine|java}}
|{{HistoryLine||1.13|dev=17w49a|Added tags type for blocks and items.}}
|{{HistoryLine|||dev=17w49b|Functions can now be tagged.}}
|{{HistoryLine|||dev=18w19a|Added fluids tag type.}}
|{{HistoryLine||1.14|dev=18w43a|Added entitys tag type.}}
|{{HistoryLine||1.16.2|dev=20w30a|Added the {{cd|replace}} property in tag.}}
|{{HistoryLine|||dev=Release Candidate 1|Entries in a tag can now be optional with the {{cd|required}} property.}}
|{{HistoryLine||1.16.5|dev=20w49a|Added game events tag type.}}
|{{HistoryLine||1.18.2|dev=22w06a|Tags can now be defined for any type in the registry, rather than only blocks, items, fluids, entity types, game events and functions previously.}}
|{{HistoryLine||1.18.2|dev=22w07a|Added biome tags.}}
|{{HistoryLine||1.19|dev=22w11a|Added world preset and flat level generator preset tags.
|Added structure tags.}}
|{{HistoryLine|||dev=22w14a|Added cat variant and point of interest tags.}}
|{{HistoryLine|||dev=22w16a|Added painting variant tags.}}
|{{HistoryLine|||dev=22w18a|Added banner pattern and instrument tags.}}
|{{HistoryLine||1.19.4|dev=23w06a|Added damage type tags.}}
|{{HistoryLine||1.20.5|dev=Pre-release 1|Added enchantment tags.}}
|{{HistoryLine||1.21.6|dev=25w20a|Added dialog tags.}}

|{{HistoryLine|bedrock}}
|{{HistoryLine||?|Added tags for blocks, items, and biomes.}}
|{{HistoryLine||1.19.40|dev=Preview 1.19.40.22|Added new item tags.}}
|{{HistoryLine||1.20.50|dev=Preview 1.20.50.20|The way an item can be tagged has been changed.}}
|{{HistoryLine||1.20.60|dev=Preview 1.20.60.24|The way a biome can be tagged has been changed.}}
}}

## Issues
{{Issue list|-Name}}

## Navigation
{{Navbox data packs}}

[de:Aliasdaten](de-aliasdaten.md)
[es:Etiqueta (técnico)](es-etiqueta-tcnico.md)
[fr:Tag](fr-tag.md)
[ja:タグ](ja.md)
[ko:태그](ko.md)
[pt:Marcação](pt-marcao.md)
[ru:Тег](ru.md)
[th:แท็ก](th.md)
[uk:Теґ](uk.md)
[zh:标签](zh.md)
