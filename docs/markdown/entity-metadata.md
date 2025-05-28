Various **Entities** have different metadata fields and [status codes](entity-statuses.md). 

These are the valid codes for Minecraft Java Edition 1.21.5; for upcoming snapshots, see [Pre-release protocol#Entity Metadata](pre-release-protocol.md#entity-metadata).

This page is maintained semi-automatically using a work-in-progress script made by mat, so it should update fairly quickly to new Minecraft versions. Regardless, it's not recommended that you parse it programmatically. Instead, consider using Bixilon's [PixLyzer](https://gitlab.bixilon.de/bixilon/pixlyzer) or [Burger](https://github.com/Pokechu22/Burger) (or [mat's Burger fork](https://github.com/mat-1/Burger), which the script for updating this page depends on).

## Entities

> ⚠️ **Warning:** These entity IDs are up to date for 1.21.5. Use [Data Generators](data-generators.md) or [Burger](https://pokechu22.github.io/Burger/) to get older IDs. If using Burger just replace the version number to what you want to see.

Most entities are spawned via [Protocol#Spawn Entity](protocol.md#spawn-entity), however, care should be taken for the following cases:

Entities marked in <span style="border: solid 1px black; background: #aaaaff; color: #aaaaff;">__</span> blue must be spawned in their own special ways:
- `Experience Orb`, should be spawned using [Spawn Experience Orb](protocol.md#spawnexperienceorb)

Entities marked in <span style="border: solid 1px black; background: #ffaaaa; color: #ffaaaa;">__</span> red must not be spawned at all, as they're server-side only:
- `Marker`, more info can be found [here](marker.md).

<table class="wikitable">
  <tbody>
    <tr>
      <th>Type</th>
      <th>Name</th>
      <th>bounding box x and z</th>
      <th>bounding box y</th>
      <th>ID</th>
    </tr>
    <tr>
      <td>0</td>
      <td>Acacia Boat</td>
      <td>1.375</td>
      <td>0.5625</td>
      <td>`minecraft:acacia_boat`</td>
    </tr>
    <tr>
      <td>1</td>
      <td>Acacia Boat with Chest</td>
      <td>1.375</td>
      <td>0.5625</td>
      <td>`minecraft:acacia_chest_boat`</td>
    </tr>
    <tr>
      <td>2</td>
      <td>Allay</td>
      <td>0.35</td>
      <td>0.6</td>
      <td>`minecraft:allay`</td>
    </tr>
    <tr>
      <td>3</td>
      <td>Area Effect Cloud</td>
      <td>2.0 * Radius</td>
      <td>0.5</td>
      <td>`minecraft:area_effect_cloud`</td>
    </tr>
    <tr>
      <td>4</td>
      <td>Armadillo</td>
      <td>0.7</td>
      <td>0.65</td>
      <td>`minecraft:armadillo`</td>
    </tr>
    <tr>
      <td>5</td>
      <td>Armor Stand</td>
      <td>normal: 0.5 marker: 0.0 small: 0.25</td>
      <td>normal: 1.975 marker: 0.0 small: 0.9875</td>
      <td>`minecraft:armor_stand`</td>
    </tr>
    <tr>
      <td>6</td>
      <td>Arrow</td>
      <td>0.5</td>
      <td>0.5</td>
      <td>`minecraft:arrow`</td>
    </tr>
    <tr>
      <td>7</td>
      <td>Axolotl</td>
      <td>0.75</td>
      <td>0.42</td>
      <td>`minecraft:axolotl`</td>
    </tr>
    <tr>
      <td>8</td>
      <td>Bamboo Raft with Chest</td>
      <td>1.375</td>
      <td>0.5625</td>
      <td>`minecraft:bamboo_chest_raft`</td>
    </tr>
    <tr>
      <td>9</td>
      <td>Bamboo Raft</td>
      <td>1.375</td>
      <td>0.5625</td>
      <td>`minecraft:bamboo_raft`</td>
    </tr>
    <tr>
      <td>10</td>
      <td>Bat</td>
      <td>0.5</td>
      <td>0.9</td>
      <td>`minecraft:bat`</td>
    </tr>
    <tr>
      <td>11</td>
      <td>Bee</td>
      <td>0.7</td>
      <td>0.6</td>
      <td>`minecraft:bee`</td>
    </tr>
    <tr>
      <td>12</td>
      <td>Birch Boat</td>
      <td>1.375</td>
      <td>0.5625</td>
      <td>`minecraft:birch_boat`</td>
    </tr>
    <tr>
      <td>13</td>
      <td>Birch Boat with Chest</td>
      <td>1.375</td>
      <td>0.5625</td>
      <td>`minecraft:birch_chest_boat`</td>
    </tr>
    <tr>
      <td>14</td>
      <td>Blaze</td>
      <td>0.6</td>
      <td>1.8</td>
      <td>`minecraft:blaze`</td>
    </tr>
    <tr>
      <td>15</td>
      <td>Block Display</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>`minecraft:block_display`</td>
    </tr>
    <tr>
      <td>16</td>
      <td>Bogged</td>
      <td>0.6</td>
      <td>1.99</td>
      <td>`minecraft:bogged`</td>
    </tr>
    <tr>
      <td>17</td>
      <td>Breeze</td>
      <td>0.6</td>
      <td>1.77</td>
      <td>`minecraft:breeze`</td>
    </tr>
    <tr>
      <td>18</td>
      <td>Wind Charge</td>
      <td>0.3125</td>
      <td>0.3125</td>
      <td>`minecraft:breeze_wind_charge`</td>
    </tr>
    <tr>
      <td>19</td>
      <td>Camel</td>
      <td>1.7</td>
      <td>2.375</td>
      <td>`minecraft:camel`</td>
    </tr>
    <tr>
      <td>20</td>
      <td>Cat</td>
      <td>0.6</td>
      <td>0.7</td>
      <td>`minecraft:cat`</td>
    </tr>
    <tr>
      <td>21</td>
      <td>Cave Spider</td>
      <td>0.7</td>
      <td>0.5</td>
      <td>`minecraft:cave_spider`</td>
    </tr>
    <tr>
      <td>22</td>
      <td>Cherry Boat</td>
      <td>1.375</td>
      <td>0.5625</td>
      <td>`minecraft:cherry_boat`</td>
    </tr>
    <tr>
      <td>23</td>
      <td>Cherry Boat with Chest</td>
      <td>1.375</td>
      <td>0.5625</td>
      <td>`minecraft:cherry_chest_boat`</td>
    </tr>
    <tr>
      <td>24</td>
      <td>Minecart with Chest</td>
      <td>0.98</td>
      <td>0.7</td>
      <td>`minecraft:chest_minecart`</td>
    </tr>
    <tr>
      <td>25</td>
      <td>Chicken</td>
      <td>0.4</td>
      <td>0.7</td>
      <td>`minecraft:chicken`</td>
    </tr>
    <tr>
      <td>26</td>
      <td>Cod</td>
      <td>0.5</td>
      <td>0.3</td>
      <td>`minecraft:cod`</td>
    </tr>
    <tr>
      <td>27</td>
      <td>Minecart with Command Block</td>
      <td>0.98</td>
      <td>0.7</td>
      <td>`minecraft:command_block_minecart`</td>
    </tr>
    <tr>
      <td>28</td>
      <td>Cow</td>
      <td>0.9</td>
      <td>1.4</td>
      <td>`minecraft:cow`</td>
    </tr>
    <tr>
      <td>29</td>
      <td>Creaking</td>
      <td>0.9</td>
      <td>2.7</td>
      <td>`minecraft:creaking`</td>
    </tr>
    <tr>
      <td>30</td>
      <td>Creeper</td>
      <td>0.6</td>
      <td>1.7</td>
      <td>`minecraft:creeper`</td>
    </tr>
    <tr>
      <td>31</td>
      <td>Dark Oak Boat</td>
      <td>1.375</td>
      <td>0.5625</td>
      <td>`minecraft:dark_oak_boat`</td>
    </tr>
    <tr>
      <td>32</td>
      <td>Dark Oak Boat with Chest</td>
      <td>1.375</td>
      <td>0.5625</td>
      <td>`minecraft:dark_oak_chest_boat`</td>
    </tr>
    <tr>
      <td>33</td>
      <td>Dolphin</td>
      <td>0.9</td>
      <td>0.6</td>
      <td>`minecraft:dolphin`</td>
    </tr>
    <tr>
      <td>34</td>
      <td>Donkey</td>
      <td>1.3964844</td>
      <td>1.5</td>
      <td>`minecraft:donkey`</td>
    </tr>
    <tr>
      <td>35</td>
      <td>Dragon Fireball</td>
      <td>1.0</td>
      <td>1.0</td>
      <td>`minecraft:dragon_fireball`</td>
    </tr>
    <tr>
      <td>36</td>
      <td>Drowned</td>
      <td>0.6</td>
      <td>1.95</td>
      <td>`minecraft:drowned`</td>
    </tr>
    <tr>
      <td>37</td>
      <td>Thrown Egg</td>
      <td>0.25</td>
      <td>0.25</td>
      <td>`minecraft:egg`</td>
    </tr>
    <tr>
      <td>38</td>
      <td>Elder Guardian</td>
      <td>1.9975 (2.35 * guardian)</td>
      <td>1.9975 (2.35 * guardian)</td>
      <td>`minecraft:elder_guardian`</td>
    </tr>
    <tr>
      <td>39</td>
      <td>Enderman</td>
      <td>0.6</td>
      <td>2.9</td>
      <td>`minecraft:enderman`</td>
    </tr>
    <tr>
      <td>40</td>
      <td>Endermite</td>
      <td>0.4</td>
      <td>0.3</td>
      <td>`minecraft:endermite`</td>
    </tr>
    <tr>
      <td>41</td>
      <td>Ender Dragon</td>
      <td>16.0</td>
      <td>8.0</td>
      <td>`minecraft:ender_dragon`</td>
    </tr>
    <tr>
      <td>42</td>
      <td>Thrown Ender Pearl</td>
      <td>0.25</td>
      <td>0.25</td>
      <td>`minecraft:ender_pearl`</td>
    </tr>
    <tr>
      <td>43</td>
      <td>End Crystal</td>
      <td>2.0</td>
      <td>2.0</td>
      <td>`minecraft:end_crystal`</td>
    </tr>
    <tr>
      <td>44</td>
      <td>Evoker</td>
      <td>0.6</td>
      <td>1.95</td>
      <td>`minecraft:evoker`</td>
    </tr>
    <tr>
      <td>45</td>
      <td>Evoker Fangs</td>
      <td>0.5</td>
      <td>0.8</td>
      <td>`minecraft:evoker_fangs`</td>
    </tr>
    <tr>
      <td>46</td>
      <td>Thrown Bottle o' Enchanting</td>
      <td>0.25</td>
      <td>0.25</td>
      <td>`minecraft:experience_bottle`</td>
      <td>- style="background: #aaaaff;"</td>
      <td>47</td>
      <td>Experience Orb</td>
      <td>0.5</td>
      <td>0.5</td>
      <td>`minecraft:experience_orb`</td>
    </tr>
    <tr>
      <td>48</td>
      <td>Eye of Ender</td>
      <td>0.25</td>
      <td>0.25</td>
      <td>`minecraft:eye_of_ender`</td>
    </tr>
    <tr>
      <td>49</td>
      <td>Falling Block</td>
      <td>0.98</td>
      <td>0.98</td>
      <td>`minecraft:falling_block`</td>
    </tr>
    <tr>
      <td>50</td>
      <td>Fireball</td>
      <td>1.0</td>
      <td>1.0</td>
      <td>`minecraft:fireball`</td>
    </tr>
    <tr>
      <td>51</td>
      <td>Firework Rocket</td>
      <td>0.25</td>
      <td>0.25</td>
      <td>`minecraft:firework_rocket`</td>
    </tr>
    <tr>
      <td>52</td>
      <td>Fox</td>
      <td>0.6</td>
      <td>0.7</td>
      <td>`minecraft:fox`</td>
    </tr>
    <tr>
      <td>53</td>
      <td>Frog</td>
      <td>0.5</td>
      <td>0.5</td>
      <td>`minecraft:frog`</td>
    </tr>
    <tr>
      <td>54</td>
      <td>Minecart with Furnace</td>
      <td>0.98</td>
      <td>0.7</td>
      <td>`minecraft:furnace_minecart`</td>
    </tr>
    <tr>
      <td>55</td>
      <td>Ghast</td>
      <td>4.0</td>
      <td>4.0</td>
      <td>`minecraft:ghast`</td>
    </tr>
    <tr>
      <td>56</td>
      <td>Giant</td>
      <td>3.6</td>
      <td>12.0</td>
      <td>`minecraft:giant`</td>
    </tr>
    <tr>
      <td>57</td>
      <td>Glow Item Frame</td>
      <td>0.75 or 0.0625 (depth)</td>
      <td>0.75</td>
      <td>`minecraft:glow_item_frame`</td>
    </tr>
    <tr>
      <td>58</td>
      <td>Glow Squid</td>
      <td>0.8</td>
      <td>0.8</td>
      <td>`minecraft:glow_squid`</td>
    </tr>
    <tr>
      <td>59</td>
      <td>Goat</td>
      <td>1.3</td>
      <td>0.9</td>
      <td>`minecraft:goat`</td>
    </tr>
    <tr>
      <td>60</td>
      <td>Guardian</td>
      <td>0.85</td>
      <td>0.85</td>
      <td>`minecraft:guardian`</td>
    </tr>
    <tr>
      <td>61</td>
      <td>Hoglin</td>
      <td>1.3964844</td>
      <td>1.4</td>
      <td>`minecraft:hoglin`</td>
    </tr>
    <tr>
      <td>62</td>
      <td>Minecart with Hopper</td>
      <td>0.98</td>
      <td>0.7</td>
      <td>`minecraft:hopper_minecart`</td>
    </tr>
    <tr>
      <td>63</td>
      <td>Horse</td>
      <td>1.3964844</td>
      <td>1.6</td>
      <td>`minecraft:horse`</td>
    </tr>
    <tr>
      <td>64</td>
      <td>Husk</td>
      <td>0.6</td>
      <td>1.95</td>
      <td>`minecraft:husk`</td>
    </tr>
    <tr>
      <td>65</td>
      <td>Illusioner</td>
      <td>0.6</td>
      <td>1.95</td>
      <td>`minecraft:illusioner`</td>
    </tr>
    <tr>
      <td>66</td>
      <td>Interaction</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>`minecraft:interaction`</td>
    </tr>
    <tr>
      <td>67</td>
      <td>Iron Golem</td>
      <td>1.4</td>
      <td>2.7</td>
      <td>`minecraft:iron_golem`</td>
    </tr>
    <tr>
      <td>68</td>
      <td>Item</td>
      <td>0.25</td>
      <td>0.25</td>
      <td>`minecraft:item`</td>
    </tr>
    <tr>
      <td>69</td>
      <td>Item Display</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>`minecraft:item_display`</td>
    </tr>
    <tr>
      <td>70</td>
      <td>Item Frame</td>
      <td>0.75 or 0.0625 (depth)</td>
      <td>0.75</td>
      <td>`minecraft:item_frame`</td>
    </tr>
    <tr>
      <td>71</td>
      <td>Jungle Boat</td>
      <td>1.375</td>
      <td>0.5625</td>
      <td>`minecraft:jungle_boat`</td>
    </tr>
    <tr>
      <td>72</td>
      <td>Jungle Boat with Chest</td>
      <td>1.375</td>
      <td>0.5625</td>
      <td>`minecraft:jungle_chest_boat`</td>
    </tr>
    <tr>
      <td>73</td>
      <td>Leash Knot</td>
      <td>0.375</td>
      <td>0.5</td>
      <td>`minecraft:leash_knot`</td>
    </tr>
    <tr>
      <td>74</td>
      <td>Lightning Bolt</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>`minecraft:lightning_bolt`</td>
    </tr>
    <tr>
      <td>75</td>
      <td>Llama</td>
      <td>0.9</td>
      <td>1.87</td>
      <td>`minecraft:llama`</td>
    </tr>
    <tr>
      <td>76</td>
      <td>Llama Spit</td>
      <td>0.25</td>
      <td>0.25</td>
      <td>`minecraft:llama_spit`</td>
    </tr>
    <tr>
      <td>77</td>
      <td>Magma Cube</td>
      <td>0.5202 * size</td>
      <td>0.5202 * size</td>
      <td>`minecraft:magma_cube`</td>
    </tr>
    <tr>
      <td>78</td>
      <td>Mangrove Boat</td>
      <td>1.375</td>
      <td>0.5625</td>
      <td>`minecraft:mangrove_boat`</td>
    </tr>
    <tr>
      <td>79</td>
      <td>Mangrove Boat with Chest</td>
      <td>1.375</td>
      <td>0.5625</td>
      <td>`minecraft:mangrove_chest_boat`</td>
      <td>- style="background: #ffaaaa;"</td>
      <td>80</td>
      <td>Marker</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>`minecraft:marker`</td>
    </tr>
    <tr>
      <td>81</td>
      <td>Minecart</td>
      <td>0.98</td>
      <td>0.7</td>
      <td>`minecraft:minecart`</td>
    </tr>
    <tr>
      <td>82</td>
      <td>Mooshroom</td>
      <td>0.9</td>
      <td>1.4</td>
      <td>`minecraft:mooshroom`</td>
    </tr>
    <tr>
      <td>83</td>
      <td>Mule</td>
      <td>1.3964844</td>
      <td>1.6</td>
      <td>`minecraft:mule`</td>
    </tr>
    <tr>
      <td>84</td>
      <td>Oak Boat</td>
      <td>1.375</td>
      <td>0.5625</td>
      <td>`minecraft:oak_boat`</td>
    </tr>
    <tr>
      <td>85</td>
      <td>Oak Boat with Chest</td>
      <td>1.375</td>
      <td>0.5625</td>
      <td>`minecraft:oak_chest_boat`</td>
    </tr>
    <tr>
      <td>86</td>
      <td>Ocelot</td>
      <td>0.6</td>
      <td>0.7</td>
      <td>`minecraft:ocelot`</td>
    </tr>
    <tr>
      <td>87</td>
      <td>Ominous Item Spawner</td>
      <td>0.25</td>
      <td>0.25</td>
      <td>`minecraft:ominous_item_spawner`</td>
    </tr>
    <tr>
      <td>88</td>
      <td>Painting</td>
      <td>type width or 0.0625 (depth)</td>
      <td>type height</td>
      <td>`minecraft:painting`</td>
    </tr>
    <tr>
      <td>89</td>
      <td>Pale Oak Boat</td>
      <td>1.375</td>
      <td>0.5625</td>
      <td>`minecraft:pale_oak_boat`</td>
    </tr>
    <tr>
      <td>90</td>
      <td>Pale Oak Boat with Chest</td>
      <td>1.375</td>
      <td>0.5625</td>
      <td>`minecraft:pale_oak_chest_boat`</td>
    </tr>
    <tr>
      <td>91</td>
      <td>Panda</td>
      <td>1.3</td>
      <td>1.25</td>
      <td>`minecraft:panda`</td>
    </tr>
    <tr>
      <td>92</td>
      <td>Parrot</td>
      <td>0.5</td>
      <td>0.9</td>
      <td>`minecraft:parrot`</td>
    </tr>
    <tr>
      <td>93</td>
      <td>Phantom</td>
      <td>0.9</td>
      <td>0.5</td>
      <td>`minecraft:phantom`</td>
    </tr>
    <tr>
      <td>94</td>
      <td>Pig</td>
      <td>0.9</td>
      <td>0.9</td>
      <td>`minecraft:pig`</td>
    </tr>
    <tr>
      <td>95</td>
      <td>Piglin</td>
      <td>0.6</td>
      <td>1.95</td>
      <td>`minecraft:piglin`</td>
    </tr>
    <tr>
      <td>96</td>
      <td>Piglin Brute</td>
      <td>0.6</td>
      <td>1.95</td>
      <td>`minecraft:piglin_brute`</td>
    </tr>
    <tr>
      <td>97</td>
      <td>Pillager</td>
      <td>0.6</td>
      <td>1.95</td>
      <td>`minecraft:pillager`</td>
    </tr>
    <tr>
      <td>98</td>
      <td>Polar Bear</td>
      <td>1.4</td>
      <td>1.4</td>
      <td>`minecraft:polar_bear`</td>
    </tr>
    <tr>
      <td>99</td>
      <td>Splash Potion</td>
      <td>0.25</td>
      <td>0.25</td>
      <td>`minecraft:splash_potion`</td>
    </tr>
    <tr>
      <td>100</td>
      <td>Lingering Potion</td>
      <td>0.25</td>
      <td>0.25</td>
      <td>`minecraft:lingering_potion`</td>
    </tr>
    <tr>
      <td>101</td>
      <td>Pufferfish</td>
      <td>0.7</td>
      <td>0.7</td>
      <td>`minecraft:pufferfish`</td>
    </tr>
    <tr>
      <td>102</td>
      <td>Rabbit</td>
      <td>0.4</td>
      <td>0.5</td>
      <td>`minecraft:rabbit`</td>
    </tr>
    <tr>
      <td>103</td>
      <td>Ravager</td>
      <td>1.95</td>
      <td>2.2</td>
      <td>`minecraft:ravager`</td>
    </tr>
    <tr>
      <td>104</td>
      <td>Salmon</td>
      <td>0.7</td>
      <td>0.4</td>
      <td>`minecraft:salmon`</td>
    </tr>
    <tr>
      <td>105</td>
      <td>Sheep</td>
      <td>0.9</td>
      <td>1.3</td>
      <td>`minecraft:sheep`</td>
    </tr>
    <tr>
      <td>106</td>
      <td>Shulker</td>
      <td>1.0</td>
      <td>1.0-2.0 (depending on peek)</td>
      <td>`minecraft:shulker`</td>
    </tr>
    <tr>
      <td>107</td>
      <td>Shulker Bullet</td>
      <td>0.3125</td>
      <td>0.3125</td>
      <td>`minecraft:shulker_bullet`</td>
    </tr>
    <tr>
      <td>108</td>
      <td>Silverfish</td>
      <td>0.4</td>
      <td>0.3</td>
      <td>`minecraft:silverfish`</td>
    </tr>
    <tr>
      <td>109</td>
      <td>Skeleton</td>
      <td>0.6</td>
      <td>1.99</td>
      <td>`minecraft:skeleton`</td>
    </tr>
    <tr>
      <td>110</td>
      <td>Skeleton Horse</td>
      <td>1.3964844</td>
      <td>1.6</td>
      <td>`minecraft:skeleton_horse`</td>
    </tr>
    <tr>
      <td>111</td>
      <td>Slime</td>
      <td>0.5202 * size</td>
      <td>0.5202 * size</td>
      <td>`minecraft:slime`</td>
    </tr>
    <tr>
      <td>112</td>
      <td>Small Fireball</td>
      <td>0.3125</td>
      <td>0.3125</td>
      <td>`minecraft:small_fireball`</td>
    </tr>
    <tr>
      <td>113</td>
      <td>Sniffer</td>
      <td>1.9</td>
      <td>1.75</td>
      <td>`minecraft:sniffer`</td>
    </tr>
    <tr>
      <td>114</td>
      <td>Snowball</td>
      <td>0.25</td>
      <td>0.25</td>
      <td>`minecraft:snowball`</td>
    </tr>
    <tr>
      <td>115</td>
      <td>Snow Golem</td>
      <td>0.7</td>
      <td>1.9</td>
      <td>`minecraft:snow_golem`</td>
    </tr>
    <tr>
      <td>116</td>
      <td>Minecart with Monster Spawner</td>
      <td>0.98</td>
      <td>0.7</td>
      <td>`minecraft:spawner_minecart`</td>
    </tr>
    <tr>
      <td>117</td>
      <td>Spectral Arrow</td>
      <td>0.5</td>
      <td>0.5</td>
      <td>`minecraft:spectral_arrow`</td>
    </tr>
    <tr>
      <td>118</td>
      <td>Spider</td>
      <td>1.4</td>
      <td>0.9</td>
      <td>`minecraft:spider`</td>
    </tr>
    <tr>
      <td>119</td>
      <td>Spruce Boat</td>
      <td>1.375</td>
      <td>0.5625</td>
      <td>`minecraft:spruce_boat`</td>
    </tr>
    <tr>
      <td>120</td>
      <td>Spruce Boat with Chest</td>
      <td>1.375</td>
      <td>0.5625</td>
      <td>`minecraft:spruce_chest_boat`</td>
    </tr>
    <tr>
      <td>121</td>
      <td>Squid</td>
      <td>0.8</td>
      <td>0.8</td>
      <td>`minecraft:squid`</td>
    </tr>
    <tr>
      <td>122</td>
      <td>Stray</td>
      <td>0.6</td>
      <td>1.99</td>
      <td>`minecraft:stray`</td>
    </tr>
    <tr>
      <td>123</td>
      <td>Strider</td>
      <td>0.9</td>
      <td>1.7</td>
      <td>`minecraft:strider`</td>
    </tr>
    <tr>
      <td>124</td>
      <td>Tadpole</td>
      <td>0.4</td>
      <td>0.3</td>
      <td>`minecraft:tadpole`</td>
    </tr>
    <tr>
      <td>125</td>
      <td>Text Display</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>`minecraft:text_display`</td>
    </tr>
    <tr>
      <td>126</td>
      <td>Primed TNT</td>
      <td>0.98</td>
      <td>0.98</td>
      <td>`minecraft:tnt`</td>
    </tr>
    <tr>
      <td>127</td>
      <td>Minecart with TNT</td>
      <td>0.98</td>
      <td>0.7</td>
      <td>`minecraft:tnt_minecart`</td>
    </tr>
    <tr>
      <td>128</td>
      <td>Trader Llama</td>
      <td>0.9</td>
      <td>1.87</td>
      <td>`minecraft:trader_llama`</td>
    </tr>
    <tr>
      <td>129</td>
      <td>Trident</td>
      <td>0.5</td>
      <td>0.5</td>
      <td>`minecraft:trident`</td>
    </tr>
    <tr>
      <td>130</td>
      <td>Tropical Fish</td>
      <td>0.5</td>
      <td>0.4</td>
      <td>`minecraft:tropical_fish`</td>
    </tr>
    <tr>
      <td>131</td>
      <td>Turtle</td>
      <td>1.2</td>
      <td>0.4</td>
      <td>`minecraft:turtle`</td>
    </tr>
    <tr>
      <td>132</td>
      <td>Vex</td>
      <td>0.4</td>
      <td>0.8</td>
      <td>`minecraft:vex`</td>
    </tr>
    <tr>
      <td>133</td>
      <td>Villager</td>
      <td>0.6</td>
      <td>1.95</td>
      <td>`minecraft:villager`</td>
    </tr>
    <tr>
      <td>134</td>
      <td>Vindicator</td>
      <td>0.6</td>
      <td>1.95</td>
      <td>`minecraft:vindicator`</td>
    </tr>
    <tr>
      <td>135</td>
      <td>Wandering Trader</td>
      <td>0.6</td>
      <td>1.95</td>
      <td>`minecraft:wandering_trader`</td>
    </tr>
    <tr>
      <td>136</td>
      <td>Warden</td>
      <td>0.9</td>
      <td>2.9</td>
      <td>`minecraft:warden`</td>
    </tr>
    <tr>
      <td>137</td>
      <td>Wind Charge</td>
      <td>0.3125</td>
      <td>0.3125</td>
      <td>`minecraft:wind_charge`</td>
    </tr>
    <tr>
      <td>138</td>
      <td>Witch</td>
      <td>0.6</td>
      <td>1.95</td>
      <td>`minecraft:witch`</td>
    </tr>
    <tr>
      <td>139</td>
      <td>Wither</td>
      <td>0.9</td>
      <td>3.5</td>
      <td>`minecraft:wither`</td>
    </tr>
    <tr>
      <td>140</td>
      <td>Wither Skeleton</td>
      <td>0.7</td>
      <td>2.4</td>
      <td>`minecraft:wither_skeleton`</td>
    </tr>
    <tr>
      <td>141</td>
      <td>Wither Skull</td>
      <td>0.3125</td>
      <td>0.3125</td>
      <td>`minecraft:wither_skull`</td>
    </tr>
    <tr>
      <td>142</td>
      <td>Wolf</td>
      <td>0.6</td>
      <td>0.85</td>
      <td>`minecraft:wolf`</td>
    </tr>
    <tr>
      <td>143</td>
      <td>Zoglin</td>
      <td>1.3964844</td>
      <td>1.4</td>
      <td>`minecraft:zoglin`</td>
    </tr>
    <tr>
      <td>144</td>
      <td>Zombie</td>
      <td>0.6</td>
      <td>1.95</td>
      <td>`minecraft:zombie`</td>
    </tr>
    <tr>
      <td>145</td>
      <td>Zombie Horse</td>
      <td>1.3964844</td>
      <td>1.6</td>
      <td>`minecraft:zombie_horse`</td>
    </tr>
    <tr>
      <td>146</td>
      <td>Zombie Villager</td>
      <td>0.6</td>
      <td>1.95</td>
      <td>`minecraft:zombie_villager`</td>
    </tr>
    <tr>
      <td>147</td>
      <td>Zombified Piglin</td>
      <td>0.6</td>
      <td>1.95</td>
      <td>`minecraft:zombified_piglin`</td>
    </tr>
    <tr>
      <td>148</td>
      <td>Player</td>
      <td>0.6</td>
      <td>1.8</td>
      <td>`minecraft:player`</td>
    </tr>
    <tr>
      <td>149</td>
      <td>Fishing Bobber</td>
      <td>0.25</td>
      <td>0.25</td>
      <td>`minecraft:fishing_bobber`</td>
    </tr>
  </tbody>
</table>

## Entity Metadata Format

Note that entity metadata is a totally distinct concept from block metadata.  It is not required to send all metadata fields, or even any metadata fields, so long as the terminating entry is correctly sent.

Entity Metadata is an array of entries, each of which looks like the following:

<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Meaning</th>
    </tr>
    <tr>
      <td>Index</td>
      <td>`Unsigned Byte`</td>
      <td>Unique index key determining the meaning of the following value, see the table below. If this is `0xff` then the it is the end of the Entity Metadata array and no more is read.</td>
    </tr>
    <tr>
      <td>Type</td>
      <td>`VarInt` `Enum`</td>
      <td>Only if Index is not `0xff`; the type of the index, see the table below</td>
    </tr>
    <tr>
      <td>Value</td>
      <td>Varies</td>
      <td>Only if Index is not `0xff`: the value of the metadata field, see the table below</td>
    </tr>
  </tbody>
</table>

{{Metadata type definition/begin}}
 ! Value
 ! Notes
{{Metadata type definition|Byte}}
 | `Byte`
 |
{{Metadata type definition|VarInt}}
 | `VarInt`
 |
{{Metadata type definition|VarLong}}
 | `VarLong`
 |
{{Metadata type definition|Float}}
 | `Float`
 |
{{Metadata type definition|String}}
 | `String` (32767)
 |
{{Metadata type definition|Text Component}}
 | `Text Component`
 |
{{Metadata type definition|Optional Text Component}}
 | (`Boolean`, `Optional` `Text Component`)
 | Text Component is present if the Boolean is set to true.
{{Metadata type definition|Slot}}
 | `Slot`
 |
{{Metadata type definition|Boolean}}
 | `Boolean`
 |
{{Metadata type definition|Rotations}}
 | (`Float`, `Float`, `Float`)
 | rotation on x, rotation on y, rotation on z
{{Metadata type definition|Position}}
 | `Position`
 |
{{Metadata type definition|Optional Position}}
 | (`Boolean`, `Optional` `Position`)
 | Position is present if the Boolean is set to true.
{{Metadata type definition|Direction}}
 | `VarInt` `Enum`
 | Down = 0, Up = 1, North = 2, South = 3, West = 4, East = 5
{{Metadata type definition|Optional Living Entity Reference}}
 | (`Boolean`, `Optional` `UUID`)
 | UUID is present if the Boolean is set to true.
{{Metadata type definition|Block State}}
 | `VarInt`
 | An ID in the block state registry.
{{Metadata type definition|Optional Block State}}
 | `VarInt`
 | 0 for absent (air is unrepresentable); otherwise, an ID in the block state registry.
{{Metadata type definition|NBT}}
 | `NBT`
 |
{{Metadata type definition|Particle}}
 | (`VarInt`, Varies)
 | particle type (an ID in the `minecraft:particle_type` registry), particle data (See [Particles](particles.md).)
{{Metadata type definition|Particles}}
 | (`VarInt`, `Array` of (`VarInt`, Varies))
 | length-prefixed list of particle defintions (as above).
{{Metadata type definition|Villager Data}}
 | (`VarInt`, `VarInt`, `VarInt`)
 | villager type, villager profession, level (See below.)
{{Metadata type definition|Optional VarInt}}
 | `VarInt`
 | 0 for absent; 1 + actual value otherwise. Used for entity IDs.
{{Metadata type definition|Pose}}
 | `VarInt` `Enum`
 | STANDING = 0, FALL_FLYING = 1, SLEEPING = 2, SWIMMING = 3, SPIN_ATTACK = 4, SNEAKING = 5, LONG_JUMPING = 6, DYING = 7, CROAKING = 8, USING_TONGUE = 9, SITTING = 10, ROARING = 11, SNIFFING = 12, EMERGING = 13, DIGGING = 14, (1.21.3: SLIDING = 15, SHOOTING = 16, INHALING = 17)
{{Metadata type definition|Cat Variant}}
 | `VarInt`
 | An ID in the `minecraft:cat_variant` registry.
{{Metadata type definition|Cow Variant}}
 | `VarInt`
 | An ID in the `minecraft:cow_variant` registry.
{{Metadata type definition|Wolf Variant}}
 | `VarInt`
 | An ID in the `minecraft:wolf_variant` registry.
{{Metadata type definition|Wolf Sound Variant}}
 | `VarInt`
 | An ID in the `minecraft:wolf_sound_variant` registry.
{{Metadata type definition|Frog Variant}}
 | `VarInt`
 | An ID in the `minecraft:frog_variant` registry.
{{Metadata type definition|Pig Variant}}
 | `VarInt`
 | An ID in the `minecraft:pig_variant` registry.
{{Metadata type definition|Chicken Variant}}
 | `VarInt`
 | An ID in the `minecraft:chicken_variant` registry.
{{Metadata type definition|Optional Global Position}}
 | (`Boolean`, `Optional` `Identifier`, `Optional` `Position`)
 | dimension identifier, position; only if the Boolean is set to true.
{{Metadata type definition|Painting Variant}}
 | `ID or` [[#Painting Variant|Painting Variant]]
 | An ID in the `minecraft:painting_variant` registry, or an inline definition.
{{Metadata type definition|Sniffer State}}
 | `VarInt` `Enum`
 | IDLING = 0, FEELING_HAPPY = 1, SCENTING = 2, SNIFFING = 3, SEARCHING = 4, DIGGING = 5, RISING = 6
{{Metadata type definition|Armadillo State}}
 | `VarInt` `Enum`
 | IDLE = 0, ROLLING = 1, SCARED = 2, UNROLLING = 3
{{Metadata type definition|Vector3}}
 | (`Float`, `Float`, `Float`)
 | x, y, z
{{Metadata type definition|Quaternion}}
 | (`Float`, `Float`, `Float`, `Float`)
 | x, y, z, w
 |}

Villager types (`minecraft:villager_type` registry):

<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>ID</th>
    </tr>
    <tr>
      <td>`minecraft:desert`</td>
      <td>0</td>
    </tr>
    <tr>
      <td>`minecraft:jungle`</td>
      <td>1</td>
    </tr>
    <tr>
      <td>`minecraft:plains`</td>
      <td>2</td>
    </tr>
    <tr>
      <td>`minecraft:savanna`</td>
      <td>3</td>
    </tr>
    <tr>
      <td>`minecraft:snow`</td>
      <td>4</td>
    </tr>
    <tr>
      <td>`minecraft:swamp`</td>
      <td>5</td>
    </tr>
    <tr>
      <td>`minecraft:taiga`</td>
      <td>6</td>
    </tr>
  </tbody>
</table>

Villager professions (`minecraft:villager_profession` registry):

<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>ID</th>
    </tr>
    <tr>
      <td>`minecraft:none`</td>
      <td>0</td>
    </tr>
    <tr>
      <td>`minecraft:armorer`</td>
      <td>1</td>
    </tr>
    <tr>
      <td>`minecraft:butcher`</td>
      <td>2</td>
    </tr>
    <tr>
      <td>`minecraft:cartographer`</td>
      <td>3</td>
    </tr>
    <tr>
      <td>`minecraft:cleric`</td>
      <td>4</td>
    </tr>
    <tr>
      <td>`minecraft:farmer`</td>
      <td>5</td>
    </tr>
    <tr>
      <td>`minecraft:fisherman`</td>
      <td>6</td>
    </tr>
    <tr>
      <td>`minecraft:fletcher`</td>
      <td>7</td>
    </tr>
    <tr>
      <td>`minecraft:leatherworker`</td>
      <td>8</td>
    </tr>
    <tr>
      <td>`minecraft:librarian`</td>
      <td>9</td>
    </tr>
    <tr>
      <td>`minecraft:mason`</td>
      <td>10</td>
    </tr>
    <tr>
      <td>`minecraft:nitwit`</td>
      <td>11</td>
    </tr>
    <tr>
      <td>`minecraft:shepherd`</td>
      <td>12</td>
    </tr>
    <tr>
      <td>`minecraft:toolsmith`</td>
      <td>13</td>
    </tr>
    <tr>
      <td>`minecraft:weaponsmith`</td>
      <td>14</td>
    </tr>
  </tbody>
</table>

### Wolf Variant

See also:
  * [Minecraft Wiki:Projects/wiki.vg merge/Registry Data#Wolf Variant](./registry-data.md#wolf-variant)

<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Meaning</th>
    </tr>
    <tr>
      <td>Wild texture</td>
      <td>`Identifier`</td>
      <td>The texture for the wild version of this wolf.
The Notchian client uses the corresponding asset located at `textures`.</td>
    </tr>
    <tr>
      <td>Tame texture</td>
      <td>`Identifier`</td>
      <td>The texture for the tamed version of this wolf.
The Notchian client uses the corresponding asset located at `textures`.</td>
    </tr>
    <tr>
      <td>Angry texture</td>
      <td>`Identifier`</td>
      <td>The texture for the angry version of this wolf.
The Notchian client uses the corresponding asset located at `textures`.</td>
    </tr>
    <tr>
      <td>Biomes</td>
      <td>`ID Set`</td>
      <td>Biomes in which this wolf can spawn in (IDs in the `minecraft:biome` registry).</td>
    </tr>
  </tbody>
</table>

### Painting Variant

See also:
  * [Minecraft Wiki:Projects/wiki.vg merge/Registry Data#Painting Variant](./registry-data.md#painting-variant)

<table class="wikitable">
  <tbody>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Meaning</th>
    </tr>
    <tr>
      <td>Width</td>
      <td>`Int`</td>
      <td>The width of the painting, in blocks.</td>
    </tr>
    <tr>
      <td>Height</td>
      <td>`Int`</td>
      <td>The height of the painting, in blocks.</td>
    </tr>
    <tr>
      <td>Asset ID</td>
      <td>`Identifier`</td>
      <td>The texture for the painting.
The Notchian client uses the corresponding asset located at 
`textures/painting`.</td>
    </tr>
    <tr>
      <td>Title</td>
      <td>`Prefixed Optional` `Text Component`</td>
      <td>The displayed title of the painting. Only present if Has title is true.</td>
    </tr>
    <tr>
      <td>Author</td>
      <td>`Prefixed Optional` `Text Component`</td>
      <td>The displayed author of the painting. Only present if Has author is true.</td>
    </tr>
  </tbody>
</table>

Entity classes also recursively inherit fields from classes they extend.

## Entity Metadata

### Entity

_**Entity**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td rowspan="9">{{Metadata id|}}</td>
      <td rowspan="9">{{Metadata type|Byte}}</td>
      <th>Bit mask</th>
      <th>Meaning</th>
      <td rowspan="9">0</td>
    </tr>
    <tr>
      <td>0x01</td>
      <td>Is on fire</td>
    </tr>
    <tr>
      <td>0x02</td>
      <td>Is pressing sneak key (hides the name tag, but does not make the entity visually sneak.)</td>
    </tr>
    <tr>
      <td>0x04</td>
      <td>*Unused* (previously riding)</td>
    </tr>
    <tr>
      <td>0x08</td>
      <td>Is sprinting (shows sprinting particles when on ground.)</td>
    </tr>
    <tr>
      <td>0x10</td>
      <td>Is swimming</td>
    </tr>
    <tr>
      <td>0x20</td>
      <td>Is invisible</td>
    </tr>
    <tr>
      <td>0x40</td>
      <td>has glowing effect</td>
    </tr>
    <tr>
      <td>0x80</td>
      <td>Is flying with an [elytra](elytra.md)</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Air ticks</td>
      <td>300</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Optional Text Component}}</td>
      <td colspan="2">Custom name</td>
      <td>empty</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Is custom name visible</td>
      <td>false</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Is silent</td>
      <td>false</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Has no gravity</td>
      <td>false</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Pose}}</td>
      <td colspan="2">Pose</td>
      <td>STANDING</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Ticks frozen in powdered snow</td>
      <td>0</td>
    </tr>
  </tbody>
</table>

On the Notchan server Is pressing sneak key reflects the sneak key state indicated by the client rather than the entity's pose, and can thus be set while swimming, flying or crawling, or unset while stuck sneaking under a block.

Freezing ticks cap at 140 in the client for the player's snow overlay when stuck in powder snow. If the entity extends LivingEntity and freezing ticks reaches the cap, the mob will start shaking (this excludes the skeleton, which has its own indicator).

### Area Effect Cloud

_**Area Effect Cloud** inherits from **Entity**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Float}}</td>
      <td colspan="2">Radius</td>
      <td>3.0</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Ignore radius and show effect as single point, not area</td>
      <td>false</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Particle}}</td>
      <td colspan="2">The particle</td>
      <td>-1</td>
    </tr>
  </tbody>
