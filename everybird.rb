require 'twitter'
require 'net/http'
require 'twitter'
require 'active_support/all'

require_relative 'custom_twitter'
require_relative './keys'

TWITTER_KEY ||= ENV["TWITTER_KEY"]
TWITTER_SECRET ||= ENV["TWITTER_SECRET"]
ACCESS_TOKEN ||= ENV["ACCESS_TOKEN"]
ACCESS_SECRET ||= ENV["ACCESS_SECRET"]

def tweet
  tweeter = EveryBirdTwitter.new
  puts tweeter.get_last_bird_number
end

def rerun_test
  tweeter = EveryBirdTwitter.new
  tweeter.get_text_to_post
end

def test_tweet
  tweeter = EveryBirdTwitter.new
  puts tweeter.get_all_last_birds
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

def rerun
  tweeter = EveryBirdTwitter.new
  text = tweeter.get_text_to_post
  tweeter.update(text)
end