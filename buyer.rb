require "net/http"
require "uri"
require "openssl"
require "json"

key = ENV["BITFLYER_API_KEY"]
secret = ENV["BITFLYER_API_SECRET"]

timestamp = Time.now.to_i.to_s
method = "POST"
uri = URI.parse("https://api.bitflyer.jp")
uri.path = "/v1/me/sendchildorder"

body = {
  product_code: "BTC_JPY",
  child_order_type: "MARKET",
  side: "BUY",
  size: 0.05
}.to_json

text = timestamp + method + uri.request_uri + body
sign = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha256"), secret, text)

options = Net::HTTP::Post.new(uri.request_uri, initheader = {
  "ACCESS-KEY" => key,
  "ACCESS-TIMESTAMP" => timestamp,
  "ACCESS-SIGN" => sign,
  "Content-Type" => "application/json"
});
options.body = body

https = Net::HTTP.new(uri.host, uri.port)
https.use_ssl = true
response = https.request(options)
puts response.body
