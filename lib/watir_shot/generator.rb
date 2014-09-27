module WatirShot
  class WatirShotGenerator < Rails::Generators::Base
    desc "Initialize WatirShot"
    def create_initializer_file
      initializer "watir_shot.rb" do
        <<-FILE.strip_heredoc
WatirShot.configure do |config|
  config.default_url_options = {host: "localhost:3000"}
end
        FILE
      end
    end


  end
end