require "settings/setting"

module Settings
  class Collection
    SettingNotFound = Class.new(StandardError)

    def initialize(key)
      @key = key
      @settings = Hash.new
      @collections = Hash.new { |hash, key| hash[key] = Collection.new(key) }
    end

    def store(key, value)
      key = key.to_s
      settings[key] = Setting.new(key: key, value: value)
    end

    def empty?
      settings.empty?
    end

    def collection(key)
      key = key.to_s
      collections[key]
    end

    private

    attr_reader :settings, :collections

    def method_missing(name, *args)
      raise "Need to first check any collections for :name, then check settings."
      key = name.to_s
      if settings.include?(key)
        settings[key].value
      else
        raise SettingNotFound, "Setting for '#{key}' not found"
      end
    end
  end
end
