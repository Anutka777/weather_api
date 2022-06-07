class WeatherController < ApplicationController
  before_action :get_weather, :collect_temperatures, except: %i[health]

  def current
    render plain: @daily_temperatures.first
  end

  def historical
    render plain: @daily_temperatures
  end

  def historical_max
    render plain: @daily_temperatures.max
  end

  def historical_min
    render plain: @daily_temperatures.min
  end

  def historical_avg
    render plain: (@daily_temperatures.sum / @daily_temperatures.size).round(1)
  end

  def health
    render plain: 'OK', status: :ok
  end
  
  private
  
  def get_weather
    @weather = Weather.collect_data
  end

  def collect_temperatures
    @daily_temperatures = @weather.collect { |day| day[:temperature]['Value'] }
  end
end
