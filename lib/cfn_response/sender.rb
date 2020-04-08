require "net/http"
require "uri"

class CfnResponse
  class Sender < Base
    def call(response_data)
      puts "Sending #{response_data["Status"]} Status to CloudFormation"
      url = @event['ResponseURL']
      http_request(url, response_data)
    end

    def http_request(url, response_data)
      uri = URI(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == "https"
      http.max_retries = 1 # Default is already 1, just being explicit
      http.open_timeout = http.read_timeout = 20

      # must used url to include the AWSAccessKeyId and Signature
      req = Net::HTTP::Put.new(url) # url includes query string and uri.path does not

      body = JSON.dump(response_data)
      req.body = body
      req.content_length = body.bytesize
      # set headers
      req['content-type'] = ''
      req['content-length'] = body.bytesize

      res = http.request(req)
      puts "status code: #{res.code}"
      puts "headers: #{res.each_header.to_h.inspect}"
      puts "body: #{res.body}"
      res
    end
  end
end
