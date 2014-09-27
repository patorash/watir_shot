require 'rails/railtie'
require 'watir_shot'

module WatirShot
  class Railtie < ::Rails::Railtie
    config.watir_shot = ActiveSupport::OrderedOptions.new
    config.eager_load_namespaces << WatirShot

    generators do
      require 'watir_shot/generator'
    end


    rake_tasks do
      load 'tasks/watir_shot_tasks.rake'
    end
  end
end