This article documents the current list of particle types (contents of the `minecraft:particle_type` registry, accurate as of 1.21.5), and the formats of their associated data.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Particle Name</th>
      <th>Particle ID</th>
      <th>Data</th>
    </tr>
    <tr>
      <td>`minecraft:angry_villager`</td>
      <td>0</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:block`</td>
      <td>1</td>
      <td>
<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Meaning</th>
    </tr>
    <tr>
      <td>BlockState</td>
      <td>`VarInt`</td>
      <td>The ID of the block state.</td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>`minecraft:block_marker`</td>
      <td>2</td>
      <td>
<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Meaning</th>
    </tr>
    <tr>
      <td>BlockState</td>
      <td>`VarInt`</td>
      <td>The ID of the block state.</td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>`minecraft:bubble`</td>
      <td>3</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:cloud`</td>
      <td>4</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:crit`</td>
      <td>5</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:damage_indicator`</td>
      <td>6</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:dragon_breath`</td>
      <td>7</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:dripping_lava`</td>
      <td>8</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:falling_lava`</td>
      <td>9</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:landing_lava`</td>
      <td>10</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:dripping_water`</td>
      <td>11</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:falling_water`</td>
      <td>12</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:dust`</td>
      <td>13</td>
      <td>
<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Meaning</th>
    </tr>
    <tr>
      <td>Color</td>
      <td>`Int`</td>
      <td>The color, encoded as 0xRRGGBB; top bits are ignored.</td>
    </tr>
    <tr>
      <td>Scale</td>
      <td>`Float`</td>
      <td>The scale, will be clamped between 0.01 and 4.</td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>`minecraft:dust_color_transition`</td>
      <td>14</td>
      <td>
<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Meaning</th>
    </tr>
    <tr>
      <td>From Color</td>
      <td>`Int`</td>
      <td>The start color, encoded as 0xRRGGBB; top bits are ignored.</td>
    </tr>
    <tr>
      <td>To Color</td>
      <td>`Int`</td>
      <td>The start color, encoded as 0xRRGGBB; top bits are ignored.</td>
    </tr>
    <tr>
      <td>Scale</td>
      <td>`Float`</td>
      <td>The scale, will be clamped between 0.01 and 4.</td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>`minecraft:effect`</td>
      <td>15</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:elder_guardian`</td>
      <td>16</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:enchanted_hit`</td>
      <td>17</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:enchant`</td>
      <td>18</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:end_rod`</td>
      <td>19</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:entity_effect`</td>
      <td>20</td>
      <td>
<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Meaning</th>
    </tr>
    <tr>
      <td>Color</td>
      <td>`Int`</td>
      <td>The ARGB components of the color encoded as an Int</td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>`minecraft:explosion_emitter`</td>
      <td>21</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:explosion`</td>
      <td>22</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:gust`</td>
      <td>23</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:small_gust`</td>
      <td>24</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:gust_emitter_large`</td>
      <td>25</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:gust_emitter_small`</td>
      <td>26</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:sonic_boom`</td>
      <td>27</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:falling_dust`</td>
      <td>28</td>
      <td>
<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Meaning</th>
    </tr>
    <tr>
      <td>BlockState</td>
      <td>`VarInt`</td>
      <td>The ID of the block state.</td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>`minecraft:firework`</td>
      <td>29</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:fishing`</td>
      <td>30</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:flame`</td>
      <td>31</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:infested`</td>
      <td>32</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:cherry_leaves`</td>
      <td>33</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:pale_oak_leaves`</td>
      <td>34</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:tinted_leaves`</td>
      <td>35</td>
      <td>
<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Meaning</th>
    </tr>
    <tr>
      <td>Color</td>
      <td>`Int`</td>
      <td>The ARGB components of the color encoded as an Int</td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>`minecraft:sculk_soul`</td>
      <td>36</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:sculk_charge`</td>
      <td>37</td>
      <td>
<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Meaning</th>
    </tr>
    <tr>
      <td>Roll</td>
      <td>`Float`</td>
      <td>How much the particle will be rotated when displayed.</td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>`minecraft:sculk_charge_pop`</td>
      <td>38</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:soul_fire_flame`</td>
      <td>39</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:soul`</td>
      <td>40</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:flash`</td>
      <td>41</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:happy_villager`</td>
      <td>42</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:composter`</td>
      <td>43</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:heart`</td>
      <td>44</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:instant_effect`</td>
      <td>45</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:item`</td>
      <td>46</td>
      <td>
<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Meaning</th>
    </tr>
    <tr>
      <td>Item</td>
      <td>`Slot`</td>
      <td>The item that will be used.</td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>`minecraft:vibration`</td>
      <td>47</td>
      <td>
<table class="wikitable">
  <tbody>
    <tr>
      <th colspan="2">Field Name</th>
      <th>Field Type</th>
      <th>Meaning</th>
    </tr>
    <tr>
      <td colspan="2">Position Source Type</td>
      <td>`VarInt`</td>
      <td>The type of the vibration source defined by the `minecraft:position_source_type` builtin registry.</td>
    </tr>
    <tr>
      <th>Type-Specific Data</th>
      <th>Field Name</th>
      <th></th>
      <th></th>
    </tr>
    <tr>
      <td>0: `minecraft:block`</td>
      <td>Block Position</td>
      <td>`Position`</td>
      <td>The position of the block the vibration originated from.</td>
    </tr>
    <tr>
      <td rowspan="2">1: `minecraft:entity`</td>
      <td>Entity ID</td>
      <td>`VarInt`</td>
      <td>The ID of the entity the vibration originated from.</td>
    </tr>
    <tr>
      <td>Entity eye height</td>
      <td>`Float`</td>
      <td>The height of the entity's eye relative to the entity.</td>
    </tr>
    <tr>
      <th colspan="2">Field Name</th>
      <th></th>
      <th></th>
    </tr>
    <tr>
      <td colspan="2">Ticks</td>
      <td>`VarInt`</td>
      <td>The amount of ticks it takes for the vibration to travel from its source to its destination.</td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>`minecraft:trail`</td>
      <td>48</td>
      <td>
