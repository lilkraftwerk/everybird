require 'twitter'
require 'net/http'
require 'twitter'
require 'active_support/all'

require_relative 'custom_twitter'
require_relative '/.keysbird'

TWITTER_KEY ||= ENV["TWITTER_KEY"]
TWITTER_SECRET ||= ENV["TWITTER_SECRET"]
ACCESS_TOKEN ||= ENV["ACCESS_TOKEN"]
ACCESS_SECRET ||= ENV["ACCESS_SECRET"]

def tweet
  tweeter = EveryBirdTwitter.new
  puts tweeter.get_last_bird_number
end

def test_tweet
  tweeter = EveryBirdTwitter.new
  puts tweeter.get_all_last_birds
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