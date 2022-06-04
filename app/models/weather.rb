class Weather < ApplicationRecord
  require 'net/http'
  require 'json'

  def get_data
    uri = URI("http://dataservice.accuweather.com/currentconditions/v1/290714/historical/24?apikey=IVbDrteOShnZzYss4kSDoLZdGpDf96Z9")
    data = Net::HTTP.get(uri)
  end

  def filter_data
    # Introduce dummy json to minimize API's calls count
    data_json = File.read('data.json')
    data = JSON.parse(data_json)

    #Now let's actually filter it
    data.collect do |item|
      Hash[
        time: item['LocalObservationDateTime'],
        temperature: item['Temperature']['Metric']
      ]
    end
  end
end
