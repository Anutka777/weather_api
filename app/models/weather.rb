class Weather < ApplicationRecord
  require 'net/http'
  require 'json'

  def self.call_api
    uri = URI("http://dataservice.accuweather.com/currentconditions/v1/290714/historical/24?apikey=IVbDrteOShnZzYss4kSDoLZdGpDf96Z9")
    data = Net::HTTP.get(uri)
  end

  def self.collect_data
    # Actual behavour
    # data_json = self.call_api

    # Introduce dummy json to minimize API's calls count
    data_json = File.read(Rails.root.join "app", "models", "data.json")
    data = JSON.parse(data_json)

    # Filter irrelevant info
    data.collect do |item|
      Hash[
        time: item['LocalObservationDateTime'],
        temperature: item['Temperature']['Metric']
      ]
    end
  end
end
