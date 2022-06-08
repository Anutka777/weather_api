class Weather < ApplicationRecord
  require 'net/http'
  require 'json'

  def self.collect_data
    # Actual behavour
    # response = self.call_api

    # Introduce dummy json to minimize API's calls count
    response = File.read(Rails.root.join "app", "models", "data.json")
    
    # Filter irrelevant info
    data = JSON.parse(response)
    data.collect do |item|
      Hash[
        epoch: item ['EpochTime'],
        time: item['LocalObservationDateTime'],
        temperature: item['Temperature']['Metric']
      ]
    end
  end

  private

  def self.call_api
    uri = URI("http://dataservice.accuweather.com/currentconditions/v1/290714/historical/24?apikey=IVbDrteOShnZzYss4kSDoLZdGpDf96Z9")
    Net::HTTP.get(uri)
  end
end
