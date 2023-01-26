### 1.11.0 / 2023-01-26

Enhancements:

* Add `DatabaseServer#reset` and `#resize` methods
* Added requests to support database server resets and resizing

Bug fixes:

* Remove duplicated request references
* Fix test method declaration causing parsing error in Ruby 2.0

Changes:

* Added `rubocop` gem configured to Ruby 2.0
* Cleaning up of codebase to fix various style and layout problems

### 1.10.0 / 2023-01-24

Enhancements:

* Add `ConfigMap#save` and `#destroy` methods to allow model updates

### 1.9.1 / 2023-01-10

Bug fixes:

* Allow `encrypted` parameter in `Volume#save` to allow it to propagate from
  the model to the API request
### 1.9.0 / 2023-01-09

Enhancements:

* Expose read-only `Volume.zone` attribute on model to report which zone the
  volume was allocated to
* Add `boot` argument to `Volume#attach` to allow changing the boot volume of
  inactive servers via the model API by passing through to the API request

Changes:

* Fix Github actions `setup-ruby` version to pick up bug fixes in running tests
  caused by the older templates mismatching Ruby/Bundler versions
* Correct CHANGELOG for mixed references of "enhancements" and minor "changes"

### 1.8.2 / 2022-12-06

Bug fixes:

* Fix issue in storage directory `#save` that prevented creating and updating
  permissions/ACL on Orbit containers correctly

### 1.8.1 / 2022-12-05

Bug fixes:

* Remove outdated check for required arguments in `Image.create` model which
  prevented using newer arguments in the latest API version

### 1.8.0 / 2022-08-31

Enhancements:

* Allow custom `volume_size` in server creation where supported

### 1.7.3 / 2022-08-17

Bug fixes:

* Fix to deduplicate forward slashes in `Storage::File#public_url` when object keys are prefixed with "/"

### 1.7.2 / 2022-08-17

Bug fixes:

* Fix in `Storage.escape` regexp which failed to handle dashes correctly and broke generated URLs.

### 1.7.1 / 2022-08-17

Bug fixes:

* Implement `Storage::Directory#public_url` to allow generation of `File` public URLs correctly.

### 1.7.0 / 2022-07-28

Enhancements:

* Adds support for `ConfigMaps` which are simple key/value stores for configuring
  other resources.
* Updated the API models to include the latest set of attributes defined in the
  Brightbox API enabling them to be referenced.

### 1.6.0 / 2022-07-25

Enhancements:

* Added support to opt-in to support Brightbox 2FA within clients.

Two Factor Authentication (2FA) support:

Passing `brightbox_support_two_factor` into a configuration will raise a new
error when user authentication has failed BUT the presence of the
`X-Brightbox-OTP: required` HTTP header is found.

This new error `Fog::Brightbox::OAuth2::TwoFactorMissingError` can be handled
differently by the client and the second factor can be prompted for or
recovered from a secure keychain.

Without opting in, the previous error `Excon::Errors::Unauthorized` is raised.

To send the OTP, the `brightbox_one_time_password` can be passed into a
configuration object or one_time_password can be passed to a credentials
object.

### 1.5.0 / 2022-06-09

Enhancements:

* Added support for `Volume` resources. These are dynamic, network attached
  volumes. Servers with `nbs` (Network Block Storage) types can be created
  from volumes. Additional volumes can be attached to a server. The volumes
  can be quickly copied and resized.

### 1.4.2 / 2022-06-09

Bug fixes:

* `Fog::Brightbox::Compute::ImageSelector#latest_ubuntu` was fixed to resolve
  two bugs that prevented the latest version being found since Xenial:
  * The filtering for `i686` was missing later release which are only available
    as `x86_64` images following support being dropped upstream. The filter is
    now swapped to only match 64bit releases.
  * The reverse name sorting failed when the Ubuntu codenames returned to the
    start of the alphabet so `xenial` (16.04) would appear above `bionic`
    (18.04) or `jammy` (22.04). The names are now split and the version used
    instead for the sorting.

### 1.4.1 / 2021-04-20

Bug fixes:

