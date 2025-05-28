require "file_utils"
require "openssl/cipher"
require "digest/sha256"
require "base64"
require "log"

#
# Currently only in use by the client; Stores login credentials (access token)
# 

module Disk
  extend self

  APP_NAME         = "briar-protocol"
  CIPHER_ALGORITHM = "AES-256-CBC"

  Log = ::Log.for(self)

  def read_token?(email : String, password : String) : String?
    filename = hash_email(email)
    path = File.join(write_cache_dir, filename)

    unless File.exists?(path)
      Log.debug { "Token file not found for email: #{email}" }
      return nil
    end

    encrypted_content = File.read(path)
    decrypt(encrypted_content, password)
  rescue e : OpenSSL::Cipher::Error
    Log.debug { "Failed to decrypt token: #{e.message}" }
    nil
  rescue e : Exception
    Log.debug { "Unexpected error reading token: #{e.message}" }
    nil
  end

  def write_token(email : String, password : String, refresh_token : String)
    filename = hash_email(email)
    path = File.join(write_cache_dir, filename)

    encrypted_content = encrypt(refresh_token, password)
    File.write(path, encrypted_content)
  rescue e : Exception
    Log.error { "Failed to write token: #{e.message}" }
  end

  def write_cache_dir : String
    base = case
           when ENV["XDG_CACHE_HOME"]?
             ENV["XDG_CACHE_HOME"]
           when ENV["HOME"]?
             File.join(ENV["HOME"], ".cache")
           when ENV["APPDATA"]? # Windows
             ENV["APPDATA"]
           else
             File.join(Dir.current, ".cache")
           end

    path = File.join(base, APP_NAME)
    FileUtils.mkdir_p(path)
    path
  end

  private def hash_email(email : String) : String
    Digest::SHA256.hexdigest(email)
  end

  private def encrypt(data : String, password : String) : String
    cipher = OpenSSL::Cipher.new(CIPHER_ALGORITHM)
    cipher.encrypt
    key = OpenSSL::PKCS5.pbkdf2_hmac(password, "salt", iterations: 10000, key_size: 32, algorithm: OpenSSL::Algorithm::SHA256)
    cipher.key = key
    iv = cipher.random_iv

    io = IO::Memory.new
    io.write(cipher.update(data))
    io.write(cipher.final)

    Base64.strict_encode(iv + io.to_slice)
  end

  private def decrypt(encrypted_data : String, password : String) : String
    cipher = OpenSSL::Cipher.new(CIPHER_ALGORITHM)
    cipher.decrypt
    key = OpenSSL::PKCS5.pbkdf2_hmac(password, "salt", iterations: 10000, key_size: 32, algorithm: OpenSSL::Algorithm::SHA256)
    cipher.key = key

    begin
      data = Base64.decode(encrypted_data)
    rescue e : Base64::Error
      raise "Invalid Base64 encoding: #{e.message}"
    end

    if data.size < cipher.iv_len
      raise "Encrypted data is too short (#{data.size} bytes), expected at least #{cipher.iv_len} bytes for IV"
    end

    iv = data[0, cipher.iv_len]
    cipher.iv = iv

    begin
      io = IO::Memory.new
      io.write(cipher.update(data[cipher.iv_len, data.size - cipher.iv_len]))
      io.write(cipher.final)
      io.to_s
    rescue e : OpenSSL::Cipher::Error
      raise "Decryption failed: #{e.message}"
    end
  end
end
