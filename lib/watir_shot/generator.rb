module WatirShot
  class WatirShotGenerator < Rails::Generators::Base
    desc "Initialize WatirShot"
    def create_initializer_file
      initializer "watir_shot.rb" do
        <<-FILE.strip_heredoc
WatirShot.configure do |config|
  config.default_url_options = {schema: "http", host: "localhost:3000"}

  config.before :default do |browser|
    # Please input setup.
    # (Ex: Sign in)
    #
    # browser.goto WatirShot.base_url + '/user/login'
    # browser.text_field(:id, "user_email").set("foo@example.com")
    # browser.text_field(:id, "user_password").set("something")
    # browser.button(:value, "Sign In").click
  end

  config.after :default do |browser|
    # Please input after.
    # (Ex: Sign out)
    #
    # browser.link(:text, "Sign Out").click
  end

  # If you want to capture in various situations, make a new symbol.
  # And you should add new element in watir_shot.yml
  # (Ex. Admin user)
  #
  # config.before :admin_user do |browser|
  #   # Something
  # end
  #
  # config.after :admin_user do |browser|
  #   # Something
  # end
  #
  # Sample watir_shot.yml
  # ---
  # pages:
  #   default:
  #     -
  #        title: 'TopPage'
  #        path: '/'
  #   admin_user:
  #     -
  #        title: 'TopPage'
  #        path: '/'
end
        FILE
      end
      create_routes_yml
    end

    def create_routes_yml
      all_routes = Rails.application.routes.routes
      require 'action_dispatch/routing/inspector'
      inspector = ActionDispatch::Routing::RoutesInspector.new(all_routes)
      routes = inspector.format(ActionDispatch::Routing::ConsoleFormatter.new, ENV['CONTROLLER']).split("\n")
      method_get_routes = routes.select{|route| route =~ /GET/ }.map{|route| route.strip }
      paths = method_get_routes.map{|route| route.gsub(/\s+/, ' ').split(' ')[2].gsub('(.:format)', '')}
      routes_yml = {'pages' =>
           {'default' => paths.map{|path| {'title' => '', 'path' => path}} }
      }.to_yaml
      create_file "config/watir_shot.yml", routes_yml
    end
  end
end