</table>

### Wind Charge

_**Wind Charge** inherits from **Entity**._

No additional metadata.

### Dragon Fireball

_**Dragon Fireball** inherits from **Entity**._

No additional metadata.

### End Crystal

_**End Crystal** inherits from **Entity**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Optional Position}}</td>
      <td colspan="2">Beam target</td>
      <td>Empty</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Show bottom</td>
      <td>true</td>
    </tr>
  </tbody>
</table>

### Evoker Fangs

_**Evoker Fangs** inherits from **Entity**._

No additional metadata.

### Experience Orb

_**Experience Orb** inherits from **Entity**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">The amount of experience this orb will reward once collected.</td>
      <td>0</td>
    </tr>
  </tbody>
</table>

### Eye of Ender

_**Eye of Ender** inherits from **Entity**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Slot}}</td>
      <td colspan="2">Item</td>
      <td>Empty (which behaves as if it were a `minecraft:ender_eye`)</td>
    </tr>
  </tbody>
</table>

### Falling Block

_**Falling Block** inherits from **Entity**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Position}}</td>
      <td colspan="2">spawn position</td>
      <td>(0, 0, 0)</td>
    </tr>
  </tbody>
</table>

### Fireball

_**Fireball** inherits from **Entity**._

This is the large fireball shot by ghasts.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Slot}}</td>
      <td colspan="2">Item</td>
      <td>Empty</td>
    </tr>
  </tbody>
