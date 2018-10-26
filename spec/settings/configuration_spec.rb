RSpec.describe Settings::Configuration do
  describe "#included" do
    it "registers the group" do
      class Example
        include Settings::Configuration
      end

      expect(Settings.collection?(:example)).to be true
    end
  end
end
