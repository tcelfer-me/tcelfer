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
require 'json'

require 'tcelfer/day'

module Tcelfer
  # Store the data for tcelfer
  class Storage
    attr_reader :data

    def initialize
      load!
    end

    def load!
      @data = File.exist?(Tcelfer.config.db_path) ? JSON.parse(File.read(Tcelfer.config.db_path)) : {}
    end

    def save!
      cache_dir = File.dirname(Tcelfer.config.db_path)
      FileUtils.mkdir_p(cache_dir) unless Dir.exist? cache_dir
      File.write(Tcelfer.config.db_path, JSON.pretty_generate(@data))
    end

    def by_month(mon)
      raise StorageError, "Invalid Month #{mon}, valid: [1-12]" unless (1..12).cover? mon

      raw_days = @data.group_by { |k, _v| Date.parse(k).month }
      raw_days.fetch(mon, {}).map do |date, info|
        Day.new(info['rating'], info['notes'], Date.parse(date))
      end
    end
  end
end
