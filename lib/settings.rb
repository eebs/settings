require "settings/version"

require "settings/configuration"
require "settings/collection"
require "settings/utils"

module Settings
  extend Utils

  def self.register_collection(base_class)
    names = collection_path(base_class)
    names.reduce(root_collection) do |collection, name|
      collection.create(key: name)
    end
  end

  def self.collection?(key)
    root_collection.collection?(key)
  end

  def self.store_at(path, key, value, **options)
    root_collection.store_at(path, key, value, options)
  end

  def self.reset
    root_collection.reset
  end

  private

  def self.collection(key)
    if collection?(key)
      root_collection.collection(key)
    else
      raise Collection::CollectionNotFound, "Collection '#{key}' has not been registered"
    end
  end

  def self.method_missing(name, *args)
    collection(name)
  end

  def self.root_collection
    @_root_collection ||= Collection.new(key: 'root')
  end
end
