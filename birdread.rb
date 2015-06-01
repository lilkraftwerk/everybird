require 'json'

class BirdRead
  def self.get_specific_bird(number)
    file = File.open('all_birds.json', 'r')
    json = JSON.parse(file.read)
    return json[number]
  end
end