</table>

### Firework Rocket

_**Firework Rocket** inherits from **Entity**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Slot}}</td>
      <td colspan="2">Firework info</td>
      <td>Empty</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Optional VarInt}}</td>
      <td colspan="2">Entity ID of entity which used firework (for elytra boosting)</td>
      <td>Empty</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Is shot at angle (from a crossbow)</td>
      <td>false</td>
    </tr>
  </tbody>
</table>

### Interaction

_**Interaction** inherits from **Entity**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Float}}</td>
      <td colspan="2">Width</td>
      <td>1.0</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Float}}</td>
      <td colspan="2">Height</td>
      <td>1.0</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Responsive - can be attacked/interacted with if true</td>
      <td>false</td>
    </tr>
  </tbody>
</table>

### Item

_**Item** inherits from **Entity**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Slot}}</td>
      <td colspan="2">Item</td>
      <td>Empty</td>
    </tr>
  </tbody>
</table>

### Item Frame

_**Item Frame** inherits from **Entity**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Slot}}</td>
      <td colspan="2">Item</td>
      <td>Empty</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Rotation</td>
      <td>0</td>
    </tr>
  </tbody>
</table>

### Glow Item Frame

_**Glow Item Frame** inherits from **Item Frame**._

No additional metadata.

### Leash Knot

