require 'openssl'
require 'net/http'
require 'base64'

class Net::HTTP
  class Auth
    class HMAC
      def initialize(shared_secret)
        @secret = shared_secret
      end

      def sign_request(request)
        raise BodyNotFound if !request.body
        request.body = base64_encode(request.body)
        request['X-HMAC-Digest'] = base64_encode(signature(request.body))
        request
      end

      def unsign_request(request)
        raise DigestNotFound if !request['X-HMAC-Digest']
        request_signature = base64_decode(request['X-HMAC-Digest'])
        raise InvalidSignature if request_signature != signature(request.body)

        request.body = base64_decode(request.body)
        request
      end

      private

      def signature(payload)
        OpenSSL::HMAC.digest('sha256', @secret, payload)
      end

      def base64_encode(string)
        Base64.urlsafe_encode64(string)
      end

      def base64_decode(string)
        Base64.urlsafe_decode64(string)
      end
    end
  end
end


class Net::HTTP::Auth::HMAC
  class InvalidSignature < StandardError
    def message
      "The X-HMAC-Digest it's invalid"
    end
  end

  class BodyNotFound < StandardError
    def message
      "The body of the request it's missing"
    end
  end

  class DigestNotFound < StandardError
    def message
      "The X-HMAC-Digest it's missing"
    end
  end
end
