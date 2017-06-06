module Etherlite
  class InitGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)

    desc "Initializes the app to work with etherlite"
    def create_index
      template("etherlite.yml", "config/etherlite.yml")
    end
  end
end