_**Leash Knot** inherits from **Entity**._

No additional metadata.

### Lightning Bolt

_**Lightning Bolt** inherits from **Entity**._

No additional metadata.

### Llama Spit

_**Llama Spit** inherits from **Entity**._

No additional metadata.

### Marker

_**Marker** inherits from **Entity**._

No additional metadata.

### Ominous Item Spawner

_**Ominous Item Spawner** inherits from **Entity**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Slot}}</td>
      <td colspan="2">Item</td>
      <td>Empty</td>
    </tr>
  </tbody>
</table>

### Painting

_**Painting** inherits from **Entity**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Painting Variant}}</td>
      <td colspan="2">Painting Type</td>
      <td>KEBAB</td>
    </tr>
  </tbody>
</table>

### Shulker Bullet

_**Shulker Bullet** inherits from **Entity**._

No additional metadata.

### Small Fireball

_**Small Fireball** inherits from **Entity**._

This is the fireball shot by blazes and dispensers with fire charges.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Slot}}</td>
      <td colspan="2">Item</td>
      <td>Empty (which behaves as if it were a `minecraft:fire_charge`)</td>
    </tr>
  </tbody>
</table>

### Primed TNT

_**Primed TNT** inherits from **Entity**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Fuse time</td>
      <td>80</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Block State}}</td>
      <td colspan="2">The block state ID that is exploding</td>
      <td>TNT</td>
    </tr>
  </tbody>
