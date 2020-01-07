
class EveryBirdTwitter
  attr_reader :last_bird

  def initialize
    configure_twitter_client
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
    puts "last tweet was #{time_ago_in_words(last)} ago, so should we tweet? #{last <= 4.hours.ago}"
    last <= 4.hours.ago
  end

   def is_last_tweet_older_than_five_hours
    last = @client.user_timeline.first.created_at
    puts "last tweet was #{time_ago_in_words(last)} ago, so should we tweet? #{last <= 5.hours.ago}"
    last <= 5.hours.ago
  end

  def is_last_tweet_older_than_six_hours
    last = @client.user_timeline.first.created_at
    puts "last tweet was #{time_ago_in_words(last)} ago, so should we tweet? #{last <= 6.hours.ago}"
    last <= 6.hours.ago
  end

  def get_last_bird_number
    regexp = /BIRD\s#(.+)\s/
    me = @client.user.id
    timeline = @client.user_timeline(me)
    @most_recent_tweet = @client.user_timeline(me).first
    match = regexp.match(@most_recent_tweet.text).captures.first
    p match
    match.gsub!(',','') if match.to_s.length > 3
    p match
    return match.to_i
  end

  def get_all_last_birds
    regexp = /BIRD\s#(.+)\s/
    me = @client.user.id
    timeline = @client.user_timeline(me)
    @recent_tweets = @client.user_timeline(me)
    matches = @recent_tweets.map do |tweet|
      regexp.match(@most_recent_tweet.text).captures.first.to_i
    end
    return matches
  end

  def set_last_bird
    @last_bird = get_last_bird_number
  end

  def update(text, file)
    @client.update_with_media(text,file)
  end
end



