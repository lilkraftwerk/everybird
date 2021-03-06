require_relative './spec_helper'
require_relative '../bing'
require_relative '../keys'

describe CustomBing do
  before(:each) do
    @bing = CustomBing.new(["Black Honeyeater", "Certhionyx niger"])
  end

  it 'should be a CustomBing' do
    expect(@bing).to be_instance_of(CustomBing)
  end

  it 'should set the latin name correctly' do
    expect(@bing.latin_name).to eq("Certhionyx niger")
  end

  it 'should set the regular name correctly' do
    expect(@bing.name).to eq("Black Honeyeater")
  end

  it 'should get a hash back as results for the bird' do
    VCR.use_cassette('bing') do
      @bing.get_list_of_birds
      expect(@bing.parsed).to be_a(Hash)
    end
  end

  it 'should get an array back as results for the image section of the hash' do
    VCR.use_cassette('bing') do
      @bing.get_list_of_birds
      expect(@bing.parsed[:Image]).to be_an(Array)
    end
  end

  it 'should get search results for the bird' do
    VCR.use_cassette('bing') do
      @bing.get_list_of_birds
      @bing.set_image_attributes(1)
      expect(@bing.image_url).to match(/(https?:\/\/.*\.(?:png|jpg|gif))/)
    end
  end
end