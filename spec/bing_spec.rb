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

  it 'should get search results for the bird' do
    VCR.use_cassette('bing') do
      @bing.get_list_of_birds
      @bing.set_image_attributes(1)
      expect(@bing.parsed).to be_type_of(hash)
    end
  end

  it 'should get search results for the bird' do
    VCR.use_cassette('bing') do
      @bing.get_list_of_birds
      @bing.set_image_attributes(1)
      expect(@bing.image_url).to eq('')
    end
  end
end