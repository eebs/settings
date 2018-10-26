RSpec.describe Settings::Collection do
  describe "accessing a setting" do
    describe "when the setting has been configured" do
      it "returns the setting's value" do
        collection = Settings::Collection.new
        collection.store(:foo, "bar")

        expect(collection.foo).to eq "bar"
      end
    end

    describe "when the setting has not been configured" do
      it "raises a SettingNotFound exception" do
        collection = Settings::Collection.new

        expect{ collection.foo }.to raise_error(Settings::Collection::SettingNotFound)
      end
    end
  end

  describe "#empty?" do
    it "is true when no settings have been stored" do
      collection = Settings::Collection.new

      expect(collection.empty?).to be true
    end

    it "is false when a setting has been stored" do
      collection = Settings::Collection.new

      collection.store("foo", "bar")

      expect(collection.empty?).to be false
    end
  end
end
