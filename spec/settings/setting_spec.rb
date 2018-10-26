RSpec.describe Settings::Setting do
  describe "#value" do
    it "returns the setting's value" do
      setting = Settings::Setting.new(key: "foo", value: "abc123")

      expect(setting.value).to eq "abc123"
    end
  end
end
