require "simplecov"

SimpleCov.start do
  add_filter "/spec/"
  add_filter "/config/"
  add_filter "/vendor/"
end

# Currently just above 75% coverage - don't make it worse
SimpleCov.minimum_coverage 75

require "minitest/autorun"
require "fog/brightbox"
require "model_setup"
require "supports_resource_locking"
require "stock_storage_responses"