</table>

### Wind Charge

_**Wind Charge** inherits from **Entity**._

No additional metadata.

### Wither Skull

_**Wither Skull** inherits from **Entity**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Is invulnerable</td>
      <td>false</td>
    </tr>
  </tbody>
</table>

### Fishing Bobber

_**Fishing Bobber** inherits from **Entity**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Hooked entity id + 1, or 0 if there is no hooked entity</td>
      <td>0</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Is catchable</td>
      <td>False</td>
    </tr>
  </tbody>
</table>

### Abstract Arrow

_**Abstract Arrow** inherits from **Entity**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td rowspan="3">{{Metadata id|}}</td>
      <td rowspan="3">{{Metadata type|Byte}}</td>
      <th>Bit mask</th>
      <th>Meaning</th>
      <td rowspan="3">0</td>
    </tr>
    <tr>
      <td>0x01</td>
      <td>Is critical</td>
    </tr>
    <tr>
      <td>0x02</td>
      <td>Is noclip (used by loyalty tridents when returning)</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Byte}}</td>
      <td colspan="2">Piercing level</td>
      <td>0</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Is in ground</td>
      <td>false</td>
    </tr>
  </tbody>
</table>

### Arrow

_**Arrow** inherits from **Abstract Arrow**._

Used for both tipped and regular arrows.  If not tipped, then color is set to -1 and no tipped arrow particles are used.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Color (-1 for no particles)</td>
      <td>-1</td>
    </tr>
  </tbody>
</table>

### Spectral Arrow

_**Spectral Arrow** inherits from **Abstract Arrow**._

No additional metadata.

### Trident

_**Trident** inherits from **Abstract Arrow**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Byte}}</td>
      <td colspan="2">Loyalty level (enchantment)</td>
      <td>0</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Has enchantment glint</td>
      <td>False</td>
    </tr>
  </tbody>
</table>

### Display

_**Display** inherits from **Entity**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Interpolation delay</td>
      <td>0</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Transformation interpolation duration</td>
      <td>0</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Position/Rotation interpolation duration</td>
      <td>0</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Vector3}}</td>
      <td colspan="2">Translation</td>
      <td>(0.0, 0.0, 0.0)</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Vector3}}</td>
      <td colspan="2">Scale</td>
      <td>(1.0, 1.0, 1.0)</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Quaternion}}</td>
      <td colspan="2">Rotation left</td>
      <td>(0.0, 0.0, 0.0, 1.0)</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Quaternion}}</td>
      <td colspan="2">Rotation right</td>
      <td>(0.0, 0.0, 0.0, 1.0)</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Byte}}</td>
      <td colspan="2">Billboard Constraints (0 = FIXED, 1 = VERTICAL, 2 = HORIZONTAL, 3 = CENTER)</td>
      <td>0</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Brightness override (`blockLight << 4 | skyLight << 20`)</td>
      <td>-1</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Float}}</td>
      <td colspan="2">View range</td>
      <td>1.0</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Float}}</td>
      <td colspan="2">Shadow radius</td>
      <td>0.0</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Float}}</td>
      <td colspan="2">Shadow strength</td>
      <td>1.0</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Float}}</td>
      <td colspan="2">Width</td>
      <td>0.0</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Float}}</td>
      <td colspan="2">Height</td>
      <td>0.0</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Glow color override</td>
      <td>-1</td>
    </tr>
  </tbody>
</table>

### Block Display

_**Block Display** inherits from **Display**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Block State}}</td>
      <td colspan="2">Displayed block state</td>
      <td>0 (Air)</td>
    </tr>
  </tbody>
</table>

### Item Display

_**Item Display** inherits from **Display**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Slot}}</td>
      <td colspan="2">Displayed item</td>
      <td>Empty</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Byte}}</td>
      <td colspan="2">Display type:
* 0 = NONE
* 1 = THIRD_PERSON_LEFT_HAND
* 2 = THIRD_PERSON_RIGHT_HAND
* 3 = FIRST_PERSON_LEFT_HAND
* 4 = FIRST_PERSON_RIGHT_HAND
* 5 = HEAD
* 6 = GUI
* 7 = GROUND
* 8 = FIXED</td>
      <td>0 (NONE)</td>
    </tr>
  </tbody>
</table>

### Text Display

_**Text Display** inherits from **Display**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Text Component}}</td>
      <td colspan="2">Text</td>
      <td>Empty</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Line width</td>
      <td>200</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Background color</td>
      <td>1073741824 (0x40000000)</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Byte}}</td>
      <td colspan="2">Text opacity</td>
      <td>-1 (fully opaque)</td>
    </tr>
    <tr>
      <td rowspan="5">{{Metadata id|}}</td>
      <td rowspan="5">{{Metadata type|Byte}}</td>
      <th>Bit mask</th>
      <th>Meaning</th>
      <td rowspan="5">0</td>
    </tr>
    <tr>
      <td>0x01</td>
      <td>Has shadow</td>
    </tr>
    <tr>
      <td>0x02</td>
      <td>Is see through</td>
    </tr>
    <tr>
      <td>0x04</td>
      <td>Use default background color</td>
    </tr>
    <tr>
      <td>0x08</td>
      <td>Alignment:
* 0 = CENTER
* 1 or 3 = LEFT
* 2 = RIGHT</td>
    </tr>
  </tbody>
</table>

### Living Entity

_**Living Entity** inherits from **Entity**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td rowspan="5">{{Metadata id|}}</td>
      <td rowspan="5">{{Metadata type|Byte}}</td>
      <td colspan="2">Hand states, used to trigger blocking/eating/drinking animation.</td>
      <td rowspan="5">0</td>
    </tr>
    <tr>
      <th>Bit mask</th>
      <th>Meaning</th>
    </tr>
    <tr>
      <td>0x01</td>
      <td>Is hand active</td>
    </tr>
    <tr>
      <td>0x02</td>
      <td>Active hand (0 = main hand, 1 = offhand)</td>
    </tr>
    <tr>
      <td>0x04</td>
      <td>Is in riptide spin attack</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Float}}</td>
      <td colspan="2">Health</td>
      <td>1.0</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Particles}}</td>
      <td colspan="2">Potion effect color (or 0 if there is no effect)</td>
      <td>0</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Is potion effect ambient: reduces the number of particles generated by potions to 1/5 the normal amount</td>
      <td>false</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Number of arrows in entity</td>
      <td>0</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Number of bee stingers in entity</td>
      <td>0</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Optional Position}}</td>
      <td colspan="2">Location of the bed that the entity is currently sleeping in (Empty if it isn't sleeping)</td>
      <td>Empty</td>
    </tr>
  </tbody>
</table>

### Armor Stand

_**Armor Stand** inherits from **Living Entity**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td rowspan="6">{{Metadata id|}}</td>
      <td rowspan="6">{{Metadata type|Byte}}</td>
      <th>Bit mask</th>
      <th>Meaning</th>
      <td rowspan="6">0</td>
    </tr>
    <tr>
      <td>0x01</td>
      <td>Is Small</td>
    </tr>
    <tr>
      <td>0x02</td>
      <td>*Unused*</td>
    </tr>
    <tr>
      <td>0x04</td>
      <td>Has Arms</td>
    </tr>
    <tr>
      <td>0x08</td>
      <td>Has no BasePlate</td>
    </tr>
    <tr>
      <td>0x10</td>
      <td>Is Marker</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Rotations}}</td>
      <td colspan="2">Head rotation</td>
      <td>(0.0, 0.0, 0.0)</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Rotations}}</td>
      <td colspan="2">Body rotation</td>
      <td>(0.0, 0.0, 0.0)</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Rotations}}</td>
      <td colspan="2">Left arm rotation</td>
      <td>(-10.0, 0.0, -10.0)</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Rotations}}</td>
      <td colspan="2">Right arm rotation</td>
      <td>(-15.0, 0.0, 10.0)</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Rotations}}</td>
      <td colspan="2">Left leg rotation</td>
      <td>(-1.0, 0.0, -1.0)</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Rotations}}</td>
      <td colspan="2">Right leg rotation</td>
      <td>(1.0, 0.0, 1.0)</td>
    </tr>
  </tbody>
</table>

