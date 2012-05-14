Gem::Specification.new do |s|
  s.name              = "net-http-auth-hmac"
  s.version           = "0.0.1"
  s.summary           = "HMAC base identity authentication"
  s.description       = "Exchanges a digest to be validated against a token"
  s.authors           = ["elcuervo"]
  s.email             = ["yo@brunoaguirre.com"]
  s.homepage          = "http://github.com/elcuervo/net-http-auth-hmac"
  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files test`.split("\n")
end
