require 'twitter'
require 'net/http'
require 'twitter'
require 'active_support/all'

require_relative 'custom_twitter'

TWITTER_KEY ||= ENV["TWITTER_KEY"]
TWITTER_SECRET ||= ENV["TWITTER_SECRET"]
ACCESS_TOKEN ||= ENV["ACCESS_TOKEN"]
ACCESS_SECRET ||= ENV["ACCESS_SECRET"]

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

def rerun_test
  tweeter = EveryBirdTwitter.new
  p tweeter.get_text_to_post
end

def get_last_birds
  tweeter = EveryBirdTwitter.new
  p tweeter.bird_without_recent_ones
end