
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
    puts "last tweet was #{time_ago_in_words(last)} ago, so should we tweet? #{last <= 4.hours.ago}"
    last <= 4.hours.ago
  end

  def get_all_last_birds
    regexp = /BIRD\s#(.+)\s/
    me = @client.user.id
    timeline = @client.user_timeline(me)
    recent_tweets = @client.user_timeline(me, { count: 200 })
    with_match = recent_tweets.select do |tweet|
      !regexp.match(tweet.text).nil?
    end

    matches = with_match.map do |tweet|
      regexp.match(tweet.text).captures
    end
    return matches
  end

  def birds
    puts @posted_birds
  end

  def random_bird
    @posted_birds.sample
  end

  def get_bird_link(id)
    puts id
    "https://twitter.com/_everybird_/status/" + id
  end

  def get_text_to_post
    bird = random_bird
    name = bird['name']
    link = get_bird_link(bird['id'])
    date = DateTime.parse(bird['created_at']).strftime("%A, %d %B, %Y")
    [name, ", originally posted on " + date, link].join(" ")
  end

  def update(text)
    @client.update(text)
  end
end



