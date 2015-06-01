require_relative './spec_helper'
require_relative '../custom_twitter'

describe EveryBirdTwitter do
  before(:each) do
    @twitter = EveryBirdTwitter.new
  end

  it 'should be an EveryBirdTwitter' do
    expect(@twitter).to be_instance_of(EveryBirdTwitter)
  end

  it 'should get a number' do
    VCR.use_cassette('twitter') do
      @twitter.set_last_bird
      expect(@twitter.last_bird).to be_a(Integer)
    end
  end
end