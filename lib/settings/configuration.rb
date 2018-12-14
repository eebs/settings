require "settings/utils"

module Settings
  module Configuration
    def self.included(base)
      base.extend(ClassMethods)
      Settings.register_collection(base)
    end

    module ClassMethods
      include Utils

      def setting(key, value, **options)
        path = collection_path(self)
        Settings.store_at(path, key, value, options)
      end
    end
  end
end
