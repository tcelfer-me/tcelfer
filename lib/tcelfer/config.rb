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
require 'anyway'

module Tcelfer
  # Configuration for tcelfer, thanks to anyway_config
  class Config < Anyway::Config
    config_name :tcelfer
    attr_config(
      :sqlite_path,
      debug: false,
      update_existing: false
    )

    def validate!
      raise Tcelfer::StorageError, 'TCELFER_SQLITE_PATH not defined, cannot continue' if sqlite_path.nil?

      self
    end
  end
end
