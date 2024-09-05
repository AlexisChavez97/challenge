# frozen_string_literal: true

require_relative "data_processor"

class WeatherData
  include DataProcessor

  SKIP_LINES_COUNT = 5
  
  def smallest_temperature_spread
    min_spread = Float::INFINITY
    day_with_min_spread = nil

    data.each do |day_entry|
      spread = day_entry[:max_temp] - day_entry[:min_temp]
      
      if spread < min_spread
        min_spread = spread
        day_with_min_spread = day_entry[:day]
      end
    end

    day_with_min_spread
  end

  private
    def process_line(line)
      columns = line.split
      day = columns[0].to_i
      return unless day.between?(1, 31)

      max_temp = columns[1].to_f
      min_temp = columns[2].to_f

      data << { day: day, max_temp: max_temp, min_temp: min_temp }
    end
end

# Usage
weather_data = WeatherData.new(file_path: "data/w_data.dat")
puts weather_data.smallest_temperature_spread