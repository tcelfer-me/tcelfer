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
require 'tcelfer'

module Tcelfer
  # Handle "business" logic with days
  class Day
    attr_reader :rating, :notes

    def initialize(rating, notes)
      @rating = rating
      @notes = notes
    end

    def save!
      @store = Tcelfer::Storage.new
      today = Date.today.to_s
      raise(Tcelfer::Error, "You already created an entry for #{today}") if @store.data.include?(today)

      @store.data[Date.today.to_s] = { rating: @rating, notes: @notes }
      @store.save!
    end
  end
end
