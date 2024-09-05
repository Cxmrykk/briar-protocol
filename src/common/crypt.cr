require "big"
require "openssl"
require "random/secure"

require "../buffer"

module Crypt
  extend self

  # Generates a new 16-byte shared secret
  def generate_shared_secret
    Random::Secure.random_bytes(16)
  end

  # Creates an encryption cipher using the secret provided
  def encryptor(cipher : String, key : Bytes)
    cipher = OpenSSL::Cipher.new(cipher)
    cipher.encrypt
    cipher.key = key
    cipher.iv = key
    cipher
  end

  # Creates a decryption cipher using the secret provided
  def decryptor(cipher : String, key : Bytes)
    cipher = OpenSSL::Cipher.new(cipher)
    cipher.decrypt
    cipher.key = key
    cipher.iv = key
    cipher
  end

  # Encrypts data using the cipher provided
  def encrypt(cipher : OpenSSL::Cipher, data : Bytes)
    io = IO::Memory.new
    io.write(cipher.update(data))
    io.write(cipher.final)
    io.rewind
    io.to_slice
  end

  # Decrypts data using the cipher provided
  def decrypt(cipher : OpenSSL::Cipher, data : Bytes)
    io = IO::Memory.new
    io.write(cipher.update(data))
    io.write(cipher.final)
    io.rewind
    io.to_slice
  end

  # Generates a server hash for authentication with custom hexadecimal representation
  def generate_server_hash(server_id : String, shared_secret : Bytes, public_key : Bytes)
    digest = OpenSSL::Digest::SHA1.new
    digest << server_id.encode("ISO-8859-1") # ASCII encoding
    digest << shared_secret
    digest << public_key

    # Calculate the final hash
    hash = digest.final

    # Check for negative hashes (most significant bit is sign bit)
    negative = (hash[0] & 0x80) != 0

    if negative
      perform_twos_complement(hash)
    end

    digest = hash.hexstring

    # Trim leading zeroes
    digest = digest.sub(/^0+/, "")

    negative ? "-#{digest}" : digest
  end

  private def perform_twos_complement(buffer : Bytes)
    carry = true
    (buffer.size - 1).downto(0) do |i|
      value = buffer[i].to_u8
      new_byte = (~value) & 0xff
      if carry
        carry = new_byte == 0xff_u8
        buffer[i] = (new_byte &+ 1).to_u8
      else
        buffer[i] = new_byte
      end
    end
  end
end
