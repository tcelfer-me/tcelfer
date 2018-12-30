# frozen_string_literal: true

# Copyright (C) 2018  Anthony Gargiulo <anthony@agargiulo.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
require 'paint'
require 'terminal-table'

require 'tcelfer'

module Tcelfer
  # Generate reports with day/week/month/year granularity.
  class Report
    def initialize
      @store = Tcelfer::Storage.new
    end

    def data
      @store.data
    end

    # Currently implemented as a short color line
    # broken up by weeks
    # TODO: Figure out how to space correctly according to day-of-week
    def generate_month_report(month)
      weeks = @store.by_month(month).each_slice(7).map(&method(:color_week))
      raise ReportError, "Unable to process #{Date::MONTHNAMES[month]}, no data found" if weeks.empty?

      Terminal::Table.new(rows: weeks, style: { all_separators: true })
    end

    private

    def rating_to_color_map
      # Magic array?
      # ordering taking from a mix of examples on reddit
      # and my own preferences.
      colors = ['maroon', :green, 'peru', '#4B0082', :red, 'orange', :blue]
      Tcelfer::DAY_RATINGS.zip(colors).to_h
    end

    # convert a Tcelfer::Day object
    # to an ANSI colored space
    # @param [Tcelfer::Day] day
    # @return [String]
    def color_day(day)
      color = rating_to_color_map[day.rating]
      Paint['  ', :inverse, color]
    end

    # Takes an Array[Tcelfer::Day]
    # returns an array of "colored days"
    # @param [Array] week
    # @return [Array]
    def color_week(week)
      color_week = week.map(&method(:color_day))
      color_week << '  ' while color_week.length < 7
      color_week
    end
  end
end
