require "settings/utils"

module Settings
  module Configuration
    def self.included(base)
      base.extend(ClassMethods)
      Settings.register_collection(base.key)
    end

    module ClassMethods
      include Utils

      def key
        @key ||= to_key(self)
      end

      def setting(key, value)
        Settings.store(to_key(self), key, value)
      end
    end
  end
end
