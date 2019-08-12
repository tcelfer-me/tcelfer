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
  module CLI
    # Subcommands for various database tasks
    class DBTasks < Thor
      def initialize(*_args)
        # Quit on Ctrl-C please
        @prompt = TTY::Prompt.new(interrupt: :exit)

        super
      end

      # Useful return codes are nice, of course
      def self.exit_on_failure?
        true
      end

      # Used to force migrations, and other destructive actions
      class_option(:force, aliases: %w[-f], type: :boolean, default: false)
      # Set up debug things I guess? This could be messy
      class_option(:verbose, aliases: %w[-v], type: :boolean, default: false)

      desc 'initdb', 'Initialize the database'
      def initdb
        Tcelfer.config.debug = options[:verbose]
        _db_exists! if File.exist?(Tcelfer.config.sqlite_path) && !options.force

        _db_migrate!
      rescue Tcelfer::Error => e
        @prompt.error("[#{e.class}]", e)
      end

      desc 'migrate [--version|-M]', 'Initialize the database'
      method_option(:version, aliases: %w[-M], type: :numeric, required: false)
      def migrate
        Tcelfer.config.debug = options[:verbose]
        _db_migrate!(options.version)
      rescue Tcelfer::Error => e
        @prompt.error("[#{e.class}]", e)
      end

      desc 'path', 'print the current db path, useful for debugging'
      def path
        @prompt.say(Tcelfer.config.sqlite_path)
      end

      private

      # Migrate the DB to a specific version, or latest if none specified
      def _db_migrate!(version = nil)
        require 'sequel/core'
        Sequel.connect("sqlite://#{Tcelfer.config.sqlite_path}") do |db|
          db.loggers << Logger.new($stderr) if Tcelfer.config.debug
          Sequel.extension :migration
          Sequel::Migrator.run(db, Tcelfer.config.migrations_path, target: version)
        end
      end

      def _db_exists!
        raise CliError, "Database file `#{Tcelfer.config.sqlite_path}' already exists."
      end
    end
  end
end
