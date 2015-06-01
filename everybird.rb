require 'twitter'
require 'tempfile'
require 'mini_magick'

require_relative 'birdread'
require_relative 'bing'
require_relative 'custom_twitter'

TWITTER_KEY ||= ENV["TWITTER_KEY"]
TWITTER_SECRET ||= ENV["TWITTER_SECRET"]
ACCESS_TOKEN ||= ENV["ACCESS_TOKEN"]
ACCESS_SECRET ||= ENV["ACCESS_SECRET"]
BING_KEY ||= ENV["BING_KEY"]

def tweet
  bird_reader = BirdRead.new
  tweeter = EveryBirdTwitter.new

  tweeter.set_last_bird
  number_of_bird_to_tweet = tweeter.last_bird + 1

  unless number_of_bird_to_tweet > 9701
    bird_array = bird_reader.get_specific_bird(number_of_bird_to_tweet)
    bing = CustomBing.new(bird_array)

    bird_string = "BIRD \##{number_of_bird_to_tweet}\n" +
                  "#{bird_array[1]}\n(#{bird_array[0]})\n"

    puts bird_string

    puts "ahead of until loop"
    image_number = 0

    bing.get_list_of_birds

    until tweeter.get_last_bird_number == number_of_bird_to_tweet
      puts "in until loop"
      bing.set_image_attributes(image_number)

      image = MiniMagick::Image.open(bing.image_url)
      image.resize "800x800"
      file = image.write("./tmp/tweety_bird.jpg")

      File.open("./tmp/tweety_bird.jpg") do |f|
        tweeter.update(bird_string, f)
      end

      sleep 30
      image_number += 1
    end
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