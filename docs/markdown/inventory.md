Minecraft displays the **player inventory** differently, according to how the window was opened. Ranges of slot indices vary in meaning between different “windows”.

{{TOC|right}}

## Types
<table class="wikitable">
  <tbody>
    <tr>
      <th>Packet</th>
      <th>Type</th>
      <th>Name</th>
      <th>Description</th>
    </tr>
    <tr>
      <td></td>
      <td colspan="2"><center>`inventory`</center></td>
      <td>[[#Player Inventory|The player inventory]].</td>
    </tr>
    <tr>
      <td>[Open Horse Screen](java_edition_protocol-packets.md#openhorsescreen)</td>
      <td colspan="2"><center>`horse`</center></td>
      <td>[[#Horse|A inventory for horses]]. Used by [Horse](horse.md), [Donkey](donkey.md), [Mule](mule.md), [Llama](llama.md), [Trader Llama](trader-llama.md), and [Camel](camel.md).</td>
    </tr>
    <tr>
      <td rowspan="25">[Open Screen](java_edition_protocol-packets.md#openscreen)</td>
      <td>0</td>
      <td>`generic_9x1`</td>
      <td>[[#Chest|A 1-row inventory]], not used by the notchian server.</td>
    </tr>
    <tr>
      <td>1</td>
      <td>`generic_9x2`</td>
      <td>[[#Chest|A 2-row inventory]], not used by the notchian server.</td>
    </tr>
    <tr>
      <td>2</td>
      <td>`generic_9x3`</td>
      <td>[[#Chest|General-purpose 3-row inventory]]. Used by [Chest](chest.md), [Minecart with Chest](minecart-with-chest.md), [Ender Chest](ender-chest.md), and [Barrel](barrel.md).</td>
    </tr>
    <tr>
      <td>3</td>
      <td>`generic_9x4`</td>
      <td>[[#Chest|A 4-row inventory]], not used by the notchian server.</td>
    </tr>
    <tr>
      <td>4</td>
      <td>`generic_9x5`</td>
      <td>[[#Chest|A 5-row inventory]], not used by the notchian server.</td>
    </tr>
    <tr>
      <td>5</td>
      <td>`generic_9x6`</td>
      <td>[[#Large Chest|General-purpose 6-row inventory]], used by [Large Chest](chest.md#largechest).</td>
    </tr>
    <tr>
      <td>6</td>
      <td>`generic_3x3`</td>
      <td>[[#Dispenser|General-purpose 3-by-3 square inventory]], used by [Dispenser](dispenser.md) and [Dropper](dropper.md).</td>
    </tr>
    <tr>
      <td>7</td>
      <td>`crafter_3x3`</td>
      <td>[[#Crafter|Crafter]]</td>
    </tr>
    <tr>
      <td>8</td>
      <td>`anvil`</td>
      <td>[[#Anvil|Anvil]]</td>
    </tr>
    <tr>
      <td>9</td>
      <td>`beacon`</td>
      <td>[[#Beacon|Beacon]]</td>
    </tr>
    <tr>
      <td>10</td>
      <td>`blast_furnace`</td>
      <td>[[#Blast Furnace|Blast Furnace]]</td>
    </tr>
    <tr>
      <td>11</td>
      <td>`brewing_stand`</td>
      <td>[[#Brewing Stand|Brewing Stand]]</td>
    </tr>
    <tr>
      <td>12</td>
      <td>`crafting`</td>
      <td>[[#Crafting Table|Crafting Table]]</td>
    </tr>
    <tr>
      <td>13</td>
      <td>`enchantment`</td>
      <td>[[#Enchanting Table|Enchanting Table]]</td>
    </tr>
    <tr>
      <td>14</td>
      <td>`furnace`</td>
      <td>[[#Furnace|Furnace]]</td>
    </tr>
    <tr>
      <td>15</td>
      <td>`grindstone`</td>
      <td>[[#Grindstone|Grindstone]]</td>
    </tr>
    <tr>
      <td>16</td>
      <td>`hopper`</td>
      <td>[[#Hopper|Hopper or Minecart with Hopper]]</td>
    </tr>
    <tr>
      <td>17</td>
      <td>`lectern`</td>
      <td>[[#Lectern|Lectern]]</td>
    </tr>
    <tr>
      <td>18</td>
      <td>`loom`</td>
      <td>[[#Loom|Loom]]</td>
    </tr>
    <tr>
      <td>19</td>
      <td>`merchant`</td>
      <td>[[#Villager|Villager or Wandering Trader]]</td>
    </tr>
    <tr>
      <td>20</td>
      <td>`shulker_box`</td>
      <td>[[#Shulker Box|Shulker Box]]</td>
    </tr>
    <tr>
      <td>21</td>
      <td>`smithing`</td>
      <td>[[#Smithing Table|Smithing Table]]</td>
    </tr>
    <tr>
      <td>22</td>
      <td>`smoker`</td>
      <td>[[#Smoker|Smoker]]</td>
    </tr>
    <tr>
      <td>23</td>
      <td>`cartography_table`</td>
      <td>[[#Cartography Table|Cartography Table]]</td>
    </tr>
    <tr>
      <td>24</td>
      <td>`stonecutter`</td>
      <td>[[#Stonecutter|Stonecutter]]</td>
    </tr>
  </tbody>
</table>

The slot number is calculated starting at 0, counting up through the window's unique slots, and then counting through the players inventory.

For all windows, the slot in the upper-left corner of the player's inventory is slot *n* where *n* is the number of unique slots, and slot number -999 is always used for clicking outside the window.

The default inventory window, which is never explicitly opened by the server, has 10 unique slots.

Rectangular regions are always indexed starting with the upper-left corner and scanning across rows. If a window has a crafting region, the output slot is always slot 0 followed immediately by the input region.

Each window type is described in the following sections. All slot index ranges are inclusive and reflect the indices observed in the Minecraft protocol.

For the window properties (additional data in each window, e.g. smelting progress or enchantments), refer to the table in the [Set Container Property](java_edition_protocol-packets.md#setcontainerproperty) packet.

Using -1 as slot index and as window id will set the cursor item (the stack dragged with the mouse).

## Player Inventory
<a id="inventory"></a>
![Inventory slots](Inventory-slots.png)

This is the inventory window that the player can always open, typically by pressing <kbd>E</kbd> since [Beta 1.4](beta-1.4.md). Before, you had to press <kbd>I</kbd>.

> ⚠️ **Warning:** The slots differ when storing using the [player.dat format](player.dat_format.md#inventoryslotnumbers).

<table class="wikitable">
  <tbody>
    <tr>
      <th>Slot range</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>0</td>
      <td>crafting output</td>
    </tr>
    <tr>
      <td>1–4</td>
      <td>2×2 crafting input (`1 + x + 2 * y`)</td>
    </tr>
    <tr>
      <td>5–8</td>
      <td>armor (head, chest, legs, feet)</td>
    </tr>
    <tr>
      <td>9–35</td>
      <td>main inventory</td>
    </tr>
    <tr>
      <td>36–44</td>
      <td>hotbar</td>
    </tr>
    <tr>
      <td>45</td>
      <td>Offhand slot</td>
    </tr>
  </tbody>
</table>

---

## Horse

![Horse slots](Horse-slots.png)

The GUI that appears when interacting with a tamed [horse](horse.md), or when opening the player's inventory while riding a tamed horse.

> ℹ️ The horse, donkey and llama technically share the same GUI, but are split into separate entries for clarity.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Slot range</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>0</td>
      <td>saddle</td>
    </tr>
    <tr>
      <td>1</td>
      <td>armor</td>
    </tr>
    <tr>
      <td>2–28</td>
      <td>main inventory</td>
    </tr>
    <tr>
      <td>29–37</td>
      <td>hotbar</td>
    </tr>
  </tbody>
</table>

![Horse-slots](Horse-slots.png|Horse slots)
![Skeleton-horse-slots](Skeleton-horse-slots.png|Skeleton horse slots)
![Zombie-horse-slots](Zombie-horse-slots.png|Zombie horse slots)
![Camel-slots](Camel-slots.png|Camel slots)

---

### Donkey

![Donkey slots](Donkey-slots.png)

The GUI that appears when interacting with a tamed [donkey](donkey.md) or [mule](mule.md), or when opening the player's inventory while riding a tamed donkey or mule.

> ⚠️ **Warning:** There still is an armor slot, even though it cannot be used and is invisible.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Slot range</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>0</td>
      <td>saddle</td>
    </tr>
    <tr>
      <td>1</td>
      <td>armor</td>
    </tr>
    <tr>
      <td>2–16</td>
      <td>donkey inventory</td>
    </tr>
    <tr>
      <td>17–43 (2-28 if unchested)</td>
      <td>player inventory</td>
    </tr>
    <tr>
      <td>44–52 (29-37 if unchested)</td>
      <td>hotbar</td>
    </tr>
  </tbody>
</table>

![Donkey-unchested-slots](Donkey-unchested-slots.png|Unchested donkey)
![Donkey-chested-slots](Donkey-chested-slots.png|Chested donkey)
![Mule-unchested-slots](Mule-unchested-slots.png|Unchested mule)
![Mule-chested-slots](Mule-chested-slots.png|Chested mule)

---

### Llama
![Llama slots](Llama-strength5-slots.png)

The GUI that appears when interacting with a tamed [llama](llama.md) or [trader llama](trader_llama.md) that has a chest, or when opening the player's inventory while riding a tamed llama.

Depending on the value of the strength field, the number of chest rows may vary (max is 5, so 15 slots).

> ⚠️ **Warning:** There still is a saddle slot, even though it cannot be used and is invisible.

> ⚠️ **Warning:** Slot positions within the llama inventory vary - slot 2 may be at (1,0) or at (0,1) depending on the number of columns.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Slot range</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>0</td>
      <td>saddle</td>
    </tr>
    <tr>
      <td>1</td>
      <td>carpet</td>
    </tr>
    <tr>
      <td>2 - `(2 + 3 * strength)`</td>
      <td>llama inventory</td>
    </tr>
    <tr>
      <td>`(2 + 3 * strength) + 1` - `(2 + 3 * strength) + 27`</td>
      <td>player inventory</td>
    </tr>
    <tr>
      <td>`(2 + 3 * strength) + 28` - `(2 + 3 * strength) + 35`</td>
      <td>hotbar</td>
    </tr>
  </tbody>
</table>

![Llama-unchested-slots](Llama-unchested-slots.png|Unchested llama)
![Llama-strength1-slots](Llama-strength1-slots.png|Llama with strength 1)
![Llama-strength2-slots](Llama-strength2-slots.png|Llama with strength 2)
![Llama-strength3-slots](Llama-strength3-slots.png|Llama with strength 3)
![Llama-strength4-slots](Llama-strength4-slots.png|Llama with strength 4)
![Llama-strength5-slots](Llama-strength5-slots.png|Llama with strength 5)

## Chest
<a id="large-chest"></a>
![Chest slots](Chest-slots.png)

The `generic_9x3` GUI appears when interacting with a [single chest](chest.md#chest), [minecart with chest](minecart_with_chest.md), [ender chest](ender_chest.md), or [barrel](barrel.md).

<table class="wikitable">
  <tbody>
    <tr>
      <th>Slot range</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>0–26</td>
      <td>chest</td>
    </tr>
    <tr>
      <td>27–53</td>
      <td>main inventory</td>
    </tr>
    <tr>
      <td>54–62</td>
      <td>hotbar</td>
    </tr>
  </tbody>
</table>

![Generic-9x1-slots](Generic-9x1-slots.png|Generic 9x1 slots)
![Generic-9x2-slots](Generic-9x2-slots.png|Generic 9x2 slots)
![Chest-slots](Chest-slots.png|Chest slots)
![Generic-9x4-slots](Generic-9x4-slots.png|Generic 9x4 slots)
![Generic-9x5-slots](Generic-9x5-slots.png|Generic 9x5 slots)
![DoubleChest-slots](DoubleChest-slots.png|Large chest slots)

---

## Dispenser
<a id="dropper"></a>

![Dispenser/dropper slots](Dispenser-slots.png)

The `generic_3x3` GUI appears when interacting with a [dispenser](dispenser.md) or [dropper](dropper.md).

<table class="wikitable">
  <tbody>
    <tr>
      <th>Slot range</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>0–8</td>
      <td>3×3 dispenser contents (`x + 3 * y`)</td>
    </tr>
    <tr>
      <td>9–35</td>
      <td>main inventory</td>
    </tr>
    <tr>
      <td>36-44</td>
      <td>hotbar</td>
    </tr>
  </tbody>
</table>

---

## Crafter

![Crafter slots](Crafter-slots.png)

The `crafter` GUI appears when interacting with a [crafter](crafter.md).

> ℹ️ Disabling slots is implemented by sending a [Click Container](java_edition_protocol-packets.md#clickcontainer) packet with no carried item to an empty slot.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Slot range</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>0-8</td>
      <td>3×3 crafting input (`x + 3 * y`)</td>
    </tr>
    <tr>
      <td>9–35</td>
      <td>main inventory</td>
    </tr>
    <tr>
      <td>36–44</td>
      <td>hotbar</td>
    </tr>
    <tr>
      <td>45</td>
      <td>result</td>
    </tr>
  </tbody>
</table>

---

## Anvil

![Anvil slots](Anvil-slots.png)

The `anvil` GUI appears when interacting with an [anvil](anvil.md).

> ℹ️ The name input is implemented using the [Rename Item](java_edition_protocol-packets.md#renameitem) packet.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Slot range</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>0</td>
      <td>first item</td>
    </tr>
    <tr>
      <td>1</td>
      <td>second item</td>
    </tr>
    <tr>
      <td>2</td>
      <td>result</td>
    </tr>
    <tr>
      <td>3–29</td>
      <td>main inventory</td>
    </tr>
    <tr>
      <td>30–38</td>
      <td>hotbar</td>
    </tr>
  </tbody>
</table>

---

## Beacon

![Beacon slots](Beacon-slots.png)

The `beacon` GUI appears when interacting with a [beacon](beacon.md).

> ℹ️ The effect buttons are clientside and sent using the [Set Beacon Effect](java_edition_protocol-packets.md#setbeaconeffect) packet when clicking the confirm button.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Slot range</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>0</td>
      <td>payment item</td>
    </tr>
    <tr>
      <td>1–27</td>
      <td>main inventory</td>
    </tr>
    <tr>
      <td>28–36</td>
      <td>hotbar</td>
    </tr>
  </tbody>
</table>

---

## Furnace
![Furnace slots](Furnace-slots.png)

The `furnace` GUI appears when interacting with a [furnace](furnace.md).

<table class="wikitable">
  <tbody>
    <tr>
      <th>Slot range</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>0</td>
      <td>ingredient</td>
    </tr>
    <tr>
      <td>1</td>
      <td>fuel</td>
    </tr>
    <tr>
      <td>2</td>
      <td>output</td>
    </tr>
    <tr>
      <td>3–29</td>
      <td>main inventory</td>
    </tr>
    <tr>
      <td>30–38</td>
      <td>hotbar</td>
    </tr>
  </tbody>
</table>

---

### Blast Furnace
![Blast furnace slots](Blast_Furnace-slots.png)

The `blast_furnace` GUI appears when interacting with a [blast furnace](blast_furnace.md).

Same layout as a furnace; however, the recipe book displays blast furnace recipes instead of regular furnace recipes.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Slot range</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>0</td>
      <td>ingredient</td>
    </tr>
    <tr>
      <td>1</td>
      <td>fuel</td>
    </tr>
    <tr>
      <td>2</td>
      <td>output</td>
    </tr>
    <tr>
      <td>3–29</td>
      <td>main inventory</td>
    </tr>
    <tr>
      <td>30–38</td>
      <td>hotbar</td>
    </tr>
  </tbody>
</table>

---

### Smoker
![Smoker slots](Smoker-slots.png)

The `smoker` GUI appears when interacting with a [smoker](smoker.md).

Same layout as a furnace; however, the recipe book displays smoker recipes instead of regular furnace recipes.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Slot range</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>0</td>
      <td>ingredient</td>
    </tr>
    <tr>
      <td>1</td>
      <td>fuel</td>
    </tr>
    <tr>
      <td>2</td>
      <td>output</td>
    </tr>
    <tr>
      <td>3–29</td>
      <td>main inventory</td>
    </tr>
    <tr>
      <td>30–38</td>
      <td>hotbar</td>
    </tr>
  </tbody>
</table>

---

## Brewing Stand

![Brewing stand slots](BrewingStand-slots.png)

The `brewing_stand` GUI appears when interacting with a [brewing stand](brewing_stand.md).

<table class="wikitable">
  <tbody>
    <tr>
      <th>Slot range</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>0-2</td>
      <td>bottles/potions</td>
    </tr>
    <tr>
      <td>3</td>
      <td>potion ingredient</td>
    </tr>
    <tr>
      <td>4</td>
      <td>blaze powder</td>
    </tr>
    <tr>
      <td>5-31</td>
      <td>main inventory</td>
    </tr>
    <tr>
      <td>32-40</td>
      <td>hotbar</td>
    </tr>
  </tbody>
</table>

---

## Crafting
<a id="crafting-table"></a>

![Crafting table slots](CraftingTable-slots.png)

The `crafting` GUI appears when interacting with a [crafting table](crafting_table.md).

<table class="wikitable">
  <tbody>
    <tr>
      <th>Slot range</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>0</td>
      <td>crafting output</td>
    </tr>
    <tr>
      <td>1–9</td>
      <td>3×3 crafting input (`1 + x + 3 * y`)</td>
    </tr>
    <tr>
      <td>10–36</td>
      <td>main inventory</td>
    </tr>
    <tr>
      <td>37–45</td>
      <td>hotbar</td>
    </tr>
  </tbody>
</table>

---

## Enchantment
<a id="enchantment-table"></a>

![Enchanting table slots](EnchantmentTable-slots.png)

The `enchantment` GUI appears when interacting with an [enchanting table](enchanting_table.md).

<table class="wikitable">
  <tbody>
    <tr>
      <th>Slot range</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>0</td>
      <td>item to enchant</td>
    </tr>
    <tr>
      <td>1</td>
      <td>lapis lazuli slot</td>
    </tr>
    <tr>
      <td>2–28</td>
      <td>main inventory</td>
    </tr>
    <tr>
      <td>29–37</td>
      <td>hotbar</td>
    </tr>
  </tbody>
</table>

<table class="wikitable">
  <tbody>
    <tr>
      <th>Button</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>0-2</td>
      <td>Enchantment</td>
    </tr>
  </tbody>
</table>

---

## Grindstone
![Grindstone slots](Grindstone-slots.png)

The `grindstone` GUI appears when interacting with a [grindstone](grindstone.md).

<table class="wikitable">
  <tbody>
    <tr>
      <th>Slot range</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>0</td>
      <td>first item</td>
    </tr>
    <tr>
      <td>1</td>
      <td>second item</td>
    </tr>
    <tr>
      <td>2</td>
      <td>result</td>
    </tr>
    <tr>
      <td>3–29</td>
      <td>main inventory</td>
    </tr>
    <tr>
      <td>30–38</td>
      <td>hotbar</td>
    </tr>
  </tbody>
</table>

---

## Hopper

![Hopper slots](Hopper-slots.png)

The `hopper` GUI appears when interacting with a [hopper](hopper.md) or [minecart with hopper](minecart_with_hopper.md).

<table class="wikitable">
  <tbody>
    <tr>
      <th>Slot range</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>0-4</td>
      <td>hopper slots</td>
    </tr>
    <tr>
      <td>5–31</td>
      <td>main inventory</td>
    </tr>
    <tr>
      <td>32–40</td>
      <td>hotbar</td>
    </tr>
  </tbody>
</table>

---

## Lectern
![Lectern UI](Lectern-slots.png)

The `lectern` GUI appears when interacting with a [lectern](lectern.md) with a book.

The player inventory is not included.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Slot range</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>0</td>
      <td>book</td>
    </tr>
  </tbody>
</table>

<table class="wikitable">
  <tbody>
    <tr>
      <th>Button</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>0</td>
      <td>unused</td>
    </tr>
    <tr>
      <td>1</td>
      <td>Page back</td>
    </tr>
    <tr>
      <td>2</td>
      <td>Page forward</td>
    </tr>
    <tr>
      <td>3</td>
      <td>Take Book</td>
    </tr>
    <tr>
      <td>`100 + page - 1`</td>
      <td>Change page (via [`"change_page"` click event](text_component_format.md#javaedition))</td>
    </tr>
  </tbody>
</table>

---

## Loom
![Loom slots](Loom-slots.png)

The `loom` GUI appears when interacting with a [loom](loom.md).

> ℹ️ The patterns retain their button ID when scrolling, i.e. the first visible button may have an ID higher than zero.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Slot range</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>0</td>
      <td>banner</td>
    </tr>
    <tr>
      <td>1</td>
      <td>dye</td>
    </tr>
    <tr>
      <td>2</td>
      <td>pattern</td>
    </tr>
    <tr>
      <td>3</td>
      <td>result</td>
    </tr>
    <tr>
      <td>4–30</td>
      <td>main inventory</td>
    </tr>
    <tr>
      <td>31–39</td>
      <td>hotbar</td>
    </tr>
  </tbody>
</table>

<table class="wikitable">
  <tbody>
    <tr>
      <th>Button</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>`n`</td>
      <td>Pattern `n`</td>
    </tr>
  </tbody>
</table>

---

## Merchant
<a id="villager-trading"></a>

![Merchant slots](Merchant-slots.png)

The `merchant` GUI appears when interacting with a [villager](villager.md) or [wandering trader](wandering_trader.md).

> ℹ️ If the villager only requires one item, you can put it in either (or both) slots.

> ℹ️ The trade buttons are implemented using the [Select Trade](java_edition_protocol-packets.md#selecttrade) packet.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Slot range</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>0-1</td>
      <td>input items</td>
    </tr>
    <tr>
      <td>2</td>
      <td>result</td>
    </tr>
    <tr>
      <td>3–29</td>
      <td>main inventory</td>
    </tr>
    <tr>
      <td>30–38</td>
      <td>hotbar</td>
    </tr>
  </tbody>
</table>

---

## Shulker Box
![Shulker box slots](Shulker-box-slots.png)

The `shulker_box` GUI appears when interacting with a [shulker box](shulker-box.md).

> ℹ️ Although the GUI is effectively identical to `[[#Chest|generic_9x3]]`, it is technically a distinct GUI (with its own texture).

<table class="wikitable">
  <tbody>
    <tr>
      <th>Slot range</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>0–26</td>
      <td>box slots</td>
    </tr>
    <tr>
      <td>27–53</td>
      <td>main inventory</td>
    </tr>
    <tr>
      <td>54–62</td>
      <td>hotbar</td>
    </tr>
  </tbody>
</table>

---

## Smithing
<a id="smithing-table"></a>
![Smithing table slots](Smithing_Table-slots.png)

The `smithing` GUI appears when interacting with a [smithing table](smithing_table.md).

<table class="wikitable">
  <tbody>
    <tr>
      <th>Slot range</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>0</td>
      <td>template</td>
    </tr>
    <tr>
      <td>1</td>
      <td>base item</td>
    </tr>
    <tr>
      <td>2</td>
      <td>additional item</td>
    </tr>
    <tr>
      <td>3</td>
      <td>result</td>
    </tr>
    <tr>
      <td>4–30</td>
      <td>main inventory</td>
    </tr>
    <tr>
      <td>31–39</td>
      <td>hotbar</td>
    </tr>
  </tbody>
</table>

---

## Cartography Table
![Cartography table slots](Cartography-slots.png)

The `cartography_table` GUI appears when interacting with a [cartography table](cartography_table.md).

<table class="wikitable">
  <tbody>
    <tr>
      <th>Slot range</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>0</td>
      <td>map</td>
    </tr>
    <tr>
      <td>1</td>
      <td>paper</td>
    </tr>
    <tr>
      <td>2</td>
      <td>output</td>
    </tr>
    <tr>
      <td>3–29</td>
      <td>main inventory</td>
    </tr>
    <tr>
      <td>30–38</td>
      <td>hotbar</td>
    </tr>
  </tbody>
</table>

---

## Stonecutter
![Stonecutter slots](Stonecutter-slots.png)

The `stonecutter` GUI appears when interacting with a [stonecutter](stonecutter.md).

> ℹ️ The recipes retain their button ID when scrolling, i.e. the first visible button may have an ID higher than zero.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Slot range</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>0</td>
      <td>input</td>
    </tr>
    <tr>
      <td>1</td>
      <td>result</td>
    </tr>
    <tr>
      <td>2–28</td>
      <td>main inventory</td>
    </tr>
    <tr>
      <td>29–37</td>
      <td>hotbar</td>
    </tr>
  </tbody>
</table>

<table class="wikitable">
  <tbody>
    <tr>
      <th>Button</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>`n`</td>
      <td>Recipe `n`</td>
    </tr>
  </tbody>
</table>

---

[Category:Protocol Details](category-protocol-details.md)
[Category:Java Edition protocol](category-java-edition-protocol.md)
_Content is licensed under wiki.vg terms._
