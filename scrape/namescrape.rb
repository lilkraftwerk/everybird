require 'nokogiri'

file = File.open('wikilist.html')
doc = Nokogiri::HTML(file)

p doc