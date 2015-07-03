require 'twitter'

class EveryBirdTwitter
  attr_reader :last_bird

  def initialize
    configure_twitter_client
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
    regexp = /BIRD\s#(.+)\s/
    me = @client.user.id
    timeline = @client.user_timeline(me)
    @most_recent_tweet = @client.user_timeline(me).first
    regexp.match(@most_recent_tweet.text).captures.first.to_i
  end

  def set_last_bird
    @last_bird = get_last_bird_number
  end

  def update(text, file)
    @client.update_with_media(text,file)
  end
end



