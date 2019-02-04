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
require 'logger'
require 'sequel'

module Tcelfer
  # Middleware between Sequel and everything else
  class Storage
    attr_reader :days

    def initialize
      db = Sequel.connect("sqlite://#{Tcelfer.config.sqlite_path}")
      db.loggers << Logger.new($stderr) if Tcelfer.config.debug
      validate_db! db
      Dir["#{__dir__}/models/*"].each(&Kernel.method(:require))
      @days = Tcelfer::Models::Day
      @days.plugin :update_or_create
    end

    # Record a new day or update an existing one
    # @param [String] rating
    # @param [String] notes
    # @param [Date] date
    def rec_day(rating, notes, date)
      if Tcelfer.config.update_existing
        days.update_or_create({ date: date }, rating: rating, notes: notes)
      elsif days.where(date: date).count.zero?
        days.new(date: date, rating: rating, notes: notes).save
      else
        raise Tcelfer::DuplicateDayError, "Date: `#{date}' already has a record. Try again tomorrow."
      end
    end

    # Returns an array of Tcelfer::Model::Day objects for the given month/year
    # @param [Integer] month
    # @param [Integer] year
    # @return [Array]
    def by_month(month, year)
      raise StorageError, "Invalid Month #{month}, valid: [1-12]" unless (1..12).cover? month

      @days.where(date: Date.new(year, month, 1)..Date.new(year, month, -1)).to_a
    end

    private

    def validate_db!(db)
      raise Tcelfer::StorageError, 'did you forget to run `bin/db_init`?' unless db.tables.include? :days
    end
  end
end
