require "active_support/core_ext/string/inflections"

module Settings
  module Utils
    def collection_path(klass)
      klass.to_s.split("::").map(&:underscore)
    end
  end
end
