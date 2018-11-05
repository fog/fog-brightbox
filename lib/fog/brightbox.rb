require "fog/core"
require "fog/json"

# See the main fog gem for more details about the top level class {Fog}
#
# @see https://github.com/fog/fog
# @see http://fog.io/
# @see http://rubydoc.info/gems/fog
#
module Fog
  module Brightbox
    extend Fog::Provider

    autoload :Compute, File.expand_path("../brightbox/compute", __FILE__)
    autoload :Storage, File.expand_path("../brightbox/storage", __FILE__)

    autoload :Config, File.expand_path("../brightbox/config", __FILE__)
    autoload :LinkHelper, File.expand_path("../brightbox/link_helper", __FILE__)
    autoload :Model, File.expand_path("../brightbox/model", __FILE__)
    autoload :ModelHelper, File.expand_path("../brightbox/model_helper", __FILE__)
    autoload :OAuth2, File.expand_path("../brightbox/oauth2", __FILE__)

    service(:compute, "Compute")
    service(:storage, "Storage")
  end
end
