require 'openssl'
require "test/unit"

class TestCertificate < Test::Unit::TestCase
  def setup
    cert_file = File.expand_path('fixture/selfcert.pem', File.dirname(__FILE__))
    key_file = File.expand_path('fixture/keypair.pem', File.dirname(__FILE__))
    @cert = OpenSSL::X509::Certificate.new(File.read(cert_file))
    @key = OpenSSL::PKey::RSA.new(File.read(key_file))
  end

  def test_sign_for_pem_initialized_certificate
    pem = @cert.to_pem
    exts = @cert.extensions
    assert_nothing_raised do
      @cert.sign(@key, OpenSSL::Digest::SHA1.new)
    end
    # TODO: for now, jruby-openssl cannot keep order of extensions after sign.
    # assert_equal(pem, @cert.to_pem)
    assert_equal(exts.size, @cert.extensions.size)
    exts.each do |ext|
      found = @cert.extensions.find { |e| e.oid == ext.oid }
      assert_not_nil(found)
      assert_equal(ext.value, found.value)
    end
  end

  def test_set_public_key
    pkey = @cert.public_key
    newkey = OpenSSL::PKey::RSA.new(1024)
    @cert.public_key = newkey
    assert_equal(newkey.public_key.to_pem, @cert.public_key.to_pem)
  end

  # JRUBY-3468
  def test_jruby3468
    pem_cert = <<END
-----BEGIN CERTIFICATE-----
MIIC/jCCAmegAwIBAgIBATANBgkqhkiG9w0BAQUFADBNMQswCQYDVQQGEwJKUDER
MA8GA1UECgwIY3Rvci5vcmcxFDASBgNVBAsMC0RldmVsb3BtZW50MRUwEwYDVQQD
DAxodHRwLWFjY2VzczIwHhcNMDcwOTExMTM1ODMxWhcNMDkwOTEwMTM1ODMxWjBN
MQswCQYDVQQGEwJKUDERMA8GA1UECgwIY3Rvci5vcmcxFDASBgNVBAsMC0RldmVs
b3BtZW50MRUwEwYDVQQDDAxodHRwLWFjY2VzczIwgZ8wDQYJKoZIhvcNAQEBBQAD
gY0AMIGJAoGBALi66ujWtUCQm5HpMSyr/AAIFYVXC/dmn7C8TR/HMiUuW3waY4uX
LFqCDAGOX4gf177pX+b99t3mpaiAjJuqc858D9xEECzhDWgXdLbhRqWhUOble4RY
c1yWYC990IgXJDMKx7VAuZ3cBhdBxtlE9sb1ZCzmHQsvTy/OoRzcJCrTAgMBAAGj
ge0wgeowDwYDVR0TAQH/BAUwAwEB/zAxBglghkgBhvhCAQ0EJBYiUnVieS9PcGVu
U1NMIEdlbmVyYXRlZCBDZXJ0aWZpY2F0ZTAdBgNVHQ4EFgQUJNE0GGaRKmN2qhnO
FyBWVl4Qj6owDgYDVR0PAQH/BAQDAgEGMHUGA1UdIwRuMGyAFCTRNBhmkSpjdqoZ
zhcgVlZeEI+qoVGkTzBNMQswCQYDVQQGEwJKUDERMA8GA1UECgwIY3Rvci5vcmcx
FDASBgNVBAsMC0RldmVsb3BtZW50MRUwEwYDVQQDDAxodHRwLWFjY2VzczKCAQEw
DQYJKoZIhvcNAQEFBQADgYEAH11tstSUuqFpMqoh/vM5l3Nqb8ygblbqEYQs/iG/
UeQkOZk/P1TxB6Ozn2htJ1srqDpUsncFVZ/ecP19GkeOZ6BmIhppcHhE5WyLBcPX
It5q1BW0PiAzT9LlEGoaiW0nw39so0Pr1whJDfc1t4fjdk+kSiMIzRHbTDvHWfpV
nTA=
-----END CERTIFICATE-----
END

    cert   = OpenSSL::X509::Certificate.new(pem_cert)
    key_id = cert.extensions[2]

    assert_equal "24:D1:34:18:66:91:2A:63:76:AA:19:CE:17:20:56:56:5E:10:8F:AA", key_id.value
  end

  # JRUBY-5060
  def test_to_pem_with_empty_object
    empty_cert = "MCUwGwIAMAMGAQAwADAEHwAfADAAMAgwAwYBAAMBADADBgEAAwEA"
    empty_req = "MBowEAIAMAAwCDADBgEAAwEAoAAwAwYBAAMBAA=="
    empty_crl = "MBMwCTADBgEAMAAfADADBgEAAwEA"
    empty_key = "MAA="
    #assert_equal(empty_cert, OpenSSL::X509::Certificate.new.to_pem.split("\n")[1])
    #assert_equal(empty_req, OpenSSL::X509::Request.new.to_pem.split("\n")[1])
    #assert_equal(empty_crl, OpenSSL::X509::CRL.new.to_pem.split("\n")[1])
    assert_nothing_raised do
      OpenSSL::X509::Certificate.new.to_pem
    end
    assert_nothing_raised do
      OpenSSL::X509::Request.new.to_pem
    end
    assert_nothing_raised do
      OpenSSL::X509::CRL.new.to_pem
    end
    assert_equal(empty_key, OpenSSL::PKey::RSA.new.to_pem.split("\n")[1].chomp)
    assert_equal(empty_key, OpenSSL::PKey::DSA.new.to_pem.split("\n")[1].chomp)
    assert_equal(empty_key, OpenSSL::PKey::DH.new.to_pem.split("\n")[1].chomp)
  end

  # JRUBY-5096
  def test_verify_failed_by_lazy_public_key_initialization
    msg = 'hello,world'
    digester = OpenSSL::Digest::SHA1.new
    sig = @key.sign(digester, msg)
    assert(@cert.public_key.verify(digester, sig, msg))
    assert(@cert.verify(@cert.public_key))
  end
end
