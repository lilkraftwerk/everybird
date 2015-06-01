require 'rspec'
require 'vcr'
require 'webmock'
require 'rspec'

require_relative '../bing.rb'
require_relative '../everybird.rb'

VCR.configure do |c|
  c.cassette_library_dir = '../cassettes'
  c.stub_with :webmock
  c.default_cassette_options = { :record => :once }
end