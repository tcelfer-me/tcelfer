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

module Tcelfer
  # Store the data for tcelfer
  class Storage
    attr_reader :data

    DEFAULT_STORE_PATH = File.join(File.expand_path('../../', __dir__), 'tmp', 'dev_store.json')

    def initialize
      load!
    end

    def load!
      @data = File.exist?(DEFAULT_STORE_PATH) ? JSON.parse(File.read(DEFAULT_STORE_PATH)) : {}
    end

    def save!
      File.write(DEFAULT_STORE_PATH, @data.to_json)
    end
  end
end
