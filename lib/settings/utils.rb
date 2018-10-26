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
  end
end
