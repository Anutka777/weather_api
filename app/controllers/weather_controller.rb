class WeatherController < ApplicationController
  before_action :get_weather
  before_action :collect_temperatures, except: %i[health, by_time]

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
    @daily_temperatures = @weather.collect { |day| day[:temperature]['Value'] }
  end
end
