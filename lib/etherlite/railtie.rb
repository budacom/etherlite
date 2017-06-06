require "etherlite/railties/configuration_extensions"
require "etherlite/railties/utils"

# Add rails specifig related configuration parameters
class Etherlite::Configuration
  include Etherlite::Railties::ConfigurationExtensions
end

module Etherlite
  class Railtie < Rails::Railtie
    initializer "etherlite.configure" do
      if File.exists? "#{Rails.application.paths['config'].existent.first}/etherlite.yml"
        Etherlite.configure Rails.application.config_for(:etherlite)
      end

      Etherlite.config.logger = Rails.logger
    end

    initializer "etherlite.load_available_contracts", after: "etherlite.configure" do
      Etherlite::Railties::Utils.load_contracts(Rails.root.join(Etherlite.config.contracts_path))
    end

    rake_tasks do
      # Nothing for now
    end

    # IDEA: use config.to_prepare to reload contracts on every request.
  end
end
