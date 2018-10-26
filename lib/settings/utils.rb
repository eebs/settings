require "active_support/core_ext/string/inflections"

module Settings
  module Utils
    def to_key(base)
      if base.name == nil
        raise "Does not support anonymous classes"
      end

      if base.name.include?("::")
        raise "Does not support namespaced classes"
      end

      base.name.downcase
    end

    def class_paths(base)
      base.name.split("::").map(&:underscore)
    end
  end
end