* Fix passing `snapshots_schedule` to database servers as the value was being
  omitted in the model layer. This was preventing creating without a schedule
  causing the default behaviour.

### 1.4.0 / 2021-02-17

Enhancements:

* Relax dependencies to allow Ruby 3.0 to be used.

### 1.3.0 / 2020-11-24

Enhancements:

* Add `Server#disk_encrypted` attribute to support creation of servers with
  LUKS based encryption at rest.

### 1.2.0 / 2020-11-16

Enhancements:

* Add `LoadBalancer#ssl_minimum_version` attribute to configure the TLS/SSL
  version supported by the load balancer.

### 1.1.0 / 2020-06-30

Changes:

* Add Ruby 2.6 and 2.7 to Travis CI testing matrix.
* Remove bundler installation step from Travis CI.
* Use `example.test` for testing domains rather than `example.com` to avoid
  leaking routable traffic.
* Add `FOG_TEST_COLLABORATOR_EMAIL` to enable ENV based setting of email
  address when using the tests for integation tests.`

Bug fixes:

* Add `status` check to `ImageSelector` so that unavailable images were not
  selected for use automatically and causing failures in tests.
* Fix creating database servers from snapshots by adding the `snapshot_id`
  attribute ensuring the value is not filtered when using the model.

### 1.0.0 / 2018-10-05

Major Changes:

* Gem version has been changed 1.0 to reflect breaking changes.
* Ruby versions 1.9 is longer supported as per fog-core v2.
* Ruby versions 2.0 and 2.1 are no longer supported by Brightbox although a
  hard value has not been used in the gemspec to avoid issues with `fog`
* Remove deprecated versions of `#(get|update)_account` and `#get_user` which
  did not require identifiers and were treated as the authenticated user.
* Remove deprecated `Compute#request` multiple argument version.
* Remove deprecated `#destroy_(resource)` requests.
* Fix `#destroy_(resource)` references in models.

### 0.16.1 / 2018-09-07

Bug fixes:

* Fix ordering issue between declaration of fog services and `autoload` modules.
  Changes in `fog-core` would reference modules before available in autoload so
  caused a name error.

### 0.16.0 / 2018-09-04

Changes:

* Replaced abandoned `inflecto` dependency with `dry-inflector` gem.

### 0.15.1 / 2018-06-22

Bug fixes:

* Remove pessimistic dependency versions.

### 0.15.0 / 2018-06-14

Bug fixes:

* Attempting to generate a temporary URL for a storage object would fail with
  unclear message. Now a `Fog::Brightbox::Storage::ManagementUrlUnknown` is
  raised instead. It must be either configured OR an authentication request
  made before so the management URL is received from the server.
* `:brightbox_storage_management_url` is now whitelisted to be passed in to the
  configuration to avoid the authentication previously required.

### 0.14.0 / 2017-10-30

Enhancements:

* Added `public_ipv6` and `public_ipv4` attributes to `CloudIp` model to access
  both types of exposed IP addresses. The deprecated `public_ip` attribute
  remains.

### 0.13.0 / 2017-08-01

Enhancements:

* Added `cloud_ip` argument to server creation to request an immediate mapping
  when a server build has completed. Either to a known cloud IP using its
  identifier or by using `true` to allocate a new IP for the operation.

### 0.12.0 / 2017-07-19

Enhancements:

* Exposed `domains` field on load balancers to support Let's Encrypt via models

Bug fixes:

* Ruby 1.9 Gemfile was locked down against `webmock` and `public_suffix`
  dropping support for Ruby 2.0

### 0.11.0 / 2016-07-05

Enhancements:

* Exposed fields on database servers related to automatic scheduled snapshots.

Bug fixes:

* Removed an error spec broken by Excon v0.50 undergoing a change of error
  namespace breaking loading of the specs at present.

Changes:

* Stop testing Ruby 1.8.7 due to bitrot, the dependencies are creating more
  issues than needed.

### 0.10.1 / 2015-12-01

Bug fixes:

* Do not add `nested` option as body content, only query if present.

### 0.10.0 / 2015-11-30

Changes:

* Updated auto-generated documentation for requests
* Added `options` to all requests. Select options are passed through to the API
  to alter behaviour for all requests.
