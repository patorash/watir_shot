require "test_helper"

class InstallGeneratorTest < Rails::Generators::TestCase
  tests WatirShot::WatirShotGenerator
  destination File.expand_path("../../tmp", __FILE__)
  setup :prepare_destination

  test "Assert all files are properly created" do
    run_generator
    assert_file "config/initializers/watir_shot.rb"
    assert_file "config/watir_shot.yml"
  end
end