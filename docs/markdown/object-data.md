This article documents the **Data** field in the [Spawn Entity](packets.md#spawn-entity) packet. The field is of type Int, and the meaning of its contents depend on the [type of entity](entity_metadata.md) being spawned, as defined in the Type field of the same packet, and is documented below.

## [Item Frame](entity_metadata.md#itemframe)

<table class="wikitable">
  <tbody>
    <tr>
      <th>Value</th>
      <th>Orientation</th>
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
      <td>North</td>
    </tr>
    <tr>
      <td>3</td>
      <td>South</td>
    </tr>
    <tr>
      <td>4</td>
      <td>West</td>
    </tr>
    <tr>
      <td>5</td>
      <td>East</td>
    </tr>
  </tbody>
</table>

The Notchian client clamps invalid values into the valid range through the modulus operator. If the resulting value is negative, the absolute value is used.

Velocity in the packet is always ignored.

## [Painting](entity_metadata.md#painting)

<table class="wikitable">
  <tbody>
    <tr>
      <th>Value</th>
      <th>Orientation</th>
    </tr>
    <tr>
      <td>2</td>
      <td>North</td>
    </tr>
    <tr>
      <td>3</td>
      <td>South</td>
    </tr>
    <tr>
      <td>4</td>
      <td>West</td>
    </tr>
    <tr>
      <td>5</td>
      <td>East</td>
    </tr>
  </tbody>
</table>

The Notchian client clamps invalid values into the valid range through the modulus operator. If the resulting value is negative, the absolute value is used.

> ⚠️ **Warning:** Although the values of 0 and 1 are invalid, the Notchian client uses the same clamping algorithm as [[#Item_Frame|Item Frame]], which can result in any value from 0 to 5. If the resulting value is invalid, the entity will fail to spawn.

Velocity in the packet is always ignored.

## [Falling Block](entity_metadata.md#fallingblock)

<table class="wikitable">
  <tbody>
    <tr>
      <th>Field name</th>
      <th>Field type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>Block state ID</td>
      <td>`Int`</td>
      <td>ID of the block state that the falling block will represent.</td>
    </tr>
  </tbody>
</table>

Velocity in the packet is always ignored.

## [Fishing Hook](entity_metadata.md#fishinghook)

<table class="wikitable">
  <tbody>
    <tr>
      <th>Field name</th>
      <th>Field type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>Owner</td>
      <td>`Int`</td>
      <td>The entity ID of the owner</td>
    </tr>
  </tbody>
</table>

> ⚠️ **Warning:** If the entity with the Owner ID doesn't exist in the client, the entity will fail to spawn.

Velocity in the packet is ignored, and instead should be inferred from the shooter's position.

> ❓ **Missing info (section):** What's the exact algorithm for determining this?

## [Projectile](entity_metadata.md#projectile)

<table class="wikitable">
  <tbody>
    <tr>
      <th>Field name</th>
      <th>Field type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>Owner ID</td>
      <td>`Int`</td>
      <td>The entity ID of the owner</td>
    </tr>
  </tbody>
</table>

## [Warden](entity_metadata.md#warden)

<table class="wikitable">
  <tbody>
    <tr>
      <th>Field name</th>
      <th>Field type</th>
      <th>Notes</th>
    </tr>
    <tr>
      <td>Pose</td>
      <td>`Int`</td>
      <td>If a value of 1 is specified, the Warden will spawn in the [emerging pose](entity_metadata.md#entitymetadataformat).
Any other value is silently ignored.</td>
    </tr>
  </tbody>
</table>


[Category:Protocol Details](category-protocol-details.md)
[Category:Java Edition protocol](category-java-edition-protocol.md)
_Content is licensed under wiki.vg terms._
