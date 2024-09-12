require "http/client"
require "json"
require "log"

module Authenticator
  extend self

  CLIENT_ID = "00000000441cc96b" # Nintendo Switch client ID
  SCOPE     = "service::user.auth.xboxlive.com::MBI_SSL"

  alias AuthToken = NamedTuple(access_token: String, refresh_token: String)
  alias AuthResult = NamedTuple(access_token: String, refresh_token: String, profile: JSON::Any)

  class Error < Exception; end

  # Sends a join request to mojang session server
  def server_auth(uuid : String, access_token : String, server_hash : String)
    response = HTTP::Client.post(
      "https://sessionserver.mojang.com/session/minecraft/join",
      headers: HTTP::Headers{"Content-Type" => "application/json"},
      body: {
        "accessToken"     => access_token,
        "selectedProfile" => uuid,
        "serverId"        => server_hash,
      }.to_json
    )

    unless response.status.success?
      Log.debug { "Session authentication failed; Body:\n#{response.body}" }
      raise "Failed to authenticate with sessionserver: Got #{response.status_code} (#{response.status})"
    end
  end

  def auth(email : String, refresh_token : String? = nil) : AuthResult
    # Get Microsoft token
    msa_token = if refresh_token.is_a?(String)
                  begin
                    refresh_ms_auth_token(refresh_token)
                  rescue Error
                    Log.warn { "'refresh_ms_auth_token' failed; Refresh token might have expired. Using 'interactive_get_ms_auth_token' as fallback" }
                    interactive_get_ms_auth_token(email)
                  end
                else
                  interactive_get_ms_auth_token(email)
                end

    access_token = msa_token[:access_token]
    refresh_token = msa_token[:refresh_token]

    # Authenticate with Xbox Live
    xbl_auth = auth_with_xbox_live(access_token)

    # Obtain XSTS token for Minecraft
    xsts_token = obtain_xsts_for_minecraft(xbl_auth["Token"].as_s)

    # Authenticate with Minecraft
    mca_token = auth_with_minecraft(xbl_auth["DisplayClaims"]["xui"][0]["uhs"].as_s, xsts_token)

    # Get profile
    profile = get_profile(mca_token)

    return {
      access_token:  mca_token,
      refresh_token: refresh_token,
      profile:       profile,
    }
  end

  private def interactive_get_ms_auth_token(email : String) : AuthToken
    response = HTTP::Client.post(
      "https://login.live.com/oauth20_connect.srf",
      form: {
        "scope"         => SCOPE,
        "client_id"     => CLIENT_ID,
        "response_type" => "device_code",
      }
    )
    device_code_data = JSON.parse(response.body)

    puts "Go to #{device_code_data["verification_uri"].as_s} and enter the code #{device_code_data["user_code"].as_s} for #{email}"

    expires_in = device_code_data["expires_in"].as_i
    interval = device_code_data["interval"].as_i

    expires_at = Time.utc + expires_in.seconds

    while Time.utc < expires_at
      sleep interval.seconds

      response = HTTP::Client.post(
        "https://login.live.com/oauth20_token.srf",
        form: {
          "client_id"   => CLIENT_ID,
          "device_code" => device_code_data["device_code"].as_s,
          "grant_type"  => "urn:ietf:params:oauth:grant-type:device_code",
        }
      )

      if response.status_code == 200
        json = JSON.parse(response.body)
        return {
          access_token:  json["access_token"].as_s,
          refresh_token: json["refresh_token"].as_s,
        }
      end
    end

    raise Error.new("Authentication timed out")
  end

  private def refresh_ms_auth_token(refresh_token : String) : AuthToken
    response = HTTP::Client.post(
      "https://login.live.com/oauth20_token.srf",
      form: {
        "client_id"     => CLIENT_ID,
        "scope"         => SCOPE,
        "grant_type"    => "refresh_token",
        "refresh_token" => refresh_token,
      }
    )

    if response.status_code == 200
      return {
        access_token:  JSON.parse(response.body)["access_token"].as_s,
        refresh_token: refresh_token,
      }
    end

    raise Error.new("Authentication failed at 'refresh_ms_auth_token'")
  end

  private def auth_with_xbox_live(access_token : String) : JSON::Any
    response = HTTP::Client.post(
      "https://user.auth.xboxlive.com/user/authenticate",
      headers: HTTP::Headers{"Content-Type" => "application/json"},
      body: {
        "Properties" => {
          "AuthMethod" => "RPS",
          "SiteName"   => "user.auth.xboxlive.com",
          "RpsTicket"  => access_token,
        },
        "RelyingParty" => "http://auth.xboxlive.com",
        "TokenType"    => "JWT",
      }.to_json
    )
    JSON.parse(response.body)
  end

  private def obtain_xsts_for_minecraft(xbl_auth_token : String) : String
    response = HTTP::Client.post(
      "https://xsts.auth.xboxlive.com/xsts/authorize",
      headers: HTTP::Headers{"Content-Type" => "application/json"},
      body: {
        "Properties" => {
          "SandboxId"  => "RETAIL",
          "UserTokens" => [xbl_auth_token],
        },
        "RelyingParty" => "rp://api.minecraftservices.com/",
        "TokenType"    => "JWT",
      }.to_json
    )
    JSON.parse(response.body)["Token"].as_s
  end

  private def auth_with_minecraft(user_hash : String, xsts_token : String) : String
    response = HTTP::Client.post(
      "https://api.minecraftservices.com/authentication/login_with_xbox",
      headers: HTTP::Headers{"Content-Type" => "application/json"},
      body: {
        "identityToken" => "XBL3.0 x=#{user_hash};#{xsts_token}",
      }.to_json
    )
    JSON.parse(response.body)["access_token"].as_s
  end

  private def get_profile(minecraft_access_token : String) : JSON::Any
    response = HTTP::Client.get(
      "https://api.minecraftservices.com/minecraft/profile",
      headers: HTTP::Headers{"Authorization" => "Bearer #{minecraft_access_token}"}
    )
    JSON.parse(response.body)
  end
end
