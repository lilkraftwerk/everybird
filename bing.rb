require 'httparty'
require 'pry'
require 'json'
require 'net/http'

class BirdDownloader
  def initialize
    @BASE_URL = "https://api.cognitive.microsoft.com/bing/v5.0/images/search"
    @headers = { "Ocp-Apim-Subscription-Key" => BING_KEY_2 }
    @options = {
      "mkt" => 'en-US',
      "count" => 20
    }
  end

  def get_bird(name)
    @options["q"] = "#{name} bird"
    response = HTTParty.get("https://api.cognitive.microsoft.com/bing/v5.0/images/search",
      :query => @options,
      :headers => @headers
    )
    return response
  end
end