Note that armor stands with the [[#Entity|invisible flag from the base entity class]] set also cannot be attacked or damaged, except for by the void.

### Player

_**Player** inherits from **Living Entity**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Float}}</td>
      <td colspan="2">Additional Hearts</td>
      <td>0.0</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Score</td>
      <td>0</td>
    </tr>
    <tr>
      <td rowspan="10">{{Metadata id|}}</td>
      <td rowspan="10">{{Metadata type|Byte}}</td>
      <td colspan="2">The Displayed Skin Parts bit mask that is sent in [Client Settings](protocol.md#client-settings)</td>
      <td rowspan="10">0</td>
    </tr>
    <tr>
      <th>Bit mask</th>
      <th>Meaning</th>
    </tr>
    <tr>
      <td>0x01</td>
      <td>Cape enabled</td>
    </tr>
    <tr>
      <td>0x02</td>
      <td>Jacket enabled</td>
    </tr>
    <tr>
      <td>0x04</td>
      <td>Left sleeve enabled</td>
    </tr>
    <tr>
      <td>0x08</td>
      <td>Right sleeve enabled</td>
    </tr>
    <tr>
      <td>0x10</td>
      <td>Left pants leg enabled</td>
    </tr>
    <tr>
      <td>0x20</td>
      <td>Right pants leg enabled</td>
    </tr>
    <tr>
      <td>0x40</td>
      <td>Hat enabled</td>
    </tr>
    <tr>
      <td>0x80</td>
      <td>*Unused*</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Byte}}</td>
      <td colspan="2">Main hand (0 : Left, 1 : Right)</td>
      <td>1</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|NBT}}</td>
      <td colspan="2">Left shoulder entity data (for occupying parrot)</td>
      <td>Empty</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|NBT}}</td>
      <td colspan="2">Right shoulder entity data (for occupying parrot)</td>
      <td>Empty</td>
    </tr>
  </tbody>
</table>

### Mob

_**Mob** inherits from **Living Entity**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td rowspan="4">{{Metadata id|}}</td>
      <td rowspan="4">{{Metadata type|Byte}}</td>
      <th>Bit mask</th>
      <th>Meaning</th>
      <td rowspan="4">0</td>
    </tr>
    <tr>
      <td>0x01</td>
      <td>NoAI</td>
    </tr>
    <tr>
      <td>0x02</td>
      <td>Is left handed</td>
    </tr>
    <tr>
      <td>0x04</td>
      <td>Is aggressive</td>
    </tr>
  </tbody>
</table>

### Bat

_**Bat** inherits from **Mob**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td rowspan="2">{{Metadata id|}}</td>
      <td rowspan="2">{{Metadata type|Byte}}</td>
      <th>Bit mask</th>
      <th>Meaning</th>
      <td rowspan="2">0</td>
    </tr>
    <tr>
      <td>0x01</td>
      <td>Is hanging</td>
    </tr>
  </tbody>
</table>

### Ender Dragon

_**Ender Dragon** inherits from **Mob**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Dragon phase</td>
      <td>10 (hover)</td>
    </tr>
  </tbody>
</table>

Phases (according to [the wiki page on dragon data values](ender-dragon.md#datavalues)) are:

- 0: circling
- 1: strafing (preparing to shoot a fireball)
- 2: flying to the portal to land (part of transition to landed state)
- 3: landing on the portal (part of transition to landed state)
- 4: taking off from the portal (part of transition out of landed state)
- 5: landed, performing breath attack
- 6: landed, looking for a player for breath attack
- 7: landed, roar before beginning breath attack
- 8: charging player
- 9: flying to portal to die
- 10: hovering with no AI (default when using the /summon command).

### Ghast

_**Ghast** inherits from **Mob**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Is attacking</td>
      <td>false</td>
    </tr>
  </tbody>
</table>

### Phantom

_**Phantom** inherits from **Mob**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Size</td>
      <td>0</td>
    </tr>
  </tbody>
</table>

Hitbox size is determined by horizontal=0.9 + 0.2*size and vertical=0.5 + 0.1 * i

### Slime

_**Slime** inherits from **Mob**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Size</td>
      <td>1</td>
    </tr>
  </tbody>
</table>

### Magma Cube

_**Magma Cube** inherits from **Slime**._

No additional metadata.

### Creature

_**Creature** inherits from **Mob**._

No additional metadata.

### Allay

_**Allay** inherits from **Creature**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Is dancing</td>
      <td>false</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Can duplicate</td>
      <td>true</td>
    </tr>
  </tbody>
</table>

### Iron Golem

_**Iron Golem** inherits from **Creature**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td rowspan="2">{{Metadata id|}}</td>
      <td rowspan="2">{{Metadata type|Byte}}</td>
      <th>Bit mask</th>
      <th>Meaning</th>
      <td rowspan="2">0</td>
    </tr>
    <tr>
      <td>0x01</td>
      <td>Is player-created</td>
    </tr>
  </tbody>
</table>

### Pufferfish

_**Pufferfish** inherits from **Creature**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">PuffState (varies from 0 to 2)</td>
      <td>0</td>
    </tr>
  </tbody>
</table>

### Shulker

_**Shulker** inherits from **Creature**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Direction}}</td>
      <td colspan="2">Attach face</td>
      <td>Down (0)</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Byte}}</td>
      <td colspan="2">Shield height</td>
      <td>0</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Byte}}</td>
      <td colspan="2">Color (dye color)</td>
      <td>16</td>
    </tr>
  </tbody>
</table>

### Snow Golem

_**Snow Golem** inherits from **Creature**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td rowspan="6">{{Metadata id|}}</td>
      <td rowspan="6">{{Metadata type|Byte}}</td>
      <th>Bit mask</th>
      <th>Meaning</th>
      <td rowspan="6">0x10</td>
    </tr>
    <tr>
      <td>0x01</td>
      <td>*Unused*</td>
    </tr>
    <tr>
      <td>0x02</td>
      <td>*Unused*</td>
    </tr>
    <tr>
      <td>0x04</td>
      <td>*Unused*</td>
    </tr>
    <tr>
      <td>0x08</td>
      <td>*Unused*</td>
    </tr>
    <tr>
      <td>0x10</td>
      <td>Has pumpkin hat</td>
    </tr>
  </tbody>
</table>

### Tadpole

_**Tadpole** inherits from **Creature**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Is from bucket</td>
      <td>false</td>
    </tr>
  </tbody>
</table>

### Ageable Mob

_**Ageable Mob** inherits from **Creature**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Is baby</td>
      <td>false</td>
    </tr>
  </tbody>
</table>

### Dolphin

_**Dolphin** inherits from **Ageable Mob**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Has fish</td>
      <td>false</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Moisture level</td>
      <td>2400</td>
    </tr>
  </tbody>
</table>

### Squid

_**Squid** inherits from **Ageable Mob**._

No additional metadata.

### Glow Squid

_**Glow Squid** inherits from **Squid**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Dark ticks remaining</td>
      <td>0</td>
    </tr>
  </tbody>
</table>

### Animal

_**Animal** inherits from **Ageable Mob**._

No additional metadata.

### Armadillo

_**Armadillo** inherits from **Animal**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Armadillo State}}</td>
      <td colspan="2">Armadillo state</td>
      <td>IDLE</td>
    </tr>
  </tbody>
</table>

### Axolotl

_**Axolotl** inherits from **Animal**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Variant (0 = lucy, 1 = wild, 2 = gold, 3 = cyan, 4 = blue)</td>
      <td>0 (lucy)</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">If it is currently playing dead.</td>
      <td>false</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">If it was spawned from a bucket.</td>
      <td>false</td>
    </tr>
  </tbody>
</table>

### Bee

_**Bee** inherits from **Animal**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td rowspan="5">{{Metadata id|}}</td>
      <td rowspan="5">{{Metadata type|Byte}}</td>
      <th>Bit mask</th>
      <th>Meaning</th>
      <td rowspan="5">0</td>
    </tr>
    <tr>
      <td>0x01</td>
      <td>*Unused*</td>
    </tr>
    <tr>
      <td>0x02</td>
      <td>Is angry</td>
    </tr>
    <tr>
      <td>0x04</td>
      <td>Has stung</td>
    </tr>
    <tr>
      <td>0x08</td>
      <td>Has nectar</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Anger time in ticks</td>
      <td>0 (Not angry)</td>
    </tr>
  </tbody>
</table>

### Chicken

_**Chicken** inherits from **Animal**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Chicken Variant}}</td>
      <td colspan="2">Variant</td>
      <td>TEMPERATE</td>
    </tr>
  </tbody>
</table>

### Cow

_**Cow** inherits from **Animal**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Cow Variant}}</td>
      <td colspan="2">Variant</td>
      <td>TEMPERATE</td>
    </tr>
  </tbody>
</table>

### Fox

_**Fox** inherits from **Animal**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Type (0: red, 1: snow)</td>
      <td>0 (red)</td>
    </tr>
    <tr>
      <td rowspan="9">{{Metadata id|}}</td>
      <td rowspan="9">{{Metadata type|Byte}}</td>
      <th>Bit mask</th>
      <th>Meaning</th>
      <td rowspan="9">0</td>
    </tr>
    <tr>
      <td>0x01</td>
      <td>Is sitting</td>
    </tr>
    <tr>
      <td>0x02</td>
      <td>*Unused*</td>
    </tr>
    <tr>
      <td>0x04</td>
      <td>Is crouching</td>
    </tr>
    <tr>
      <td>0x08</td>
      <td>Is interested</td>
    </tr>
    <tr>
      <td>0x10</td>
      <td>Is pouncing</td>
    </tr>
    <tr>
      <td>0x20</td>
      <td>Is sleeping</td>
    </tr>
    <tr>
      <td>0x40</td>
      <td>Is faceplanted</td>
    </tr>
    <tr>
      <td>0x80</td>
      <td>Is defending</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Optional Living Entity Reference}}</td>
      <td colspan="2">First UUID (in `UUIDs` NBT)?</td>
      <td>Absent</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Optional Living Entity Reference}}</td>
      <td colspan="2">Second UUID (in `UUIDs` NBT)?</td>
      <td>Absent</td>
    </tr>
  </tbody>
</table>

### Frog

_**Frog** inherits from **Animal**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Frog Variant}}</td>
      <td colspan="2">Frog Variant</td>
      <td>TEMPERATE</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Optional VarInt}}</td>
      <td colspan="2">Tongue Target</td>
      <td>0</td>
    </tr>
  </tbody>
</table>

### Goat

_**Goat** inherits from **Animal**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Is Screaming Goat</td>
      <td>false</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Has Left Horn</td>
      <td>true</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Has Right Horn</td>
      <td>true</td>
    </tr>
  </tbody>
</table>

### Hoglin

_**Hoglin** inherits from **Animal**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Is immune to zombification</td>
      <td>false</td>
    </tr>
  </tbody>
</table>

### Mooshroom

_**Mooshroom** inherits from **Animal**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Variant ("red" or "brown")</td>
      <td>red</td>
    </tr>
  </tbody>
</table>

### Ocelot

_**Ocelot** inherits from **Animal**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Is trusting</td>
      <td>false</td>
    </tr>
  </tbody>
