require 'twitter'
require 'tempfile'
require 'mini_magick'

require_relative 'birdread'
require_relative 'bing'


TWITTER_KEY ||= ENV["TWITTER_KEY"]
TWITTER_SECRET ||= ENV["TWITTER_SECRET"]
ACCESS_TOKEN ||= ENV["ACCESS_TOKEN"]
ACCESS_SECRET ||= ENV["ACCESS_SECRET"]
BING_KEY ||= ENV["BING_KEY"]

class EveryBirdTwitter

  def initialize
    configure_twitter_client
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

  def message(text)
    @client.update(text)
  end
end

def tweet
  tweety = EveryBirdTwitter.new
  tweety.get_last_bird_number
  num = tweety.last_bird + 1
  unless num > 9701
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

  def tweet_specific_number(number)
    number = number + 1
    tweety = EveryBirdTwitter.new
    bird = get_specific_bird(number)
    bing = CustomBing.new(bird)
    bing.search_and_parse_bird

    bird_string = "BIRD \##{number}\n" +
                  "#{bird[0]}\n(#{bird[1]})\n"


    image = MiniMagick::Image.open(bing.image_url)
    image.resize "800x800"
    file = image.write("./tmp/tweety_bird.jpg")

    File.open("./tmp/tweety_bird.jpg") do |f|
      tweety.update(bird_string, f)
    end
  end
end

def should_tweet?
  should = Time.now.hour % 4 == 0
  return should
end

def timed_tweet
  tweet if should_tweet?
end

def message_about_shuffle
  tweety = EveryBirdTwitter.new
  message = "[ everybird note ]\ndue to feedback (and an overabundance of tinamous) the next 9,653 birds will be randomized. thank you. \n-@nah_solo"
  tweety.message(message)
end

def tweet_number_fortynine
  tweet_specific_number(49)
end