require 'action_view'
require 'action_view/helpers'
include ActionView::Helpers::DateHelper

class EveryBirdTwitter
  attr_reader :last_bird

  def initialize
    configure_twitter_client
    @posted_birds = JSON.parse(File.read('./postedbirds.json'))
  end

  def configure_twitter_client
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = TWITTER_KEY
      config.consumer_secret = TWITTER_SECRET
      config.access_token = ACCESS_TOKEN
      config.access_token_secret = ACCESS_SECRET
    end
  end

  def is_last_tweet_older_than_four_hours
    last = @client.user_timeline.first.created_at
    puts last
    puts "last tweet was #{time_ago_in_words(last)} ago, so should we tweet? #{last <= 4.hours.ago}"
    last <= 4.hours.ago
  end

  def get_all_last_birds
    regexp = /Everybird\s\#(.+):\s/
    me = @client.user.id
    timeline = @client.user_timeline(me)
    recent_tweets = @client.user_timeline(me, { count: 200 })
    with_match = recent_tweets.select do |tweet|
      !regexp.match(tweet.text).nil?
    end

    with_match.map do |tweet|
      regexp.match(tweet.text).captures[0]
    end
  end

  def bird_without_recent_ones
    recents = get_all_last_birds
    @posted_birds.filter do |bird|
      !recents.include?(bird["number"])
    end
  end

  def random_bird
    @posted_birds.sample
  end

  def random_filtered_bird
    bird_without_recent_ones.sample
  end

  def get_bird_link(id)
    "https://twitter.com/_everybird_/status/" + id
  end

  def get_text_to_post
    bird = random_filtered_bird
    number = bird['number']
    name = bird['name'].strip
    link = get_bird_link(bird['id'])
    date = DateTime.parse(bird['created_at']).strftime("%A, %d %B, %Y")
    "Everybird \##{number}: #{name}, originally posted on #{date} #{link}"
  end

  def retweet_random_tweet
    ids = []
    20.times do
      ids.push(@posted_birds.sample["id"])
    end

    retweeted = false
    20.times do |index|
      if retweeted == false
        random_tweet = @client.status(ids[index])
        if random_tweet.retweeted? == false
          @client.retweet(random_tweet)
          retweeted = true
        end

        if retweeted == false && index == 19
          @client.unretweet(random_tweet)
          @client.retweet(random_tweet)
          retweeted = true
        end
      end
    end
  end

  def update(text)
    @client.update(text)
  end
end



