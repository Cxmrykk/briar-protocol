<div align="left">
  <img src="assets/berries.png" alt="Briar logo" width="64" height="64">
</div>

## Briar Protocol

**`1.21` is incomplete and WIP!**

#### Planned Features:

- Connect to a minecraft server as a client
- Server and proxy implementation
- Protocol encryption and compression
- Authentication with Microsoft

#### Usage

First, add the dependency to your `shards.yml`

```yml
dependencies:
  briar-protocol:
    github: cxmrykk/briar-protocol
    branch: 1.21
```

#### Development Goals:

- Small code base (use macros, avoid repitition)
- Modular code (avoid nested dependencies)
- Resilient error handling (failsafes and logging, rather than crashing)

#### Compromises:

- Only support the latest minor version (currently `1.21.5`)
- No backwards compatibility