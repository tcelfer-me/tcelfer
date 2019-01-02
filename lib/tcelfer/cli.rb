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
require 'date'
require 'paint'
require 'thor'
require 'tty-prompt'

require 'tcelfer'

module Tcelfer
  module CLI
    # Thor CLI for Tcelfer
    class Base < Thor
      def initialize(*_args)
        # Quit on Ctrl-C please
        @prompt = TTY::Prompt.new(interrupt: :exit)

        super
      end

      # Useful return codes are nice, of course
      def self.exit_on_failure?
        true
      end

      desc 'version', 'Prints the current version'

      def version
        puts Tcelfer::VERSION
      end

      method_option(:date, aliases: %w[-d], desc: 'Any format valid for ruby Date e.g. 2019-10-31', required: false)
      desc 'day', 'record info for a day'

      def day
        store  = Tcelfer::Storage.new
        tc_day = rec_day!(store)
        @prompt.say("Recorded [#{tc_day.date}]: #{Paint[tc_day.rating, :bold]}")
      rescue Tcelfer::Error => err
        @prompt.error("[#{err.class}]", err)
      rescue Sequel::UniqueConstraintViolation => sql_err
        @prompt.error("[#{sql_err.class}]", 'You already have a record for that day')
      end

      method_option(:month, aliases: %w[-m], type: :numeric)
      method_option(:legend, aliases: %w[-k], type: :boolean, default: false)
      method_option(:year, aliases: %w[-y], type: :numeric, default: Date.today.year)
      desc 'report', 'generate a report'

      def report
        require 'tcelfer/cli/report'
        rep = Report.new
        @prompt.say(gen_report(rep, options['month'], options['year'], options['legend']))
      rescue Tcelfer::Error => err
        @prompt.error("[#{err.class}]", err)
      end

      private

      # Heavy lifting for `tcelfer day ...`
      # returns an instance of the Day model representing the users choices.
      # @return [Tcelfer::Models::Day]
      def rec_day!(store)
        user_date = options.key?('date') ? Date.parse(options['date']) : Date.today
        rating    = @prompt.select('How was your day?', DAY_RATINGS, required: true, filter: true)
        notes     = @prompt.ask('Any additional notes?')
        # noinspection RubyArgCount
        store.days.new(rating: rating, notes: notes, date: user_date).save
      end

      # Heavy lifting for `tcelfer report ...`
      # Returns a string report to print to the console
      # @param [Tcelfer::CLI::Report] rep Report object
      # @param [Integer] month
      # @param [Integer] year
      # @param [Boolean] legend do we want to include the legend in the report?
      # @return [String]
      def gen_report(rep, month, year, legend)
        if month && legend
          rep.month_with_legend(month, year)
        elsif month
          rep.generate_month_report(month, year)
        elsif legend
          Report.legend
        else
          'Unfinished path at the moment'
        end
      end
    end
  end
end
