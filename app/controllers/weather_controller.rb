class WeatherController < ApplicationController
  before_action :collect_data

  def current
    render json: @weather.first
  end

  def historical
    render json: @weather
  end

  def historical_max
    @weather = sort_by_temperature
    max = @weather.last
    render json: max
  end

  def historical_min
    @weather = sort_by_temperature
    min = @weather.first
    render json: min
  end
  
  private
  
  def collect_data
    # TODO: Date condition 
    @weather = Weather.get_weather
  end

  def sort_by_temperature
    @weather.sort_by { |item| item[:temperature]['Value']}
  end
end
