{{For|the command|Commands/attribute}}
> **Note:** This content is exclusive to the Java Edition.

An **attribute** is a value that determines certain properties of [mob](mob.md)s, [armor stand](armor-stand.md)s, and [player](player.md)s. Attributes also have modifiers that adjust the strength of their effects.

## Applying attributes

Attributes can be applied directly to living entities using the {{cmd|attribute}} command. The below command is an example that dramatically increases the luck attribute, leading to the player being able to fish treasures nearly every time:

{{cmd|long=1|attribute @p minecraft:luck base set 1024 }}

After it's modified, it can then be reset to the default value (which is 0.0 for {{attr|minecraft:luck}} attribute):

{{cmd|long=1|attribute @p minecraft:luck base reset}}

Additionally, attribute values can be specified when summoning a mob. For example, the following command summons a zombie that follows players when they are 100 blocks or less from it instead of the usual 40:

{{cmd|long=1|summon zombie ~ ~ ~ {attributes:[{id:"follow_range", base:100.0}]} }}

### Item modifiers

Attributes can also be applied as attribute modifiers on items by using [data components](data-components.md). When applied to an item, a modifier adjusts the corresponding attribute if the item is held or worn.<ref>{{tweet|dinnerbone|337540303647027201|Good news for mapmakers: Items can have attribute modifiers. It's possible to make a bow that slows the holder, helm that buffs health, etc|May 23, 2013}}</ref><ref>{{tweet|dinnerbone|337543314435878913|Equipped as armour or held in hand.|May 23, 2013}}</ref> Attribute modifiers can be added to items by adding data tags to the item. Each attribute modifier has an unique identifier, which is a [resource location](resource-location.md) to identify the modifier.

The following command gives the player a netherite sword that deals {{hp|20}} extra damage:

{{cmd|long=1|give @s netherite_sword[attribute_modifiers{{=}}[{type:"attack_damage", amount:20.0, operation:"add_value", id:"example:custom_damage", slot:"mainhand"}]] }}

## Attributes
A single attribute controls some property of an [entity](entity.md), described by its *name*; it has a *base* value, set within hard-coded minimum and maximum limits, and if undefined, it's specified by the default value. The base value may be multiplied or added by a set of *modifiers*; these affect the attribute's *base*, but the calculated value is always capped by the minimum and maximum.

Attribute modifiers have [namespaced identifier](namespaced-identifier.md)s. If two modifiers have the same ID and affect the same attribute, then they do not stack; instead, only the one most recently added takes effect, overriding previous modifiers.

These attributes are found on all living and undead entities, including players.
<!-- Template styles for adding border-top on each row in the table
--><templatestyles src=":Attribute/styles.css"/>
<table class="wikitable stikitable collapsible">
  <tbody>
    <tr>
      <th>Attribute Name</th>
      <th>Default Base</th>
      <th>Minimum<br>~<br>Maximum</th>
      <th>Description</th>
      <th>[Mob](mob.md)</th>
      <th>Base Value</th>
      <td>- id=armor</td>
      <td>rowspan=4 | {{cd|armor}}</td>
      <td>rowspan=4 | 0</td>
      <td>rowspan=4 | 0~30</td>
      <td>rowspan=4 | Armor defense points.</td>
      <td>{{EntityLink|Killer Bunny}}</td>
      <td>8</td>
    </tr>
    <tr>
      <td>{{EntityLink|Wither}}</td>
      <td>4</td>
    </tr>
    <tr>
      <td>{{EntityLink|Zombie}}<br>{{EntityLink|Husk}}<br>{{EntityLink|Drowned}}<br>{{EntityLink|Zombie Villager}}<br>{{EntityLink|Zombified Piglin}}</td>
      <td>2</td>
    </tr>
    <tr>
      <td>Every other mob</td>
      <td>0</td>
      <td>- id=armor_toughness</td>
      <td>{{Cd|armor_toughness}}</td>
      <td>0</td>
      <td>0~20</td>
      <td>[Armor toughness](armor-toughness.md).</td>
      <td>Every mob</td>
      <td>0</td>
      <td>- id=attack_damage</td>
      <td>rowspan=12 | {{cd|attack_damage}}</td>
      <td>rowspan=12 | 2</td>
      <td>rowspan=12 | 0~2048</td>
      <td>rowspan=12 | Damage dealt by attacks, in half-hearts.</td>
      <td>{{EntityLink|Giant}}</td>
      <td>50</td>
    </tr>
    <tr>
      <td>{{EntityLink|Warden}}</td>
      <td>30</td>
    </tr>
    <tr>
      <td>{{EntityLink|Ravager}}</td>
      <td>12</td>
    </tr>
    <tr>
      <td>{{EntityLink|Frog}}</td>
      <td>10</td>
    </tr>
    <tr>
      <td>{{EntityLink|Elder Guardian}}</td>
      <td>8</td>
    </tr>
    <tr>
      <td>{{EntityLink|Enderman}}<br>{{EntityLink|Piglin Brute}}</td>
      <td>7</td>
    </tr>
    <tr>
      <td>{{EntityLink|Blaze}}<br>{{EntityLink|Guardian}}<br>{{EntityLink|Hoglin}}<br>{{EntityLink|Panda}}<br>{{EntityLink|Phantom}}<br>{{EntityLink|Polar Bear}}<br>{{EntityLink|Zoglin}}</td>
      <td>6</td>
    </tr>
    <tr>
      <td>{{EntityLink|Piglin}}<br>{{EntityLink|Pillager}}<br>{{EntityLink|Vindicator}}<br>{{EntityLink|Zombified Piglin}}</td>
      <td>5</td>
    </tr>
    <tr>
      <td>{{EntityLink|Vex}}</td>
      <td>4</td>
    </tr>
    <tr>
      <td>{{EntityLink|Cat}}<br>{{EntityLink|Dolphin}}<br>{{EntityLink|Drowned}}<br>{{EntityLink|Husk}}<br>{{EntityLink|Ocelot}}<br>{{EntityLink|Zombie}}<br>{{EntityLink|Zombie Villager}}</td>
      <td>3</td>
    </tr>
    <tr>
      <td>{{EntityLink|Allay}}<br>{{EntityLink|Axolotl}}<br>{{EntityLink|Bee}}<br>{{EntityLink|Breeze}}<br>{{EntityLink|Cave Spider}}<br>{{EntityLink|Creeper}}<br>{{EntityLink|Endermite}}<br>{{EntityLink|Evoker}}<br>{{EntityLink|Fox}}<br>{{EntityLink|Goat}}<br>{{EntityLink|Illusioner}}<br>{{EntityLink|Magma Cube}}<br>{{EntityLink|Skeleton}}<br>{{EntityLink|Slime}}<br>{{EntityLink|Spider}}<br>{{EntityLink|Stray}}<br>{{EntityLink|Witch}}<br>{{EntityLink|Wither}}<br>{{EntityLink|Wither Skeleton}}<br>{{EntityLink|Wolf}}</td>
      <td>2</td>
    </tr>
    <tr>
      <td>{{EntityLink|Silverfish}}<br>{{EntityLink|Player}}</td>
      <td>1</td>
      <td>- id=attack_knockback</td>
      <td>rowspan=3 | {{Cd|attack_knockback}}</td>
      <td>rowspan=3 | 0</td>
      <td>rowspan=3 | 0~5</td>
      <td>rowspan=3 | Knockback applied to attacks. Applies only to mobs with physical attacks.<ref>{{bug|MC-138868}}</ref></td>
      <td>{{EntityLink|Ravager}}<br>{{EntityLink|Warden}}</td>
      <td>1.5</td>
    </tr>
    <tr>
      <td>{{EntityLink|Hoglin}}<br>{{EntityLink|Zoglin}}</td>
      <td>1</td>
    </tr>
    <tr>
      <td>{{EntityLink|Player}}<br>Every other mob</td>
      <td>0</td>
      <td>- id=generic.attack_reach</td>
      <td>{{cd|generic.attack_reach}}{{upcoming|Java Edition Combat Tests}}</td>
      <td>2.5</td>
      <td>0~6</td>
      <td>Determines the reach at which players can attack entities. Does not affect interaction range.</td>
      <td>{{EntityLink|Player}}</td>
      <td>2.5</td>
      <td>- id=attack_speed</td>
      <td>{{Cd|attack_speed}}</td>
      <td>4</td>
      <td>0~1024</td>
      <td>Determines recharging rate of attack strength. Value is the number of full-strength attacks per second.</td>
      <td>{{EntityLink|Player}}</td>
      <td>4</td>
      <td>- id=block_break_speed</td>
      <td>{{Cd|block_break_speed}}</td>
      <td>1</td>
      <td>0~1024</td>
      <td>The speed the player can break blocks as a multiplier.</td>
      <td>{{EntityLink|Player}}</td>
      <td>1</td>
      <td>- id=block_interaction_range</td>
      <td>{{Cd|block_interaction_range}}</td>
      <td>4.5</td>
      <td>0~64</td>
      <td>The block [interaction range](interaction-range.md) for players in blocks.</td>
      <td>{{EntityLink|Player}}</td>
      <td>4.5{{note|name=creative_mode|1=In [Creative](creative.md) mode, the block interaction range is increased by 0.5 and the entity interaction range by 2 to make some actions easier. This does not affect the base value of the attribute, so the bonus acts as a modifier.}}</td>
      <td>- id=burning_time</td>
      <td>{{Cd|burning_time}}</td>
      <td>1</td>
      <td>0~1024</td>
      <td>Amount of time how long an entity remains on fire after being ignited as a multiplier. A value of 0 eliminates the burn time. Has no impact on the burning time increase when staying in fire.</td>
      <td>Every mob</td>
      <td>1</td>
      <td>- id=camera_distance</td>
      <td rowspan="3">{{Cd|camera_distance}}{{upcoming|JE 1.21.6}}</td>
      <td rowspan="3">4</td>
      <td rowspan="3">0~32</td>
      <td rowspan="3">The distance at which the camera is placed away from the player or spectated entity when in a third-person view. This distance is multiplied by the `scale` attribute to get a final target camera distance. If the entity being ridden has a larger `camera_distance` attribute, that distance will be used.</td>
      <td>{{EntityLink|Ghast}}<br>{{EntityLink|Happy Ghast}}</td>
      <td>8</td>
    </tr>
    <tr>
      <td>{{EntityLink|Giant}}<br>{{EntityLink|Ender Dragon}}</td>
      <td>16</td>
    </tr>
    <tr>
      <td>Every other mob {{verify|Was anything missed?}}</td>
      <td>4</td>
      <td>- id=entity_interaction_range</td>
      <td>{{Cd|entity_interaction_range}}</td>
      <td>3</td>
      <td>0~64</td>
      <td>The entity [interaction range](interaction-range.md) for players in blocks.</td>
      <td>{{EntityLink|Player}}</td>
      <td>3{{note|name=creative_mode}}</td>
      <td>- id=explosion_knockback_resistance</td>
      <td>{{Cd|explosion_knockback_resistance}}</td>
      <td>0</td>
      <td>0~1</td>
      <td>Defines what percentage of knockback an entity resists. A value of 1 eliminates the knockback.</td>
      <td>Every mob</td>
      <td>0</td>
      <td>- id=fall_damage_multiplier</td>
      <td>rowspan=2|{{Cd|fall_damage_multiplier}}</td>
      <td>rowspan=2|1</td>
      <td>rowspan=2|0~100</td>
      <td>rowspan=2|The amount of fall damage an entity takes as a multiplier.</td>
      <td>{{EntityLink|Camel}}<br>{{EntityLink|Donkey}}<br>{{EntityLink|Horse}}<br>{{EntityLink|Llama}}<br>{{EntityLink|Mule}}<br>{{EntityLink|Skeleton Horse}}<br>{{EntityLink|Trader Llama}}<br>{{EntityLink|Zombie Horse}}</td>
      <td>0.5</td>
    </tr>
    <tr>
      <td>Every other mob</td>
      <td>1</td>
      <td>- id=flying_speed</td>
      <td>rowspan=3 | {{Cd|flying_speed}}</td>
      <td>rowspan=3 | 0.4</td>
      <td>rowspan=3 | 0~1024</td>
      <td>rowspan=3 | Flight speed modifier in some unknown metric.</td>
      <td>{{EntityLink|Bee}}<br>{{EntityLink|Wither}}</td>
      <td>0.6</td>
    </tr>
    <tr>
      <td>{{EntityLink|Parrot}}</td>
      <td>0.4</td>
    </tr>
    <tr>
      <td>{{EntityLink|Allay}}</td>
      <td>0.1</td>
      <td>- id=follow_range</td>
      <td>rowspan=11 | {{Cd|follow_range}}</td>
      <td>rowspan=11 | 32</td>
      <td>rowspan=11 | 0~2048</td>
      <td>rowspan=11 | The range in blocks within which a mob with this attribute targets players or other mobs to track. Exiting this range causes the mob to cease following the player/mob. Actual value used by most mobs is 16; for zombies it is 35.</td>
      <td>{{EntityLink|Ghast}}</td>
      <td>100</td>
    </tr>
    <tr>
      <td>{{EntityLink|Enderman}}</td>
      <td>64</td>
    </tr>
    <tr>
      <td>{{EntityLink|Allay}}<br>{{EntityLink|Bee}}<br>{{EntityLink|Blaze}}<br>{{EntityLink|Villager}}</td>
      <td>48</td>
    </tr>
    <tr>
      <td>{{EntityLink|Llama}}<br>{{EntityLink|Wither}}</td>
      <td>40</td>
    </tr>
    <tr>
      <td>{{EntityLink|Zombie}}<br>{{EntityLink|Husk}}<br>{{EntityLink|Drowned}}<br>{{EntityLink|Zombie Villager}}<br>{{EntityLink|Zombified Piglin}}</td>
      <td>35</td>
    </tr>
    <tr>
      <td>{{EntityLink|Fox}}<br>{{EntityLink|Pillager}}<br>{{EntityLink|Ravager}}</td>
      <td>32</td>
    </tr>
    <tr>
      <td>{{EntityLink|Breeze}}</td>
      <td>24</td>
    </tr>
    <tr>
      <td>{{EntityLink|Polar Bear}}</td>
      <td>20</td>
    </tr>
    <tr>
      <td>{{EntityLink|Illusioner}}</td>
      <td>18</td>
    </tr>
    <tr>
      <td>{{EntityLink|Evoker}}<br>{{EntityLink|Vindicator}}</td>
      <td>12</td>
    </tr>
    <tr>
      <td>Every other mob</td>
      <td>16</td>
      <td>- id=gravity</td>
      <td>{{Cd|gravity}}</td>
      <td>0.08</td>
      <td>-1~1</td>
      <td>The gravity affecting an entity in blocks per tick squared.</td>
      <td>Every mob</td>
      <td>0.08</td>
      <td>- id=jump_strength</td>
      <td>rowspan=3 | {{Cd|jump_strength}}</td>
      <td>rowspan=3 | 0.42{{note|Actual value is 0.41999998688697815}}</td>
      <td>rowspan=3 | 0~32</td>
      <td>rowspan=3 | The initial vertical velocity of an entity when they jump, in blocks per tick.</td>
      <td>{{EntityLink|Horse}}<br>{{EntityLink|Skeleton Horse}}<br>{{EntityLink|Zombie Horse}}</td>
      <td>0.4-1<br>Random value</td>
    </tr>
    <tr>
      <td>{{EntityLink|Donkey}}<br>{{EntityLink|Mule}}<br>{{EntityLink|Llama}}<br>{{EntityLink|Trader Llama}}</td>
      <td>0.175</td>
    </tr>
    <tr>
      <td>Every other mob</td>
      <td>0.42</td>
      <td>- id=knockback_resistance</td>
      <td>rowspan=4 | {{Cd|knockback_resistance}}</td>
      <td>rowspan=4 | 0</td>
      <td>rowspan=4 | 0~1</td>
      <td>rowspan=4 | The scale of horizontal knockback resisted from attacks and projectiles. Vertical knockback is not affected. Does not affect explosions.<ref>{{bug|MC-32578}}</ref> The resistance functions as a percentage from 0.0 (0% resistance) to 1.0 (100% resistance) (e.g. 0.4 is 40% resistance, meaning the attributed mob takes 60% of usual knockback). Iron golems and wardens suffer zero knockback from attacks or projectiles.</td>
      <td>{{EntityLink|Iron Golem}}<br>{{EntityLink|Warden}}</td>
      <td>1</td>
    </tr>
    <tr>
      <td>{{EntityLink|Ravager}}</td>
      <td>0.75</td>
    </tr>
    <tr>
      <td>{{EntityLink|Hoglin}}<br>{{EntityLink|Zoglin}}</td>
      <td>0.6</td>
    </tr>
    <tr>
      <td>Every other mob</td>
      <td>0</td>
      <td>- id=luck</td>
      <td>{{Cd|luck}}</td>
      <td>0</td>
      <td>-1024~1024</td>
      <td>Affects the results of [loot tables](loot-tables.md) using the {{cd|quality}} or {{cd|bonus_rolls}} tag (e.g. when opening chests or chest minecarts, fishing, and killing mobs).</td>
      <td>{{EntityLink|Player}}</td>
      <td>0</td>
      <td>- id=max_absorption</td>
      <td>{{Cd|max_absorption}}</td>
      <td>0</td>
      <td>0~2048</td>
      <td>The maximum [absorption](absorption.md) of this mob (in half-hearts); determines the highest health they may gain by the Absorption effect.</td>
      <td>Every mob</td>
      <td>0</td>
      <td>- id=max_health</td>
      <td>{{Cd|max_health}}</td>
      <td>20</td>
      <td>1~1024</td>
      <td>The maximum [health](health.md) of this mob (in half-hearts); determines the highest health they may be healed to. If the player is using this to summon a mob with high health, use this and the Health tag `{Health:200.0f}` for example. (Disabled in 1.17)</td>
      <td>Every mob</td>
      <td>The maximum health of the mob</td>
      <td>- id=mining_efficiency</td>
      <td>{{Cd|mining_efficiency}}</td>
      <td>0</td>
      <td>0~1024</td>
      <td>A factor to speed up the mining of blocks when using the right tool.</td>
      <td>{{EntityLink|Player}}</td>
      <td>0</td>
      <td>- id=movement_efficiency</td>
      <td>{{Cd|movement_efficiency}}</td>
      <td>0</td>
      <td>0~1</td>
      <td>A factor to improve walking on terrain that slows down movement. A value of 1 removes the slowing down.</td>
      <td>Every mob</td>
      <td>0</td>
      <td>- id=movement_speed</td>
      <td>rowspan=18 | {{Cd|movement_speed}}</td>
      <td>rowspan=18 | 0.7</td>
      <td>rowspan=18 | 0~1024</td>
      <td>rowspan=18 | Movement speed is the speed at which entities can move, but this is not the actual speed value in blocks/second. The mob's actual speed in blocks/second is a bit over 20 times this value, but is affected by various conditions, such as the behavior it's following (e.g. idling, attacking or fleeing), being ridden (if a horse), sprinting, being led by a leash, and being under the effect of a Speed or Slowness potion. Baby mobs also have an additional speed multiplier on top of the base value.</td>
      <td>{{EntityLink|Dolphin}}</td>
      <td>1.2</td>
    </tr>
    <tr>
      <td>{{EntityLink|Axolotl}}<br>{{EntityLink|Frog}}<br>{{EntityLink|Tadpole}}</td>
      <td>1</td>
    </tr>
    <tr>
      <td>{{EntityLink|Armor Stand}}<br>{{EntityLink|Bat}}<br>{{EntityLink|Cod}}<br>{{EntityLink|Ender Dragon}}<br>{{EntityLink|Ghast}}<br>{{EntityLink|Glow Squid}}<br>{{EntityLink|Phantom}}<br>{{EntityLink|Pufferfish}}<br>{{EntityLink|Salmon}}<br>{{EntityLink|Shulker}}<br>{{EntityLink|Squid}}<br>{{EntityLink|Tropical Fish}}<br>{{EntityLink|Vex}}<br>{{EntityLink|Wandering Trader}}</td>
      <td>0.7</td>
    </tr>
    <tr>
      <td>{{EntityLink|Breeze}}<br>{{EntityLink|Wither}}</td>
      <td>0.6</td>
    </tr>
    <tr>
      <td>{{EntityLink|Evoker}}<br>{{EntityLink|Giant}}<br>{{EntityLink|Guardian}}<br>{{EntityLink|Illusioner}}<br>{{EntityLink|Villager}}</td>
      <td>0.5</td>
    </tr>
    <tr>
      <td>{{EntityLink|Piglin}}<br>{{EntityLink|Piglin Brute}}<br>{{EntityLink|Pillager}}<br>{{EntityLink|Vindicator}}</td>
      <td>0.35</td>
    </tr>
    <tr>
      <td>{{EntityLink|Bee}}<br>{{EntityLink|Cat}}<br>{{EntityLink|Cave Spider}}<br>{{EntityLink|Creaking}}<br>{{EntityLink|Elder Guardian}}<br>{{EntityLink|Enderman}}<br>{{EntityLink|Fox}}<br>{{EntityLink|Hoglin}}<br>{{EntityLink|Ocelot}}<br>{{EntityLink|Rabbit}}<br>{{EntityLink|Ravager}}<br>{{EntityLink|Spider}}<br>{{EntityLink|Warden}}<br>{{EntityLink|Wolf}}<br>{{EntityLink|Zoglin}}</td>
      <td>0.3</td>
    </tr>
    <tr>
      <td>{{EntityLink|Chicken}}<br>{{EntityLink|Creeper}}<br>{{EntityLink|Endermite}}<br>{{EntityLink|Iron Golem}}<br>{{EntityLink|Pig}}<br>{{EntityLink|Polar Bear}}<br>{{EntityLink|Silverfish}}<br>{{EntityLink|Skeleton}}<br>{{EntityLink|Stray}}<br>{{EntityLink|Turtle}}<br>{{EntityLink|Witch}}<br>{{EntityLink|Wither Skeleton}}</td>
      <td>0.25</td>
    </tr>
    <tr>
      <td>{{EntityLink|Blaze}}<br>{{EntityLink|Drowned}}<br>{{EntityLink|Husk}}<br>{{EntityLink|Sheep}}<br>{{EntityLink|Zombie}}<br>{{EntityLink|Zombie Villager}}<br>{{EntityLink|Zombified Piglin}}</td>
      <td>0.23</td>
    </tr>
    <tr>
      <td>{{EntityLink|Horse}}</td>
      <td>0.1125 and 0.3375<br>Random value</td>
    </tr>
    <tr>
      <td>{{EntityLink|Magma Cube}}<br>{{EntityLink|Slime}}</td>
      <td>0.3 + 0.1 × Size</td>
    </tr>
    <tr>
      <td>{{EntityLink|Cow}}<br>{{EntityLink|Goat}}<br>{{EntityLink|Mooshroom}}<br>{{EntityLink|Parrot}}<br>{{EntityLink|Skeleton Horse}}<br>{{EntityLink|Snow Golem}}<br>{{EntityLink|Zombie Horse}}</td>
      <td>0.2</td>
    </tr>
    <tr>
      <td>{{EntityLink|Donkey}}<br>{{EntityLink|Llama}}<br>{{EntityLink|Mule}}<br>{{EntityLink|Strider}}<br>{{EntityLink|Trader Llama}}</td>
      <td>0.175</td>
    </tr>
    <tr>
      <td>{{EntityLink|Panda}}</td>
      <td>0.15</td>
    </tr>
    <tr>
      <td>{{EntityLink|Armadillo}}</td>
      <td>0.14</td>
    </tr>
    <tr>
      <td>{{EntityLink|Allay}}<br>{{EntityLink|Sniffer}}<br>{{EntityLink|Player}}</td>
      <td>0.1</td>
    </tr>
    <tr>
      <td>{{EntityLink|Camel}}</td>
      <td>0.09</td>
    </tr>
    <tr>
      <td>{{EntityLink|id=lazy-panda|Panda}}（lazy）</td>
      <td>0.07</td>
      <td>- id=oxygen_bonus</td>
      <td>{{Cd|oxygen_bonus}}</td>
      <td>0</td>
      <td>0~1024</td>
      <td>Determines the chance that an entity's {{cd|Air}} data tag decreases in any given game tick, while the entity is underwater. The chance is given by {{cd|1 / (oxygen_bonus +1)}}.</td>
      <td>Every mob</td>
      <td>0</td>
      <td>- id=safe_fall_distance</td>
      <td>rowspan=3|{{Cd|safe_fall_distance}}</td>
      <td>rowspan=3|3</td>
      <td>rowspan=3| -1024~1024</td>
      <td>rowspan=3|The number of blocks an entity can fall before fall damage starts to be accumulated. Also the minimum amount of blocks the entity has to fall to make fallling particles and sounds.</td>
      <td>{{EntityLink|Fox}}</td>
      <td>5</td>
    </tr>
    <tr>
      <td>{{EntityLink|Camel}}<br>{{EntityLink|Donkey}}<br>{{EntityLink|Horse}}<br>{{EntityLink|Llama}}<br>{{EntityLink|Mule}}<br>{{EntityLink|Skeleton Horse}}<br>{{EntityLink|Trader Llama}}<br>{{EntityLink|Zombie Horse}}</td>
      <td>6</td>
    </tr>
    <tr>
      <td>Every other mob</td>
      <td>3</td>
      <td>- id=scale</td>
      <td>{{Cd|scale}}</td>
      <td>1</td>
      <td>0.0625~16</td>
      <td>The multiplier of the size of an entity.</td>
      <td>Every mob</td>
      <td>1</td>
      <td>- id=spawn_reinforcements</td>
      <td>{{Cd|spawn_reinforcements}}</td>
      <td>0</td>
      <td>0~1</td>
      <td>Chance for a zombie to spawn another zombie when attacked.</td>
      <td>{{EntityLink|Zombie}}<br>{{EntityLink|Husk}}<br>{{EntityLink|Drowned}}<br>{{EntityLink|Zombie Villager}}<br>{{EntityLink|Zombified Piglin}}</td>
      <td>0~0.1<br>Random value</td>
      <td>- id=sneaking_speed</td>
      <td>{{Cd|sneaking_speed}}</td>
      <td>0.3</td>
      <td>0~1</td>
      <td>The movement speed factor when sneaking or crawling. A factor of 1 means sneaking or crawling is as fast as walking, a factor of 0 means unable to move while sneaking or crawling.</td>
      <td>{{EntityLink|Player}}</td>
      <td>0.3</td>
      <td>- id=step_height</td>
      <td>rowspan=4 | {{Cd|step_height}}</td>
      <td>rowspan=4 | 0.6</td>
      <td>rowspan=4 | 0~10</td>
      <td>rowspan=4 | The maximum number of blocks that an entity can step up without jumping. [Sneaking](sneaking.md) prevents drops from heights that are higher than this attribute.<ref>{{bug|MC-268917}}</ref> This happens if the height that the player is above a block is equal or less than the attribute.</td>
      <td>{{EntityLink|Axolotl}}<br>{{EntityLink|Donkey}}<br>{{EntityLink|Drowned}}<br>{{EntityLink|Enderman}}<br>{{EntityLink|Frog}}<br>{{EntityLink|Horse}}<br>{{EntityLink|Iron Golem}}<br>{{EntityLink|Llama}}<br>{{EntityLink|Mule}}<br>{{EntityLink|Ravager}}<br>{{EntityLink|Skeleton Horse}}<br>{{EntityLink|Trader Llama}}<br>{{EntityLink|Turtle}}<br>{{EntityLink|Zombie Horse}}</td>
      <td>1</td>
    </tr>
    <tr>
      <td>{{EntityLink|Camel}}</td>
      <td>1.5</td>
    </tr>
    <tr>
      <td>Every other mob</td>
      <td>0.6</td>
    </tr>
    <tr>
      <td>{{EntityLink|Armor Stand}}</td>
      <td>0<ref>{{bug|MC-133544}}</ref></td>
    </tr>
    <tr>
      <td>- id=submerged_mining_speed</td>
      <td>{{Cd|submerged_mining_speed}}</td>
      <td>0.2</td>
      <td>0~20</td>
      <td>The mining speed factor when underwater. A factor of 1 means mining as fast as on land, a factor of 0 means unable to mine while submerged. This represents only the submersion factor itself; other factors (such as not touching the ground) also apply.</td>
      <td>{{EntityLink|Player}}</td>
      <td>0.2</td>
      <td>- id=sweeping_damage_ratio</td>
      <td>{{cd|sweeping_damage_ratio}}</td>
      <td>0</td>
      <td>0~1</td>
      <td>Determines how much of the base attack damage gets transferred to secondary targets in a sweep attack. This is in addition to the base attack of the sweep damage itself. A value of 1 means that all of the base attack damage is transferred (sweep damage is attack_damage + 1)</td>
      <td>{{EntityLink|Player}}</td>
      <td>0</td>
      <td>- id=tempt_range</td>
      <td>{{cd|tempt_range}}</td>
      <td>10</td>
      <td>0~2048</td>
      <td>Determines the range, in blocks, at which temptable mobs can be tempted.</td>
      <td>{{EntityLink|Armadillo}}<br>{{EntityLink|Axolotl}}<br>{{EntityLink|Bee}}<br>{{EntityLink|Camel}}<br>{{EntityLink|Cat}}<br>{{EntityLink|Chicken}}<br>{{EntityLink|Cow}}<br>{{EntityLink|Donkey}}<br>{{EntityLink|Fox}}<br>{{EntityLink|Frog}}<br>{{EntityLink|Goat}}<br>{{EntityLink|Horse}}<br>{{EntityLink|Llama}}<br>{{EntityLink|Mooshroom}}<br>{{EntityLink|Mule}}<br>{{EntityLink|Ocelot}}<br>{{EntityLink|Panda}}<br>{{EntityLink|Parrot}}<br>{{EntityLink|Pig}}<br>{{EntityLink|Polar Bear}}<br>{{EntityLink|Rabbit}}<br>{{EntityLink|Sheep}}<br>{{EntityLink|Skeleton Horse}}<br>{{EntityLink|Sniffer}}<br>{{EntityLink|Strider}}<br>{{EntityLink|Tadpole}}<br>{{EntityLink|Trader Llama}}<br>{{EntityLink|Turtle}}<br>{{EntityLink|Wolf}}<br>{{EntityLink|Zombie Horse}}<br></td>
      <td>10</td>
      <td>- id=water_movement_efficiency</td>
      <td>{{Cd|water_movement_efficiency}}</td>
      <td>0</td>
      <td>0~1</td>
      <td>The movement speed factor when submerged. A higher value lets entities move faster. This represents only the submersion factor itself; other factors (such as not touching the ground) also apply.</td>
      <td>Every mob</td>
      <td>0</td>
      <td>- id=waypoint_receive_range</td>
      <td rowspan="2">{{cd|waypoint_receive_range}}{{upcoming|JE 1.21.6}}</td>
      <td rowspan="2">0</td>
      <td rowspan="2">0~60,000,000</td>
      <td rowspan="2">The maximum distance from the player to a waypoint at which it is displayed on the locator bar. This attribute has no effect on mobs.</td>
      <td>{{EntityLink|Player}}</td>
      <td>60,000,000</td>
    </tr>
    <tr>
      <td>Every other mob</td>
      <td>0</td>
      <td>- id=waypoint_transmit_range</td>
      <td rowspan="2">{{cd|waypoint_transmit_range}}{{upcoming|JE 1.21.6}}</td>
      <td rowspan="2">0</td>
      <td rowspan="2">0~60,000,000</td>
      <td rowspan="2">The distance at which an entity displays as a waypoint on the locator bar.</td>
      <td>{{EntityLink|Player}}</td>
      <td>60,000,000</td>
    </tr>
    <tr>
      <td>Every other mob</td>
      <td>0</td>
    </tr>
  </tbody>
</table>

{{notelist}}

## Modifiers

Modifiers increase or decrease the attribute's base value by using certain operations. The resulting value after modification is capped by the attribute's minimum and maximum limits. Similar to attribute names, modifiers have a [namespaced identifier](namespaced-identifier.md)s to uniquely identify the modifier.

However, a modifier's ID does not define the modifier's behavior; instead, it is determined by its *operation*. Modifiers carry an *amount* to their modification. When attribute modifiers are applied to items, the *type* parameter is required; this defines which attribute the modifier affects. Modifiers can be added or removed from all living entities using the {{Cmd|attribute}} command, modifying the entity's [NBT data](entity-format.md), or using item modifiers via [data components](data-components.md).

### Operations

Modifier operations dictate how it modifies an attribute base value. There are three operations that exist in the game:{{note|{{cmd|attribute ... modifier add ...}} command shows the literal name of the operations.}}

<table class="wikitable">
  <tbody>
    <tr>
      <th>Operation</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>**add_value**</td>
      <td>Adds all of the modifiers' amounts to the base attribute.

<math>\text{Total} = \text{Base} + \text{Amount}_1 + \text{Amount}_2 + \ldots + \text{Amount}_n</math>

For example, applying two **add_value** modifiers with amounts of 2 and 4, to attribute base of 3:

<math>\text{Total} = 3 + 2 + 4 = 9</math></td>
    </tr>
    <tr>
      <td>**add_multiplied_base**</td>
      <td>Multiplies the base attribute by (1 + sum of modifiers' amounts).

<math>\text{Total} = \text{Base} \times (1 + \text{Amount}_1 + \text{Amount}_2 + \ldots + \text{Amount}_n)</math>{{note|Algebraically equivalent form. The original formula used in the game's code is like: <math>\text{Total} = \text{Base} + (\text{Base} \times \text{Amount}_1) + (\text{Base} \times \text{Amount}_2) + \ldots + (\text{Base} \times \text{Amount}_n)</math>}}

For example, applying two **add_multiplied_base** modifiers with amounts of 2 and 4, to attribute base of 3:

<math>\text{Total} = 3 \times (1 + 2 + 4) = 3 \times 7 = 21</math></td>
    </tr>
    <tr>
      <td>**add_multiplied_total**</td>
      <td>Multiplies the base attribute by (1 + modifiers' amounts) for every modifier.

<math>\text{Total} = \text{Base} \times (1 + \text{Amount}_1) \times (1 + \text{Amount}_2) \times \ldots \times (1 + \text{Amount}_n)</math>

For example, applying two **add_multiplied_total** modifiers with amounts of 2 and 4, to attribute base of 3:

<math>\text{Total} = 3 \times (1 + 2) \times (1 + 4) = 3 \times 3 \times 5 = 45</math></td>
    </tr>
  </tbody>
</table>

If multiple attribute modifiers are applied, the game first executes all **add_value** modifiers, then  all **add_multiplied_base** modifiers, and finally all **add_multiplied_total** modifiers. The *Total* value is always carried as the *Base* for the next set of modifiers.

{{notelist}}

### Vanilla modifiers
As stated before, a modifier's ID can be anything, and this does not affect its behavior. The following are known modifier ids and values used in vanilla *Minecraft*. Manually setting vanilla modifiers with the correct ID and attribute overrides the default value.

<table class="wikitable stikitable sortable collapsible">
  <tbody>
    <tr>
      <th>Modifier ID</th>
      <th>Description and Known Values</th>
      <th>Known Attributes Modified</th>
    </tr>
    <tr>
      <td>minecraft:armor.body</td>
      <td>Value varies based on the armor of the horse.</td>
      <td>armor (Operation {{cd|add_value}}; [Horse](horse.md)<nowiki/>s), gene<nowiki/>ric.armor_toughness (Operation {{cd|add_value}}; [Horse](horse.md)<nowiki/>s)</td>
    </tr>
    <tr>
      <td>minecraft:armor.body</td>
      <td>Fixed value of 11.0 for wolves wearing [wolf armor](wolf-armor.md).</td>
      <td>armor (Operation {{cd|add_value}}; [Wolve](wolve.md)<nowiki/>s)</td>
    </tr>
    <tr>
      <td>minecraft:armor.helmet
minecraft:armor.chestplate

minecraft:armor.leggings

minecraft:armor.boots</td>
      <td>Value varies based on slot and tier.</td>
      <td>armor (Operation {{cd|add_value}}; boots, leggings, chestplate, helmet, turtle shell)</td>
    </tr>
    <tr>
      <td>minecraft:armor.helmet
minecraft:armor.chestplate

minecraft:armor.leggings

minecraft:armor.boots</td>
      <td>Value varies based on tier.</td>
      <td>armor_toughness (Operation {{cd|add_value}}; boots, leggings, chestplate, helmet, turtle shell)</td>
    </tr>
    <tr>
      <td>minecraft:armor.helmet
minecraft:armor.chestplate

minecraft:armor.leggings

minecraft:armor.boots</td>
      <td>Applies knockback resistance similarily to netherite armor. A piece of netherite armor is equivalent to {{cd|add_value}} with amount 0.1.</td>
      <td>knockback_resistance (Operation {{cd|add_value}}; boots, leggings, chestplate, helmet)</td>
    </tr>
    <tr>
      <td>minecraft:attacking</td>
      <td>Fixed value of 0.15 for Endermen and 0.05 for Zombified Piglins; exists only when attacking.</td>
      <td>movement_speed (Operation {{cd|add_value}}; [Endermen](endermen.md), [Zombified Piglin](zombified-piglin.md)<nowiki/>s)</td>
    </tr>
    <tr>
      <td>minecraft:base_attack_damage</td>
      <td>Value varies based on tool/weapon and tier.</td>
      <td>attack_damage (Operation {{cd|add_value}}; tridents, shovels, pickaxes, axes, hoes, maces)</td>
    </tr>
    <tr>
      <td>minecraft:base_attack_speed</td>
      <td>Value varies based on tool/weapon and tier.</td>
      <td>attack_speed (Operation {{cd|add_value}}; tridents, shovels, pickaxes, axes, hoes, maces)</td>
    </tr>
    <tr>
      <td>minecraft:baby</td>
      <td>Fixed value of 0.5 for Zombies and 0.2 for Piglins; exists only for their respective baby variants.</td>
      <td>movement_speed (Operation {{cd|add_multiplied_base}}; [Baby Zombie](baby-zombie.md)<nowiki/>s. [Baby](baby-villager.md) <nowiki/>[villager](baby-villager.md)<nowiki/>s)</td>
    </tr>
    <tr>
      <td>minecraft:covered</td>
      <td>Fixed value of 20.0 for Shulkers. Exists only when fully closed.</td>
      <td>armor (Operation {{cd|add_value}}; [Shulker](shulker.md)<nowiki/>s)</td>
    </tr>
    <tr>
      <td>minecraft:drinking</td>
      <td>Fixed value of -0.25 for Witches when drinking a potion.</td>
      <td>movement_speed (Operation {{cd|add_value}}; [Witch](witch.md)<nowiki/>es)</td>
    </tr>
    <tr>
      <td>minecraft:effect.speed</td>
      <td>Fixed value of 0.2 when under the Speed effect, multiplied by the effect's *level* (amplifier + 1).</td>
      <td>movement_speed (Operation {{cd|add_multiplied_total}}; All living entities)</td>
    </tr>
    <tr>
      <td>minecraft:effect.slowness</td>
      <td>Fixed value of -0.15 when under the Slowness effect, multiplied by the effect's level.</td>
      <td>movement_speed (Operation {{cd|add_multiplied_total}}; All living entities)</td>
    </tr>
    <tr>
      <td>minecraft:effect.haste</td>
      <td>Fixed value of 0.1 when under the Haste effect, multiplied by the effect's level.</td>
      <td>attack_speed (Operation {{cd|add_multiplied_total}}; All living entities)</td>
    </tr>
    <tr>
      <td>minecraft:effect.mining_fatigue</td>
      <td>Fixed value of -0.1 when under the Mining fatigue effect, multiplied by the effect's level.</td>
      <td>attack_speed (Operation {{cd|add_multiplied_total}}; All living entities)</td>
    </tr>
    <tr>
      <td>minecraft:effect.strength</td>
      <td>Fixed value of 3.0 when under the Strength effect, multiplied by the effect's level.</td>
      <td>attack_damage (Operation {{cd|add_value}}; All living entities)</td>
    </tr>
    <tr>
      <td>minecraft:effect.weakness</td>
      <td>Fixed value of -4.0 when under the Weakness effect, multiplied by the effect's level.</td>
      <td>attack_damage (Operation {{cd|add_value}}; All living entities)</td>
    </tr>
    <tr>
      <td>minecraft:effect.health_boost</td>
      <td>Fixed value of 4.0 when under the Health Boost effect, multiplied by the effect's level.</td>
      <td>max_health (Operation {{cd|add_value}}; All living entities)</td>
    </tr>
    <tr>
      <td>minecraft:effect.luck</td>
      <td>Fixed value of 1.0 when under the Luck effect, multiplied by the effect's level.</td>
      <td>luck (Operation {{cd|add_value}}; All living entities)</td>
    </tr>
    <tr>
      <td>minecraft:effect.unluck</td>
      <td>Fixed value of -1.0 when under the Unluck effect, multiplied by the effect's level.</td>
      <td>luck (Operation {{cd|add_value}}; All living entities)</td>
    </tr>
    <tr>
      <td>minecraft:effect.jump_boost</td>
      <td>Fixed value of 0.1 when under the Jump boost effect, multiplied by the effect's level.</td>
      <td>jump_strength (Operation {{cd|add_value}}; All living entities)</td>
    </tr>
    <tr>
      <td>minecraft:leader_zombie_bonus</td>
      <td>Has a (small) random chance of being generated on a zombie when spawned. For Spawn Reinforcements Chance, random number between 0.5 and 0.75. For max_health, random number between 1.0 and 4.0.</td>
      <td>spawn_reinforcements (Operation {{cd|add_value}}; [Zombie](zombie.md)<nowiki/>s), max<nowiki/>_health (Operation {{cd|add_multiplied_total}}; [Zombie](zombie.md)<nowiki/>s)</td>
    </tr>
    <tr>
      <td>minecraft:powder_snow</td>
      <td>Value varies from 0 to -0.05 based on ticks spent in powder snow.</td>
      <td>movement_speed (Operation {{cd|add_value}}; all living entities)</td>
    </tr>
    <tr>
      <td>minecraft:random_spawn_bonus</td>
      <td>Generated upon spawning; a random number from a Gaussian distribution ranging from 0.0 to 0.05. For Zombie Knockback Resistance, another value between 0.0 and 0.05 is also generated.</td>
      <td>follow_range (Operation {{cd|add_multiplied_base}}; all mobs), Knockback Resistance (Operation {{cd|add_value}}; [Zombie](zombie.md)<nowiki/>s only)<nowiki/></td>
    </tr>
    <tr>
      <td>minecraft:reinforcement_caller_charge</td>
      <td>Fixed value of -0.05 created each time a zombie spawns another zombie as reinforcement.</td>
      <td>spawn_reinforcements (Operation {{cd|add_value}}; [Zombie](zombie.md)<nowiki/>s)</td>
    </tr>
    <tr>
      <td>minecraft:reinforcement_callee_charge</td>
      <td>Fixed value of -0.05 created for each zombie spawned as a reinforcement.</td>
      <td>spawn_reinforcements (Operation {{cd|add_value}}; [Zombie](zombie.md)<nowiki/>s)</td>
    </tr>
    <tr>
      <td>minecraft:sprinting</td>
      <td>Fixed value of 0.3 used by all mobs (including players) when sprinting.</td>
      <td>movement_speed (Operation {{cd|add_multiplied_total}}; all living entities)</td>
    </tr>
    <tr>
      <td>minecraft:zombie_random_spawn_bonus</td>
      <td>Generated upon spawning; a random number between 0.0 and 1.5.</td>
      <td>follow_range (Operation {{cd|add_multiplied_total}}; [Zombie](zombie.md)<nowiki/>s)</td>
    </tr>
    <tr>
      <td>None/unknown</td>
      <td>Unknown; created when the client reads attribute data sent by the server.</td>
      <td>varies</td>
    </tr>
  </tbody>
</table>

## History

{{HistoryTable
|{{HistoryLine|java}}
|{{HistoryLine||1.6.1|dev=13w16a|Added attributes and modifiers.|The following attributes existed: "Max Health", "Follow Range", "Knockback Resistance"; furthermore, "Jump Strength" and "Speed" existed as horse-specific attributes.|The only modifiers were both "Random spawn bonus", one used on Zombies to knockback resistance with operation 0, and the other on all mobs to follow range with operation 1.}}
|{{HistoryLine|||dev=13w17a|Added "Spawn Reinforcements Chance" attribute for Zombies.|Added "Zombie reinforcement charge" (to spawn reinforcements charge), "Random zombie-spawn bonus" (to follow range), and "Leader zombie bonus" (to both reinforcements charge and max health).}}
|{{HistoryLine|||dev=13w18a|Replaced "Zombie reinforcement charge" with "Zombie reinforcement caller charge"}}
|{{HistoryLine|||dev=13w21a|Attributes now can be specified in NBT.|Attributes now have IDs and corresponding translation keys.|Modifiers now display on items.|Added "Attack Damage" and made "Speed" generic.|Added "potion.moveSpeed", "potion.moveSlowdown", "potion.damageBoost", and "potion.weakness" modifiers.|Added "Sprinting speed boost", "Fleeing speed bonus", "Attacking speed boost" (for both pigmen and endermen), "Drinking speed penalty", and "Baby speed boost".|Added "Tool modifier" and "Weapon modifier".}}
|{{HistoryLine|||dev=13w23b|Added "potion.healthBoost" modifier.}}
|{{HistoryLine||1.7.2|dev=13w36a|Attributes/modifiers can be added to items or mobs without the use of third-party NBT editing software by adding data tags to the {{cmd|give}} and {{cmd|summon}} commands.}}
|{{HistoryLine||1.9|dev=15w34b|Added attack speed attribute.}}
|{{HistoryLine|||dev=15w36d|Added armor attribute.}}
|{{HistoryLine|||dev=15w44b|Added luck attribute.}}
|{{HistoryLine||1.9.1|dev=pre1|Added armorToughness attribute.}}
|{{HistoryLine||1.12|dev=pre1|Added flyingSpeed attribute.}}
|{{HistoryLine||1.14|dev=18w43a|Added attackKnockback attribute.}}
|{{HistoryLine||1.16|dev=20w06a|Knockback resistance is now a scale rather than probability.}}
|{{HistoryLine|||dev=20w14a|Items and entities no longer keep unknown attributes.
|Names of some attributes have been renamed to meet [resource location](resource-location.md) requirements (i.e., lowercase separated by underscores instead of camel case).
|Renamed {{cd|generic.maxHealth|d=to|generic.max_health}}.
|Renamed {{cd|zombie.spawnReinforcements|d=to|zombie.spawn_reinforcements}}.
|Renamed {{cd|horse.jumpStrength|d=to|horse.jump_strength}}.
|Renamed {{cd|generic.followRange|d=to|generic.follow_range}}.
|Renamed {{cd|generic.knockbackResistance|d=to|generic.knockback_resistance}}.
|Renamed {{cd|generic.movementSpeed|d=to|generic.movement_speed}}.
|Renamed {{cd|generic.flyingSpeed|d=to|generic.flying_speed}}.
|Renamed {{cd|generic.attackDamage|d=to|generic.attack_damage}}
|Renamed {{cd|generic.attackKnockback|d=to|generic.attack_knockback}}
|Renamed {{cd|generic.attackSpeed|d=to|generic.attack_speed}}
|Renamed {{cd|generic.armorToughness|d=to|generic.armor_toughness}}.}}
|{{HistoryLine|||dev=20w17a|Added the {{cmd|attribute}} command, which can query and change attributes.}}
|{{HistoryLine||1.18.2|dev=22w03a|Knockback resistance no longer gives a 50% chance to ignore all knockback.}}
|{{HistoryLine||1.20.2|dev=23w31a|Added the {{cd|generic.max_absorption}} attribute.}}
|{{HistoryLine||1.20.5|dev=23w51a|Added {{cd|generic.scale}} and {{cd|generic.step_height}} attributes for all living entities, as well as {{cd|generic.block_interaction_range}} and {{cd|generic.entity_interaction_range}} attributes for players.}}
|{{HistoryLine|||dev=24w03a|Renamed {{cd|generic.block_interaction_range}} and {{cd|generic.entity_interaction_range}} to {{cd|player.block_interaction_range}} and {{cd|player.entity_interaction_range}}.}}
|{{HistoryLine|||dev=24w06a|Added {{cd|generic.gravity}}, {{cd|generic.safe_fall_distance}}, {{cd|generic.fall_damage_multiplier}} and {{cd|player.block_break_speed}} attributes.|Renamed {{cd|horse.jump_strength}} to {{cd|generic.jump_strength}}.}}
|{{HistoryLine||1.21|dev=24w18a|Added {{cd|generic.burning_time}}, {{cd|generic.explosion_knockback_resistance}}, {{cd|player.mining_efficiency}}, {{cd|generic.movement_efficiency}}, {{cd|generic.oxygen_bonus}}, {{cd|player.sneaking_speed}}, {{cd|player.submerged_mining_speed}}, {{cd|player.sweeping_damage_ratio}}and {{cd|generic.water_movement_efficiency}} attributes.|{{cd|generic.attack_knockback}} attribute now also works for players.}}
|{{HistoryLine|||dev=24w21a|The {{cd|uuid}} and {{cd|name}} arguments have been replaced with a singular {{cd|id}} argument.}}
|{{HistoryLine||1.21.2|dev=24w33a|Added the {{cd|tempt_range}} attribute.
|Removed the {{cd|generic.}}, {{cd|player.}}, or {{cd|zombie.}} prefixes from all the attributes. Instead of using the resource locations, the argument instead just asks for the name of the attribute.}}
|{{HistoryLine||1.21.4|dev=24w44a|Players can no longer sprint while sneaking or crawling when having the {{cd|sneaking_speed}} attribute set to 0.8 or higher.<ref>{{bug|MC-278349}}</ref>}}
|{{HistoryLine|upcoming java}}
|{{HistoryLine||1.21.6|exp=Locator Bar|dev=25w15a|Added {{cd|waypoint_transmit_range}} and {{cd|waypoint_receive_range}} attributes.}}
|{{HistoryLine||1.21.6|dev=25w15a|Added {{cd|camera_distance}} attribute.}}
|{{HistoryLine|||dev=25w17a|{{cd|waypoint_transmit_range}} and {{cd|waypoint_receive_range}} are no longer experimental.}}
|{{HistoryLine||Combat Tests|dev=1.14.3 - Combat Test|Added {{cd|generic.attackReach}} attribute.}}
|{{HistoryLine|||dev=Combat Test 6|Renamed {{cd|generic.attackReach|d=to|generic.attack_reach}}.}}

|{{HistoryLine|pocket alpha}}
|{{HistoryLine||v0.12.1|dev=build 1|Added attributes.}}
|{{HistoryLine|console}}
|{{HistoryLine||xbox=TU19|xbone=CU7|ps3=1.12|psvita=1.12|ps4=1.12|wiiu=Patch 1|switch=1.0.1|Added attributes.}}
|{{HistoryLine||xbox=TU36|xbone=CU25|ps3=1.28|psvita=1.28|ps4=1.28|wiiu=Patch 7|switch=1.0.1|Attributes of items are shown above the [HUD](hud.md) when switching items in the hotbar if the item has less than 3 enchantments.}}
|{{HistoryLine||xbox=TU46|xbone=CU36|ps3=1.38|psvita=1.38|ps4=1.38|wiiu=Patch 15|switch=1.0.1|Added armor and luck attributes.}}
|{{HistoryLine||xbox=TU54|xbone=CU44|ps3=1.52|psvita=1.52|ps4=1.52|wiiu=Patch 24|switch=1.0.4|Added flying speed attribute.{{verify|May be possible to use through modding/world editing.}}}}
}}

## Issues
{{issue list|projects=MC}}

## References
{{reflist}}

## Navigation
{{Navbox gameplay}}

[de:Attribut](de-attribut.md)
[es:Atributo](es-atributo.md)
[fr:Attribut](fr-attribut.md)
[ja:属性](ja.md)
[ko:속성](ko.md)
[pl:Atrybuty](pl-atrybuty.md)
[pt:Atributo](pt-atributo.md)
[zh:属性](zh.md)
