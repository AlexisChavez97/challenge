# frozen_string_literal: true

module DataProcessable
  attr_reader :file_path, :data
  
  def setup_data(file_path)
    @file_path = file_path
    @data = []
    read_data
  end

  def read_data
    File.open(file_path, 'r') do |file|
      file.each_line.with_index do |line, index|
        next if index < self.class::SKIP_LINES_COUNT

        process_line(line)
      end
    end
  end

  private

  def process_line(line)
    raise NotImplementedError, "You must implement #{self.class}##{__method__}"
  end
end