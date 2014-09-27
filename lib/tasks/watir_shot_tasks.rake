# desc "Explaining what the task does"
# task :watir_shot do
#   # Task goes here
# end
require "pry"
require "watir"
require 'watir-webdriver'

desc "Capture screenshot by watir"
task :watir_shot, "browser_type"
task watir_shot: :environment do |_, args|
  browser_type = args.browser_type.to_sym if args.browser_type.present?
  browser_type ||= :firefox
  watir_shot_path = Rails.root.join("config/watir_shot.yml")
  watir_shot_pages = YAML.load_file(watir_shot_path)["pages"]
  raise Exception.new("Need default key in watir_shot.yml") unless watir_shot_pages.keys.include?('default')
  # ブラウザの生成
  browser = case browser_type
              when :chrome
                Watir::Browser.new :chrome, switches: %w[--test-type --ignore-certificate-errors --disable-popup-blocking --disable-translate]
              # when :safari
              #   Watir::Browser.new :safari
              else
                Watir::Browser.new(browser_type)
            end

  watir_shot_pages.keys.each do |key|
    # スクショ保存用ディレクトリの準備
    tmp_dir = Rails.root.join("tmp/watir_shot/#{browser.driver.browser.to_s}/#{key}")
    FileUtils.mkdir_p tmp_dir unless Dir.exist? tmp_dir
    # ディレクトリの中身を掃除する
    FileUtils.rm(Dir.glob(tmp_dir.to_s + '/**/*.png'))
    # beforeの処理があれば行う
    WatirShot.befores[key.to_sym].call(browser) if WatirShot.befores[key.to_sym].present?
    watir_shot_pages[key].each.with_index(1) do |page, index|
      browser.goto WatirShot.base_url + page['path']
      browser.screenshot.save "#{tmp_dir}/#{sprintf('%04d', index)}-#{page['title']}.png"
    end
    # afterの処理があれば行う
    WatirShot.afters[key.to_sym].call(browser) if WatirShot.afters[key.to_sym].present?
  end
  browser.close
end