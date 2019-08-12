# frozen_string_literal: true

# Copyright (C) 2019  Anthony Gargiulo <anthony@agargiulo.com>
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
require 'tcelfer/cli/report'
require 'tcelfer/cli/db_tasks'

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

      # Set up debug things I guess? This could be messy
      class_option(:verbose, aliases: %w[-v], type: :boolean, default: false)
      # Legends are useful for more than one command
      class_option(:legend, aliases: %w[-k -l], type: :boolean, default: false)

      desc 'version', 'Prints the current version'
      def version
        puts Tcelfer::VERSION
      end

      method_option(:date, aliases: %w[-d], desc: 'Any format valid for ruby Date e.g. 2019-10-31', required: false)
      method_option(:yesterday, aliases: %w[-p], desc: 'Record yesterday, ignored if `-d` is present', required: false)
      desc 'day', 'record info for a day'
      def day
        Tcelfer.config.debug = options[:verbose]
        store = Tcelfer::Storage.new
        tc_day = rec_day! store
        @prompt.say("Recorded [#{tc_day.date}]: #{Paint[tc_day.rating, :bold]}")
      rescue Tcelfer::Error => e
        @prompt.error("[#{e.class}]", e)
      end

      method_option(:month, aliases: %w[-m], type: :numeric)
      method_option(:year, aliases: %w[-y], type: :numeric, default: Date.today.year)
      desc 'report', 'generate a report'
      def report
        Tcelfer.config.debug = options[:verbose]
        rep = Report.new
        @prompt.say(gen_report(rep, options['month'], options['year'], options['legend']))
      rescue Tcelfer::Error => e
        @prompt.error("[#{e.class}]", e)
      end

      desc 'ytd', 'Report on the current calendar year'
      def ytd
        Tcelfer.config.debug = options[:verbose]
        rep = Report.new
        1.upto(Date.today.mon) do |mon|
          @prompt.say(rep.generate_month_report(mon))
        end
        @prompt.say(Report.legend)
      rescue Tcelfer::Error => e
        @prompt.error("[#{e.class}]", e)
      end

      desc 'db', 'Perform various DB related tasks'
      subcommand 'db', DBTasks

      private

      def pick_date!
        if options.key?(:date)
          options[:date]
        elsif options.key?(:yesterday)
          Date.today - 1
        else
          Date.today
        end
      end

      # Heavy lifting for `tcelfer day ...`
      # returns an instance of the Day model representing the users choices.
      # @return [Tcelfer::Models::Day]
      def rec_day!(store)
        user_date            = pick_date!
        rate_prompt_settings = { required: true, filter: true, per_page: DAY_RATINGS.length }
        rating               = @prompt.select('How was your day?', DAY_RATINGS, **rate_prompt_settings)
        notes                = @prompt.ask('Any additional notes?')
        store.rec_day(rating, notes, user_date)
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
          raise Tcelfer::ReportError, 'Please provide either -m, -k/-l, or both'
        end
      end
    end
  end
end
