require 'twitter'
require 'tempfile'
require 'mini_magick'

require_relative 'birdread'
require_relative 'bing'
# require_relative 'keys'


TWITTER_KEY ||= ENV["TWITTER_KEY"]
TWITTER_SECRET ||= ENV["TWITTER_SECRET"]
ACCESS_TOKEN ||= ENV["ACCESS_TOKEN"]
ACCESS_SECRET ||= ENV["ACCESS_SECRET"]
BING_KEY ||= ENV["BING_KEY"]

class EveryBirdTwitter

  def initialize
    configure_twitter_client
    p @client
    get_last_bird_number
  end

  def last_bird
    @last_bird_num
  end

  def configure_twitter_client
    client = Twitter::REST::Client.new do |config|
      config.consumer_key = TWITTER_KEY
      config.consumer_secret = TWITTER_SECRET
      config.access_token = ACCESS_TOKEN
      config.access_token_secret = ACCESS_SECRET
    end
    @client = client
  end

  def get_last_bird_number
    regexp = /BIRD\s#(\d+)\s/
    me = @client.user.id
    timeline = @client.user_timeline(me)
    p me
    p timeline
    if timeline.empty?
      @last_bird_num = 0
    else
      @most_recent_tweet = @client.user_timeline(me).first
      @last_bird_num = regexp.match(@most_recent_tweet.text).captures.first.to_i
    end
  end

  def update(text, file)
    @client.update_with_media(text,file)
  end

end

def tweet
  tweety = EveryBirdTwitter.new
  num = tweety.last_bird + 1

  bird = get_specific_bird(num)
  bing = CustomBing.new(bird)
  bing.search_and_parse_bird

  bird_string = "BIRD \##{num}\n" +
                "#{bird[0]}\n(#{bird[1]})\n"


  image = MiniMagick::Image.open(bing.image_url)
  image.resize "800x800"
  file = image.write("./tmp/tweety_bird.jpg")

  File.open("./tmp/tweety_bird.jpg") do |f|
    tweety.update(bird_string, f)
  end
end

def should_tweet?
  Time.now.hour % 8 == 0
end

def rake_tweet
  tweet if should_tweet?
end