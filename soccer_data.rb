# frozen_string_literal: true

require_relative "data_processable"

class SoccerData
  include DataProcessable

  SKIP_LINES_COUNT = 2
  TEAMS_IN_LEAGUE = 20

  def initialize(file_path:)
    setup_data(file_path)
  end

  def min_goal_difference_team
    min_difference = Float::INFINITY
    team_with_min_difference = nil

    data.each do |team_entry|
      difference = (team_entry[:goals_for] - team_entry[:goals_against]).abs

      if difference < min_difference
        min_difference = difference
        team_with_min_difference = team_entry[:team]
      end
    end

    humanized_team_name(team_with_min_difference)
  end

  private
    def process_line(line)
      columns = line.split
      placement = columns[0].to_i
      team = columns[1]
      return unless placement.between?(1, TEAMS_IN_LEAGUE)

      goals_for = columns[6].to_i
      goals_against = columns[8].to_i

      data << { team: team, goals_for: goals_for, goals_against: goals_against }
    end

    def humanized_team_name(team)
      team.gsub("_", " ")
    end
end

# Usage
soccer_data = SoccerData.new(file_path: "data/soccer.dat")
puts soccer_data.min_goal_difference_team