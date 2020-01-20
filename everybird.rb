require 'twitter'
require 'net/http'
require 'twitter'
require 'date'
require 'active_support/all'

require_relative 'custom_twitter'

if ENV["TWITTER_KEY"].nil?
  require_relative './keys'
end

TWITTER_KEY ||= ENV["TWITTER_KEY"]
TWITTER_SECRET ||= ENV["TWITTER_SECRET"]
ACCESS_TOKEN ||= ENV["ACCESS_TOKEN"]
ACCESS_SECRET ||= ENV["ACCESS_SECRET"]

def last_tweet_older_than_four_hours?
  client = EveryBirdTwitter.new
  client.is_last_tweet_older_than_four_hours
end

def should_tweet?
  DateTime.now.minute < 10 && DateTime.now.hour % 4 == 0
end

def rerun
  if should_tweet?
    tweeter = EveryBirdTwitter.new
    text = tweeter.get_text_to_post
    tweeter.update(text)
  end
end

def rerun_test
  tweeter = EveryBirdTwitter.new
  puts tweeter.get_text_to_post
end

def retweet_test
  tweeter = EveryBirdTwitter.new
  puts tweeter.retweet_random_tweet
end

def rerun_retweet
  if should_tweet?
    puts "should tweet, finding one to RT"
    tweeter = EveryBirdTwitter.new
    text = tweeter.retweet_random_tweet
  else 
    puts "should not tweet, doing nothing"
  end
end