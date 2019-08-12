# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [1.0.4]  - 2019-08-12
### Changed
- new subcommands under `tcelfer db` to replace the `bin/db_init` functionality
  - initdb|migrate: run all or some DB migrations (up or down)
  - path: shows the path of the database (could be made into `tcelfer env` instead maybe?
  - new config option, `:migrations_path`, defaults to `<tcelfer_gem_root>/db/migrations`
- updated Ruby versions for Travis CI
- updated several gem dependencies

## [1.0.3]  - 2019-05-21
### Added
- `--yesterday` flag for `tcelfer day`
- `tcelfer ytd`
  - show all months up through the current one
- Enable JSON serializer plugin for sequel Day model

## [1.0.2]  - 2019-01-18
### Added
- Some action screenshots
### Fixed
- Correctly handle the --verbose flag now

## [1.0.1]  - 2019-01-18
### Fixed
- Flags for debug and specifying dates for `tcelfer day` collided

## [1.0.0]  - 2019-01-17
### Initial Public Release
- Record today or any date you choose
- Stores in a sqlite3 db at a configurable path
- Reports in monthly increments when there's at least a week of data for that month
