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
require 'anyway'

module Tcelfer
  # Configuration for tcelfer, thanks to anyway_config
  class Config < Anyway::Config
    config_name :tcelfer
    attr_config(
      :sqlite_path,
      debug:           false,
      update_existing: false,
      migrations_path: File.expand_path('../../db/migrations', __dir__)
    )

    def validate!
      return self if sqlite_path

      raise Tcelfer::StorageError, 'Please set `sqlite_path` to continue'
    end
  end
end