</table>

### Panda

_**Panda** inherits from **Animal**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Breed timer?  Set to 32 when something happens, and then counts down to 0 again.  At 29 and 14 (before counting down), will play the `entity.panda.cant_breed` sound event.</td>
      <td>0</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Sneeze timer.  Counts up from 0; when it hits 1 the `entity.panda.pre_sneeze` event plays and when it hits 21 the `entity.panda.sneeze` event plays (and it is set back to 0 and the sneeze flag is cleared).</td>
      <td>0</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Eat timer.  If nonzero, counts upwards.</td>
      <td>0</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Byte}}</td>
      <td colspan="2">Main Gene</td>
      <td>0</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Byte}}</td>
      <td colspan="2">Hidden Gene</td>
      <td>0</td>
    </tr>
    <tr>
      <td rowspan="6">{{Metadata id|}}</td>
      <td rowspan="6">{{Metadata type|Byte}}</td>
      <th>Bit mask</th>
      <th>Meaning</th>
      <td rowspan="6">0</td>
    </tr>
    <tr>
      <td>0x01</td>
      <td>*Unused*</td>
    </tr>
    <tr>
      <td>0x02</td>
      <td>Is sneezing</td>
    </tr>
    <tr>
      <td>0x04</td>
      <td>Is rolling</td>
    </tr>
    <tr>
      <td>0x08</td>
      <td>Is sitting</td>
    </tr>
    <tr>
      <td>0x10</td>
      <td>Is on back</td>
    </tr>
  </tbody>
</table>

### Pig

_**Pig** inherits from **Animal**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Total time to "boost" with a carrot on a stick for</td>
      <td>0</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Pig Variant}}</td>
      <td colspan="2">Variant</td>
      <td>TEMPERATE</td>
    </tr>
  </tbody>
</table>

Whenever a carrot on a stick is used, if the pig is not currently boosting it will start to boost for 140 to 980 (inclusive) ticks.  When boost time is changed, a counter is reset which counts up to the boost time, after which boosting will stop.  The value remains set at its modified value even after boosting is stopped.

### Polar Bear

_**Polar Bear** inherits from **Animal**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Is standing up</td>
      <td>false</td>
    </tr>
  </tbody>
</table>

### Rabbit

_**Rabbit** inherits from **Animal**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Type</td>
      <td>0</td>
    </tr>
  </tbody>
</table>

### Sheep

_**Sheep** inherits from **Animal**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td rowspan="3">{{Metadata id|}}</td>
      <td rowspan="3">{{Metadata type|Byte}}</td>
      <th>Bit mask</th>
      <th>Meaning</th>
      <td rowspan="3">0</td>
    </tr>
    <tr>
      <td>0x0F</td>
      <td>Color ID</td>
    </tr>
    <tr>
      <td>0x10</td>
      <td>Is sheared</td>
    </tr>
  </tbody>
</table>

### Sniffer

_**Sniffer** inherits from **Animal**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Sniffer State}}</td>
      <td colspan="2">Sniffer State</td>
      <td>IDLING</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Drop seed at tick</td>
      <td>0</td>
    </tr>
  </tbody>
</table>

### Strider

_**Strider** inherits from **Animal**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Total time to "boost" with warped fungus on a stick for</td>
      <td>0</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Is shaking (true unless riding a vehicle or on or in a block tagged with strider_warm_blocks (default: lava))</td>
      <td>false</td>
    </tr>
  </tbody>
</table>

### Turtle

_**Turtle** inherits from **Animal**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Has egg</td>
      <td>false</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Laying egg</td>
      <td>false</td>
    </tr>
  </tbody>
</table>

### Abstract Horse

_**Abstract Horse** inherits from **Animal**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td rowspan="8">{{Metadata id|}}</td>
      <td rowspan="8">{{Metadata type|Byte}}</td>
      <th>Bit mask</th>
      <th>Meaning</th>
      <td rowspan="8">0</td>
    </tr>
    <tr>
      <td>0x01</td>
      <td>*Unused*</td>
    </tr>
    <tr>
      <td>0x02</td>
      <td>Is tame</td>
    </tr>
    <tr>
      <td>0x04</td>
      <td>*Unused* (previously is saddled)</td>
    </tr>
    <tr>
      <td>0x08</td>
      <td>Has bred</td>
    </tr>
    <tr>
      <td>0x10</td>
      <td>Is eating</td>
    </tr>
    <tr>
      <td>0x20</td>
      <td>Is rearing (on hind legs)</td>
    </tr>
    <tr>
      <td>0x40</td>
      <td>Is mouth open</td>
    </tr>
  </tbody>
</table>

### Camel

_**Camel** inherits from **Abstract Horse**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Is dashing</td>
      <td>False</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarLong}}</td>
      <td colspan="2">Last pose change tick</td>
      <td>0</td>
    </tr>
  </tbody>
</table>

### Horse

_**Horse** inherits from **Abstract Horse**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Variant (Color & Style)</td>
      <td>0</td>
    </tr>
  </tbody>
</table>

### Skeleton Horse

_**Skeleton Horse** inherits from **Abstract Horse**._

No additional metadata.

### Zombie Horse

_**Zombie Horse** inherits from **Abstract Horse**._

No additional metadata.

### Chested Horse

_**Chested Horse** inherits from **Abstract Horse**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Has Chest</td>
      <td>false</td>
    </tr>
  </tbody>
</table>

### Donkey

_**Donkey** inherits from **Chested Horse**._

No additional metadata.

### Llama

_**Llama** inherits from **Chested Horse**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Strength (number of columns of 3 slots in the llama's inventory once a chest is equipped)</td>
      <td>0</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Variant (0: `llama_creamy.png`, 1: `llama_white.png`, 2: `llama_brown.png`, 3: `llama_gray.png`)</td>
      <td>0</td>
    </tr>
  </tbody>
</table>

### Trader Llama

_**Trader Llama** inherits from **Llama**._

No additional metadata.

### Mule

_**Mule** inherits from **Chested Horse**._

No additional metadata.

### Tameable Animal

_**Tameable Animal** inherits from **Animal**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td rowspan="4">{{Metadata id|}}</td>
      <td rowspan="4">{{Metadata type|Byte}}</td>
      <th>Bit mask</th>
      <th>Meaning</th>
      <td rowspan="4">0</td>
    </tr>
    <tr>
      <td>0x01</td>
      <td>Is sitting</td>
    </tr>
    <tr>
      <td>0x02</td>
      <td>*Unused*</td>
    </tr>
    <tr>
      <td>0x04</td>
      <td>Is tamed</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Optional Living Entity Reference}}</td>
      <td colspan="2">Owner</td>
      <td>Absent</td>
    </tr>
  </tbody>
</table>

### Cat

_**Cat** inherits from **Tameable Animal**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Cat Variant}}</td>
      <td colspan="2">Cat Variant</td>
      <td>BLACK</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Is lying</td>
      <td>false</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Is relaxed? (This makes their head go slightly upwards, unknown when used)</td>
      <td>false</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Collar color (values are those [used with dyes](data_values.md#dyes))</td>
      <td>14 (Red)</td>
    </tr>
  </tbody>
</table>

### Parrot

_**Parrot** inherits from **Tameable Animal**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Variant (0: red/blue, 1: blue, 2: green, 3: yellow/blue, 4: grey)</td>
      <td>0</td>
    </tr>
  </tbody>
</table>

### Wolf

_**Wolf** inherits from **Tameable Animal**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Is begging</td>
      <td>false</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Collar color (values are those [used with dyes](data_values.md#dyes))</td>
      <td>14 (Red)</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Anger time</td>
      <td>0</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Wolf Variant}}</td>
      <td colspan="2">Variant</td>
      <td>PALE</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Wolf Sound Variant}}</td>
      <td colspan="2">Sound variant</td>
      <td>CLASSIC</td>
    </tr>
  </tbody>
</table>

### Abstract Villager

_**Abstract Villager** inherits from **Ageable Mob**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Head shake timer (starts at 40, decrements each tick)</td>
      <td>0</td>
    </tr>
  </tbody>
</table>

### Villager

_**Villager** inherits from **Abstract Villager**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Villager Data}}</td>
      <td colspan="2">Villager Data</td>
      <td>Plains/None/1</td>
    </tr>
  </tbody>
</table>

### Wandering Trader

_**Wandering Trader** inherits from **Abstract Villager**._

No additional metadata.

### Abstract Fish

_**Abstract Fish** inherits from **Creature**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">From bucket</td>
      <td>False</td>
    </tr>
  </tbody>
</table>

### Cod

_**Cod** inherits from **Abstract Fish**._

No additional metadata.

### Salmon

_**Salmon** inherits from **Abstract Fish**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Type (0 = SMALL, 1 = MEDIUM, 2 = LARGE)</td>
      <td>1</td>
    </tr>
  </tbody>
</table>

### Tropical Fish

_**Tropical Fish** inherits from **Abstract Fish**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Variant</td>
      <td>0</td>
    </tr>
  </tbody>
</table>

### Monster

_**Monster** inherits from **Creature**._

No additional metadata.

### Blaze

_**Blaze** inherits from **Monster**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td rowspan="2">{{Metadata id|}}</td>
      <td rowspan="2">{{Metadata type|Byte}}</td>
      <th>Bit mask</th>
      <th>Meaning</th>
      <td rowspan="2">0</td>
    </tr>
    <tr>
      <td>0x01</td>
      <td>Is on fire</td>
    </tr>
  </tbody>
</table>

### Bogged

_**Bogged** inherits from **Monster**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Is sheared</td>
      <td>false</td>
    </tr>
  </tbody>
</table>

### Breeze

_**Breeze** inherits from **Monster**._

No additional metadata.

### Creaking

_**Creaking** inherits from **Monster**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Can move</td>
      <td>true</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Is active</td>
      <td>false</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Is tearing down</td>
      <td>false</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Optional Position}}</td>
      <td colspan="2">Home position</td>
      <td>Empty</td>
    </tr>
  </tbody>
</table>

### Creeper

_**Creeper** inherits from **Monster**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">State (-1 = idle, 1 = fuse)</td>
      <td>-1</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Is [charged](creeper.md#charged-creeper)</td>
      <td>false</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Is ignited</td>
      <td>false</td>
    </tr>
  </tbody>
</table>

### Enderman

_**Enderman** inherits from **Monster**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Optional Block State}}</td>
      <td colspan="2">Carried block</td>
      <td>Absent</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Is screaming</td>
      <td>false</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Is staring</td>
      <td>false</td>
    </tr>
  </tbody>
</table>

### Endermite

_**Endermite** inherits from **Monster**._

No additional metadata.

### Giant

_**Giant** inherits from **Monster**._

No additional metadata.

### Guardian

_**Guardian** inherits from **Monster**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Is retracting spikes</td>
      <td>false</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Target EID</td>
      <td>0</td>
    </tr>
  </tbody>
</table>

### Elder Guardian

_**Elder Guardian** inherits from **Guardian**._

No additional metadata.

### Silverfish

_**Silverfish** inherits from **Monster**._

