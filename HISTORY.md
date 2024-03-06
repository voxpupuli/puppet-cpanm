## v0.9.17 (2023-06-01)
### Changed
- Merged PR#15 from jfoche to support stdlib <9

## v0.9.16 (2023-04-02)
### Changed
- Merged PR#14 (fixing #13) to fix checks for `@version`.

## v0.9.15 (2023-03-21)
### Changed
- Merged PR#10 from jovandeginst to allow stdlib versions <8.

## v0.9.13 (2022-04-20)
### Changed
- Fixed #11 from gremble regarding modules where detection of an
  installed version failed. Use `Module::Metadata` to get
  this information more reliably.

## v0.9.12 (2021-10-13)
### Changed
- Merged PR#10 from xiconfjs to allow `@version` in module names.

## v0.9.11 (2021-07-16)
### Changed
- Merged PR#8 from martindemello to correctly check :force in Puppet 5.5.

## v0.9.10 (2020-06-14)
### Changed
- Merged PR#7 from arpagon to change the top version limit for stdlib
  to <7.0.0 allowing the use of newer versions.
- Updated test fixtures to use stdlib 6.3.0.

## v0.9.9 (2018-09-06)
### Added
- Merged PR#5 from treyormsbee to add lwpbootstrap option which allows
  the bootstrap to be run with `--no-lwp`.

## v0.9.8 (2018-05-26)
### Added
- Added this changelog.
- Updated bundled `cpanm` to 1.7044.

## v0.9.6 (2018-05-26)
### Changed
- Fixed issue #3 where Perl modules that cannot be imported were reinstalled
  on every puppet run.

## v0.9.5 (2018-05-25)
### Added
- Merged a PR from @dutsmiller using `ensure_packages` rather than `package`
  resources to avoid conflicts.

### Changed
- Fixed an issue where modules with non-ASCII characters in their metadata
  triggered a bug in old versions of `Encode` with incorrect locale settings.
- Added a dependency on stdlib for the `ensure_packages` function.
- Added Debian 9.0 to the supported OS list.

## v0.9.4 (2017-03-27)
### Added
- Support for specifying a CPAN mirror with the `mirror` parameter.
- Tests for both supported platforms, Debian and Red Hat.

### Changed
- Fix examples to be compatible with Puppet 3.
- Clean up perllocal parsing.
- Update documentation.

## v0.9.3 (2016-12-21)
### Changed
- Add OS support to module metadata.

## v0.9.2 (2016-12-21)
### Removed
- Dependency on stdlib, which is not in use.

## v0.9.1 (2016-12-21)
### Removed
- Debug output.

## v0.9.0 (2016-12-21)
### Added
- Tests for the puppet code.
- Example manifests to test install, latest and remove.

### Changed
- Support cpanm being installed in `/usr/local/bin`.
- Add `perl-core` package on RHEL 6+.
- Fix various errors.
- Update README.
- Change licence to Perl to be compatible with cpanminus itself.

## v0.1.0 (2016-12-10)
### Added
- Initial code.
- Bundled a copy of cpanminus for bootstrapping.
