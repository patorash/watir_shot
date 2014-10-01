# WatirShot

WatirShotはSeleniumでymlファイルに書かれたurlにアクセスしてスクリーンショットを取ることができます。  
スクリーンショットは、rails_app/tmp/watir_shot/以下の保存されます。

## Installation

Add this line to your application's Gemfile:

    gem 'watir_shot'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install watir_shot

## Generation

WatirShot用のファイルを生成します。(config/initializers/watir_shot.rbとconfig/watir_shot.yml)  
初回は自動的にrake routesのGETメソッドを抽出してconfig/watir_shot.ymlを作成します。

    $ bundle exec rails g watir_shot

## Configuration

### config/initializers/watir_shot.rb

default_url_optionsにschemaとhostを設定します。
また、before blockを定義することで、ログイン処理などの事前処理を行わせることができます。

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
    end

### config/watir_shot.yml



    pages:
      default:
        -
           title: 'Top'
           path: '/'
        -
           title: 'About'
           path: '/about'
      admin_user:
        -
           title: 'Top'
           path: '/'
        -
           title: 'About'
           path: '/about'

## Run

### firefox
    $ bundle exec rake watir_shot:capture
### Chrome
    $ bundle exec rake watir_shot:capture[chrome]
### InternetExplorer
    $ bundle exec rake watir_shot:capture[ie]

## Contributing

1. Fork it ( https://github.com/[my-github-username]/watir_shot/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request