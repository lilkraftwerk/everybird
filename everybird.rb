require 'twitter'
require 'tempfile'
require 'open-uri'
require 'mini_magick'
require 'action_view'
require 'net/http'

include ActionView::Helpers::DateHelper

require_relative 'birdread'
require_relative 'bing'
require_relative 'custom_twitter'

TWITTER_KEY ||= ENV["TWITTER_KEY"]
TWITTER_SECRET ||= ENV["TWITTER_SECRET"]
ACCESS_TOKEN ||= ENV["ACCESS_TOKEN"]
ACCESS_SECRET ||= ENV["ACCESS_SECRET"]
BING_KEY ||= ENV["BING_KEY_2"]

def tweet
  bird_reader = BirdRead.new
  tweeter = EveryBirdTwitter.new

  tweeter.set_last_bird
  number_of_bird_to_tweet = tweeter.last_bird + 1

  unless number_of_bird_to_tweet > 9701
    bird_array = bird_reader.get_specific_bird(number_of_bird_to_tweet)

    if number_of_bird_to_tweet.to_s.length > 3
      formatted_bird_number = number_of_bird_to_tweet.to_s.split('')
      formatted_bird_number.insert(1, ",")
      formatted_bird_number = formatted_bird_number.join('')
    else
      formatted_bird_number = number_of_bird_to_tweet
    end

    bird_name = bird_array[0]
    latin_name = bird_array[1]

    bird_string = "BIRD \##{formatted_bird_number}\n" +
    "#{bird_name}\n(#{latin_name})\n"

    puts bird_string
    puts "bird string above"

    downloader = BirdDownloader.new
    results = downloader.get_bird(bird_name)
    if results["value"].nil?
      puts "oops something broke."
      puts results
      return
    end
    
    puts "*" * 10
    puts "RESULTS"
    puts "*" * 10
    puts results
    puts "*" * 10

    img_info = results["value"].map { |imgdata| [imgdata["contentUrl"], imgdata["encodingFormat"]] }

    i = get_start_index
    begin
      puts "trying result #{i}..."
      this_bird = img_info[i]
      url = this_bird[0]
      filetype = url[-3..-1]
      tweeter = EveryBirdTwitter.new
      filename = "./tmp/tweety_bird.#{filetype}"

      File.open(filename, "wb") do |saved_file|
        open(url, "rb") do |read_file|
          saved_file.write(read_file.read)
        end
      end

      File.open(filename) do |f|
        tweeter.update(bird_string, f)
      end

    rescue Twitter::Error::Forbidden
      i += 1
      retry if i < 20
      return
    end
  end
end

def get_start_index
  if last_tweet_older_than_six_hours?
    return rand(2..12)
  elsif last_tweet_older_than_five_hours?
    return 1
  else
    return 0
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

def last_tweet_older_than_five_hours?
  client = EveryBirdTwitter.new
  client.is_last_tweet_older_than_five_hours
end

def last_tweet_older_than_six_hours?
  client = EveryBirdTwitter.new
  client.is_last_tweet_older_than_six_hours
end