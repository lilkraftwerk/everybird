require_relative './spec_helper'
require_relative '../birdread.rb'

describe BirdRead do
  it 'should return a specific bird' do
    bird = BirdRead.get_specific_bird(100)
    expect(bird).to eq(["Black Honeyeater", "Certhionyx niger"])
  end
end