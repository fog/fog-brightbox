# Brightbox Cloud module for fog (The Ruby cloud services library)

This gem is a module for the `fog` gem that allows you to manage resources in
the Brightbox Cloud.

It is included by the main `fog` metagem but can used as an independent library
in other applications.

This includes support for the following services:

* Compute
  * Images
  * Load Balancers
  * SQL Cloud instances

Currently all services are grouped within `compute` but will be moved to their
own sections when standardisation of fog progresses.

## Installation

Add this line to your application's Gemfile:

    gem "fog-brightbox"

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fog-brightbox

## Usage

Please see the following references for instructions using the main `fog` gem
and its modules:

* https://github.com/fog/fog
* http://fog.io/
* http://rubydoc.info/gems/fog/

### Ruby version support

As required by the main `fog-core` library, support for Ruby 1.9 was dropped in
`v1.0.0` of this gem.

Upstream changes on dependencies have resulted in support failing for Ruby <2.3
from `v1.12.0` due to some libraries failing to declare usage of newer language
features in their own gemspec files.

As of 2024 `fog-core` is only testing for Ruby 3.0+ support.

## Contributing

1. Fork it ( https://github.com/fog/fog-brightbox/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
