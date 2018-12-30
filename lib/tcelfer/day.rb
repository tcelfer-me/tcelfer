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

require 'tcelfer'

module Tcelfer
  # Handle "business" logic with day records
  class Day
    attr_reader :rating, :notes, :date

    def initialize(rating, notes, date = Date.today)
      raise(Tcelfer::DayError, "Rating, '#{rating}` not valid") unless Tcelfer::DAY_RATINGS.include? rating

      @rating = rating
      @notes = notes
      @date = date
    end

    def save!
      store = Tcelfer::Storage.new
      raise(Tcelfer::DayError, "You already created an entry for #{@date}") if store.data.include?(@date.to_s)

      store.data[@date.to_s] = { 'rating' => @rating, 'notes' => @notes }
      store.save!
      self
    end
  end
end
