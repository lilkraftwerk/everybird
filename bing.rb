require 'searchbing'
require 'open-uri'
require_relative 'birdread'

class CustomBing
  attr_reader :image_url, :latin_name, :name, :parsed

  def initialize(bird_data)
    @key = BING_KEY
    @client = bing_image = Bing.new(@key, 25, 'Image')
    set_bird(bird_data)
  end

  def set_bird(bird_data)
    @latin_name = bird_data[1]
    @name = bird_data[0]
  end

  def get_list_of_birds
    @parsed = @client.search(@name).first
  end

  def set_image_attributes(number)
    @image_url = @parsed[:Image][number][:MediaUrl]
    @extension = @image_url[-3..-1]
  end

  def download_bird(number)
    set_image_attributes(number)
    filename = @name.gsub(' ', '').downcase
    open("img/#{filename}.#{@extension}", 'wb') do |file|
      file << open(@image_url).read
    end
  end
end



