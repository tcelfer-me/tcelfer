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
require 'tcelfer/config'
require 'tcelfer/errors'
require 'tcelfer/storage'
require 'tcelfer/version'

# Main man Tcelfer himself
module Tcelfer
  # Found these on Reddit
  DAY_RATINGS = [
    'Amazing, Fantastic Day',
    'Really Good, Happy Day',
    'Normal, Average Day',
    'Exhausted, Tired Day',
    'Stressed-Out, Frantic Day',
    'Frustrated, Angry Day',
    'Depressed, Sad Day'
  ].freeze

  # Separate because reasons that used to make sense and fixing is not worth at the moment
  RATING_TO_COLOR_MAP = DAY_RATINGS.zip(
    # ordering taking from a mix of examples on reddit
    # and my own preferences.
    # '#4B0082' is indigo and :green != 'green' :(
    ['maroon', :green, 'peru', '#4B0082', :red, 'orange', :blue]
    # based on ColorPicker generic RGB on macOS if you want those
    # %w[#ca4674 #6ba089 #cca04d #4b0082 #bd2d26 #fb9f09 #5a86ac]
  ).to_h.freeze

  def self.config
    @config ||= Config.new
    @config.validate!
  end
end
