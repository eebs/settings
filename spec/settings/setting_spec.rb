RSpec.describe Settings::Setting do
  describe "#value" do
    it "returns the setting's value" do
      setting = Settings::Setting.new(key: "foo", value: "abc123")

      expect(setting.value).to eq "abc123"
    end
  end

  describe "required option" do
    it "will raise error if not found" do
      setting = Settings::Setting.new(key: "foo", value: nil, required: true)

      expect { setting.value }.to raise_error StandardError
    end

    it "will return a thing and not error if not required" do
      setting = Settings::Setting.new(key: "foo", value: nil, required: false)

      expect(setting.value).to eq nil
    end
  end
end
