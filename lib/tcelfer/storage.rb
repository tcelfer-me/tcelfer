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
require 'sequel'

module Tcelfer
  # Middleware between Sequel and everything else
  class Storage
    attr_reader :days

    def initialize
      Sequel.connect("sqlite://#{Tcelfer.config.sqlite_path}")
      Dir["#{__dir__}/models/*"].each(&Kernel.method(:require))
      @days = Tcelfer::Models::Day
    end

    def by_month(mon, year)
      raise StorageError, "Invalid Month #{mon}, valid: [1-12]" unless (1..12).cover? mon

      @days.where(date: Date.new(year, mon, 1)..Date.new(year, mon, -1)).to_a
    end

    def by_year(year)
      @days.where(date: Date.new(year, 1, 1)..Date.new(year, -1, -1)).to_a
    end
  end
end
