# net-http-auth-hmac

![HMAC](http://www.gmkfreelogos.com/logos/H/img/HMAC.gif)

Signs a request with given token to be validated in the backend.

## Usage

Sending a request

```ruby
uri = URI.parse("http://google.com/")
http = Net::HTTP.new(uri.host, uri.port)

signer = Net::HTTP::Auth::HMAC.new('super_secret_secret')
request = Net::HTTP::Post.new('/somewhere')
request.body = 'super_secret_value=42'

signed_request = signer.sign_request(request)
http.request request
```

Receiving a request

```ruby
signer = Net::HTTP::Auth::HMAC.new('super_secret_secret')
unsigned_request = signer.unsign_request(request)
request.body
```

## Installation
```bash
gem install net-http-auth-hmac
```
