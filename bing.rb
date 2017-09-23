require 'httparty'
require 'json'
require 'net/http'

class BirdDownloader
  def initialize
    @BASE_URL = "https://api.cognitive.microsoft.com/bing/v5.0/images/search"
    @headers = { "Ocp-Apim-Subscription-Key" => BING_KEY }
    @options = {
      "mkt" => 'en-US',
      "count" => 20
    }
  end

  def get_bird(name)
    puts "bird name: #{name}"
    @options["q"] = "#{name} bird".gsub("-", " ");
    puts "options for query: #{@options}"
    response = HTTParty.get("https://api.cognitive.microsoft.com/bing/v5.0/images/search",
      :query => @options,
      :headers => @headers
    )
    puts "response: "
    puts response
    return response
  end
end
