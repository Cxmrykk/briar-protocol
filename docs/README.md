# Minecraft Protocol Documentation (Version 1.21.5)

This repository contains documentation for the Minecraft Java Edition protocol, specifically for version `1.21.5`. The files aim to provide a comprehensive understanding of the various aspects of how the Minecraft client and server communicate.

## Original Format

The documentation files in the `docs/markdown/` directory were originally `.wiki` files, sourced from [minecraft.wiki](minecraft.wiki). They have been converted to Markdown format for easier readability and use in different environments. The original `.wiki` files are preserved in the `docs/mediawiki/` directory for reference.

## Files

The primary documentation is located in the `docs/markdown/` directory. Below is an outline of these files:

- **`attribute.md`**: Describes entity attributes, their properties, and how they affect entities like mobs and players.
- **`block-actions.md`**: Details the actions that specific blocks can perform, as used in the "Block Action" packet.
- **`chat.md`**: Covers various aspects of Minecraft's chat system, including client chat modes and message processing.
- **`chunk-format.md`**: Explains the structure and format of chunk data, including chunk columns, sections, and palettes.
- **`command-data.md`**: Outlines the structure of the command graph, defining how commands are parsed and executed.
- **`data-types.md`**: Defines the fundamental data types used in the Minecraft protocol (e.g., VarInt, String, Position).
- **`encryption.md`**: Describes the encryption process used during the login sequence for secure communication.
- **`entity-metadata.md`**: Lists entity metadata fields and their meanings for various entity types.
- **`entity-statuses.md`**: Documents entity status codes and their effects on different entities.
- **`faq.md`**: Answers frequently asked questions regarding the Minecraft protocol, including login and ping sequences.
- **`identifier.md`**: Explains resource locations (namespaced IDs) used to identify game objects like blocks, items, and entities.
- **`inventory.md`**: Details the structure and slot indexing for different inventory windows (e.g., player inventory, chests, furnaces).
- **`mojang-api.md`**: Provides documentation for Mojang's public web APIs, allowing programmatic access to player data and other services.
- **`nbt.md`**: Describes the Named Binary Tag (NBT) file format used by Minecraft for storing various game data.
- **`object-data.md`**: Documents the "Data" field in the "Spawn Entity" packet, which varies depending on the entity type.
- **`packets.md`**: The central document listing all known packets for protocol version `1.21.5`, their IDs, states, and fields.
- **`particles.md`**: Lists available particle types and the format of their associated data.
- **`plugin-channels.md`**: Explains the system for custom messaging between client mods and server plugins.
- **`registry-data.md`**: Details how server-defined registries (e.g., biomes, dimension types) are sent to the client.
- **`scoreboard.md`**: Describes the scoreboard system, including objectives, criteria, and teams.
- **`server-list-ping.md`**: Outlines the protocol for querying server information (MOTD, player count, version) for the server list.
- **`slot-data.md`**: Defines the structure for representing item stacks within inventory windows, including the new structured components.
- **`tag.md`**: Explains the use of tags in data packs and behavior packs for grouping game elements.
- **`text-formatting.md`**: Documents legacy §-based formatting codes for adding color and style to in-game text. (For the modern JSON-based system, see other relevant files).

## License

The content of these documentation files, originally sourced from wiki.vg and similar community efforts, is typically distributed under the terms of the **Creative Commons Attribution-ShareAlike 3.0 Unported (CC BY-SA 3.0 Unported)** license.

You can find the license details here: [https://creativecommons.org/licenses/by-sa/3.0/](https://creativecommons.org/licenses/by-sa/3.0/)

This means that while you may use the contents of these pages without restriction to create servers, clients, bots, etc., any reproductions and derivative works must be distributed under the same or compatible terms and provide appropriate attribution.

The footer of the provided `packets.md` file explicitly states:

> ℹ️ While you may use the contents of this page without restriction to create servers, clients, bots, etc; keep in mind that the contents of this page are distributed under the terms of [CC BY-SA 3.0 Unported](https://creativecommons.org/licenses/by-sa/3.0/). Reproductions and derivative works must be distributed accordingly.
>
> _Content is licensed under wiki.vg terms._

Please ensure you respect these terms when using or redistributing this documentation.
