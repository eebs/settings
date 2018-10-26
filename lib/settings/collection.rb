require "settings/setting"

module Settings
  class Collection
    SettingNotFound = Class.new(StandardError)

    def initialize
      @settings = Hash.new
    end

    def store(key, value)
      key = key.to_s
      settings[key] = Setting.new(key: key, value: value)
    end

    def empty?
      settings.empty?
    end

    private

    attr_reader :settings

    def method_missing(name, *args)
      key = name.to_s
      if settings.include?(key)
        settings[key].value
      else
        raise SettingNotFound, "Setting for '#{key}' not found"
      end
    end
  end
end
