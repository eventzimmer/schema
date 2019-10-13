# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Added RSS type

### Changed
- Split auth config into development and production

## 0.3.0
### Added
- Added proposed_events_by_organizer view
- Added proposed_events table
- Added accept_event function

## 0.2.0
### Fixed
- Return exactly two months in protected.recent_events
- Fixed bug in OpenAPI definition (wrong remote host)
- Make sources and locations unique

### Changed
- Use docker for psql and migrate commands
- Cascade events when source or location is deleted

### Added 
- Add view for locations and for sources listed by owner
- Make it possible to insert and delete locations and sources

## 0.0.1
### Added
- Added CONTRIBUTING.md
- Add docker development and deploy compose config
- Add system service config
- Add deployment information
- Make it possible to import old events
- Initial eventzimmer schema to match the current 0.2.0 API specification from OpenAPI
