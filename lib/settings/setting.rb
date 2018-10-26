module Settings
  class Setting
    attr_reader :value

    def initialize(key:, value:)
      @key = key
      @value = value
    end
  end
end
