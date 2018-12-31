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
    # ordering taking from a mix of examples on reddit
    # and my own preferences. '#4B0082' is indigo
    # Magic array?
    RATING_TO_COLOR_MAP = Tcelfer::DAY_RATINGS.zip(
      ['maroon', :green, 'peru', '#4B0082', :red, 'orange', :blue]
    ).to_h.freeze

    def initialize
      @store = Tcelfer::Storage.new
    end

    def data
      @store.data
    end

    def generate_month_report(month)
      mon_by_wday = @store.by_month(month).group_by { |day| day.date.wday }
      raise ReportError, "Unable to process #{Date::MONTHNAMES[month]}, no data found" if mon_by_wday.empty?

      pad_month_start!(mon_by_wday)
      weeks = color_month(mon_by_wday)
      Terminal::Table.new(rows: weeks, style: { all_separators: true }, headings: Date::ABBR_DAYNAMES)
    end

    def month_with_legend(month)
      tab = generate_month_report month
      Terminal::Table.new(rows: [[tab, Report.legend]]).tap do |combined|
        combined.style = { border_x: '', border_y: '', border_i: '', width: `tput cols`.to_i }
      end
    end

    def self.legend
      leg = Tcelfer::Report::RATING_TO_COLOR_MAP.map { |rate, color| [Paint['    ', :inverse, color], rate] }
      Terminal::Table.new(rows: leg, headings: %w[Rating Color].map { |head| Paint[head, :bold] })
    end

    private

    def pad_month_start!(mon_by_wday)
      mon_by_wday.keys.sort.each do |wd|
        dates = mon_by_wday[wd]
        break unless dates.first.date.day != 1

        dates.unshift(nil)
      end
    end

    # convert a Tcelfer::Day object
    # to an ANSI colored space
    # @param [Tcelfer::Day] day
    # @return [String]
    def color_day(day)
      color = RATING_TO_COLOR_MAP[day.rating]
      Paint['   ', :inverse, color]
    end

    # Returns an array of arrays of colored "dates" based on #color_day
    # @param [Hash] mon_by_wday
    # @return [Array]
    def color_month(mon_by_wday)
      mon_by_wday[0].zip(*mon_by_wday.values_at(*(1..6))).map do |week|
        week.map do |day|
          next '  ' unless day

          color_day(day)
        end
      end
    end
  end
end
