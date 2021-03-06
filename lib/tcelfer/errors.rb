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

module Tcelfer
  # Base error class, extend this one please
  class Error < StandardError; end

  # Issues with Storage
  class StorageError < Error; end

  # When we have a dupe and weren't asked to overwrite
  class DuplicateDayError < StorageError
    # The return value here is used by Sinatra's error handling
    # It leads into the `error 4XX {...}` blocks
    def http_status
      409
    end
  end

  # Issues with reports
  class ReportError < Error; end

  # Issues with the CLI
  class CliError < Error; end
end
