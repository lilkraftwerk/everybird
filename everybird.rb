require 'twitter'
require 'tempfile'
require 'mini_magick'

require_relative 'birdread'
require_relative 'bing'
require_relative 'custom_twitter'
require_relative 'keys'

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

    if number_of_bird_to_tweet.to_s.length > 3
      formatted_bird_number = number_of_bird_to_tweet.to_s.split('')
      formatted_bird_number.insert(1, ",")
      formatted_bird_number = formatted_bird_number.join('')
    else
      formatted_bird_number = number_of_bird_to_tweet
    end

    bird_string = "BIRD \##{formatted_bird_number}\n" +
                  "#{bird_array[0]}\n(#{bird_array[1]})\n"

    puts bird_string
    puts "bird string above"
    image_number = rand(5) + 1

    bing.get_list_of_birds

    until tweeter.get_last_bird_number == number_of_bird_to_tweet
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

def should_tweet?
  last_tweet_older_than_four_hours?
end

def timed_tweet
  tweet if should_tweet?
end

def last_tweet_older_than_four_hours?
  client = EveryBirdTwitter.new
  client.is_last_tweet_older_than_four_hours
end

