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
require 'thor'
require 'tty-prompt'

require 'tcelfer'

module Tcelfer
  # Thor CLI for Tcelfer
  class CLI < Thor
    def initialize(*_args)
      @prompt = TTY::Prompt.new(interrupt: :exit)

      super
    end

    def self.exit_on_failure?
      true
    end

    desc 'version', 'Prints the current version'
    def version
      puts Tcelfer::VERSION
    end

    desc 'day', 'record info for a day'
    def day
      require 'tcelfer/day'
      rating = @prompt.select(
        'How was your day?',
        DAY_RATINGS, required: true, filter: true
      )
      notes = @prompt.ask('Any additional notes?')
      day = Day.new(rating, notes).save!
      @prompt.say("Recorded [#{day.date}]: #{Paint[rating, :bold]}")
    rescue Tcelfer::Error => err
      @prompt.error("[#{err.class}] #{err}")
    end

    method_option(:month, aliases: ['-m'], type: :numeric)
    method_option(:legend, aliases: ['-k'], type: :boolean, default: false)
    desc 'report', 'generate a report'
    def report
      require 'tcelfer/report'
      rep = Report.new
      @prompt.say(gen_report(rep, options['month'], options['legend']))
    rescue Tcelfer::Error => err
      @prompt.error("[#{err.class}] #{err}")
    end

    private

    def gen_report(rep, month, legend)
      if month && legend
        rep.month_with_legend(month)
      elsif month
        rep.generate_month_report(month)
      elsif legend
        Report.legend
      else
        'Unfinished path at the moment'
      end
    end
  end
end