No additional metadata.

### Skeleton

_**Skeleton** inherits from **Monster**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Is being converted into a Stray</td>
      <td>false</td>
    </tr>
  </tbody>
</table>

### Spider

_**Spider** inherits from **Monster**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td rowspan="2">{{Metadata id|}}</td>
      <td rowspan="2">{{Metadata type|Byte}}</td>
      <th>Bit mask</th>
      <th>Meaning</th>
      <td rowspan="2">0</td>
    </tr>
    <tr>
      <td>0x01</td>
      <td>Is climbing</td>
    </tr>
  </tbody>
</table>

### Cave Spider

_**Cave Spider** inherits from **Spider**._

No additional metadata.

### Stray

_**Stray** inherits from **Monster**._

No additional metadata.

### Vex

_**Vex** inherits from **Monster**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td rowspan="2">{{Metadata id|}}</td>
      <td rowspan="2">{{Metadata type|Byte}}</td>
      <th>Bit mask</th>
      <th>Meaning</th>
      <td rowspan="2">0</td>
    </tr>
    <tr>
      <td>0x01</td>
      <td>Is attacking</td>
    </tr>
  </tbody>
</table>

### Warden

_**Warden** inherits from **Monster**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Anger Level</td>
      <td>0</td>
    </tr>
  </tbody>
</table>

### Wither

_**Wither** inherits from **Monster**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Center head's target (entity ID, or 0 if no target)</td>
      <td>0</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Left head's target (entity ID, or 0 if no target)</td>
      <td>0</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Right head's target (entity ID, or 0 if no target)</td>
      <td>0</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Invulnerable time</td>
      <td>0</td>
    </tr>
  </tbody>
</table>

### Wither Skeleton

_**Wither Skeleton** inherits from **Monster**._

No additional metadata.

### Zoglin

_**Zoglin** inherits from **Monster**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Is baby</td>
      <td>false</td>
    </tr>
  </tbody>
</table>

### Zombie

_**Zombie** inherits from **Monster**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Is baby</td>
      <td>false</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">*Unused* (previously type)</td>
      <td>0</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Is becoming a drowned</td>
      <td>false</td>
    </tr>
  </tbody>
</table>

### Drowned

_**Drowned** inherits from **Zombie**._

No additional metadata.

### Husk

_**Husk** inherits from **Zombie**._

No additional metadata.

### Zombie Villager

_**Zombie Villager** inherits from **Zombie**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Is converting</td>
      <td>false</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Villager Data}}</td>
      <td colspan="2">Villager Data</td>
      <td>Plains/None/1</td>
    </tr>
  </tbody>
</table>

### Zombified Piglin

_**Zombified Piglin** inherits from **Zombie**._

No additional metadata.

### Base Piglin

_**Base Piglin** inherits from **Monster**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Is immune to zombification</td>
      <td>false</td>
    </tr>
  </tbody>
</table>

### Piglin

_**Piglin** inherits from **Base Piglin**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Is baby</td>
      <td>false</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Is charging crossbow</td>
      <td>false</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Is dancing</td>
      <td>false</td>
    </tr>
  </tbody>
</table>

### Piglin Brute

_**Piglin Brute** inherits from **Base Piglin**._

No additional metadata.

### Raider

_**Raider** inherits from **Monster**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Is celebrating</td>
      <td>false</td>
    </tr>
  </tbody>
</table>

"Is celebrating" appears to control the pose for vindicators and does not appear to be used by other types.

### Pillager

_**Pillager** inherits from **Raider**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Is charging</td>
      <td>false</td>
    </tr>
  </tbody>
</table>

### Ravager

_**Ravager** inherits from **Raider**._

No additional metadata.

### Vindicator

_**Vindicator** inherits from **Raider**._

No additional metadata.

### Witch

_**Witch** inherits from **Raider**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Is drinking potion</td>
      <td>false</td>
    </tr>
  </tbody>
</table>

### Spellcaster Illager

_**Spellcaster Illager** inherits from **Raider**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Byte}}</td>
      <td colspan="2">Spell (0: none, 1: summon vex, 2: attack, 3: wololo, 4: disappear, 5: blindness)</td>
      <td>0</td>
    </tr>
  </tbody>
</table>

### Evoker

_**Evoker** inherits from **Spellcaster Illager**._

No additional metadata.

### Illusioner

_**Illusioner** inherits from **Spellcaster Illager**._

No additional metadata.

### Thrown Item Projectile

_**Thrown Item Projectile** inherits from **Entity**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Slot}}</td>
      <td colspan="2">Item</td>
      <td>Empty (which behaves as the default)</td>
    </tr>
  </tbody>
</table>

### Thrown Egg

_**Thrown Egg** inherits from **Thrown Item Projectile**._

Default item is `minecraft:egg`.

No additional metadata.

### Thrown Ender Pearl

_**Thrown Ender Pearl** inherits from **Thrown Item Projectile**._

Default item is `minecraft:ender_pearl`.

No additional metadata.

### Thrown Bottle o' Enchanting

_**Thrown Bottle o' Enchanting** inherits from **Thrown Item Projectile**._

Default item is `minecraft:experience_bottle`.

No additional metadata.

### Splash Potion

_**Splash Potion** inherits from **Thrown Item Projectile**._

No additional metadata.

### Lingering Potion

_**Lingering Potion** inherits from **Thrown Item Projectile**._

No additional metadata.

### Snowball

_**Snowball** inherits from **Thrown Item Projectile**._

Default item is `minecraft:snowball`.

No additional metadata.

### Abstract Vehicle

_**Abstract Vehicle** inherits from **Entity**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Shaking power</td>
      <td>0</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Shaking direction</td>
      <td>1</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Float}}</td>
      <td colspan="2">Shaking multiplier</td>
      <td>0.0</td>
    </tr>
  </tbody>
</table>

### Boat

_**Boat** inherits from **Abstract Vehicle**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Is left paddle turning</td>
      <td>false</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Is right paddle turning</td>
      <td>false</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Splash timer</td>
      <td>0</td>
    </tr>
  </tbody>
</table>

### Acacia Boat

_**Acacia Boat** inherits from **Boat**._

No additional metadata.

### Acacia Boat with Chest

_**Acacia Boat with Chest** inherits from **Boat**._

No additional metadata.

### Bamboo Raft with Chest

_**Bamboo Raft with Chest** inherits from **Boat**._

No additional metadata.

### Bamboo Raft

_**Bamboo Raft** inherits from **Boat**._

No additional metadata.

### Birch Boat

_**Birch Boat** inherits from **Boat**._

No additional metadata.

### Birch Boat with Chest

_**Birch Boat with Chest** inherits from **Boat**._

No additional metadata.

### Cherry Boat

_**Cherry Boat** inherits from **Boat**._

No additional metadata.

### Cherry Boat with Chest

_**Cherry Boat with Chest** inherits from **Boat**._

No additional metadata.

### Dark Oak Boat

_**Dark Oak Boat** inherits from **Boat**._

No additional metadata.

### Dark Oak Boat with Chest

_**Dark Oak Boat with Chest** inherits from **Boat**._

No additional metadata.

### Jungle Boat

_**Jungle Boat** inherits from **Boat**._

No additional metadata.

### Jungle Boat with Chest

_**Jungle Boat with Chest** inherits from **Boat**._

No additional metadata.

### Mangrove Boat

_**Mangrove Boat** inherits from **Boat**._

No additional metadata.

### Mangrove Boat with Chest

_**Mangrove Boat with Chest** inherits from **Boat**._

No additional metadata.

### Oak Boat

_**Oak Boat** inherits from **Boat**._

No additional metadata.

### Oak Boat with Chest

_**Oak Boat with Chest** inherits from **Boat**._

No additional metadata.

### Pale Oak Boat

_**Pale Oak Boat** inherits from **Boat**._

No additional metadata.

### Pale Oak Boat with Chest

_**Pale Oak Boat with Chest** inherits from **Boat**._

No additional metadata.

### Spruce Boat

_**Spruce Boat** inherits from **Boat**._

No additional metadata.

### Spruce Boat with Chest

_**Spruce Boat with Chest** inherits from **Boat**._

No additional metadata.

### Abstract Minecart

_**Abstract Minecart** inherits from **Abstract Vehicle**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Optional Block State}}</td>
      <td colspan="2">Custom block state</td>
      <td>0</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|VarInt}}</td>
      <td colspan="2">Custom block Y position (in 16ths of a block)</td>
      <td>6</td>
    </tr>
  </tbody>
</table>

If custom block state is unset, then each type of Minecart will render its own type of block with its own properties. Note that one does *not* need to send these values for the metadata fields, as the client will automatically select them if they are not overridden by the metadata field. They are only provided for reference to help with swapping out other blocks.

- Rideable Minecarts contain air (`minecraft:air`) and have a y position of 6
- Chest Minecarts contain chests facing north (`minecraft:chest[facing=north]`) and have a y position of 8
- Furnace Minecarts contain a normal furnace facing north when unpowered (`minecraft:furnace[facing=north]`) and a lit furnace facing north when powered (`minecraft:furnace[facing=north, lit=true]`) and have a y position of 6 in both cases
- Hopper Minecarts contain a hopper (`minecraft:hopper`) and have a y position of 1
- TNT Minecarts contain TNT (`minecraft:tnt`) and have a y position of 6
- Command block minecarts contain a Command Block (`minecraft:command_block`) and have a y position of 6
- Spawner Minecarts contain a spawner (`minecraft:spawner`) and have a y position of 6

### Minecart with Chest

_**Minecart with Chest** inherits from **Abstract Minecart**._

No additional metadata.

### Minecart with Command Block

_**Minecart with Command Block** inherits from **Abstract Minecart**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|String}}</td>
      <td colspan="2">Command</td>
      <td>``</td>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Text Component}}</td>
      <td colspan="2">Last output</td>
      <td>`{"text":""}`</td>
    </tr>
  </tbody>
</table>

### Minecart with Furnace

_**Minecart with Furnace** inherits from **Abstract Minecart**._

<table class="wikitable">
  <tbody>
    <tr>
      <th>Index</th>
      <th>Type</th>
      <th colspan="2">Meaning</th>
      <th>Default</th>
    </tr>
    <tr>
      <td>{{Metadata id|}}</td>
      <td>{{Metadata type|Boolean}}</td>
      <td colspan="2">Has fuel</td>
      <td>false</td>
    </tr>
  </tbody>
</table>

### Minecart with Hopper

_**Minecart with Hopper** inherits from **Abstract Minecart**._

No additional metadata.

### Minecart

_**Minecart** inherits from **Abstract Minecart**._

No additional metadata.

### Minecart with Monster Spawner

_**Minecart with Monster Spawner** inherits from **Abstract Minecart**._

No additional metadata.

### Minecart with TNT

_**Minecart with TNT** inherits from **Abstract Minecart**._

No additional metadata.

[Category:Protocol Details](category-protocol-details.md)
[Category:Java Edition protocol](category-java-edition-protocol.md)
_Content is licensed under wiki.vg terms._
