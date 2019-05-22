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
require 'sequel'
require 'sequel/plugins/json_serializer'

module Tcelfer
  module Models
    # Day model
    class Day < Sequel::Model(:days)
      plugin :json_serializer
      # Pretty format for a Day model
      # 2019-01-17: Normal, Average Day
      # @return [String]
      def to_s
        str = "#{date}: #{rating}"
        str += " || Notes: #{notes}" unless notes.nil?
        str
      end
    end
  end
end