* Allow requests to use `nested=false` option to collapse nested (or children)
  resources from the JSON which is faster to render and less content.
* Make `list_accounts` default to `nested=false` because it is very slow for
  large accounts and the nested resources are rarely used.

### 0.9.0 / 2015-08-18

Changes:

* Updated the OAuth model to better reflect the final OAuth 2.0 spec. This is
  not a breaking change since the server side component remain backwards
  compatible so usage of the `fog` API should not have changed.
* Updated `travis.yml` to use faster container architecture.
* Moved `shindo` tests into repo from main `fog` gem. These act as acceptance
  tests against real environments.
* Moved OAuth module specs from Shindo to Minispec.

Bug fixes:

* Use `Authorization: Bearer` scheme rather than draft value of "Token"
* Use `client_credentials` grant type rather than draft value of "none"
* Remove duplicate scheme keys causing warnings in Shindo tests

### 0.8.0 / 2015-07-16

Changes:

* Add `CloudIp#fqdn` attribute
* Use relative paths and reduce requires

### 0.7.2 / 2015-06-25

Bug fixes:

* Error if management URL is not `URI` to prevent errors when a `String` given.
* `Server#bits` returns "64" as a placeholder rather than "0".
* Fixed requires in specs so can they can all run independently.

Changes:

* Fixed some indentation problems.

### 0.7.1 / 2014-12-05

Bug fixes:

* Fixed implementation of `Storage#create_temp_url` (except on Ruby 1.8.7)

### 0.7.0 / 2014-11-27

Enhancements:

* Can read `Link` headers returned from snapshot actions
* Optionally allow return or `Snapshot` objects from snapshot actions.

Bug fixes:

* Ignore select directories from version control.
* Removed duplicate spec_helper
* Addition of style rules using `rubocop`
* Automated clean up of style rules
* Be pessimistic about `inflecto` gem.
  Next release of Inflecto gem will introduce 1.9 constraint so we need to be
  pessimistic about the version to depend on for now.

### 0.6.1 / 2014-10-22

Bug fixes:

* Fixes reading from `Server#ssl3?`

### 0.6.0 / 2014-10-21

Enhancements:

* Allow setting of Load Balancer SSL v3 parameter when creating or updating.

### 0.5.1 / 2014-09-15

Bug fixes:

* Fix a possible authentication loop when bad credentials or expired tokens
  would trigger repeated attempts to authenticate with no changes to the
  bad credentials.

### 0.5.0 / 2014-09-01

Enhancements:

* Allow setting of Load Balancer buffer sizes during create and update calls.

### 0.4.1 / 2014-08-28

Bug fixes:

* Default updated to final hostname of `orbit.brightbox.com`.

### 0.4.0 / 2014-08-28

Enhancements:

* Add Add support for Brightbox Orbit cloud storage service. This adds a
  `storage` service to the Brightbox provider using the standard `fog`
  interfaces.

### 0.3.0 / 2014-08-12

Enhancements:

* Use improved reset and reboot requests for the `Server#reboot` method
  allowing requests without having to fake restarts with a start/stop. This
  keeps the VNC console active.

### 0.2.0 / 2014-08-07

Enhancements:

* Add resource locks to prevent accidental deleting of the following resources:
  * Database servers
  * Database snapshots
  * Images
  * Load balancers
  * Servers

### 0.1.1 / 2014-06-26

Bug fixes:

* Fix `list_events` options to have workable defaults

### 0.1.0 / 2014-06-25

Enhancements:

* Add `pry` as a development dependency so available under Bundler
* Add `spec_helper` to DRY out requires on start of tests
* Add `Fog::Brightbox::Model` layer to add shared functionality between models
* Add `#resource_name` and `#collection_name` inflection methods to models
* Add basic specs for models

Changes:

* Update generated documentation for requests

Bug fixes:

* Fix `rake:spec` task to add "spec" to LOAD_PATH

### 0.1.0.dev2 / 2014-04-22

This PRERELEASE version may contain functionality that may be removed before
the next release so all APIs should be considered unstable and you should lock
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
