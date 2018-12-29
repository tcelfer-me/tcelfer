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
require 'thor'
require 'tty-prompt'

require 'tcelfer/storage'

module Tcelfer
  # Thor CLI for Tcelfer
  class CLI < Thor
    # rubocop:disable Metrics/MethodLength
    def initialize(*_args)
      @day_ratings = [
        'Amazing, Fantastic Day',
        'Really Good, Happy Day',
        'Normal, Average Day',
        'Exhausted, Tired Day',
        'Stressed-Out, Frantic Day',
        'Frustrated, Angry Day',
        'Depressed, Sad Day'
      ]
      @prompt = TTY::Prompt.new

      super
    end
    # rubocop:enable Metrics/MethodLength

    desc 'day', 'record info for a day'
    def day
      rating = @prompt.select(
        'How was your day?',
        @day_ratings,
        required: true,
        filter: true
      )
      notes = @prompt.ask('Any additional notes?')
      store = Tcelfer::Storage.new
      store.data[Date.today.to_s] = { rating: rating, notes: notes }
      store.save!
    end
  end
end
