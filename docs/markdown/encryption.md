> **Note:** This content is exclusive to the Java Edition.
This article describes the **encryption** used by the [*Java Edition* protocol](java-edition-protocol.md).

## Overview
1. **C**→**S**: [Handshake](packets.md#handshake) State=2
1. **C**→**S**: [Login Start](packets.md#login-start)
1. **S**→**C**: [Encryption Request](packets.md#encryption-request)
1. *Client authentication (if enabled)*
1. **C**→**S**: [Encryption Response](packets.md#encryption-response)
1. *Server authentication (if enabled)*
1. *Both enable encryption*
1. **S**→**C**: [Login Success](packets.md#login-success)

See [Protocol FAQ](faq.md) for a full list of packets exchanged after encryption.

## Server ID String
**Update (1.7.x):** The server ID is now sent as an empty string. Hashes also utilize the public key, so they will still be correct.

**Pre-1.7.x:**
The server ID string is a randomly-generated string of characters with a maximum length of 20 code points (the client disconnects with an exception if the length is longer than 20).

The client appears to arrive at incorrect hashes if the server ID string contains certain unprintable characters, so for consistent results only characters with code points in the range U+0021-U+007E (inclusive) should be sent.  This range corresponds to all of ASCII with the exception of the space character (U+0020) and all control characters (U+0000-U+001F, U+007F).

The client appears to arrive at incorrect hashes if the server ID string is too short.  15 to 20 (inclusive) length strings have been observed from the vanilla server and confirmed to work as of 1.5.2.

## Key Exchange

The server generates a 1024-bit RSA keypair on startup. The public key sent in the Encryption Request packet is encoded in [ASN.1](https://en.wikipedia.org/wiki/ASN.1) [DER](https://en.wikipedia.org/wiki/X.690#DER_encoding) format. This is a general-purpose binary format common in cryptography, conceptually similar to [NBT](nbt.md). The schema is the same as the `SubjectPublicKeyInfo` structure defined by [X.509](https://en.wikipedia.org/wiki/X.509) (not a full-blown X.509 certificate!):

 SubjectPublicKeyInfo ::= SEQUENCE {
   algorithm SEQUENCE {
     algorithm         OBJECT IDENTIFIER
     parameters        ANY OPTIONAL
   }
   subjectPublicKey  BIT STRING
 }
 
 SubjectPublicKey ::= SEQUENCE {
   modulus           INTEGER
   publicExponent    INTEGER
 }

(See the [#External links](external-links.md) section of this article for further information.)

If you're struggling to import this using a crypto library, try to find a function that loads a DER encoded public key. If you can't find one, you can convert it to the more common PEM encoding by base64-encoding the raw bytes and wrapping the base64 text in '-----BEGIN PUBLIC KEY-----' and '-----END PUBLIC KEY-----'. See this example of a PEM encoded key: https://git.io/v7Ol9

It is also possible for a modified or custom server to use a longer RSA key, without breaking official clients.

## Symmetric Encryption

When it receives an Encryption Request from the server, the client will generate a random 16-byte (128-bit) shared secret, to be used with the AES/CFB8 stream ciphers. It then encrypts the shared secret and verify token with the server's public key (PKCS#1 v1.5 padded), and sends both to the server in an Encryption Response packet. Both byte arrays in the Encryption Response packet will be 128 bytes long because of the padding. This is the only time the client uses the server's public key.

> ⚠️ **Warning:** In your crypto library, ensure that you set up your "feedback/segment size" to 8 bits or 1 byte, as indicated in the name AES/CFB**8**. Any other feedback size will result in encryption mismatch.

The server decrypts the shared secret and token using its private key, and checks if the token is the same. It then enables AES/CFB8 encryption and sends the Login Success packet encrypted. The server makes two ciphers, one for encryption and one for decryption, with the key and initial vector (IV) both set to the shared secret. The client does the same, setting up its own two ciphers identically. From this point forward, everything is encrypted, including the length field, packet ID, and data length (if compression is enabled).

> ⚠️ **Warning:** Note that the AES cipher is updated continuously, not finished and restarted every packet.

## Authentication

If enabled during [Encryption Request](packets.md#encryption-request), both server and client need to make a request to sessionserver.mojang.com.

### Client

After generating the shared secret, the client generates the following hash:

 sha1 := Sha1()
 sha1.update(ASCII encoding of the server id string from Encryption Request) 
 sha1.update(shared secret) 
 sha1.update(server's encoded public key from Encryption Request) 
 hash := sha1.hexdigest()  # String of hex characters
{{Warning|Note that the Sha1.hexdigest() method used by Minecraft is non standard. It doesn't match the digest method found in most programming languages and libraries. It works by treating the sha1 output bytes as one large integer in two's complement and then printing the integer in base 16, placing a minus sign if the interpreted number is negative. Here are some examples of Minecraft's hexdigest:
 sha1(Notch) :  4ed1f46bbe04bc756bcb17c0c7ce3e4632f06a48
 sha1(jeb_)  : -7c9d5b0044c130109a5d7b5fb5c317c02b4e28c1
 sha1(simon) :  88e16a1019277b15d58faf0541e11910eb756f6
}}

The resulting hash is then sent via an HTTP POST request to
 https://sessionserver.mojang.com/session/minecraft/join
With the following sent as post data. You *must* have the Content-Type header set to application/json or you will get a 415 Unsupported Media Type or 403 Forbidden response.
```javascript
  {
    "accessToken": "<accessToken>",
    "selectedProfile": "<player's uuid without dashes>",
    "serverId": "<serverHash>"
  }
```

The fields <accessToken> and the player's uuid were received by the client during [authentication](microsoft-authentication.md#authenticate-with-minecraft).

If everything goes well, the client will receive a "204 No Content" response.

The server will respond with "403 Forbidden" if the player's Xbox profile has multiplayer disabled, with the following response:
```javascript
{
    "error": "InsufficientPrivilegesException",
    "path": "/session/minecraft/join"
}
```

Similarly, if the player was banned from Multiplayer then the server will respond with the following error:
```javascript
{
    "error": "UserBannedException",
    "path": "/session/minecraft/join",
    "errorMessage": "Human readable error description."
}
```

If you forget to include a body with your request and just send an empty POST request, or if you use a malformed Content-Type header, you'll get this non-descriptive error:
```javascript
{
    "error": "Forbidden",
    "path": "/session/minecraft/join"
}
```

### Server

After decrypting the shared secret in the second Encryption Response, the server generates the login hash as above and sends a HTTP GET to
 https://sessionserver.mojang.com/session/minecraft/hasJoined?username=*username*&serverId=*hash*&ip=*ip*

The username is case insensitive and must match the client's username (which was received in the Login Start packet). Note that this is the in-game nickname of the selected profile, not the Mojang account name (which is never sent to the server).
Servers should use the name sent in the "name" field.

The ip field is optional and when present should be the IP address of the connecting player; it is the one that originally initiated the session request. The vanilla server includes this only when `prevent-proxy-connections` is set to true in server.properties.

The response is a JSON object containing the user's UUID and skin blob
```javascript
{
    "id": "<profile identifier>",
    "name": "<player name>",
    "properties": [ 
        {
            "name": "textures",
            "value": "<base64 string>",
            "signature": "<base64 string; signed data using Yggdrasil's private key>"
        }
    ]
}
```

The "id" and "name" fields are then sent back to the client using a Login Success packet. The profile id in the json response has format
"11111111222233334444555555555555" which needs to be changed into format "11111111-2222-3333-4444-555555555555" before sending it back to the client.

### Sample Code

Examples of generating Minecraft-style hex digests:

- C++: https://git.io/JfTkx
- C#: https://git.io/fhjp6
- Go: http://git.io/-5ORag
- Java: http://git.io/vzbmS
- node.js: http://git.io/v2ue_A
- PHP: https://git.io/fxcFY
- Python: https://git.io/vQFUL
- Rust: https://git.io/fj6P0

## History
{{HistoryTable
|{{HistoryLine|Java Edition}}
|{{HistoryLine||1.3.1|dev=12w17a|Encryption of the protocol is introduced for online-mode servers.}}
|{{HistoryLine||1.20.5|dev=24w03a|Protocol encryption can now be used in offline mode.}}
}}

## External links
- [DER Encoding of ASN.1 Types](https://msdn.microsoft.com/en-us/library/windows/desktop/bb648640(v=vs.85).aspx)
- [A Layman's Guide to a Subset of ASN.1, BER, and DER](http://luca.ntop.org/Teaching/Appunti/asn1.html)
- [Serializing an RSA Key Manually](https://gist.github.com/Lazersmoke/9947ada8acdd74a8b2e37d77cf1e0fdc)
- [Encryption using OpenSSL v3.0 functions (no clientside functions for making Encryption Request)](https://gist.github.com/ZWORX52/91b244b313e5210ba07023be9caaef5a)
- [Encrypt shared secret using OpenSSL (old)](https://gist.github.com/3900517)
- [Generate RSA-Keys and building the ASN.1v8 structure of the x.509 certificate using Crypto++](http://pastebin.com/8eYyKZn6)
- [Decrypt shared secret using Crypto++](http://pastebin.com/7Jvaama1)
- [De/Encrypt data via AES using Crypto++](http://pastebin.com/MjvR0T98)
- [C# AES/CFB support with bouncy castle on Mono](https://github.com/SirCmpwn/Craft.Net/blob/master/source/Craft.Net.Networking/AesStream.cs)

## Navigation
{{Navbox Java Edition technical|General}}

[Category:Protocol Details](category-protocol-details.md)
[Category:Java Edition protocol](category-java-edition-protocol.md)
_Content is licensed under wiki.vg terms._
