require "settings/setting"

module Settings
  class Collection
    SettingNotFound = Class.new(StandardError)
    CollectionNotFound = Class.new(StandardError)
    ExistingSetting = Class.new(StandardError)

    def initialize(key:)
      @key = key
      @settings = Hash.new
      @collections = Hash.new
    end

    def store(key, value, **options)
      key = key.to_s
      if settings.include?(key)
        raise ExistingSetting, "Existing setting for #{key}"
      else
        settings[key] = Setting.new(key: key, value: value, **options)
      end
    end

    def store_at(path, key, value, **options)
      if path.empty?
        store(key, value, options)
      else
        collection_name, *rest = path
        collection(collection_name).store_at(rest, key, value, options)
      end
    end

    def empty?
      settings.empty?
    end

    def create(key:)
      key = key.to_s
      if collection?(key)
        collection[key]
      else
        collections[key] = Collection.new(key: key)
      end
    end

    def collection?(key)
      collections.include?(key.to_s)
    end

    def collection(key)
      key = key.to_s
      if collections[key]
        collections[key]
      else
        raise CollectionNotFound, "Collection #{key} has not been registered"
      end
    end

    def reset
      collections.clear
      settings.clear
    end

    private

    def settings
      @settings
    end

    attr_reader :settings, :collections

    def method_missing(name, *args)
      key = name.to_s
      if collections.include?(key)
        collections[key]
      elsif settings.include?(key)
        settings[key].value
      else
        raise SettingNotFound, "Setting for '#{key}' not found"
      end
    end
  end
end
