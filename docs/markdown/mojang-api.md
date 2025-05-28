This page provides documentation for **API** endpoints provided by [Mojang Studios](mojang-studios.md) which allows user to query player data and make changes programmatically.

Currently, the API is rate limited at 600 requests per 10 minutes. <ref>http://wiki.vg/Mojang_API ([Internet Archive](https://web.archive.org/web/20241129034336/wiki.vg/Mojang_API))</ref>

## Request and response

For requests with a payload, the following restrictions apply:

- Request must include the `Content-Type` header, which must be <samp>application/json</samp>. Otherwise, the server returns HTTP 415.
- Payload must be a valid json. Otherwise, the server returns HTTP 400.

If the request is successful, the server:

- Returns a successful response code (HTTP 2XX)
- Returns an empty payload (with HTTP 204) or a valid json

Otherwise, if the request fails, the server returns a non-2XX HTTP status code with this payload:

<div class="treeview">
- {{Nbt|compound}}: Root tag.
** {{Nbt|string|error}}: Error identifier
** {{Nbt|string|errorMessage}}: Description of the error
** {{Nbt|string|cause}}: Description of the cause of the error
</div>

These are some common causes:

<table class="wikitable mw-collapsible mw-collapsed">
  <tbody>
    <tr>
      <th>HTTP status code</th>
      <th>{{cd|error}}</th>
      <th>{{cd|errorMessage}}</th>
      <th>Explanation</th>
    </tr>
    <tr>
      <td>rowspan=3 | 400</td>
      <td>IllegalArgumentException</td>
      <td>rowspan=3 | Depends on the endpoint</td>
      <td>Incorrect or invalid argument in the request.</td>
    </tr>
    <tr>
      <td>MismatchedInputException</td>
      <td>rowspan=2 | JSON payload does not meet the required schema or payload is not an invalid JSON.</td>
    </tr>
    <tr>
      <td>JsonParseException</td>
    </tr>
    <tr>
      <td>rowspan=2 | 401</td>
      <td>(empty payload)</td>
      <td>(empty payload)</td>
      <td>Endpoint requires authentication, but request header does not have an `Authorization` header or the token is invalid.</td>
    </tr>
    <tr>
      <td>Unauthorized</td>
      <td>The request requires user authentication</td>
      <td>Endpoint requires authentication, but request header does not have an `Authorization` header.</td>
    </tr>
    <tr>
      <td>rowspan=2 | 403</td>
      <td>ForbiddenOperationException</td>
      <td>Forbidden</td>
      <td>Invalid auth token.</td>
    </tr>
    <tr>
      <td>{{tc|n/a}}</td>
      <td>Your account has been suspended. Please contact customer service.</td>
      <td>Account has been banned/suspended state by triggering a high volume of erroneous requests. See [#Account suspensions](account-suspensions.md).</td>
    </tr>
    <tr>
      <td>404</td>
      <td>Not Found</td>
      <td>The server has not found anything matching the request URI</td>
      <td>Endpoint does not exist.</td>
    </tr>
    <tr>
      <td>405</td>
      <td>Method Not Allowed</td>
      <td>The method specified in the request is not allowed for the resource identified by the request URI</td>
      <td>Request method is not supported.</td>
    </tr>
    <tr>
      <td>415</td>
      <td>Unsupported Media Type</td>
      <td>The server is refusing to service the request because the entity of the request is in a format not supported by the requested resource for the requested method</td>
      <td>{{cd|Content-Type}} request header does not match the type the endpoint allows.</td>
    </tr>
  </tbody>
</table>

### Account suspensions
A Minecraft account can be entered into a banned/suspended state by triggering a high volume of erroneous requests, such as a high volume of 429s while uploading a skin.

These suspensions appear to be temporary, although this is speculation and the exact functionality of this automatic suspension system is unknown.

 POST https://api.minecraftservices.com/authentication/login_with_xbox

Returns 403 with the following JSON data
```json
{
	"path": "/authentication/login_with_xbox",
	"details": {
		"reason": "ACCOUNT_SUSPENDED"
	},
	"errorMessage": "Your account has been suspended. Please contact customer service."
}
```

Other services will report that the account is banned, such as servers serving the otherwise unused message You are banned from playing online.

These suspensions typically clear within 24 hours but may require contacting Minecraft support if they don't.

## Query player information

These endpoints do not need an access token, and some endpoints can query registered account that do not own the game.

### Query player's UUID

; Input
Player's name (case insensitive).

; Request (GET)
- `https://api.mojang.com/users/profiles/minecraft/<*player name*>`
** This endpoint is currently very unreliable as of January 15, 2025 (frequent, random 403 errors) due to a misconfiguration<ref>https://bugs.mojang.com/browse/WEB-7591?focusedId=1375404&page=com.atlassian.jira.plugin.system.issuetabpanels%3Acomment-tabpanel#comment-1375404</ref> by Mojang.
- `https://api.minecraftservices.com/minecraft/profile/lookup/name/<*player name*>`

; Response
<div class="treeview">
- {{Nbt|compound}} Root tag
** {{Nbt|string|id}}: [UUID](uuid.md) of the player.
** {{Nbt|string|name}}: Name of the player, case sensitive.
** {{Nbt|bool|legacy}}: Included in response if the account has not migrated to Mojang account.
** {{Nbt|bool|demo}}: Included in response if the account does not own the game.
</div>

; Example
`https://api.mojang.com/users/profiles/minecraft/jeb_`<br>Player <samp>jeb_</samp>'s UUID.

```json
{
    "name": "jeb_",
    "id": "853c80ef3c3749fdaa49938b674adae6"
}
```

; Error
- HTTP 404 is returned if no player with such name exists.

### Query player's username

; Input
Player's username (case insensitive).

; Request (GET)
`https://api.minecraftservices.com/minecraft/profile/lookup/<*UUID*>`

; Response
The same as [#Query player's UUID](query-players-uuid.md).

### Query player UUIDs in batch

; Payload
A JSON array with no more than 10 player names (case insensitive).

; Request (POST)
- `https://api.mojang.com/profiles/minecraft`
- `https://api.minecraftservices.com/minecraft/profile/lookup/bulk/byname`

; Response
<div class="treeview">
- {{Nbt|list}} The UUID list for all the players. For players that does not exist, no result is returned.
** {{Nbt|compound}} Player name.
*** {{Nbt|string|id}}: [UUID](uuid.md) of the player.
*** {{Nbt|string|name}}: Name of the player, case sensitive.
*** {{Nbt|bool|legacy}}: Included in response if the account has not migrated to Mojang account.
*** {{Nbt|bool|demo}}: Included in response if the account does not own the game.
</div>

; Example
Request with payload `["jeb_","notch"]`.
```json
[
    {
        "id": "853c80ef3c3749fdaa49938b674adae6",
        "name": "jeb_"
    },
    {
        "id": "069a79f444e94726a5befca90e38aaf5",
        "name": "Notch"
    }
]
```

<table class="wikitable mw-collapsible mw-collapsed">
  <tbody>
    <tr>
      <th>HTTP status code</th>
      <th>{{cd|error}}</th>
      <th>{{cd|errorMessage}}</th>
      <th>Explanation</th>
    </tr>
    <tr>
      <td>rowspan=3 | 400</td>
      <td>rowspan=3 | CONSTRAINT_VIOLATION</td>
      <td>rowspan=2 | size must be between 1 and 10</td>
      <td>RequestPayload is an empty array.</td>
    </tr>
    <tr>
      <td>RequestPayload is has more than 10 elements.</td>
    </tr>
    <tr>
      <td>Invalid profile name</td>
      <td>RequestPayload includes an empty string.</td>
    </tr>
  </tbody>
</table>

### Query player's skin and cape

; Input
Player UUID and whether the request is [signed](wikipedia-digital-signature.md).

; Request (GET)
- `https://sessionserver.mojang.com/session/minecraft/profile/<*UUID*>`
- `https://sessionserver.mojang.com/session/minecraft/profile/<*UUID*>?unsigned=false`

; Response
<div class="treeview">
- {{Nbt|compound}} Root tag
** {{Nbt|string|id}}: Player's [UUID](uuid.md).
** {{Nbt|string|name}}: Player name, case sensitive.
** {{Nbt|boolean|legacy}}: Included in response if the account has not migrated to Mojang account.
** {{Nbt|list|properties}}: A list of player properties.
*** {{Nbt|string|name}}: Name of the property. For now, the only property that exists is `textures`.
*** {{Nbt|string|signature}}: Signature signed with <samp>Yggdrasil</samp> private key as Base64 string, only exists when `unsigned=false`.
*** {{Nbt|string|value}}: [Base64](wikipedia-base64.md) string with all player textures (skin and cape). The decoded string includes:
**** {{Nbt|compound}} Texture object.
***** {{Nbt|int|timestamp}}: [Unix time](wikipedia-unix-time.md) in milliseconds the texture is accessed.
***** {{Nbt|string|profileId}}: Player's UUID without dashes.
***** {{Nbt|string|profileName}}: Player name.
***** {{Nbt|boolean|signatureRequired}}: Only exists when `unsigned=false`.
***** {{Nbt|compound|textures}}: Texture.
****** {{Nbt|compound|SKIN}}: [Skin](skin.md) texture. This does not exist if the player does not have a custom skin.
******* {{Nbt|string|url}}: URL to the skin texture.
******* {{Nbt|compound|metadata}}: Optional. Metadata for the skin.
******** {{Nbt|string|model}}: `slim`. Only exists when skin model is <samp>Alex</samp>. When skin model is <samp>Steve</samp>, this metadata does not exist.
****** {{Nbt|compound|CAPE}}: [Cape](cape.md) texture. If the player does not have a cape, this does not exist.
******* {{Nbt|string|url}}: URL to the cape texture.
</div>

; Example
`https://sessionserver.mojang.com/session/minecraft/profile/853c80ef3c3749fdaa49938b674adae6`<br>Returns:
```json
{
    "id": "853c80ef3c3749fdaa49938b674adae6",
    "name": "jeb_",
    "properties": [
        {
            "name": "textures",
            "value": "ewogICJ0aW1lc3R..."
        }
    ]
}
```
Content in {{Nbt|string|value}} after Base64 decoded:
```json
{
    "timestamp": 1653838459263,
    "profileId": "853c80ef3c3749fdaa49938b674adae6",
    "profileName": "jeb_",
    "textures": {
        "SKIN": {
            "url": "http://textures.minecraft.net/texture/7fd9ba42a7c81eeea22f1524271ae85a8e045ce0af5a6ae16c6406ae917e68b5"
        },
        "CAPE": {
            "url": "http://textures.minecraft.net/texture/9e507afc56359978a3eb3e32367042b853cddd0995d17d0da995662913fb00f7"
        }
    }
}
```

; Error

<table class="wikitable mw-collapsible mw-collapsed">
  <tbody>
    <tr>
      <th>HTTP status code</th>
      <th>{{cd|error}}</th>
      <th>{{cd|errorMessage}}</th>
      <th>Explanation</th>
    </tr>
    <tr>
      <td>204</td>
      <td>(empty payload)</td>
      <td>(empty payload)</td>
      <td>This UUID does not have an associated player</td>
    </tr>
    <tr>
      <td>400</td>
      <td>(empty)</td>
      <td>Not a valid UUID: <*inputted argument*></td>
      <td>UUID is invalid.</td>
    </tr>
  </tbody>
</table>

## Microsoft authentication

{{for|overview on the authentication steps|Microsoft authentication}}

Authentication for Microsoft accounts. Before using Microsoft auth, an [Microsoft Azure Application](https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app) must be created to obtain [OAuth 2.0](https://docs.microsoft.com/en-us/azure/active-directory/develop/v2-oauth2-auth-code-flow) client ID and token, which can then be used to obtain a Microsoft token. When obtaining the token, the {{cd|scope}} parameter should include {{samp|XboxLive.signin}} to obtain an Xbox Live token.

### Obtain an Xbox Live token with Microsoft token

; Payload
<div class="treeview">
- {{Nbt|compound}} Root tag
** {{Nbt|compound|Properties}}: Authentication properties
*** {{Nbt|string|AuthMethod}}: Login method. This should be `RPS`.
*** {{Nbt|string|SiteName}}: Website name. This should be `user.auth.xboxlive.com`.
*** {{Nbt|string|RpsTicket}}: Ticket used for logging in. Value should be `d=<*Microsoft access token*>`.
** {{Nbt|string|RelyingParty}}: Replying party. This should be `http://auth.xboxlive.com`.
** {{Nbt|string|TokenType}}: Type of the access token. This should be `JWT`.
</div>

; Request (POST)
`https://user.auth.xboxlive.com/user/authenticate`

SSL renegotiation required in SSL implementation.

; Response
<div class="treeview">
- {{Nbt|compound}} Root tag
** {{Nbt|string|IssueInstant}}: Time when obtaining the Xbox Live token.
** {{Nbt|string|NotAfter}}: Time the Xbox Live token is expired.
** {{Nbt|string|Token}}: Xbox Live access token.
** {{Nbt|compound|DisplayClaims}}: Unknown.
*** {{Nbt|list|xui}}: Unknown.
**** {{Nbt|compound}}
***** {{Nbt|string|uhs}}: User hashcode.
</div>

### Obtain an XSTS token with Xbox Live token

; Payload
<div class="treeview">
- {{Nbt|compound}} Root tag
** {{Nbt|compound|Properties}}: Auth properties.
*** {{Nbt|string|SandboxId}}: Sandbox ID. This should be `RETAIL`.
*** {{Nbt|list|UserTokens}}: User's Xbox Live token.
**** {{Nbt|string}}: User's Xbox Live token obtained in the previous step.
** {{Nbt|string|RelyingParty}}: Replying party. This should be `rp://api.minecraftservices.com/`.
** {{Nbt|string|TokenType}}: Type of the access token. This should be `JWT`.
</div>

; Request (POST)
`https://xsts.auth.xboxlive.com/xsts/authorize`

SSL renegotiation required in SSL implementation.

; Response
<div class="treeview">
- {{Nbt|compound}} Root tag
** {{Nbt|string|IssueInstant}}: Time when obtaining the XSTS token.
** {{Nbt|string|NotAfter}}: Time the XSTS token is expired.
** {{Nbt|string|Token}}: XSTS access token.
** {{Nbt|compound|DisplayClaims}}: Unknown.
*** {{Nbt|list|xui}}: Unknown.
**** {{Nbt|compound}}
***** {{Nbt|string|uhs}}: User hashcode.
</div>

; Error
HTTP 401 is returned if an error occurs in obtaining the XSTS token.

### Obtain Minecraft access token with XSTS token

; Payload
<div class="treeview">
- {{Nbt|compound}} Root tag
** {{Nbt|string|identityToken}}: Identity token. The value should be `XBL3.0 x=<*User hashcode*>;<*XSTS access token*>`.
</div>

; Request (POST)
`https://api.minecraftservices.com/authentication/login_with_xbox`

; Response
<div class="treeview">
- {{Nbt|compound}} Root tag
** {{Nbt|string|username}}: UUID (not the UUID for the player)
** {{Nbt|list|roles}}: Unknown, empty.
** {{Nbt|string|access_token}}: Minecraft access token.
** {{Nbt|string|token_type}}: Token type. This is always `Bearer`.
** {{Nbt|string|expires_in}}: Time period until the token expires in seconds.
</div>

### Check if the account owns Minecraft

; Request header
`Authorization` should be `Bearer <*Minecraft access token*>`.

; Request (GET)
`https://api.minecraftservices.com/entitlements/license?requestId=<v4 UUID>`

; Response
If the account owns Minecraft, returns:
<div class="treeview">
- {{Nbt|compound}} Root tag
** {{Nbt|list|items}}: Products licensed to use.
*** {{Nbt|string|name}}: Data name, either `product_minecraft`, `game_minecraft`, `product_minecraft_bedrock` or `game_minecraft_bedrock`.
** {{Nbt|string|signature}}: JWT signature.
** {{Nbt|string|keyID}}: Unknown.
</div>

If the account does not own Minecraft or is playing with Xbox Game Pass, empty payload is returned.

## Player config

These endpoints are at `https://api.minecraftservices.com`, and all requires the `Authorization` header in request with value <samp>Bearer <*Minecraft access token*></samp>. HTTP 401 is returned if token is missing or invalid.

### Query player profile

; Request (GET)
`/minecraft/profile`

; Response
<div class="treeview">
- {{Nbt|compound}} Root tag
** {{Nbt|string|id}}: Player's UUID.
** {{Nbt|string|name}}: Player name.
** {{Nbt|list|skins}}: A list of info of all the skins the player owns.
*** {{Nbt|compound}}: A skin.
**** {{Nbt|string|id}}: Cape's UUID.
**** {{Nbt|string|state}}: Usage status for the cape.
**** {{Nbt|string|url}}: URL to the skin.
**** {{Nbt|string|variant}}: Skin variant. `CLASSIC` for the Steve model and `SLIM` for the Alex model.
** {{Nbt|list|capes}}: A list of info of all the capes the player owns.
*** {{Nbt|compound}}: A cape.
**** {{Nbt|string|id}}: Cape's UUID.
**** {{Nbt|string|state}}: Usage status for the cape.
**** {{Nbt|string|url}}: URL to the cape.
**** {{Nbt|string|alias}}: Alias for the cape.
</div>

### Query player attributes

; Request (GET)
`/player/attributes`

; Response
<div class="treeview">
- {{Nbt|compound}} Root tag
** {{Nbt|compound|privileges}}: Player's privileges
*** {{Nbt|compound|onlineChat}}: Privilege of accepting chat messages
**** {{Nbt|boolean|enable}}
*** {{Nbt|compound|multiplayerServer}}: Privilege of joining servers.
**** {{Nbt|boolean|enable}}
*** {{Nbt|compound|multiplayerRealms}}: Privilege of joining Realms.
**** {{Nbt|boolean|enable}}
*** {{Nbt|compound|telemetry}}: Privilege of sending telemetry.
**** {{Nbt|boolean|enable}}
*** {{Nbt|compound|optionalTelemetry}}: Privilege of sending optional telemetry.
**** {{Nbt|boolean|enable}}
** {{Nbt|compound|profanityFilterPreferences}}: Profanity filter settings.
*** {{Nbt|boolean|profanityFilterOn}}: If Realms profanity filter is on.
** {{Nbt|compound|banStatus}}: Player's ban status
*** {{Nbt|compound|bannedScopes}}: Scope in which the player is banned.
**** {{Nbt|compound}}: Ban scope. If the player is not banned, these objects do not exist. Only `MULTIPLAYER` exists.
***** {{Nbt|string|banId}}: UUID of the ban.
***** {{Nbt|string|expires}}: When the ban expires. This does not exist if the player is permanently banned.
***** {{Nbt|string|reason}}: Reason for the ban.
***** {{Nbt|string|reasonMessage}}: Ban message displayed.
</div>

### Modify player attributes

; Payload
<div class="treeview">
- {{Nbt|compound}} Root tag
** {{Nbt|compound|profanityFilterPreferences}}: Realms profanity filter options.
*** {{Nbt|boolean|profanityFilterOn}}: If filter is on.
</div>

; Request (POST)
`/player/attributes`

; Response
The same as [#Query player attributes](query-player-attributes.md).

### Get list of blocked users

; Request (GET)
`/privacy/blocklist`

; Response
<div class="treeview">
- {{Nbt|compound}} Root tag
** {{Nbt|list|blockedProfiles}}: A list of blocked players whose chat messages and Realms invitations are ignored.
*** {{Nbt|string}}: UUID for the blocked player.
</div>

### Get keypair for signature

; Request (POST)
`/player/certificates`

; Response
<div class="treeview">
- {{Nbt|compound}} Root tag
** {{Nbt|compound|keyPair}}: Keypair used for signature.
*** {{Nbt|string|privateKey}}: Private key. Starts with {{cd|-----BEGIN RSA PRIVATE KEY-----}} and ends with {{cd|-----END RSA PRIVATE KEY-----}}.
*** {{Nbt|string|publicKey}}: Public key. Starts with{{cd|-----BEGIN RSA PUBLIC KEY-----}} and ends with {{cd|-----END RSA PUBLIC KEY-----}}.
** {{Nbt|string|publicKeySignature}}: Deprecated, see below.
** {{Nbt|string|publicKeySignatureV2}}: Public key signature.
** {{Nbt|string|expiresAt}}: When the keypair expires.
** {{Nbt|string|refreshedAfter}}: When the keypair should be refreshed.
</div>

### Query player's name change information

; Request (GET)
`/minecraft/profile/namechange`

; Response
<div class="treeview">
- {{Nbt|compound}} Root tag
** {{Nbt|string|changedAt}}: The last time the name has been changed.
** {{Nbt|string|createdAt}}: The time the player profile is created.
** {{Nbt|boolean|nameChangeAllowed}}: If the player can change name.
</div>

### Check gift code validity

; Request (GET)
`/productvoucher/giftcode`

; Response
Returns HTTP 200 or 204 if the gift code is valid. Otherwise returns HTTP 404.

### Check name availability

; Request (GET)
`/minecraft/profile/name/<*name to be checked*>/available`

; Response
<div class="treeview">
- {{Nbt|compound}} Root tag
** {{Nbt|string|status}}: Status of the name. `DUPLICATE` means the name is taken. `AVAILABLE` means the name is available.`NOT_ALLOWED` means the name does not meet requirements.
</div>

### Change name

; Input
Name to change to

; Request (PUT)
`/minecraft/profile/name/<*name to change to*>`

; Response
<div class="treeview">
- {{Nbt|compound}} Root tag
** {{Nbt|string|id}}: Player's UUID.
** {{Nbt|string|name}}: Player name.
** {{Nbt|list|skins}}: A list of info of all the skins the player owns.
*** {{Nbt|compound}}: A skin.
**** {{Nbt|string|id}}: Cape's UUID.
**** {{Nbt|string|state}}: Usage status for the cape.
**** {{Nbt|string|url}}: URL to the skin.
**** {{Nbt|string|variant}}: Skin variant. `CLASSIC` for the Steve model and `SLIM` for the Alex model.
** {{Nbt|list|capes}}: A list of info of all the capes the player owns.
*** {{Nbt|compound}}: A cape.
**** {{Nbt|string|id}}: Cape's UUID.
**** {{Nbt|string|state}}: Usage status for the cape.
**** {{Nbt|string|url}}: URL to the cape.
**** {{Nbt|string|alias}}: Alias for the cape.
</div>

; Error
<table class="wikitable mw-collapsible mw-collapsed">
  <tbody>
    <tr>
      <th>HTTP status code</th>
      <th>{{cd|error}}</th>
      <th>{{cd|errorMessage}}</th>
      <th>Explanation</th>
    </tr>
    <tr>
      <td>400</td>
      <td>CONSTRAINT_VIOLATION</td>
      <td>changeProfileName.profileName: Invalid profile name</td>
      <td>Name does not meet requirement. The name must have less than or equal to 16 characters and must consist of alphanumericals and underscores.</td>
    </tr>
    <tr>
      <td>403</td>
      <td>(empty)</td>
      <td>Could not change name for profile</td>
      <td>Cannot change name. If `detail.status` is <samp>DUPLICATE</samp>, the name has already been taken.</td>
    </tr>
    <tr>
      <td>429</td>
      <td>-</td>
      <td>-</td>
      <td>To many rename requests sent.</td>
    </tr>
  </tbody>
</table>

### Change skin

; Payload
<div class="treeview">
- {{Nbt|compound}} Root tag
** {{Nbt|string|variant}}: Skin variant. `classic` for the Steve model and `slim` for the Alex model.
** {{Nbt|string|url}}: URL to the skin.
</div>

; Request (POST)
`/minecraft/profile/skins`

; Response
Returns [the profile](mojang-api.md#query-player-profile) if operation succeeds.

### Upload skin

; Payload
Payload is made up of two parts:

- {{cd|variant}}: Skin variant. `classic` for the Steve model and `slim` for the Alex model.
- {{cd|file}}: Image data for the new skin. See example below.

; Request (POST)
`/minecraft/profile/skins`

; Example
```bash
curl -X POST -H "Authorization: Bearer <access token>" -F variant=classic -F file="@steeevee.png;type=image/png" https://api.minecraftservices.com/minecraft/profile/skins
```

; Response
Returns [the profile](mojang-api.md#query-player-profile) if operation succeeds.

### Reset skin

; Input
Player's UUID.

; Request (DELETE)
`/minecraft/profile/skins/active`

; Response
Returns [the profile](mojang-api.md#query-player-profile) if operation succeeds.

### Hide cape

; Request (DELETE)
`/minecraft/profile/capes/active`

; Response
Returns [the profile](mojang-api.md#query-player-profile) if operation succeeds.

### Show cape

; Payload
<div class="treeview">
- {{Nbt|compound}} Root tag
** {{Nbt|string|capeId}}: UUID for the cape to activate
</div>

; Request (PUT)
`/minecraft/profile/capes/active`

; Response
Returns [the profile](mojang-api.md#query-player-profile) if operation succeeds.

; Error
<table class="wikitable mw-collapsible mw-collapsed">
  <tbody>
    <tr>
      <th>HTTP status code</th>
      <th>{{cd|error}}</th>
      <th>{{cd|errorMessage}}</th>
      <th>Explanation</th>
    </tr>
    <tr>
      <td>400</td>
      <td>(empty)</td>
      <td>profile does not own cape</td>
      <td>The player does not own the cape.</td>
    </tr>
  </tbody>
</table>

## Server

### Query blocked server list

; Request (GET)
`https://sessionserver.mojang.com/blockedservers`

; Response
A text file where every line is the SHA-1 hash of a blocked server. 

<!-- Commented out this statement because the GitHub link leads to a 404 error.
Servers known to be blocked can be found at [here](https://github.com/Reecepbcups/FollowTheEULA/blob/master/blockedServersList.txt). -->

### Verify login session on client

; Payload
<div class="treeview">
- {{Nbt|compound}} Root tag
** {{Nbt|string|accessToken}}: Minecraft access token.
** {{Nbt|string|selectedProfile}}: Player UUID without dashes.
** {{Nbt|string|serverId}}: Server ID. See below.
</div>

Server ID is obtained from the following algorithm: 

```java
public static String generateServerId(String baseServerId,   // Base server ID, usually an empty string""
                                      PublicKey publicKey,   // Server's RSA public key
                                      SecretKey secretKey    // The symmetric AES secret key used between server and client
                                     ) throws Exception { 
    MessageDigest messageDigest = MessageDigest.getInstance("SHA-1");
    messageDigest.update(baseServerId.getBytes("ISO_8859_1"));
    messageDigest.update(secretKey.getEncoded());
    messageDigest.update(publicKey.getEncoded());
    byte[] digestData = messageDigest.digest();
    return new BigInteger(digestData).toString(16);
}
```

; Request (POST)
`https://sessionserver.mojang.com/session/minecraft/join`

; Response
Returns HTTP 204 if authentication passes.

### Verify login session on server

; Input
Case insensitive player name, server ID obtained by the above algorithm and the client IP (optional).

; Request (GET)
`https://sessionserver.mojang.com/session/minecraft/hasJoined?username=<*player name*>&serverId=<*Server ID*>&ip=<*Client IP*>`

; Response
Returns [[#Query player's skin and cape|this payload]] if verification passes.

### Get Mojang public keys

; Request (GET)
`https://api.minecraftservices.com/publickeys`

; Response
<div class="treeview">
- {{Nbt|compound}} Root tag
** {{Nbt|list|profilePropertyKeys}}: A list of public keys used for verifying player properties (such as skin and cape textures), from e.g. `https://sessionserver.mojang.com/session/minecraft/profile/<*UUID*>?unsigned=false`. A player property is considered valid by the client iff signed by any of these keys.
*** {{Nbt|string}}: Base64-encoded DER public key.
** {{Nbt|list|playerCertificateKeys}}: A list of public keys used for verifying player public keys, e.g. from `https://api.minecraftservices.com/player/certificates`. A player certificate is considered valid by the client iff signed by any of these keys.
*** {{Nbt|string}}: Base64-encoded DER public key.
</div>

## History
{{HistoryTable
|{{HistoryLine||April 14, 2014|link=https://github.com/Mojang/AccountsClient|Mojang API is released.}}
|{{HistoryLine||November 2020|link=https://bugs.mojang.com/browse/WEB-3367|Endpoint for obtaining player UUID no longer supports the {{cd|at}} parameter.}}
|{{HistoryLine||October 8, 2021|link=https://bugs.mojang.com/browse/WEB-2303?focusedCommentId=1086543&page=com.atlassian.jira.plugin.system.issuetabpanels%3Acomment-tabpanel#comment-1086543|Endpoint for querying Mojang API status is removed. The endpoint was `https://status.mojang.com/check`.}}
|{{HistoryLine||May 8, 2022|link={{tweet|Mojang_Ined|1501541417784852484}}|Endpoint for querying Minecraft sales is removed. The endpoint was `https://api.mojang.com/orders/statistics`.}}
|{{HistoryLine||September 13, 2022|link=https://help.minecraft.net/hc/en-us/articles/8969841895693-Username-History-API-Removal-FAQ-|The endpoint for querying names a player used to use is removed. The endpoint was `https://api.mojang.com/user/profiles/<*UUID*>/names`.}}
|{{HistoryLine||January 15, 2025|link=https://bugs.mojang.com/browse/WEB-7591?focusedId=1375404&page=com.atlassian.jira.plugin.system.issuetabpanels%3Acomment-tabpanel#comment-1375404|The endpoint for querying UUIDs based on a player's name has experimental rate limits introduced. The endpoint is `https://api.mojang.com/users/profiles/minecraft/<*username*>/names`.}}
}}

## References
This article is partially adapted from [Mojang API](2777487.md) on wiki.vg.

## Examples
- [C#](https://github.com/hawezo/MojangSharp) - Full API wrapper
- [C#](https://github.com/CmlLib/MojangAPI) - Full API wrapper with Mojang/Microsoft Authentication
- [Dart](https://github.com/spnda/dart_minecraft) - Almost full API wrapper with Mojang Authentication
- [Go](https://github.com/Lukaesebrot/mojango) - Full API wrapper
- [Go](https://github.com/PhilipBorgesen/minecraft/tree/master/profile) - UUIDs or names to profiles with skins, capes and name histories
- [Python](https://github.com/summer/mojang) - Full API Wrapper. Also supports authentication & parts of the Minecraft website
- [Python](https://github.com/Lucino772/pymojang) - Pymojang is a full wrapper around de Mojang API and Mojang Authentication API. Also support RCON, Query and Server List Ping
- [Python](https://github.com/SynchronousX/mojang-api) - Full API wrapper (not updated since 2018)
- [Python](https://github.com/techkid6/AccountsClientPython) - UUIDs or names to profiles (not updated since 2018)
- [PHP](https://github.com/elyby/mojang-api) - Complete Mojang's API wrapper
- [PHP](https://github.com/Davidoc26/mojang-api) - Almost full API wrapper with Mojang Authentication. Also support head rendering
- [PHP](https://github.com/MineTheCube/MojangAPI) - UUIDs or names to profiles with skins, heads and name histories
- [PHP](https://gist.github.com/ezfe/a71feccd3a837a2592f1) - UUIDs to names
- [PHP](https://github.com/ozzyfant/AccountsClientPHP) - UUIDs to names, names to uuids
- [Java](https://github.com/SparklingComet/java-mojang-api) - Almost full API Wrapper
- [Java](https://github.com/dpkgsoft/mojang) - Almost full API Wrapper with auth
- [Java](https://github.com/novastosha/NMoyang) - Almost full API with Mojang Authentication and can also work as a console Application.
- [JavaScript](https://github.com/thechunknetwork/mojang-api) - UUIDs or names to profiles with skins, capes and name histories
- [JavaScript/TypeScript](https://github.com/lukasabbe/Mojang-API-wrapper) - Almost full API wrapper

## References
{{reflist}}

## Navigation
{{Navbox Java Edition technical|General}}
[Category:Java Edition protocol](category-java-edition-protocol.md)
_Content is licensed under wiki.vg terms._

[de:Mojang API](de-mojang-api.md)
[zh:Mojang API](zh-mojang-api.md)
