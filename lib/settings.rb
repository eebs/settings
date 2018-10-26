require "settings/version"

require "settings/configuration"
require "settings/collection"
require "settings/utils"

module Settings
  extend Utils

  CollectionNotFound = Class.new(StandardError)

  def self.register_collection(key)
    collection_set.store(key.to_s, Collection.new)
  end

  def self.collection?(key)
    collection_set.include?(key.to_s)
  end

  def self.store(collection_key, key, value)
    collection(collection_key).store(key, value)
  end

  def self.collection(key)
    if collection?(key)
      collection_set[key.to_s]
    else
      raise CollectionNotFound, "Collection for '#{key}' has not been registered"
    end
  end

  def self.reset
    collection_set.clear
  end

  private

  def self.method_missing(name, *args)
    key = name.to_s
    if collection_set.include?(key)
      collection_set[key]
    else
      super
    end
  end

  def self.collection_set
    @_collection_set ||= Hash.new
  end
end
