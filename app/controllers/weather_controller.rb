class WeatherController < ApplicationController
  before_action :collect_data

  def current
    render json: @weather.first[:temperature]
  end
  
  private
  
  def collect_data
    @weather = Weather.get_weather
  end
end
