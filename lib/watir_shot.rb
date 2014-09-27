module WatirShot

  mattr_accessor :default_url_options
  @@default_url_options

  def self.configure
    yield self
  end

  mattr_accessor :befores
  @@befores = {}

  def self.before(key, &block)
    @@befores[key] = block
  end

  mattr_accessor :afters
  @@afters = {}

  def self.after(key, &block)
    @@afters[key] = block
  end

  def self.base_url
    @@default_url_options[:schema] + "://" + @@default_url_options[:host]
  end
end
require 'railtie'