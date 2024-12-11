# Brightbox Cloud module for fog (The Ruby cloud services library)

This gem is a module for the [`fog`](https://github.com/fog/fog) gem that allows
you to manage resources in the [Brightbox Cloud](https://brightbox.com).

It is included by the main `fog` meta-gem but can used as an independent library
in other applications.

This includes support for the following services:

* Compute
  * Accounts
  * Api Clients
  * Applications (User Credentials)
  * Cloud IPs
  * Cloud SQL (Database Server)
  * Database Snapshots
  * Firewall Policies and Rules
  * Images
  * Load Balancers
  * Servers
  * Server Groups
  * Server Types (Flavors)
  * Users
  * User Collaborations
  * Volumes
  * Zones
* Storage (Orbit via Switch compatibility)
  * Directories
  * Files

## Installation

Add this line to your application's Gemfile:

    gem "fog-brightbox"

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install fog-brightbox

## Configuration

This code can use `fog`'s credentials or can be configured by passing in the
details to the [Fog::Brightbox::Config](lib/fog/brightbox/config.rb).

### Using `fog`

Assuming credentials are setup as expected by fog, the configuration can be used
as such:

```ruby
@config = Fog::Brightbox::Config.new(Fog.credentials)
```

### Using options Hash

Alternatively credentials can be set using a Hash of options:

```ruby
@config = Fog::Brightbox::Config.new(
    brightbox_client_id: "cli-12345",
    brightbox_secret: "<demo-value>"
)
```

See [Fog::Brightbox::Config's documentation](lib/fog/brightbox/config.rb) for
all possible settings.

## Usage

Here is a basic example of usage:

```ruby
require "fog/brightbox"

# Passing either a configuration object or Hash of options are supported
@service = Fog::Brightbox::Compute.new(
  brightbox_client_id: "acc-12345",
  brightbox_secret: "<demo-value>"
)

# Request all servers using the class method
servers = @service.servers.all
servers.each do |server|
  puts server.id
end
```

An alternative using a configuration object instead:

```ruby
require "fog/brightbox"

@config = Fog::Brightbox::Config.new(
  brightbox_client_id: "acc-12345",
  brightbox_secret: "<demo-value>"
)
@service = Fog::Brightbox::Compute.new(@config)
# Use service as normal
```

The main advantages of using a configuration option is that it can be set from
the main `Fog.credentials` which could be configured for  numerous service
providers.

`Fog::Brightbox::Config` also wraps around credentials itself so will manage
OAuth access and refresh tokens. This can be disabled with the
`brightbox_token_management: false` setting.

Please see the following references for instructions using the main `fog` gem
and its modules:

* https://github.com/fog/fog
* http://rubydoc.info/gems/fog/

## Brightbox CLI

It may be that our [Brightbox CLI](https://github.com/brightbox/brightbox-cli)
(based on this library) is suitable for you than using the library directly.

## Ruby version support

As required by the main `fog-core` library, support for Ruby 1.9 was dropped in
`v1.0.0` of this gem.

Upstream changes on dependencies have resulted in support failing for Ruby <2.3
from `v1.12.0` due to some libraries failing to declare usage of newer language
features in their own gemspec files.

As of 2024 `fog-core` is only testing for Ruby 3.0+ support.

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/fog/fog-brightbox.

1. Fork it ( https://github.com/fog/fog-brightbox/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](LICENSE.txt).
