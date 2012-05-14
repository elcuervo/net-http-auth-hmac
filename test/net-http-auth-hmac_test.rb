$: << File.join(File.dirname(__FILE__), '../lib')
require 'test/unit'
require 'net/http'
require 'net/http/auth/hmac'

class TestNetHTTPAuthHMAC < Test::Unit::TestCase
  def setup
    @body = 'Once upon a midnight dreary, while I pondered weak and weary'
    @request = Net::HTTP::Post.new('/signed')
    @request.body = @body
  end

  def test_sending_and_unsigning_a_request
    secret = 'changeme'
    signer = Net::HTTP::Auth::HMAC.new(secret)
    signed_request = signer.sign_request(@request)

    assert signed_request.is_a?(Net::HTTP::Post)
    assert signed_request['X-HMAC-Digest']
    assert signed_request.body != @body

    unsigned_request = signer.unsign_request(signed_request)
    assert_equal unsigned_request.body, @body
  end

  def test_raising_an_error_when_the_header_is_missing
    signer = Net::HTTP::Auth::HMAC.new('one')
    request = Net::HTTP::Post.new('/somewhere')
    request.body = 'something'

    assert_raise Net::HTTP::Auth::HMAC::DigestNotFound do
      signer.unsign_request(request)
    end
  end

  def test_raising_an_error_when_the_body_is_missing
    signer = Net::HTTP::Auth::HMAC.new('one')
    request = Net::HTTP::Post.new('/somewhere')

    assert_raise Net::HTTP::Auth::HMAC::BodyNotFound do
      signer.sign_request(request)
    end
  end

  def test_raising_an_error_when_the_signature_is_invalid
    one = Base64.urlsafe_encode64('one')
    two = Base64.urlsafe_encode64('two')

    signer = Net::HTTP::Auth::HMAC.new(one)
    signed_request = signer.sign_request(@request)
    signed_request['X-HMAC-Digest'] = two

    assert_raise Net::HTTP::Auth::HMAC::InvalidSignature  do
      signer.unsign_request(signed_request)
    end
  end
end
