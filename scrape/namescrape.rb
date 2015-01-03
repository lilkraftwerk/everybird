require 'nokogiri'

file = File.open('wikilist.html')
doc = Nokogiri::HTML(file)

everylink = doc.xpath('//li/a')

open('birdlinks.txt', 'w') do |f|
  everylink.each do |link|
    f.puts link.attributes["href"].value
  end
end



puts everylink.length