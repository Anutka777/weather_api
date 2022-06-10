class WeatherController < ApplicationController
  before_action :get_weather
  before_action :collect_temperatures, except: %i[health, historical, by_time]
  before_action :collect_temperatures_with_timestamps, only: :historical

  def current
    render json: @daily_temperatures.first, status: :ok
  end

  def historical
    render json: @timestamp_temperatures, status: :ok
  end

  def historical_max
    render json: @daily_temperatures.max, status: :ok
  end

  def historical_min
    render json: @daily_temperatures.min, status: :ok
  end

  def historical_avg
    render json: (@daily_temperatures.sum / @daily_temperatures.size).round(1), status: :ok
  end

  def health
    render json: 'OK', status: :ok
  end

  def by_time
    query_time = (params[:epoch].to_i)

    weather_from_nearest_time = @weather.min_by { |record| (query_time - record[:epoch]).to_i.abs }

    if (weather_from_nearest_time[:epoch] - query_time).to_i.abs > (60 * 60)
      render file: "#{Rails.root}/public/404.html", layout: false, status: 404
    else
      render json: weather_from_nearest_time[:temperature]['Value'], status: :ok
    end
  end
  
  private
  
  def get_weather
    @weather = Weather.collect_data
  end

  def collect_temperatures
    @daily_temperatures = @weather.collect { |record| record[:temperature]['Value'] }
  end

  def collect_temperatures_with_timestamps
    @timestamp_temperatures = @weather.collect do |record|
      Hash[
        time: record[:time],
        temperature: record[:temperature]['Value']
      ]
    end
  end
end
