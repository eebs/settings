module Settings
  class Setting
    def initialize(key:, value:, **options)
      @key = key
      @value = value
      @options = options
    end

    def value
      if required && !value_present?
        raise StandardError.new("Value is required, but was not present")
      else
        @value
      end
    end

    private

    attr_reader :options

    def required
      options[:required]
    end

    # For now nil is all we will check for. We can imagine that we might want to
    # prevent empty collections or strings as well
    def value_present?
      !@value.nil?
    end

  end
end
