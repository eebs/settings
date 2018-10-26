require "settings/utils"

module Settings
  module Configuration
    def self.included(base)
      base.extend(ClassMethods)
      Settings.register_class(base)
    end

    module ClassMethods
      include Utils

      def setting(key, value)
        # raise "need to set setting with namespace"
        # Settings.store(to_key(self), key, value)
      end
    end
  end
end
