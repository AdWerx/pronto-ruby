require 'json'
require 'net/http'

class Client

  attr_reader :token,
              :http

  def initialize(token: ENV.fetch('GITHUB_TOKEN'))
    @token = token
    @http = Net::HTTP.new('api.github.com', 443)
    http.use_ssl = true
  end

  def post(path, body, headers = {})
    http.post(path, body.to_json, headers.merge(perma_headers)).tap do |resp|
      fail resp.message if resp.code.to_i >= 300
    end
  end

  def patch(path, body, headers = {})
    http.patch(path, body.to_json, headers.merge(perma_headers)).tap do |resp|
      fail resp.message if resp.code.to_i >= 300
    end
  end

  private

  def perma_headers
    @perma_headers ||= {
      "Content-Type": 'application/json',
      "Accept": 'application/vnd.github.antiope-preview+json',
      "Authorization": "Bearer #{token}",
      "User-Agent": 'adwerx/pronto-ruby'
    }
  end

end
