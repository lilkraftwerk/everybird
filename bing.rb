require 'searchbing'
require 'open-uri'
require_relative 'birdread'

class CustomBing
  attr_reader :image_url

  def initialize(bird_data)
    @key = ENV["BING_KEY"]
    @client = bing_image = Bing.new(@key, 1, 'Image')
    set_bird(bird_data)
  end

  def set_bird(bird_data)
    @latin_name = bird_data[0]
    @name = bird_data[1]
  end

  def search_and_parse_bird
    @parsed = @client.search(@name)
    @image_url = @parsed[0][:Image][0][:MediaUrl]
    @extension = @image_url[-3..-1]
  end

  def download_bird
    filename = @name.gsub(' ', '').downcase
    open("img/#{filename}.#{@extension}", 'wb') do |file|
      file << open(@image_url).read
    end
  end
end



