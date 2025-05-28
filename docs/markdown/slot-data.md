The **Slot** data structure defines how an item is represented when inside an inventory window of any kind, such as a chest or furnace.

This page presents the new Slot data structure, using structured components. You can find the documentation of the old structure, that utilizes raw NBT data, [here](2768623.md).

= Format =

<table class="wikitable">
  <tbody>
    <tr>
      <th colspan="2">Name</th>
      <th colspan="2">Type</th>
      <th>Meaning</th>
    </tr>
    <tr>
      <td colspan="2">Item Count</td>
      <td colspan="2">`VarInt`</td>
      <td>The item count. Every following field is only present if this value is greater than zero.</td>
    </tr>
    <tr>
      <td colspan="2">Item ID</td>
      <td colspan="2">`Optional` `VarInt`</td>
      <td>The [item ID](java-edition-data-values.md#blocks). Item IDs are distinct from block IDs; see [Data Generators](data-generators.md) for more information.</td>
    </tr>
    <tr>
      <td colspan="2">Number of components to add</td>
      <td colspan="2">`Optional` `VarInt`</td>
      <td>Number of elements present in the first data component array</td>
    </tr>
    <tr>
      <td colspan="2">Number of components to remove</td>
      <td colspan="2">`Optional` `VarInt`</td>
      <td>Number of elements present in the second data component array. This serve as a way to remove the default component values that are present on some items.</td>
    </tr>
    <tr>
      <td rowspan="2">Components to add</td>
      <td>Component type</td>
      <td rowspan="2">`Optional` `Array`</td>
      <td>`VarInt` `Enum`</td>
      <td colspan="2">The type of component. See [[#Structured_components|Structured components]] for more detail.</td>
    </tr>
    <tr>
      <td>Component data</td>
      <td>Varies</td>
      <td colspan="1">The component-dependent data. See [[#Structured_components|Structured components]] for more detail.</td>
    </tr>
    <tr>
      <td rowspan="1">Components to remove</td>
      <td>Component type</td>
      <td rowspan="1">`Optional` `Array`</td>
      <td>`VarInt` `Enum`</td>
      <td colspan="2">The type of component. See [[#Structured_components|Structured components]] for more detail.</td>
    </tr>
  </tbody>
</table>


= Hashed Format =

Similar to [[#Format|the usual slot format]], but with the notable difference that data component values are encoded as a CRC32 hash of their type ID and value instead of their actual value. It's currently only used in the [click container](java_edition_protocol-packets.md#clickcontainer) packet.

<table class="wikitable">
  <tbody>
    <tr>
      <th colspan="2">Name</th>
      <th colspan="2">Type</th>
      <th>Meaning</th>
    </tr>
    <tr>
      <td colspan="2">Has Item</td>
      <td colspan="2">`Boolean`</td>
      <td>Every following field is only present if this value is true.</td>
    </tr>
    <tr>
      <td colspan="2">Item ID</td>
      <td colspan="2">`Optional` `VarInt`</td>
      <td>The [item ID](java-edition-data-values.md#blocks). Item IDs are distinct from block IDs; see [Data Generators](data-generators.md) for more information.</td>
    </tr>
    <tr>
      <td colspan="2">Item Count</td>
      <td colspan="2">`Optional` `VarInt`</td>
      <td>The item count.</td>
    </tr>
    <tr>
      <td rowspan="2">Components to add</td>
      <td>Component type</td>
      <td rowspan="2">`Optional` `Prefixed Array`</td>
      <td>`VarInt` `Enum`</td>
      <td colspan="2">The type of component. See [[#Structured_components|Structured components]] for more detail.</td>
    </tr>
    <tr>
      <td>Component data hash</td>
      <td>`Int`</td>
      <td colspan="1">The CRC32 hash of a buffer with the component type (encoded the same as above) and value, concatenated. See [[#Structured_components|Structured components]] for how the values are serialized.</td>
    </tr>
    <tr>
      <td rowspan="1">Components to remove</td>
      <td>Component type</td>
      <td rowspan="1">`Optional` `Prefixed Array`</td>
      <td>`VarInt` `Enum`</td>
      <td colspan="2">The type of component. See [[#Structured_components|Structured components]] for more detail.</td>
    </tr>
  </tbody>
</table>

= Structured components =

The complete list of available components is described below.

For a more in-depth description, and information on how the items below are encoded with the NBT format, check [here](https://minecraft.wiki/w/Data_component_format).


<table class="wikitable">
  <tbody>
    <tr>
      <th>Type</th>
      <th>Name</th>
      <th>Description</th>
      <th>Data</th>
    </tr>
    <tr>
      <td>0</td>
      <td>`minecraft:custom_data`</td>
      <td>Customizable data that doesn't fit any specific component.</td>
      <td>As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Data</td>
      <td>`NBT`</td>
      <td>Always a Compound Tag.</td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>1</td>
      <td>`minecraft:max_stack_size`</td>
      <td>Maximum stack size for the item.</td>
      <td>As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Max Stack Size</td>
      <td>`VarInt`</td>
      <td>Ranges from 1 to 99.</td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>2</td>
      <td>`minecraft:max_damage`</td>
      <td>The maximum damage the item can take before breaking.</td>
      <td>As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Max Damage</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>3</td>
      <td>`minecraft:damage`</td>
      <td>The current damage of the item.</td>
      <td>As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Damage</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>4</td>
      <td>`minecraft:unbreakable`</td>
      <td>Marks the item as unbreakable.</td>
      <td>*no fields*</td>
    </tr>
    <tr>
      <td>5</td>
      <td>`minecraft:custom_name`</td>
      <td>Item's custom name.<br>Normally shown in italic, and changeable at an anvil.</td>
      <td>As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Name</td>
      <td>`Text Component`</td>
      <td></td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>6</td>
      <td>`minecraft:item_name`</td>
      <td>Override for the item's default name.<br>Shown when the item has no custom name.</td>
      <td>As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Name</td>
      <td>`Text Component`</td>
      <td></td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>7</td>
      <td>`minecraft:item_model`</td>
      <td>Item's model.</td>
      <td>As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Model</td>
      <td>`Identifier`</td>
      <td></td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>8</td>
      <td>`minecraft:lore`</td>
      <td>Item's lore.</td>
      <td>As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Lines</td>
      <td>`Prefixed Array` of `Text Component`</td>
      <td></td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>9</td>
      <td>`minecraft:rarity`</td>
      <td>Item's rarity.<br>This affects the default color of the item's name.</td>
      <td>As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Rarity</td>
      <td>`VarInt` `Enum`</td>
      <td>Can be one of the following:
* 0 - Common (white)
* 1 - Uncommon (yellow)
* 2 - Rare (aqua)
* 3 - Epic (pink)</td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>10</td>
      <td>`minecraft:enchantments`</td>
      <td>The enchantments of the item.</td>
      <td>As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th colspan="2">Name</th>
      <th colspan="2">Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td rowspan="2">Enchantment</td>
      <td>Type ID</td>
      <td rowspan="2">`Prefixed Array`</td>
      <td>`VarInt` `Enum`</td>
      <td>The ID of the enchantment in the enchantment registry.</td>
    </tr>
    <tr>
      <td>Level</td>
      <td>`VarInt`</td>
      <td>The level of the enchantment.</td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>11</td>
      <td>`minecraft:can_place_on`</td>
      <td>List of blocks this block can be placed on when in adventure mode.</td>
      <td>As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Block Predicates</td>
      <td>`Prefixed Array` of [[#Block_Predicate|Block Predicate]]</td>
      <td>See [[#Block_Predicate|Block Predicate]].</td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>12</td>
      <td>`minecraft:can_break`</td>
      <td>List of blocks this item can break when in adventure mode.</td>
      <td>As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Block Predicates</td>
      <td>`Prefixed Array` of [[#Block_Predicate|Block Predicate]]</td>
      <td>See [[#Block_Predicate|Block Predicate]].</td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>13</td>
      <td>`minecraft:attribute_modifiers`</td>
      <td>The attribute modifiers of the item.</td>
      <td>As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th colspan="2">Name</th>
      <th colspan="2">Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td rowspan="5">Attribute Modifier</td>
      <td>Attribute ID</td>
      <td rowspan="5">`Prefixed Array`</td>
      <td>`VarInt`</td>
      <td>The attribute to be modified (ID in the `minecraft:attribute` registry).</td>
    </tr>
    <tr>
      <td>Modifier ID</td>
      <td>`Identifier`</td>
      <td>The modifier's unique ID.</td>
    </tr>
    <tr>
      <td>Value</td>
      <td>`Double`</td>
      <td>The modifier's value.</td>
    </tr>
    <tr>
      <td>Operation</td>
      <td>`VarInt` `Enum`</td>
      <td>The operation to be applied upon the value. Can be one of the following:
* 0 - Add
* 1 - Multiply base
* 2 - Multiply total</td>
    </tr>
    <tr>
      <td>Slot</td>
      <td>`VarInt` `Enum`</td>
      <td>The item slot placement required for the modifier to have effect.<br>Can be one of the following:
* 0 - Any
* 1 - Main hand
* 2 - Off hand
* 3 - Hand
* 4 - Feet
* 5 - Legs
* 6 - Chest
* 7 - Head
* 8 - Armor
* 9 - Body</td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>14</td>
      <td>`minecraft:custom_model_data`</td>
      <td>Value for the item predicate when using custom item models.<br>More info can be found [here](https://minecraft.wiki/w/Tutorials/Models#Item_predicates).</td>
      <td>As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Floats</td>
      <td>`Prefixed Array` of `Float`</td>
      <td></td>
    </tr>
    <tr>
      <td>Flags</td>
      <td>`Prefixed Array` of `Boolean`</td>
      <td></td>
    </tr>
    <tr>
      <td>Strings</td>
      <td>`Prefixed Array` of `String`</td>
      <td></td>
    </tr>
    <tr>
      <td>Colors</td>
      <td>`Prefixed Array` of `Int`</td>
      <td></td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>15</td>
      <td>`minecraft:tooltip_display`</td>
      <td>Allows you to hide all or parts of the item tooltip.</td>
      <td>As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Hide tooltip</td>
      <td>`Boolean`</td>
      <td>Whether to hide the tooltip entirely.</td>
    </tr>
    <tr>
      <td>Hidden components</td>
      <td>`Prefixed Array` of `VarInt` `Enum`</td>
      <td>The IDs of data components in the `minecraft:data_component_type` registry to hide.</td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>16</td>
      <td>`minecraft:repair_cost`</td>
      <td>Accumulated anvil usage cost. The client displays "Too Expensive" if the value is greater than 40 and the player is not in creative mode (more specifically, if they don't have the [insta-build flag enabled](protocol.md#playerabilitiesclientbound)).<br>This behavior can be overridden by setting the level with the [Set Container Property](protocol.md#setcontainerproperty) packet.</td>
      <td>As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Cost</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>17</td>
      <td>`minecraft:creative_slot_lock`</td>
      <td>Marks the item as non-interactive on the creative inventory (the first 5 rows of items).<br>This is used internally by the client on the paper icon in the saved hot-bars tab.</td>
      <td>*no fields*</td>
    </tr>
    <tr>
      <td>18</td>
      <td>`minecraft:enchantment_glint_override`</td>
      <td>Overrides the item glint resulted from enchantments</td>
      <td>As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Has Glint</td>
      <td>`Boolean`</td>
      <td></td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>19</td>
      <td>`minecraft:intangible_projectile`</td>
      <td>Marks the projectile as intangible (cannot be picked-up).</td>
      <td>As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Empty</td>
      <td>`NBT`</td>
      <td>Always an empty Compound Tag.</td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>20</td>
      <td>`minecraft:food`</td>
      <td>Makes the item restore the player's hunger bar when consumed.</td>
      <td>As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th colspan="2">Name</th>
      <th colspan="2">Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td colspan="2">Nutrition</td>
      <td colspan="2">`VarInt`</td>
      <td>Non-negative</td>
    </tr>
    <tr>
      <td colspan="2">Saturation Modifier</td>
      <td colspan="2">`Float`</td>
      <td>How much saturation will be given after consuming the item.</td>
    </tr>
    <tr>
      <td colspan="2">Can Always Eat</td>
      <td colspan="2">`Boolean`</td>
      <td>Whether the item can always be eaten, even at full hunger.</td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>21</td>
      <td>`minecraft:consumable`</td>
      <td>Makes the item consumable.</td>
      <td>As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Consume seconds</td>
      <td>`Float`</td>
      <td>How long it takes to consume the item.</td>
    </tr>
    <tr>
      <td>Animation</td>
      <td>`VarInt` `Enum`</td>
      <td>0: none, 1: eat, 2: drink, 3: block, 4: bow, 5: spear, 6: crossbow, 7: spyglass, 8: toot_horn, 9: brush</td>
    </tr>
    <tr>
      <td>Sound</td>
      <td>`ID or` `Sound Event`</td>
      <td>ID in the `minecraft:sound_event` registry, or an inline definition.</td>
    </tr>
    <tr>
      <td>Has consume particles</td>
      <td>`Boolean`</td>
      <td></td>
    </tr>
    <tr>
      <td>Effects</td>
      <td>`Prefixed Array` of [[#Consume Effect|Consume Effect]]</td>
      <td>Effects to apply on consumption. See [[#Consume Effect|Consume Effect]].</td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>22</td>
      <td>`minecraft:use_remainder`</td>
      <td>This specifies the item produced after using the current item. In the Notchian server, this is used for stews, which turn into bowls.</td>
      <td>As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Remainder</td>
      <td>`Slot`</td>
      <td></td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>23</td>
      <td>`minecraft:use_cooldown`</td>
      <td>Cooldown to apply on use of the item.</td>
      <td>As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Seconds</td>
      <td>`Float`</td>
      <td></td>
    </tr>
    <tr>
      <td>Cooldown group</td>
      <td>`Optional` `Identifier`</td>
      <td>Group of items to apply the cooldown to. Only present if Has cooldown group is true; otherwise defaults to the item's identifier.</td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>24</td>
      <td>`minecraft:damage_resistant`</td>
      <td>Marks this item as damage resistant.<br>The client won't render the item as being on-fire if this component is present.</td>
      <td>As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Types</td>
      <td>`Identifier`</td>
      <td>Tag specifying damage types the item is immune to. Not prefixed by '#'!.</td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>25</td>
      <td>`minecraft:tool`</td>
      <td>Alters the speed at which this item breaks certain blocks</td>
      <td>As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th colspan="2">Name</th>
      <th colspan="2">Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td rowspan="5">Rule</td>
      <td>Blocks</td>
      <td rowspan="5">`Prefixed Array`</td>
      <td>`ID Set`</td>
      <td>The blocks this rule applies to (IDs in the `minecraft:block` registry).</td>
    </tr>
    <tr>
      <td>Has Speed</td>
      <td>`Boolean`</td>
      <td></td>
    </tr>
    <tr>
      <td>Speed</td>
      <td>`Optional` `Float`</td>
      <td>The speed at which the tool breaks this rules' blocks. Only present if Has Speed is true.</td>
    </tr>
    <tr>
      <td>Has Correct Drop For Blocks</td>
      <td>`Boolean`</td>
      <td></td>
    </tr>
    <tr>
      <td>Correct Drop For Blocks</td>
      <td>`Optional` `Boolean`</td>
      <td>Whether items should drop only if this is the correct tool. Only present if Has Correct Drop For Blocks is true.</td>
    </tr>
    <tr>
      <td colspan="2">Default Mining Speed</td>
      <td colspan="2">`Float`</td>
      <td>The mining speed in case none of the previous rule were matched.</td>
    </tr>
    <tr>
      <td colspan="2">Damage Per Block</td>
      <td colspan="2">`VarInt`</td>
      <td>The amount of damage the item takes per block break.</td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>26</td>
      <td>`minecraft:weapon`</td>
      <td>Item treated as a weapon</td>
      <td>As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Damage Per Attack</td>
      <td>`VarInt`</td>
    </tr>
    <tr>
      <td>Disable Blocking For</td>
      <td>`Float`</td>
      <td>In Seconds</td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>27</td>
      <td>`minecraft:enchantable`</td>
      <td>Allows the item to be enchanted by an enchanting table.</td>
      <td>As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Value</td>
      <td>`VarInt`</td>
      <td>Opaque internal value controlling how expensive enchantments may be offered.</td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>28</td>
      <td>`minecraft:equippable`</td>
      <td>Allows the item to be equipped by the player.</td>
      <td>As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Slot</td>
      <td>`VarInt` `Enum`</td>
      <td>0: mainhand, 1: feet, 2: legs, 3: chest, 4: head, 5: offhand, 6: body</td>
    </tr>
    <tr>
      <td>Equip sound</td>
      <td>`ID or` `Sound Event`</td>
      <td>ID in the `minecraft:sound_event` registry, or an inline definition.</td>
    </tr>
    <tr>
      <td>Has model</td>
      <td>`Boolean`</td>
      <td></td>
    </tr>
    <tr>
      <td>Model</td>
      <td>`Optional` `Identifier`</td>
      <td>Only present if Has model is true.</td>
    </tr>
    <tr>
      <td>Has camera overlay</td>
      <td>`Boolean`</td>
      <td></td>
    </tr>
    <tr>
      <td>Camera overlay</td>
      <td>`Optional` `Identifier`</td>
      <td>Only present if Has camera overlay is true.</td>
    </tr>
    <tr>
      <td>Has allowed entities</td>
      <td>`Boolean`</td>
    </tr>
    <tr>
      <td>Allowed entities</td>
      <td>`Optional` `ID Set`</td>
      <td>IDs in the `minecraft:entity_type` registry. Only present if Has allowed entities is true.</td>
    </tr>
    <tr>
      <td>Dispensable</td>
      <td>`Boolean`</td>
      <td></td>
    </tr>
    <tr>
      <td>Swappable</td>
      <td>`Boolean`</td>
      <td></td>
    </tr>
    <tr>
      <td>Damage on hurt</td>
      <td>`Boolean`</td>
      <td></td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>29</td>
      <td>`minecraft:repairable`</td>
      <td>Items that can be combined with this item in an anvil to repair it.</td>
      <td>As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Items</td>
      <td>`ID Set`</td>
      <td>IDs in the `minecraft:item` registry.</td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>30</td>
      <td>`minecraft:glider`</td>
      <td>Makes the item function like elytra.</td>
      <td>*no fields*</td>
    </tr>
    <tr>
      <td>31</td>
      <td>`minecraft:tooltip_style`</td>
      <td>Custom textures for the item tooltip.</td>
      <td>As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Style</td>
      <td>`Identifier`</td>
      <td></td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>32</td>
      <td>`minecraft:death_protection`</td>
      <td>Makes the item function like a totem of undying.</td>
      <td>As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Effects</td>
      <td>`Prefixed Array` of [[#Consume Effect|Consume Effect]]</td>
      <td>Effects to apply on consumption. See [[#Consume Effect|Consume Effect]].</td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>33</td>
      <td>`minecraft:blocks_attacks`</td>
      <td>Makes the item act like a shield.</td>
      <td>As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th colspan="2">Name</th>
      <th colspan="2">Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td colspan="2">Block delay seconds</td>
      <td colspan="2">`Float`</td>
      <td></td>
    </tr>
    <tr>
      <td colspan="2">Disable cooldown scale</td>
      <td colspan="2">`Float`</td>
      <td></td>
    </tr>
    <tr>
      <td rowspan="4">Damage reductions</td>
      <td>Horizontal blocking angle</td>
      <td rowspan="4">`Prefixed Array`</td>
      <td>`Float`</td>
      <td></td>
    </tr>
    <tr>
      <td>Type</td>
      <td>`Prefixed Optional` `ID Set`</td>
      <td>IDs in the `minecraft:damage_kind` registry.</td>
    </tr>
    <tr>
      <td>Base</td>
      <td>`Float`</td>
      <td></td>
    </tr>
    <tr>
      <td>Factor</td>
      <td>`Float`</td>
      <td></td>
    </tr>
    <tr>
      <td colspan="2">Item damage threshold</td>
      <td colspan="2">`Float`</td>
      <td></td>
    </tr>
    <tr>
      <td colspan="2">Item damage base</td>
      <td colspan="2">`Float`</td>
      <td></td>
    </tr>
    <tr>
      <td colspan="2">Item damage factor</td>
      <td colspan="2">`Float`</td>
      <td></td>
    </tr>
    <tr>
      <td colspan="2">Bypassed by</td>
      <td colspan="2">`Prefixed Optional` `Identifier`</td>
      <td></td>
    </tr>
    <tr>
      <td colspan="2">Block sound</td>
      <td colspan="2">`Prefixed Optional` `ID Or` `Sound Event`</td>
      <td></td>
    </tr>
    <tr>
      <td colspan="2">Disable sound</td>
      <td colspan="2">`Prefixed Optional` `ID Or` `Sound Event`</td>
      <td></td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>34</td>
      <td>`minecraft:stored_enchantments`</td>
      <td>The enchantments stored in this enchanted book.</td>
      <td>As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th colspan="2">Name</th>
      <th colspan="2">Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td rowspan="2">Enchantment</td>
      <td>Type ID</td>
      <td rowspan="2">`Prefixed Array`</td>
      <td>`VarInt` `Enum`</td>
      <td>The ID of the enchantment in the enchantment registry.</td>
    </tr>
    <tr>
      <td>Level</td>
      <td>`VarInt`</td>
      <td>The level of the enchantment.</td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>35</td>
      <td>`minecraft:dyed_color`</td>
      <td>Color of dyed leather armor.</td>
      <td>As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Color</td>
      <td>`Int`</td>
      <td>The RGB components of the color, encoded as an integer.</td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>36</td>
      <td>`minecraft:map_color`</td>
      <td>Color of the markings on the map item model.</td>
      <td>As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Color</td>
      <td>`Int`</td>
      <td>The RGB components of the color, encoded as an integer.</td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>37</td>
      <td>`minecraft:map_id`</td>
      <td>The ID of the map.</td>
      <td>As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>ID</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>38</td>
      <td>`minecraft:map_decorations`</td>
      <td>Icons present on a map.</td>
      <td>As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Data</td>
      <td>`NBT`</td>
      <td>Always a Compound Tag.</td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>39</td>
      <td>`minecraft:map_post_processing`</td>
      <td>Used internally by the client when expanding or locking a map. Display extra information on the item's tooltip when the component is present.</td>
      <td>As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Type</td>
      <td>`VarInt` `Enum`</td>
      <td>Type of post processing. Can be either:
* 0 - Lock
* 1 - Scale</td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>40</td>
      <td>`minecraft:charged_projectiles`</td>
      <td>Projectiles loaded into a charged crossbow.</td>
      <td>As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Projectiles</td>
      <td>`Prefixed Array` of `Slot`</td>
      <td>The projectiles.</td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>41</td>
      <td>`minecraft:bundle_contents`</td>
      <td>Contents of a bundle.</td>
      <td>As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Items</td>
      <td>`Prefixed Array` of `Slot`</td>
      <td>The projectiles.</td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>42</td>
      <td>`minecraft:potion_contents`</td>
      <td>Visual and effects of a potion item.</td>
      <td>As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Has Potion ID</td>
      <td>`Boolean`</td>
      <td>Whether this potion has an ID in the potion registry. If true, it has the default effects associated with the potion type.</td>
    </tr>
    <tr>
      <td>Potion ID</td>
      <td>`Optional` `VarInt`</td>
      <td>The ID of the potion type in the potion registry. Only present if Has Potion ID is true.</td>
    </tr>
    <tr>
      <td>Has Custom Color</td>
      <td>`Boolean`</td>
      <td>Whether this potion has a custom color. If false, it uses the default color associated with the potion type.</td>
    </tr>
    <tr>
      <td>Custom Color</td>
      <td>`Optional` `Int`</td>
      <td>The RGB components of the color, encoded as an integer. Only present if Has Custom Color is true.</td>
    </tr>
    <tr>
      <td>Custom Effects</td>
      <td>`Prefixed Array` of [[#Potion_Effect|Potion Effect]]</td>
      <td>Any custom effects the potion might have. See [[#Potion_Effect|Potion Effect]].</td>
    </tr>
    <tr>
      <td>Custom Name</td>
      <td>`String`</td>
      <td></td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>43</td>
      <td>`minecraft:potion_duration_scale`</td>
      <td>A duration multiplier for items that also have the `minecraft:potion_contents` component.</td>
      <td>As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
    </tr>
    <tr>
      <td>Effect Multiplier</td>
      <td>`Float`</td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>44</td>
      <td>`minecraft:suspicious_stew_effects`</td>
      <td>Effects granted by a suspicious stew.</td>
      <td>As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th colspan="2">Name</th>
      <th colspan="2">Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td rowspan="2">Effect</td>
      <td>Type ID</td>
      <td rowspan="2">`Prefixed Array`</td>
      <td>`VarInt` `Enum`</td>
      <td>The ID of the effect in the potion effect type registry.</td>
    </tr>
    <tr>
      <td>Duration</td>
      <td>`VarInt`</td>
      <td>The duration of the effect.</td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>45</td>
      <td>`minecraft:writable_book_content`</td>
      <td>Content of a writable book.</td>
      <td>As follows:</td>
      <td rowspan="3">Page</td>
      <td>Raw Content</td>
      <td rowspan="3">`Prefixed Array` (100)</td>
      <td>`String` (1024)</td>
      <td>The raw text of the page.</td>
    </tr>
    <tr>
      <td>Has Filtered Content</td>
      <td>`Boolean`</td>
      <td></td>
    </tr>
    <tr>
      <td>Filtered Content</td>
      <td>`Optional` `String` (1024)</td>
      <td>The content after passing through chat filters. Only present if Has Filtered Content is true.</td>
    </tr>
  </tbody>
</table>
 |-
 | 46
 | `minecraft:written_book_content`
 | Content of a written and signed book.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th colspan="2">Name</th>
      <th colspan="2">Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td colspan="2">Raw Title</td>
      <td colspan="2">`String` (32)</td>
      <td>The raw title of the book.</td>
    </tr>
    <tr>
      <td colspan="2">Has Filtered Title</td>
      <td colspan="2">`Boolean`</td>
      <td></td>
    </tr>
    <tr>
      <td colspan="2">Filtered Title</td>
      <td colspan="2">`Optional` `String` (32)</td>
      <td>The title after going through chat filters. Only present if Has Filtered Title is true.</td>
    </tr>
    <tr>
      <td colspan="2">Author</td>
      <td colspan="2">`String`</td>
      <td></td>
    </tr>
    <tr>
      <td colspan="2">Generation</td>
      <td colspan="2">`VarInt`</td>
      <td></td>
    </tr>
    <tr>
      <td rowspan="3">Page</td>
      <td>Raw Content</td>
      <td rowspan="3">`Prefixed Array` (100)</td>
      <td>`TextComponent` (1024)</td>
      <td>The raw text of the page.</td>
    </tr>
    <tr>
      <td>Has Filtered Content</td>
      <td>`Boolean`</td>
      <td></td>
    </tr>
    <tr>
      <td>Filtered Content</td>
      <td>`Optional` `Text Component` (1024)</td>
      <td>The content after passing through chat filters. Only present if Has Filtered Content is true.</td>
    </tr>
    <tr>
      <td colspan="2">Resolved</td>
      <td colspan="2">`Boolean`</td>
      <td>Whether entity selectors have already been resolved.</td>
    </tr>
  </tbody>
</table>
 |-
 | 47
 | `minecraft:trim`
 | Armor's trim pattern and color
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Trim Material</td>
      <td>`ID or` [[#Trim Material|Trim Material]]</td>
      <td>ID in the `minecraft:trim_material` registry, or an inline definition.</td>
    </tr>
    <tr>
      <td>Trim Pattern</td>
      <td>`ID or` [[#Trim Pattern|Trim Pattern]]</td>
      <td>ID in the `minecraft:trim_pattern` registry, or an inline definition.</td>
    </tr>
  </tbody>
</table>
 |-
 | 48
 | `minecraft:debug_stick_state`
 | State of the debug stick
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Data</td>
      <td>`NBT`</td>
      <td>States of previously interacted blocks. Always a Compound Tag.</td>
    </tr>
  </tbody>
</table>
 |-
 | 49
 | `minecraft:entity_data`
 | Data for the entity to be created from this item.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Data</td>
      <td>`NBT`</td>
      <td>Always a Compound Tag.</td>
    </tr>
  </tbody>
</table>
 |-
 | 50
 | `minecraft:bucket_entity_data`
 | Data of the entity contained in this bucket.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Data</td>
      <td>`NBT`</td>
      <td>Always a Compound Tag.</td>
    </tr>
  </tbody>
</table>
 |-
 | 51
 | `minecraft:block_entity_data`
 | Data of the block entity to be created from this item.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Data</td>
      <td>`NBT`</td>
      <td>Always a Compound Tag.</td>
    </tr>
  </tbody>
</table>
 |-
 | 52
 | `minecraft:instrument`
 | The sound played when using a goat horn.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Instrument</td>
      <td>`ID or` [[#Instrument|Instrument]]</td>
      <td>ID in the `minecraft:instrument` registry, or an inline definition.</td>
    </tr>
  </tbody>
</table>
 |-
 | 53
 | `minecraft:provides_trim_material`
 | Used to make an item into a valid armor trim material.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Mode</td>
      <td>`Byte` `Enum`</td>
      <td>Defines how the following field is read, either referenced or direct.</td>
    </tr>
    <tr>
      <td>Material</td>
      <td>Varies</td>
      <td>
<table class="wikitable">
  <tbody>
    <tr>
      <th>Mode</th>
      <th>Data</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>0</td>
      <td>`Identifier`</td>
      <td>The name of a material.</td>
    </tr>
    <tr>
      <td>1</td>
      <td>`ID or` [[#Trim Material|Trim Material]]</td>
      <td>An ID in the `minecraft:trim_material` registry or a direct trim material definition.</td>
    </tr>
  </tbody>
</table></td>
    </tr>
  </tbody>
</table>
 |-
 | 54
 | `minecraft:ominous_bottle_amplifier`
 | Amplifier for the effect of an ominous bottle.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Amplifier</td>
      <td>`VarInt`</td>
      <td>Between 0 and 4.</td>
    </tr>
  </tbody>
</table>
 |-
 | 55
 | `minecraft:jukebox_playable`
 | The song this item will play when inserted into a jukebox.<br>> ⚠️ **Warning:** The Notchian client assumes that the server will always represent the jukebox song either by name, or reference an entry on its respective registry. Trying to directly specify a jukebox song (when `Jukebox Song Type` is 0) will cause the client to fail to parse it and subsequently disconnect, which is likely an unintended bug.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Mode</td>
      <td>`Byte` `Enum`</td>
      <td>Whether the jukebox song is specified directly, or just referenced by name. This defines how the following field is read.</td>
    </tr>
    <tr>
      <td>Jukebox Song</td>
      <td>Varies</td>
      <td>
<table class="wikitable">
  <tbody>
    <tr>
      <th>Mode</th>
      <th>Data</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>0</td>
      <td>`Identifier`</td>
      <td>The name of a jukebox song in its respective registry.</td>
    </tr>
    <tr>
      <td>1</td>
      <td>`ID or` [[#Jukebox Song|Jukebox Song]]</td>
      <td>ID in the `minecraft:jukebox_song` registry or a direct jukebox song.</td>
    </tr>
  </tbody>
</table></td>
    </tr>
  </tbody>
</table>
 |-
 | 56
 | `minecraft:provides_banner_patterns`
 | Used to make an item into a valid banner pattern material. 
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Key</td>
      <td>`Identifier`</td>
      <td>A pattern identifier like `#minecraft:pattern_item/globe`.</td>
    </tr>
  </tbody>
</table>
 |-
 | 57
 | `minecraft:recipes`
 | The recipes this knowledge book unlocks.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Data</td>
      <td>`NBT`</td>
      <td>Always a Compound Tag.</td>
    </tr>
  </tbody>
</table>
 |-
 | 58
 | `minecraft:lodestone_tracker`
 | The lodestone this compass points to.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Has Global Position</td>
      <td>`Boolean`</td>
      <td>Whether this lodestone points to a position, otherwise it spins randomly.</td>
    </tr>
    <tr>
      <td>Dimension</td>
      <td>`Identifier`</td>
      <td>The dimension the compass points to. Only present if Has Global Position is true.</td>
    </tr>
    <tr>
      <td>Position</td>
      <td>`Position`</td>
      <td>The position the compass points to. Only present if Has Global Position is true.</td>
    </tr>
    <tr>
      <td>Tracked</td>
      <td>`Boolean`</td>
      <td>Whether the component is removed when the associated lodestone is broken.</td>
    </tr>
  </tbody>
</table>
 |-
 | 59
 | `minecraft:firework_explosion`
 | Properties of a firework star.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Explosion</td>
      <td>[[#Firework_Explosion|Firework Explosion]]</td>
      <td>See [[#Firework_Explosion|Firework Explosion]].</td>
    </tr>
  </tbody>
</table>
 |-
 | 60
 | `minecraft:fireworks`
 | Properties of a firework.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Flight Duration</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
    <tr>
      <td>Explosions</td>
      <td>`Prefixed Array` of [[#Firework_Explosion|Firework Explosion]]</td>
      <td>See [[#Firework_Explosion|Firework Explosion]].</td>
    </tr>
  </tbody>
</table>
 |-
 | 61
 | `minecraft:profile`
 | Game Profile of a player's head.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th colspan="2">Name</th>
      <th colspan="2">Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td colspan="2">Has Name</td>
      <td colspan="2">`Boolean`</td>
      <td></td>
    </tr>
    <tr>
      <td colspan="2">Name</td>
      <td colspan="2">`Optional` `String` (16)</td>
      <td>Only present if Has Name is true.</td>
    </tr>
    <tr>
      <td colspan="2">Has Unique ID</td>
      <td colspan="2">`Boolean`</td>
      <td></td>
    </tr>
    <tr>
      <td colspan="2">Unique ID</td>
      <td colspan="2">`Optional` `UUID`</td>
      <td>Only present if Has Unique ID is true.</td>
    </tr>
    <tr>
      <td rowspan="4">Property</td>
      <td>Name</td>
      <td rowspan="4">`Prefixed Array`</td>
      <td>`String` (64)</td>
      <td></td>
    </tr>
    <tr>
      <td>Value</td>
      <td>`String`</td>
      <td></td>
    </tr>
    <tr>
      <td>Has Signature</td>
      <td>`Boolean`</td>
      <td></td>
    </tr>
    <tr>
      <td>Signature</td>
      <td>`String` (1024)</td>
      <td>Only present if Has Signature is true.</td>
    </tr>
  </tbody>
</table>
 |-
 | 62
 | `minecraft:note_block_sound`
 | Sound played by a note block when this player's head is placed on top of it.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Sound</td>
      <td>`Identifier`</td>
      <td></td>
    </tr>
  </tbody>
</table>
 |-
 | 63
 | `minecraft:banner_patterns`
 | Patterns of a banner or banner applied to a shield.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th colspan="2">Name</th>
      <th colspan="2">Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td rowspan="4">Layer</td>
      <td>Pattern Type</td>
      <td rowspan="4">`Prefixed Array`</td>
      <td>`VarInt`</td>
      <td>Identifier used to determine the data that follows. It can be either:
* 0 - Directly represents a pattern, with the necessary data following.
* Anything else - References a pattern in its registry, by the ID of `Pattern Type - 1`.</td>
    </tr>
    <tr>
      <td>Asset ID</td>
      <td>`Optional` `Identifier`</td>
      <td>Identifier of the asset. Only present if Pattern Type is 0.</td>
    </tr>
    <tr>
      <td>Translation Key</td>
      <td>`Optional` `String`</td>
      <td>Only present if Pattern Type is 0.</td>
    </tr>
    <tr>
      <td>Color</td>
      <td>[[#Dye_Color|Dye Color]]</td>
      <td>See [[#Dye_Color|Dye Color]].</td>
    </tr>
  </tbody>
</table>
 |-
 | 64
 | `minecraft:base_color`
 | Base color of the banner applied to a shield.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Color</td>
      <td>[[#Dye_Color|Dye Color]]</td>
      <td>See [[#Dye_Color|Dye Color]].</td>
    </tr>
  </tbody>
</table>
 |-
 | 65
 | `minecraft:pot_decorations`
 | Decorations on the four sides of a pot.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Decorations</td>
      <td>`Prefixed Array` (4) of `VarInt` `Enum`</td>
      <td>The ID of the items in the item registry.</td>
    </tr>
  </tbody>
</table>
 |-
 | 66
 | `minecraft:container`
 | Items inside a container of any type.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Items</td>
      <td>`Prefixed Array` (256) of `Slot`</td>
      <td></td>
    </tr>
  </tbody>
</table>
 |-
 | 67
 | `minecraft:block_state`
 | State of a block.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th colspan="2">Name</th>
      <th colspan="2">Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td rowspan="2">Property</td>
      <td>Name</td>
      <td rowspan="2">`Prefixed Array`</td>
      <td>`String`</td>
      <td></td>
    </tr>
    <tr>
      <td>Value</td>
      <td>`String`</td>
      <td></td>
    </tr>
  </tbody>
</table>
 |-
 | 68
 | `minecraft:bees`
 | Bees inside a hive.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th colspan="2">Name</th>
      <th colspan="2">Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td rowspan="3">Bee</td>
      <td>Entity Data</td>
      <td rowspan="3">`Prefixed Array`</td>
      <td>`NBT`</td>
      <td>Custom data for the entity, always a Compound Tag. Same structure as the `minecraft:custom_data` component.</td>
    </tr>
    <tr>
      <td>Ticks In Hive</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
    <tr>
      <td>Min Ticks In Hive</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
  </tbody>
</table>
 |-
 | 69
 | `minecraft:lock`
 | Name of the necessary key to open this container.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Key</td>
      <td>`NBT`</td>
      <td>Always a String Tag.</td>
    </tr>
  </tbody>
</table>
 |-
 | 70
 | `minecraft:container_loot`
 | Loot table for an unopened container.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Data</td>
      <td>`NBT`</td>
      <td>Always a Compound Tag.</td>
    </tr>
  </tbody>
</table>
 |-
 | 71
 | `minecraft:break_sound`
 | Changes the sound that plays when the item breaks. 
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Sound Event</td>
      <td>`ID or` `Sound Event`</td>
      <td>ID in the `minecraft:sound_event` registry, or an inline definition.</td>
    </tr>
  </tbody>
</table>
 |-
 | 72
 | `minecraft:villager/variant`
 | The biome variant of a villager.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Variant</td>
      <td>`VarInt` `Enum`</td>
      <td>An ID in the `minecraft:villager_type` registry.</td>
    </tr>
  </tbody>
</table>
 |-
 | 73
 | `minecraft:wolf/variant`
 | The variant of a wolf.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Variant</td>
      <td>`VarInt` `Enum`</td>
      <td>An ID in the `minecraft:wolf_variant` registry.</td>
    </tr>
  </tbody>
</table>
 |-
 | 74
 | `minecraft:wolf/sound_variant`
 | The type of sounds that a wolf makes.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Variant</td>
      <td>`VarInt` `Enum`</td>
      <td>An ID in the `minecraft:wolf_sound_variant` registry.</td>
    </tr>
  </tbody>
</table>
 |-
 | 75
 | `minecraft:wolf/collar`
 | The dye color of the wolf's collar.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
    </tr>
    <tr>
      <td>Color</td>
      <td>[[#Dye_Color|Dye Color]]</td>
    </tr>
  </tbody>
</table>
 |-
 | 76
 | `minecraft:fox/variant`
 | The variant of a fox.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Variant</td>
      <td>`VarInt` `Enum`</td>
      <td>0: red, 1: snow.</td>
    </tr>
  </tbody>
</table>
 |-
 | 77
 | `minecraft:salmon/size`
 | The size of a salmon.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Type</td>
      <td>`VarInt` `Enum`</td>
      <td>0: small, 1: medium, 2: large.</td>
    </tr>
  </tbody>
</table>
 |-
 | 78
 | `minecraft:parrot/variant`
 | The variant of a parrot.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Variant</td>
      <td>`VarInt` `Enum`</td>
      <td>An ID in the `minecraft:parrot_type` registry.</td>
    </tr>
  </tbody>
</table>
 |-
 | 79
 | `minecraft:tropical_fish/pattern`
 | The pattern of a tropical fish.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Pattern</td>
      <td>`VarInt` `Enum`</td>
      <td>0: kob, 1: sunstreak, 2: snooper, 3: dasher, 4: brinely, 5: spotty, 6: flopper, 7: stripey, 8: glitter, 9: blockfish, 10: betty, 11: clayfish.</td>
    </tr>
  </tbody>
</table>
 |-
 | 80
 | `minecraft:tropical_fish/base_color`
 | The base color of a tropical fish.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
    </tr>
    <tr>
      <td>Color</td>
      <td>`Dye Color`</td>
    </tr>
  </tbody>
</table>
 |-
 | 81
 | `minecraft:tropical_fish/pattern_color`
 | The pattern color of a tropical fish.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
    </tr>
    <tr>
      <td>Color</td>
      <td>`Dye Color`</td>
    </tr>
  </tbody>
</table>
 |-
 | 82
 | `minecraft:mooshroom/variant`
 | The variant of a mooshroom.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Variant</td>
      <td>`VarInt` `Enum`</td>
      <td>0: red, 1: brown.</td>
    </tr>
  </tbody>
</table>
 |-
 | 83
 | `minecraft:rabbit/variant`
 | The variant of a rabbit.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Variant</td>
      <td>`VarInt` `Enum`</td>
      <td>0: brown, 1: white, 2: black, 3: white splotched, 4: gold, 5: salt, 6: evil.</td>
    </tr>
  </tbody>
</table>
 |-
 | 84
 | `minecraft:pig/variant`
 | The variant of a pig.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Variant</td>
      <td>`VarInt` `Enum`</td>
      <td>An ID in the `minecraft:pig_variant` registry.</td>
    </tr>
  </tbody>
</table>
 |-
 | 85
 | `minecraft:cow/variant`
 | The variant of a cow.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Variant</td>
      <td>`VarInt` `Enum`</td>
      <td>An ID in the `minecraft:cow_variant` registry.</td>
    </tr>
  </tbody>
</table>
 |-
 | 86
 | `minecraft:chicken/variant`
 | The variant of a chicken.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Mode</td>
      <td>`Byte` `Enum`</td>
      <td>Defines how the following field is read.</td>
    </tr>
    <tr>
      <td>Variant</td>
      <td>Varies</td>
      <td>
<table class="wikitable">
  <tbody>
    <tr>
      <th>Mode</th>
      <th>Data</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>0</td>
      <td>`Identifier`</td>
      <td>The name of a chicken variant.</td>
    </tr>
    <tr>
      <td>1</td>
      <td>`VarInt`</td>
      <td>An ID in the `minecraft:chicken_variant` registry.</td>
    </tr>
  </tbody>
</table></td>
    </tr>
  </tbody>
</table>
 |-
 | 87
 | `minecraft:frog/variant`
 | The variant of a frog.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Variant</td>
      <td>`VarInt` `Enum`</td>
      <td>An ID in the `minecraft:frog_variant` registry.</td>
    </tr>
  </tbody>
</table>
 |-
 | 88
 | `minecraft:horse/variant`
 | The variant of a horse.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Variant</td>
      <td>`VarInt` `Enum`</td>
      <td>0: white, 1: creamy, 2: chestnut, 3: brown, 4: black, 5: gray, 6: dark brown.</td>
    </tr>
  </tbody>
</table>
 |-
 | 89
 | `minecraft:painting/variant`
 | The variant of a painting.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
    </tr>
    <tr>
      <td>Variant</td>
      <td>[Painting Variant](entity_metadata.md#paintingvariant)</td>
    </tr>
  </tbody>
</table>
 |-
 | 90
 | `minecraft:llama/variant`
 | The variant of a llama.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Variant</td>
      <td>`VarInt` `Enum`</td>
      <td>0: creamy, 1: white, 2: brown, 3: gray.</td>
    </tr>
  </tbody>
</table>
 |-
 | 91
 | `minecraft:axolotl/variant`
 | The variant of an axolotl.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Variant</td>
      <td>`VarInt` `Enum`</td>
      <td>0: lucy, 1: wild, 2: gold, 3: cyan, 4: blue.</td>
    </tr>
  </tbody>
</table>
 |-
 | 92
 | `minecraft:cat/variant`
 | The variant of a cat.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Variant</td>
      <td>`VarInt` `Enum`</td>
      <td>An ID in the `minecraft:cat_variant` registry.</td>
    </tr>
  </tbody>
</table>
 |-
 | 93
 | `minecraft:cat/collar`
 | The dye color of the cat's collar.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
    </tr>
    <tr>
      <td>Color</td>
      <td>[[#Dye_Color|Dye Color]]</td>
    </tr>
  </tbody>
</table>
 |-
 | 94
 | `minecraft:sheep/color`
 | The color of a sheep.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
    </tr>
    <tr>
      <td>Color</td>
      <td>[[#Dye_Color|Dye Color]]</td>
    </tr>
  </tbody>
</table>
 |-
 | 95
 | `minecraft:shulker/color`
 | The color of a shulker.
 | As follows:
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
    </tr>
    <tr>
      <td>Color</td>
      <td>[[#Dye_Color|Dye Color]]</td>
    </tr>
  </tbody>
</table>
 |}

## Other types

Common types used in multiple components are described below.

### Block Predicate

Describes a predicate used when block filtering is necessary. It can be parameterized to account for any combination of the type of block, the values of specific block state properties, or block entities' NBT data or data components.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Blocks</td>
      <td>`Prefixed Optional` `ID Set`</td>
      <td>IDs in the `minecraft:block` registry. Present only when tied to specific types of blocks.</td>
    </tr>
    <tr>
      <td>Properties</td>
      <td>`Prefixed Optional` `Prefixed Array` of [Property](slot-data.md#property)</td>
      <td>See Property structure below. Present only when tied to specific properties of blocks.</td>
    </tr>
    <tr>
      <td>NBT</td>
      <td>`Prefixed Optional` `NBT`</td>
      <td>
 </td>
    </tr>
    <tr>
      <td>Data Components</td>
      <td>`Prefixed Array` of [Exact Data Component Matcher](slot-data.md#exact-data-component-matcher)</td>
      <td>A list of [data components](data-component-format.md) which must exactly match the target block.</td>
    </tr>
    <tr>
      <td>Partial Data Component Predicates</td>
      <td>`Prefixed Array` of [Partial Data Component Matcher](slot-data.md#partial-data-component-matcher)</td>
      <td>A list of predicates to match the block's data components. Max length = 64.</td>
    </tr>
  </tbody>
</table>

#### Property
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Name</td>
      <td>`String`</td>
      <td>Name of the block state property.</td>
    </tr>
    <tr>
      <td>Is Exact Match</td>
      <td>`Boolean`</td>
      <td>Whether this is an exact value match, as opposed to ranged.</td>
    </tr>
    <tr>
      <td>Exact Value</td>
      <td>`Optional``String`</td>
      <td>Value of the block state property. Only present in exact match mode.</td>
    </tr>
    <tr>
      <td>Min Value</td>
      <td>`Optional` `String`</td>
      <td>Minimum value of the block state property range. Only present in ranged match mode.</td>
    </tr>
    <tr>
      <td>Max Value</td>
      <td>`Optional` `String`</td>
      <td>Maximum value of the block state property range. Only present in ranged match mode.</td>
    </tr>
  </tbody>
</table>

#### Exact Data Component Matcher
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Type</td>
      <td>`VarInt` `Enum`</td>
      <td>ID of the data component as listed in the table of data component types above.</td>
    </tr>
    <tr>
      <td>Value</td>
      <td>[Structured Component](slot-data.md#structured-components)</td>
      <td>Value of the data component.</td>
    </tr>
  </tbody>
</table>

#### Partial Data Component Matcher
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Type</td>
      <td>`VarInt` `Enum`</td>
      <td>Type of predicate. 0: damage, 1: enchantments, 2: stored_enchantments, 3: potion_contents, 4: custom_data, 5: container, 6: bundle_contents, 7: firework_explosion, 8: fireworks, 9: writable_book_content, 10: written_book_content, 11: attribute_modifiers, 12: trim, 13: jukebox_playable.</td>
    </tr>
    <tr>
      <td>Predicate</td>
      <td>`NBT` Compound</td>
      <td>[Data component predicate](data-component-predicate.md) encoded as an NBT compound tag.</td>
    </tr>
  </tbody>
</table>

### Dye Color

A color from one of the 16 dye types.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Color</td>
      <td>`VarInt` `Enum`</td>
      <td>Can be one of the following:
* 0 - White
* 1 - Orange
* 2 - Magenta
* 3 - Light Blue
* 4 - Yellow
* 5 - Lime
* 6 - Pink
* 7 - Gray
* 8 - Light Gray
* 9 - Cyan
* 10 - Purple
* 11 - Blue
* 12 - Brown
* 13 - Green
* 14 - Red
* 15 - Black</td>
    </tr>
  </tbody>
</table>

### Firework Explosion

Represents a firework explosion, consisting of a shape, colors, and extra details.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Shape</td>
      <td>`VarInt` `Enum`</td>
      <td>Can be one of the following:
* 0 - Small ball
* 1 - Large ball
* 2 - Star
* 3 - Creeper
* 4 - Burst</td>
    </tr>
    <tr>
      <td>Number Of Colors</td>
      <td>`VarInt`</td>
      <td>The number of elements in the following array.</td>
    </tr>
    <tr>
      <td>Colors</td>
      <td>`Array` of `Int`</td>
      <td>The RGB components of the color, encoded as an integer.</td>
    </tr>
    <tr>
      <td>Number Of Fade Colors</td>
      <td>`VarInt`</td>
      <td>The number of elements in the following array.</td>
    </tr>
    <tr>
      <td>Fade Colors</td>
      <td>`Array` of `Int`</td>
      <td>The RGB components of the color, encoded as an integer.</td>
    </tr>
    <tr>
      <td>Has Trail</td>
      <td>`Boolean`</td>
      <td></td>
    </tr>
    <tr>
      <td>Has Twinkle</td>
      <td>`Boolean`</td>
      <td></td>
    </tr>
  </tbody>
</table>

### Potion Effect

Describes all the aspects of a potion effect.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Type ID</td>
      <td>`VarInt` `Enum`</td>
      <td>The ID of the effect in the potion effect type registry.</td>
    </tr>
    <tr>
      <td>Details</td>
      <td>Detail</td>
      <td>See Detail structure below.</td>
    </tr>
  </tbody>
</table>

The Detail structure is defined as follows:

<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Amplifier</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
    <tr>
      <td>Duration</td>
      <td>`VarInt`</td>
      <td>-1 for infinite.</td>
    </tr>
    <tr>
      <td>Ambient</td>
      <td>`Boolean`</td>
      <td>Produces more translucent particle effects if true.</td>
    </tr>
    <tr>
      <td>Show Particles</td>
      <td>`Boolean`</td>
      <td>Completely hides effect particles if false.</td>
    </tr>
    <tr>
      <td>Show Icon</td>
      <td>`Boolean`</td>
      <td>Shows the potion icon in the inventory screen if true.</td>
    </tr>
    <tr>
      <td>Has Hidden Effect</td>
      <td>`Boolean`</td>
      <td>Used to store the state of the previous potion effect when a stronger one is applied. This guarantees that the weaker one will persist, in case it lasts longer.
{{missing info|section|This behavior seems to be entirely server-sided. Does the presence of this field actually has any noticeable impact on the client?}}</td>
    </tr>
    <tr>
      <td>Hidden Effect</td>
      <td>`Optional` Detail</td>
      <td>Only present if Has Hidden Effect is true.</td>
    </tr>
  </tbody>
</table>

### Trim Material

See also:
  * [Minecraft Wiki:Projects/wiki.vg merge/Registry Data#Armor Trim Material](./registry-data.md#armor-trim-material)

<table class="wikitable">
  <tbody>
    <tr>
      <th colspan="2">Name</th>
      <th colspan="2">Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td colspan="2">Suffix</td>
      <td colspan="2">`String`</td>
      <td></td>
    </tr>
    <tr>
      <td rowspan="2">Overrides</td>
      <td>Armor Material Type</td>
      <td rowspan="2">`Prefixed Array`</td>
      <td>`Identifier`</td>
      <td></td>
    </tr>
    <tr>
      <td>Overriden Asset Name</td>
      <td>`String`</td>
      <td></td>
    </tr>
    <tr>
      <td colspan="2">Description</td>
      <td colspan="2">`Text Component`</td>
    </tr>
  </tbody>
</table>

### Trim Pattern

See also:
  * [Minecraft Wiki:Projects/wiki.vg merge/Registry Data#Armor Trim Pattern](./registry-data.md#armor-trim-pattern)

<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Asset Name</td>
      <td>`String`</td>
      <td></td>
    </tr>
    <tr>
      <td>Template Item</td>
      <td>`VarInt`</td>
      <td></td>
    </tr>
    <tr>
      <td>Description</td>
      <td>`Text Component`</td>
      <td></td>
    </tr>
    <tr>
      <td>Decal</td>
      <td>`Boolean`</td>
      <td></td>
    </tr>
  </tbody>
</table>

### Consume Effect

<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Type</td>
      <td>`VarInt`</td>
      <td>The ID of the effect in the consume effect registry.</td>
    </tr>
    <tr>
      <td>Data</td>
      <td>Varies</td>
      <td>See below</td>
    </tr>
  </tbody>
</table>


 |-
 | 4
 | `minecraft:play_sound`
 |
<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Sound</td>
      <td>`Sound Event`</td>
      <td></td>
    </tr>
  </tbody>
</table>
 |}


### Instrument

<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Sound Event</td>
      <td>`ID or` `Sound Event`</td>
      <td>The sound to be played.</td>
    </tr>
    <tr>
      <td>Sound range</td>
      <td>`Float`</td>
      <td>The maximum range of the sound.</td>
    </tr>
    <tr>
      <td>Range</td>
      <td>`Float`</td>
      <td>The range of the instrument.</td>
    </tr>
    <tr>
      <td>Description</td>
      <td>`Text Component`</td>
      <td>Description shown in the item tooltip.</td>
    </tr>
  </tbody>
</table>

### Jukebox Song

<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>Sound Event</td>
      <td>`ID or` `Sound Event`</td>
      <td>The sound to be played.</td>
    </tr>
    <tr>
      <td>Description</td>
      <td>`Text Component`</td>
      <td>The description shown in the item lore.</td>
    </tr>
    <tr>
      <td>Duration</td>
      <td>`Float`</td>
      <td>The duration the songs should play for, in seconds.</td>
    </tr>
    <tr>
      <td>Output</td>
      <td>`VarInt`</td>
      <td>The output strength given by a comparator. Between 0 and 15.</td>
    </tr>
  </tbody>
</table>
[Category:Protocol Details](category-protocol-details.md)
[Category:Java Edition protocol](category-java-edition-protocol.md)
_Content is licensed under wiki.vg terms._
