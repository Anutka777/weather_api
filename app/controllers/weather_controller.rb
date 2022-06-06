class WeatherController < ApplicationController
  before_action :get_weather

  def current
    render json: @weather.first
  end

  def historical
    render json: @weather
  end

  def historical_max
    max = sort_by_temperature.last
    render json: max
  end

  def historical_min
    min = sort_by_temperature.first
    render json: min
  end

  def historical_avg
    avg = (@weather.sum { |item| item[:temperature]['Value'] }) / @weather.count
    render plain: avg
  end
  
  private
  
  def get_weather
    # TODO: Date condition 
    @weather = Weather.collect_data
  end

  def sort_by_temperature
    @weather.sort_by { |item| item[:temperature]['Value'] }
  end
end