<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Meaning</th>
    </tr>
    <tr>
      <td>X</td>
      <td>`Double`</td>
      <td>Target X</td>
    </tr>
    <tr>
      <td>Y</td>
      <td>`Double`</td>
      <td>Target Y</td>
    </tr>
    <tr>
      <td>Z</td>
      <td>`Double`</td>
      <td>Target Z</td>
    </tr>
    <tr>
      <td>Color</td>
      <td>`Int`</td>
      <td>The trail color, encoded as 0xRRGGBB; top bits are ignored.</td>
    </tr>
    <tr>
      <td>Duration</td>
      <td>`VarInt`</td>
      <td>Life time in ticks</td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>`minecraft:item_slime`</td>
      <td>49</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:item_cobweb`</td>
      <td>50</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:item_snowball`</td>
      <td>51</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:large_smoke`</td>
      <td>52</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:lava`</td>
      <td>53</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:mycelium`</td>
      <td>54</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:note`</td>
      <td>55</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:poof`</td>
      <td>56</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:portal`</td>
      <td>57</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:rain`</td>
      <td>58</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:smoke`</td>
      <td>59</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:white_smoke`</td>
      <td>60</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:sneeze`</td>
      <td>61</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:spit`</td>
      <td>62</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:squid_ink`</td>
      <td>63</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:sweep_attack`</td>
      <td>64</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:totem_of_undying`</td>
      <td>65</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:underwater`</td>
      <td>66</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:splash`</td>
      <td>67</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:witch`</td>
      <td>68</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:bubble_pop`</td>
      <td>69</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:current_down`</td>
      <td>70</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:bubble_column_up`</td>
      <td>71</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:nautilus`</td>
      <td>72</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:dolphin`</td>
      <td>73</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:campfire_cosy_smoke`</td>
      <td>74</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:campfire_signal_smoke`</td>
      <td>75</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:dripping_honey`</td>
      <td>76</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:falling_honey`</td>
      <td>77</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:landing_honey`</td>
      <td>78</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:falling_nectar`</td>
      <td>79</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:falling_spore_blossom`</td>
      <td>80</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:ash`</td>
      <td>81</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:crimson_spore`</td>
      <td>82</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:warped_spore`</td>
      <td>83</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:spore_blossom_air`</td>
      <td>84</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:dripping_obsidian_tear`</td>
      <td>85</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:falling_obsidian_tear`</td>
      <td>86</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:landing_obsidian_tear`</td>
      <td>87</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:reverse_portal`</td>
      <td>88</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:white_ash`</td>
      <td>89</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:small_flame`</td>
      <td>90</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:snowflake`</td>
      <td>91</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:dripping_dripstone_lava`</td>
      <td>92</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:falling_dripstone_lava`</td>
      <td>93</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:dripping_dripstone_water`</td>
      <td>94</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:falling_dripstone_water`</td>
      <td>95</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:glow_squid_ink`</td>
      <td>96</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:glow`</td>
      <td>97</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:wax_on`</td>
      <td>98</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:wax_off`</td>
      <td>99</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:electric_spark`</td>
      <td>100</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:scrape`</td>
      <td>101</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:shriek`</td>
      <td>102</td>
      <td>
<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Meaning</th>
    </tr>
    <tr>
      <td>Delay</td>
      <td>`VarInt`</td>
      <td>The time in ticks before the particle is displayed</td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>`minecraft:egg_crack`</td>
      <td>103</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:dust_plume`</td>
      <td>104</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:trial_spawner_detection`</td>
      <td>105</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:trial_spawner_detection_ominous`</td>
      <td>106</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:vault_connection`</td>
      <td>107</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:dust_pillar`</td>
      <td>108</td>
      <td>
<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Meaning</th>
    </tr>
    <tr>
      <td>BlockState</td>
      <td>`VarInt`</td>
      <td>The ID of the block state.</td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>`minecraft:ominous_spawning`</td>
      <td>109</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:raid_omen`</td>
      <td>110</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:trial_omen`</td>
      <td>111</td>
      <td>None</td>
    </tr>
    <tr>
      <td>`minecraft:block_crumble`</td>
      <td>112</td>
      <td>
<table class="wikitable">
  <tbody>
    <tr>
      <th>Field Name</th>
      <th>Field Type</th>
      <th>Meaning</th>
    </tr>
    <tr>
      <td>BlockState</td>
      <td>`VarInt`</td>
      <td>The ID of the block state.</td>
    </tr>
  </tbody>
</table></td>
    </tr>
    <tr>
      <td>`minecraft:firefly`</td>
      <td>113</td>
      <td>None</td>
    </tr>
  </tbody>
</table>

[Category:Protocol Details](category-protocol-details.md)
[Category:Java Edition protocol](category-java-edition-protocol.md)
_Content is licensed under wiki.vg terms._
