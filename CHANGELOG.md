### 0.1.0.dev2 / 2014-04-22

This PRERELEASE version may contain functionality that is removed before the 
next release so all APIs should be considered unstable and you should lock
to the exact version if used!

Bug fixes:

* Reference fog-core-v1.22 rather than "master" branch now it is released.

### 0.1.0.dev1 / 2014-04-10

Enhancements:

* Add support for events feed

### 0.0.2 / 2014-04-10

Bug fixes:

* Add CHANGELOG.md to `fog-brightbox` module.
* Add MiniTest::Specs to project. Use `rake test` to check the code.
* Add Gemfile, Rakefile, README and LICENCE to start documenting project.
* Remove redundant calls to `Fog.credentials`. The code flow was such that the
  credentials were being passed in to `Fog::Compute::Brightbox` anyway.
* Isolate testing from contents of `~.fog` file which is leaking in throug the
  `Fog.credentials` global.

### 0.0.1 / 2014-02-19

Enhancements:

* Initial release of extracted `fog-brightbox` module. This is pretty much the
  pilot for fog modules so bear with us as we iron out the bugs.
