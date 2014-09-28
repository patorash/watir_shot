namespace :watir_shot do
  desc "Create config/watir_shot.yml"
  task create_yml: :environment do
    require 'watir_shot/generator'
    WatirShot::WatirShotGenerator.new.create_routes_yml
  end

  desc "Capture screenshot by watir.(Ex. rake watir_shot:capture[chrome])"
  task :capture, "browser_type"
  task capture: :environment do |_, args|
    require "pry"
    require "watir"
    browser_type = args.browser_type.to_sym if args.browser_type.present?
    browser_type ||= :firefox
    watir_shot_yml_path = Rails.root.join("config/watir_shot.yml")
    unless File.exist? watir_shot_yml_path
      raise Exception.new("config/watir_shot.yml not found.\nCreate config/watir_shot.yml(rake watir_shot:create_yml)")
    end
    watir_shot_pages = YAML.load_file(watir_shot_yml_path)["pages"]
    raise Exception.new("Need default key in watir_shot.yml") unless watir_shot_pages.keys.include?('default')
    # generate browser
    browser = case browser_type
                when :chrome
                  Watir::Browser.new :chrome, switches: %w[--test-type --ignore-certificate-errors --disable-popup-blocking --disable-translate]
                else
                  Watir::Browser.new(browser_type)
              end

    watir_shot_pages.keys.each do |key|
      # prepare saved screenshot directory
      tmp_dir = Rails.root.join("tmp/watir_shot/#{browser.driver.browser.to_s}/#{key}")
      FileUtils.mkdir_p tmp_dir unless Dir.exist? tmp_dir
      # clean screenshot directory before capture.
      FileUtils.rm(Dir.glob(tmp_dir.to_s + '/**/*.png'))
      # do pre-processing
      WatirShot.befores[key.to_sym].call(browser) if WatirShot.befores[key.to_sym].present?
      watir_shot_pages[key].each.with_index(1) do |page, index|
        browser.goto WatirShot.base_url + page['path']
        browser.screenshot.save "#{tmp_dir}/#{sprintf('%04d', index)}-#{page['title']}.png"
      end
      # do post-processing
      WatirShot.afters[key.to_sym].call(browser) if WatirShot.afters[key.to_sym].present?
    end
    browser.close
  end
end