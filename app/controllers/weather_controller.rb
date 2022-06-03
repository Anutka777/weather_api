class WeatherController < ApplicationController
  def current
    render plain: 'OK'
  end
end
