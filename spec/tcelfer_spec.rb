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
RSpec.describe Tcelfer do
  context 'base info' do
    before(:all) do
      ENV['TCELFER_SQLITE_PATH'] = ''
    end
    it 'has a version number' do
      expect(Tcelfer::VERSION).not_to be nil
    end

    it 'defines more than one daily rating' do
      expect(Tcelfer::DAY_RATINGS.length).to be > 1
    end

    it 'is configurable with any_config' do
      expect(described_class.config).to be_a Anyway::Config
    end
  end
end
