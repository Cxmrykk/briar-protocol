{{For|the Legacy Console Edition Leaderboard|Leaderboards}}
{{For|the command|Commands/scoreboard}}
{{Redirect|scores|the other mechanic named "score"|Experience#Score}}
![350px|A screenshot of a scoreboard on the right side of the screen.](Scoreboard.png)

The **scoreboard** system is a complex gameplay mechanic utilized through [commands](commands.md). Mainly intended for mapmakers and [server](server.md) operators, scoreboards are used to track, set, and list the scores of [entities](entities.md) in a myriad of different ways.

## Objectives

An **objective** tracks a score for entities while meeting a single criterion. These scores are stored as 32-bit integer ranging from -2<sup>31</sup> to 2<sup>31</sup>-1.{{fn|Actual values are -2,147,483,648 and 2,147,483,647.}}

Objectives have two main properties: a **name** and a **criterion**. The objectives' name is used internally for referencing in commands, target arguments, and the [[#NBT format|file format]], while the criterion determines the objectives' behavior &ndash; primarily what to track.

{{IN|java}}, the objectives' name must be a single, case-sensitive string consisting of {{w|alphanumeric}} characters (A&ndash;Z and 0&ndash;9), hyphen {{cd|-}}, plus {{cd|+}}, dot {{cd|.}}, and underscore {{cd|_}}. {{IN|bedrock}}, it must either be a single string that has no space or a quoted string. When a string is quoted, backslash {{cd|\}} can be used to escape characters.

The entity's **score** in any objective can be changed from [[#Command reference|commands]], unless it's read-only and automatically set by the game (see {{slink||Criteria}}). It can be increased by, decreased by, or set to a given amount with commands. Non-player entities only support dummy criterion in the scoreboard; their scores can only be changed by commands and not automatically by the game. Unlike players, when a non-player entity dies, its scores are deleted. Notable commands that can modify any entities' scores are {{cmd|scoreboard}} and {{cmd|execute store}} (the latter is exclusive to *Java Edition* only).

The score holder's name can either be the player's [username](username.md) or the entity's [UUID](uuid.md). For players, the score holder's name doesn't need to belong to an actual [player](player.md), and can be specified by any arbitrary username.

Objectives also have other properties to change its appearance and behavior:
{{#VARDEFINE:boolean_true|**Boolean**: `true` (default) or `false`}}
<table class="wikitable">
  <tbody>
    <tr>
      <th>Property</th>
      <th>Description</th>
      <th>Value</th>
    </tr>
    <tr>
      <td>displayname</td>
      <td>The objective's display name that appears on [[#Display slots|display slot]]s, such as the player list, below the player's name tag, and the sidebar. By default, the objective's name is the display name.</td>
      <td>**[Text component](text-component.md)**</td>
    </tr>
    <tr>
      <td>numberformat</td>
      <td>The objective's number format for the score. The value can be `blank`, `fixed`, or `styled`.</td>
      <td>
* `blank` displays nothing on the scoreboard. 
* `fixed` displays the contents specified in the command.
* `styled` displays the score number with the styling applied from the [text component format](text-component-format.md), such as {{nbt|string|color}}, {{nbt|boolean|italic}}, {{nbt|boolean|bold}}, etc. This means that the {{nbt|string|text}} property is ignored.</td>
    </tr>
    <tr>
      <td>rendertype</td>
      <td>How the score is rendered in the player list (all other display locations are unaffected). The value can be `integer` (the default) or `hearts`.</td>
      <td>
* `integer` the score is rendered as an integer.
* `hearts` the score is rendered in the form of hearts (half a heart for each point).
** Values below 1 are not rendered.
** Values above 43 are instead rendered as `<full-hearts>hp`, where `<full-hearts>` is the floating-point representation of `value / 2`.</td>
    </tr>
    <tr>
      <td>displayautoupdate</td>
      <td>Whether or not to display auto updates when the score has changed.</td>
      <td>{{#VAR:boolean_true}}</td>
    </tr>
  </tbody>
</table>

The number format property and the score holder's name can be changed per-entity using {{cmd|scoreboard players display numberformat|name &lt;target> ...}}.

Server [operator](operator.md)s can select entities by their scores using [target selector](target-selector.md) with the "scores" argument (syntax: `@e[scores={&lt;name>=&lt;min>..&lt;max>}]`). This argument uses the `&lt;name>` argument to specify the score name of the objective. For example, inputting {{cmd|1=execute if entity @a[scores={deaths=1..}]}} into a [command block](command-block.md) triggers a [comparator](comparator.md) or [conditional command block](command-block.md#modification) if any player has died at least once ever since the objective was created, assuming the `deaths` objective has the `deathCount` criterion.

{{fnlist}}

## Criteria

A **criterion** determines an objective's behavior and tracks statistical game elements. When a criterion's source value changes, the change is automatically reflected in the objective's score.

{{IN|je}}, criteria are categorized by single and compound criteria. Each of the criteria tracks specific game elements, such as players' [health](health.md), [hunger](hunger.md), [experience](experience.md), [trigger](trigger.md)s, [statistic](statistic.md)s, and among other things. {{IN|be}}, the "dummy" criterion is the only criteria supported. As such, scores can only be changed by commands.

### Single criteria
{{exclusive|java|section=1|customtext=This feature is primarily exclusive to *[Java Edition](java-edition.md)*.}}

Single criteria names consist of an alphabetical string.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Criteria name</th>
      <th>Description</th>
      <th>Can be modified</th>
    </tr>
    <tr>
      <td>dummy</td>
      <td>A score that can be changed only by commands and not automatically by the game. This can be used for storing integer states and variables, which can then be used with the scoreboard's operations to perform arithmetic calculations.</td>
      <td>{{tc|yes|style=text-align:center}}</td>
    </tr>
    <tr>
      <td>trigger</td>
      <td>A score that can be changed by commands and not automatically by the game. The {{cmd|trigger}} command allows players to set, increment, or decrement their own score. The command fails if the objective has not been "enabled" for the player using it. After a player uses it, the objective is automatically disabled for them. By default, all trigger objectives are disabled for players. Ordinary players can use the {{cmd|trigger}} command, even if [cheats](cheats.md) are disabled or they are not [server operators](operator.md), making it useful for safely taking input from non-operator players.</td>
      <td>{{tc|yes|style=text-align:center}}</td>
    </tr>
    <tr>
      <td>deathCount</td>
      <td>The score increments automatically when a player dies.</td>
      <td>{{tc|yes|style=text-align:center}}</td>
    </tr>
    <tr>
      <td>playerKillCount</td>
      <td>The score increments automatically when a player kills another player.</td>
      <td>{{tc|yes|style=text-align:center}}</td>
    </tr>
    <tr>
      <td>totalKillCount</td>
      <td>The score increments automatically when a player kills another player or a mob.</td>
      <td>{{tc|yes|style=text-align:center}}</td>
    </tr>
    <tr>
      <td>health</td>
      <td>Ranges from 0 to 20 (and greater) for a normal player; represents the amount of half-hearts a player has. It may appear as 0 for players before their health has changed for the first time. The health score can surpass 20 points with extra hearts from [attribute](attribute.md)s, [Health Boost](health-boost.md) or [Absorption](absorption.md) effects.</td>
      <td>{{tc|no|style=text-align:center}}</td>
    </tr>
    <tr>
      <td>xp</td>
      <td>Matches the total amount of [experience](experience.md) the player has collected since their last death.</td>
      <td>{{tc|no|style=text-align:center}}</td>
    </tr>
    <tr>
      <td>level</td>
      <td>Matches the current experience level of the player.</td>
      <td>{{tc|no|style=text-align:center}}</td>
    </tr>
    <tr>
      <td>food</td>
      <td>Ranges from 0 to 20; represents the amount of hunger points a player has. It may appear as 0 for players before their food level has changed for the first time.</td>
      <td>{{tc|no|style=text-align:center}}</td>
    </tr>
    <tr>
      <td>air</td>
      <td>Ranges from 0 to 300; represents the amount of air a player has left while [swimming](swimming.md) underwater. It matches the air NBT tag of the player.</td>
      <td>{{tc|no|style=text-align:center}}</td>
    </tr>
    <tr>
      <td>armor</td>
      <td>Ranges from 0 to 20; represents the amount of armor points a player has. It may appear as 0 for players before their armor level has changed for the first time.</td>
      <td>{{tc|no|style=text-align:center}}</td>
    </tr>
  </tbody>
</table>

### Compound criteria
{{exclusive|java|section=1}}

Compound criteria names are divided into parts, delimited with periods {{cd|.}}. For example, {{cd|minecraft.killed_by:minecraft.zombie}} is a valid compound criterion, under which a player's score increments whenever they are killed by a zombie.

Objectives based on a compound criterion are writable and can be modified with commands.

[Statistics](statistics.md) can be used as compound criteria whose name are their [identifier](statistics.md#resource-location). Player statistics are stored separately from the scoreboard, and as they update, the scores in these objectives are updated too.

In addition, there are some other compound criteria:
{{#VARDEFINE:team_colors|{{cd|black|dark_blue|dark_green|dark_aqua|dark_red|dark_purple|gold|gray|dark_gray|blue|green|aqua|red|light_purple|yellow|white|d=and}} }}
<table class="wikitable">
  <tbody>
    <tr>
      <th>Criteria base name</th>
      <th>Description</th>
      <th>Number of sub-criteria</th>
    </tr>
    <tr>
      <td>teamkill.&lt;team_color></td>
      <td>Sub-criteria include team colors. Player scores increment when a player kills a member of the given colored team.

These criteria follow the complete format `teamkill.&lt;team_color>`, where `&lt;team_color>` is a color from the list:
{{collapse |title=**Team colors** |content={{#VAR:team_colors}} }}</td>
      <td>16</td>
    </tr>
    <tr>
      <td>killedByTeam.&lt;team_color></td>
      <td>Sub-criteria include team colors. Player scores increment when a player is killed by a member of the given colored team.

These criteria follow the complete format `killedByTeam.&lt;team_color>`, where `&lt;team_color>` is a color from the list:
{{collapse |title=**Team colors** |content={{#VAR:team_colors}} }}</td>
      <td>16</td>
    </tr>
  </tbody>
</table>

## Score operations

Players can increment, decrement, reset and modify an entity's scores by a specific amount using [command](command.md)s. They can also set scores to a [random](random.md) number within a range, and test if the scores are set between specific minimum and maximum values.

Scores can also be modified by using **arithmetic operations** like addition, subtraction, multiplication, and etc. These operations take the target entity's score and execute it with another score from a different entity. The result of such operations is then assigned as the new target score.

For example, executing an addition operation on a target entity's score with a source entity's score can be expressed as:

<math>\text{New Target Score} = \text{Target Score} + \text{Source Score}</math>

Below is a list of available arithmetic operations.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Operation</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>+=</td>
      <td>Adds the target's score and the source's score.<br><math>\text{New Target Score} = \text{Target Score} + \text{Source Score}</math></td>
    </tr>
    <tr>
      <td>-=</td>
      <td>Subtracts the target's score and the source's score.<br><math>\text{New Target Score} = \text{Target Score} - \text{Source Score}</math></td>
    </tr>
    <tr>
      <td>*=</td>
      <td>Multiplies the target's score and the source's score.<br><math>\text{New Target Score} = \text{Target Score} \times \text{Source Score}</math></td>
    </tr>
    <tr>
      <td>/=</td>
      <td>Divides the target's score and the source's score, then applies the {{w|Floor and ceiling functions|floor}} function on the result.<br><math>\text{New Target Score} = \left\lfloor \frac{\text{Target Score}}{\text{Source Score}} \right\rfloor</math></td>
    </tr>
    <tr>
      <td>%=</td>
      <td>Applies the {{w|modulo}} operation on the target's score and the source's score, returning the remainder of a division.<br><math>\text{New Target Score} = \text{Target Score} \mod \text{Source Score}</math></td>
    </tr>
    <tr>
      <td>=</td>
      <td>Assigns the source's score as the new target's score without applying any other arithmetic operations whatsoever.<br><math>\text{New Target Score } = \text{ Source Score}</math></td>
    </tr>
    <tr>
      <td><</td>
      <td>Assigns the minimum value between the target's score and the source's score. It will compare and pick the lowest score value between the target's and the source's scores.<br><math>\text{New Target Score} = \min(\text{Target Score}, \text{Source Score})</math></td>
    </tr>
    <tr>
      <td>></td>
      <td>Assigns the maximum value between the target's score and the source's score. It will compare and pick the highest score value between the target's and the source's scores.<br><math>\text{New Target Score} = \max(\text{Target Score}, \text{Source Score})</math></td>
    </tr>
    <tr>
      <td>><</td>
      <td>Swaps the target's score and the source's score. The target's score will be the source's score, and the source's score will be the target's score.<br><math>\text{Target Score } \leftrightarrow \text{ Source Score}</math></td>
    </tr>
  </tbody>
</table>

For arithmetic operations, if there is more than one score holder specified as the sources, the game executes the operations once with each source's score, and if there is more than one target score holder, the game executes the operations for each target one by one.

These operations are available by using the [scoreboard players](commands-scoreboard.md#players-commands) sub-commands, e.g.
- {{cmd|scoreboard players operation <targets> <targetObjective> <operation> <source> <sourceObjective>}} for arithmetic operations,
- {{cmd|scoreboard players set <targets> <objective> <score>}} to set a target entity's score, and
- {{cmd|scoreboard players test <player: target> <objective: string> <min: wildcard int> [<max: wildcard int>]}} to test a target entity's score.{{only|BE}}
** {{IN|JE}}, you'd use {{cmd|execute if <targets>}} and the {{cd|1=[scores={<objective>=<min>..<max>}]}} [target selector argument](target_selectors.md#targetselectorarguments).

In *Java Edition*, modifying scores are also possible using {{cmd|execute store result score}} command, where the result of a command would be stored to the entity's score. Such commands like {{cmd|random}} results a random value that can be stored to the entity's scores.

## Display slots
![360px|An objective with two points to the player is displayed in the "list" slot, while an objective with the display name "Quest Points" with 0 points to the player is displayed in the "sidebar" slot.](Scoreboard Display.png)

An entity's scores in objectives can be displayed in certain slots in the game. These slots are called **display slots**, and they can appear in the player list, sidebar on the right side of the screen, below a player's [name tag](player.md#username), etc. Each display slot can show one objective at a time, and multiple display slots may be used for the same or different objectives.

When players' scores appear on display slots, their [username](username.md) is used to attribute the score holder. For entities, their [unique identifier](unique-identifier.md)s are used instead. The score holder's name on display slots can be specifically changed by using {{cmd|scoreboard players display name <target> <objective> [<name>]}}.

Entities' scores can only be displayed on the sidebar slot, while other slots are exclusive for players.

Display slots can be set by {{cmd|scoreboard objectives setdisplay <slot> [<objective>]}} command.

<table class="wikitable">
  <tbody>
    <tr>
      <th>Slot</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>list</td>
      <td>Displays a yellow number or some hearts ({{cmd|scoreboard objectives modify <objective> rendertype (hearts|integer)}}) without the objective heading on the tab menu, where online players are shown.{{only|java}}

Displays a white number without the objective heading on the [pause menu](pause-menu.md), where online players are shown.{{only|bedrock}}

Visible even in singleplayer. </td>
    </tr>
    <tr>
      <td>sidebar</td>
      <td>Shows on the right hand side of the screen, up to 15 entities with the highest score of that objective with a heading labeled with the objective's display name.

Note that players are shown even if offline, and untracked players are not shown. In addition, fake players with names starting with a {{cd|#}} character do not show up in the sidebar under any circumstances. </td>
    </tr>
    <tr>
      <td>{{nohtml|sidebar.team.<color>}} {{only|java}}</td>
      <td>There are 16 team-specific sidebar display slots. These operate the same as the standard sidebar slot, but display only to players who are on teams that use the specified color (for example, "sidebar.team.green" displays to players on "green" teams).

The `<color>` is a color from the list:
{{collapse |title=**Team colors** |content={{#VAR:team_colors}} }}</td>
    </tr>
    <tr>
      <td>below_name{{only|java}}
belowname{{only|bedrock}}</td>
      <td>Shows the score followed by the objective's display name below the player's name tag above their head. This is hidden beyond around 10 blocks and when the player is [sneaking](sneaking.md). Not visible in singleplayer.</td>
    </tr>
  </tbody>
</table>

## Tags
{{For|the command|Commands/tag}}
**Tags** are a simple list of single-word strings stored directly in the [{{nbt|list|Tags}}](entity-format.md) data of an entity, with maximum limit of 1024 tags. As with objectives, tags are case-sensitive.

Target selectors can be used to check whether an entity has a tag with the ["tag" argument](target-selectors.md#selecting-targets-by-tag).

## Teams
{{redirect|team|the command|Commands/team}}
{{exclusive|java|section=1}}

**Teams** group entities or players together as allies.

Any entity can only have a single team. Mobs do not intentionally attack other entities on the same team.

Teams have a **name** property, used internally for reference in commands, target arguments, and the file format. Like objectives, it is a single, case-sensitive string consisting of alphanumeric characters. Teams also have other several properties to set its appearances and behaviors:

<table class="wikitable">
  <tbody>
    <tr>
      <th>Property</th>
      <th>Description</th>
      <th>Value</th>
    </tr>
    <tr>
      <td>displayName</td>
      <td>Sets the team's display name that appears on the scoreboard's [[#Display slots|display slot]]s, such as the player list, below the player's name tag, and the sidebar.</td>
      <td>**[Text component](text-component.md)**</td>
    </tr>
    <tr>
      <td>color</td>
      <td>Sets the team's color that appears on the player name in chat, name tag, player list menu, and on the scoreboard sidebar. It also changes the color of the entities outline caused by the [Glowing](glowing.md) effect.</td>
      <td>{{#VAR:team_colors}}</td>
    </tr>
    <tr>
      <td>collisionRule</td>
      <td>Controls a member's collision rule with other team members, or their own.</td>
      <td>`always` (default), {{cd|never|pushOtherTeams|pushOwnTeam|d=and}}</td>
    </tr>
    <tr>
      <td>deathMessageVisibility</td>
      <td>Controls a member's [death message](death-message.md) visibility with other team members, or their own.</td>
      <td>`always` (default), {{cd|never|hideForOtherTeams|hideForOwnTeam|d=and}}</td>
    </tr>
    <tr>
      <td>nametagVisibility</td>
      <td>Controls a member's [name tag](player.md#username) visibility from other team members, or their own. Members' name tag is visible above the [player head](player-head.md).</td>
      <td>`always` (default), {{cd|never|hideForOtherTeams|hideForOwnTeam|d=and}}</td>
    </tr>
    <tr>
      <td>friendlyFire</td>
      <td>Toggles the team's friendly fire rule that controls if a member can attack other members on the same team. The attack damage can be from melee attack, bow and arrow, [splash potion](splash-potion.md) of [Harming](harming.md), and more. Note that team members may still inflict negative status effects on each other with potions, like with a splash potion of [Poison](poison.md).</td>
      <td>{{#VAR:boolean_true}}</td>
    </tr>
    <tr>
      <td>seeFriendlyInvisibles</td>
      <td>Toggles a member's visibility to other members on the same team with [Invisibility](invisibility.md) effect.</td>
      <td>{{#VAR:boolean_true}}</td>
    </tr>
    <tr>
      <td>prefix</td>
      <td>Sets the team's prefix that appears before the member's name in the chat, name tag, and the player list menu.</td>
      <td>**Quoted string**</td>
    </tr>
    <tr>
      <td>suffix</td>
      <td>Sets the team's suffix that appears after the member's name in the chat, name tag, and the player list menu.</td>
      <td>**Quoted string**</td>
    </tr>
  </tbody>
</table>

Commands can be used to check whether team members exist by using target selection with the "team" argument. An exclamation point {{cd|!}} character may be placed before a team name to check for entities *not* on that team. For example, inputting {{cmd|1=execute if entity @a[team=red]}} into a [command block](command-block.md) provides [comparator](comparator.md) output if any player exists on the red team. Conversely, {{cmd|1=execute if entity @a[team=!red]}} provides output when there are any players *not* on the red team. {{cmd|1=execute if entity @a[team=!]}} allows output when at least one player is on *any* team, and {{cmd|1=execute if entity @a[team=]}} allows output when at least one player is on *no* team.

## NBT format
{{exclusive|java|section=1}}
{{needs testing|Seems that java version 1.20.5 no longer automatically generates or requires the render_type, display_auto_update, locked and player_scores fields. Not sure whether some of them were completely removed or just no longer auto generated}}

The file **scoreboard.dat** in the `data` folder of the [world save folder](java-edition-level-format.md) stores the scoreboard data for that world as a {{w|gzip|newtab=1}} compressed [NBT](nbt.md) file:

<div class="treeview">
- {{nbt|compound}} The root tag.
**{{nbt|compound|data}}: The scoreboard data.
***{{nbt|list|Objectives}}: A list of compound tags representing objectives.
**** {{nbt|compound}} An objective.
***** {{nbt|string|CriteriaName}}: The criterion of this objective.
***** {{nbt|string|DisplayName}}: The display name of this objective in JSON. If none was specified during the objective's creation, this is set to `{"text":"*Value of Name*"}`.
***** {{nbt|string|Name}}: The internal name of this objective.
***** {{nbt|string|RenderType}}: The way the score is displayed. Can be "integer" or "hearts", but defaults to "integer".
***** {{nbt|byte|display_auto_update}}: 1 or 0 (true/false) - Whether the display names in the sidebar automatically updates whenever the score values are changed.
***** {{nbt|compound|format}}: Optional, the default number format for this objective.
****** {{nbt|string|type}}: One of `blank`, `fixed`, or `result` (called `styled` in the command).
****** Additional fields based on the type.
*** {{nbt|list|PlayerScores}}: A list of compound tags representing scores tracked by the scoreboard system.
**** {{nbt|compound}} A tracked player/objective pair with a score.
***** {{nbt|int|Score}}: The score this player has in this objective.
***** {{nbt|string|Name}}: The name of the player who has this score in this objective.
***** {{nbt|string|Objective}}: The internal name of the objective that this player has this score in.
***** {{nbt|byte|Locked}}: 1 or 0 (true/false) - false if this objective is "enabled". Meaningful only for objectives with the criteria "trigger", where this must be false before a player can use the /trigger command on it.
***** {{nbt|string|display}}: Optional, the text component used as display name in the sidebar.
***** {{nbt|compound|format}}: Optional, the number format of the player score.
****** {{nbt|string|type}}: One of `blank`, `fixed`, or `result` (called `styled` in the command).
****** Additional fields based on the type.
*** {{nbt|list|Teams}}: A list of compound tags representing teams.
**** {{nbt|compound}} A Team.
***** {{nbt|byte|AllowFriendlyFire}}: 1 or 0 (true/false) - true if players on this team can harm each other.
***** {{nbt|byte|SeeFriendlyInvisibles}}: 1 or 0 (true/false) - true if players on this team can see invisible teammates.
***** {{nbt|string|NameTagVisibility}}: The value of the nametagVisibility option of this team.
***** {{nbt|string|DeathMessageVisibility}}: The value of the deathMessageVisibility option of this team. Valid options are: never, hideForOtherTeams, hideForOwnTeam, always
***** {{nbt|string|CollisionRule}}: The value of the collisionrule option of this team. Valid options are: always, pushOwnTeam, never, pushOtherTeams
***** {{nbt|string|DisplayName}}: The display name of this team in JSON. If none was specified during the team's creation, this is set to `{"text":"*Value of Name*"}`.
***** {{nbt|string|Name}}: The internal name of this team.
***** {{nbt|string|MemberNamePrefix}}: The prefix prepended to names of players on this team. In JSON format.
***** {{nbt|string|MemberNameSuffix}}: The suffix appended to names of players on this team. In JSON format
***** {{nbt|string|TeamColor}}: The text-based color given to the team. Does not exist if no color is set. Valid colors are: {{#VAR:team_colors}}.
***** {{nbt|list|Players}}: A list of names of players on this team.
****** {{nbt|string}} The name of a player on this team.
*** {{nbt|compound|DisplaySlots}}: A set of slots that display specific objectives. If a slot is empty, its tag is not present.
****{{nbt|string|slot_*n*}}: The internal name of the objective displayed (see below).
</div>

<table class="wikitable">
  <caption>Display slots</caption>
  <tbody>
    <tr>
      <th>No.</th>
      <th>Type</th>
      <th>Name</th>
    </tr>
    <tr>
      <td>0</td>
      <td>Player list</td>
      <td>list</td>
    </tr>
    <tr>
      <td>1</td>
      <td>On the sidebar</td>
      <td>sidebar</td>
    </tr>
    <tr>
      <td>2</td>
      <td>Below the player's username</td>
      <td>belowName</td>
    </tr>
    <tr>
      <td>3</td>
      <td rowspan="16">Team color</td>
      <td>sidebar.team.black</td>
    </tr>
    <tr>
      <td>4</td>
      <td>sidebar.team.dark_blue</td>
    </tr>
    <tr>
      <td>5</td>
      <td>sidebar.team.dark_green</td>
    </tr>
    <tr>
      <td>6</td>
      <td>sidebar.team.dark_aqua</td>
    </tr>
    <tr>
      <td>7</td>
      <td>sidebar.team.dark_red</td>
    </tr>
    <tr>
      <td>8</td>
      <td>sidebar.team.dark_purple</td>
    </tr>
    <tr>
      <td>9</td>
      <td>sidebar.team.gold</td>
    </tr>
    <tr>
      <td>10</td>
      <td>sidebar.team.gray</td>
    </tr>
    <tr>
      <td>11</td>
      <td>sidebar.team.dark_gray</td>
    </tr>
    <tr>
      <td>12</td>
      <td>sidebar.team.blue</td>
    </tr>
    <tr>
      <td>13</td>
      <td>sidebar.team.green</td>
    </tr>
    <tr>
      <td>14</td>
      <td>sidebar.team.aqua</td>
    </tr>
    <tr>
      <td>15</td>
      <td>sidebar.team.red</td>
    </tr>
    <tr>
      <td>16</td>
      <td>sidebar.team.light_purple</td>
    </tr>
    <tr>
      <td>17</td>
      <td>sidebar.team.yellow</td>
    </tr>
    <tr>
      <td>18</td>
      <td>sidebar.team.white</td>
    </tr>
  </tbody>
</table>

## History

{{HistoryTable
|{{HistoryLine|java}}
|{{HistoryLine||1.5|dev=13w04a|Added scoreboard.}}
|{{HistoryLine|||dev=13w05a|Added team-based functionality.}}
|{{HistoryLine||1.7.2|dev=13w36a|Added statistic-based objective criteria.}}
|{{HistoryLine||1.8|dev=14w02a|Entities other than players can now be part of teams and have objective scores.}}
|{{HistoryLine|||dev=14w06a|Added the `trigger` and team kill-based objective criteria.
|Added `/scoreboard players enable`.
|"*" can be used in a player name argument to represent all players tracked by the scoreboard.
|Added the "objective" argument to `/scoreboard players reset`.
|Statistic objective criteria now use named IDs instead of numerical IDs.
|Added the `achievement.overpowered` objective criterion.}}
|{{HistoryLine|||dev=14w07a|Added `/scoreboard players operation` and `/scoreboard players test`.
|Scores for fake players that have a name beginning with "#" don't appear in the sidebar.
|Added team-specific sidebar display slots.|Added the `nametagVisibility` team option.}}
|{{HistoryLine|||dev=14w10a|Added the `deathMessageVisibility` team option.
|Added a `dataTag` argument to  `/scoreboard players set`, `/scoreboard players add`, and `/scoreboard players remove`.
|Added the `stat.crouchOneCm`, `stat.sprintOneCm`, and `stat.timeSinceDeath` objective criteria.}}
|{{HistoryLine|||dev=14w25a|Added `=`, `<`, and `>` to `/scoreboard players operation`.}}
|{{HistoryLine|||dev=14w29a|Player/entity names in the sidebar are now secondarily sorted by alphabetical order.}}
|{{HistoryLine|||dev=14w30a|Added the `stat.talkedToVillager` and `stat.tradedWithVillager` objective criteria.}}
|{{HistoryLine|||dev=unknown|Added `><` to `/scoreboard players operation`.}}
|{{HistoryLine||1.8.2|Added the `stat.cauldronFilled`, `stat.cauldronUsed`, `stat.armorCleaned`, `stat.bannerCleaned`, `stat.brewingstandInteraction`, `stat.beaconInteraction`, `stat.dropperInspected`, `stat.hopperInspected`, `stat.dispenserInspected`, `stat.noteblockPlayed`, `stat.noteblockTuned`, `stat.flowerPotted`, `stat.trappedChestTriggered`, `stat.enderchestOpened`, `stat.itemEnchanted`, `stat.recordPlayed`, `stat.furnaceInteraction`, `stat.craftingTableInteraction`, `stat.chestOpened` objective criteria.}}
|{{HistoryLine||1.9|dev=15w32a|Added the `stat.sneakTime` objective criteria.}}
|{{HistoryLine|||dev=15w32b|Added `/scoreboard players tag`.
|Added the `xp`, `food`, and `air` objective types.}}
|{{HistoryLine|||dev=15w33a|Added the `stat.pickup` and `stat.drop` objective criteria.
|Added the `armor`, `level` objective types.}}
|{{HistoryLine|||dev=15w36a|Added `collisionRule`.}}
|{{HistoryLine|||dev=15w49a|Added the `stat.aviateOneCm` objective criteria.}}
|{{HistoryLine||1.13|dev=pre7|Added {{cmd|scoreboard objectives modify}}.}}
|{{HistoryLine|||dev=pre8|Added {{cmd|scoreboard objectives modify <*objectiveName*> rendertype *hearts*|link=none}}, which makes health bars display as hearts, like this: {{Healthbar|12|total=20}}.
|Added {{cmd|scoreboard objectives modify <objectiveName> rendertype *integer*|link=none}}, which makes health bars display as yellow numbers.
|Objective names are now text components, not raw strings.}}
|{{HistoryLine||1.13.1|dev=18w31a|Changed the scoreboard operator {{code|%{{=}}}} from using {{code|%}} to {{code|Math.floorMod}}.}}|{{HistoryLine||1.18|dev=21w37a|Removed 16-character length limits for scoreboards, score holders and team names.}}
|{{HistoryLine||1.20.2|dev=23w31a|The {{cd|belowName}} display slot selector is now {{cd|below_name}}.}}
|{{HistoryLine||1.20.3|dev=23w46a|Added custom display settings for scores in the sidebar.}}
|{{HistoryLine|bedrock}}
|{{HistoryLine||1.7.0|dev=beta 1.7.0.2|exp=Experimental Gameplay|Added basic scoreboard mechanics.
|Added dummy scoreboards.|Both are currently only available with [Experimental Gameplay](experimental-gameplay.md) enabled.}}
|{{HistoryLine||1.7.0|dev=beta 1.7.0.7|Scorebord functionality is now available outside of Experimental Gameplay.}}
}}

## Issues
{{issue list}}

## Gallery
### Screenshots

## Navigation
{{Navbox gameplay}}
{{Navbox Java Edition technical|general}}

[de:Anzeigetafel](de-anzeigetafel.md)
[es:Marcador](es-marcador.md)
[fr:Tableau de score](fr-tableau-de-score.md)
[ja:スコアボード](ja.md)
[ko:스코어보드](ko.md)
[nl:Scorebord](nl-scorebord.md)
[pl:Tablica wyników](pl-tablica-wynikw.md)
[pt:Placar](pt-placar.md)
[ru:Система счёта игровых событий](ru.md)
[uk:Табло](uk.md)
[zh:记分板](zh.md)
