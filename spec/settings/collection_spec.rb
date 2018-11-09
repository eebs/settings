require "settings/utils"
RSpec.describe Settings::Collection do
  describe "accessing a setting" do
    describe "when the setting has been configured" do
      it "returns the setting's value" do
        collection = Settings::Collection.new(key: :email_settings)
        collection.store(:foo, "bar")

        expect(collection.foo).to eq "bar"
      end
    end

    describe "when the setting has not been configured" do
      it "raises a SettingNotFound exception" do
        collection = Settings::Collection.new(key: :email_settings)

        expect{ collection.foo }.to raise_error(Settings::Collection::SettingNotFound)
      end
    end
  end

  describe "accessing sub-collections" do
    it "allows access via dot-notion" do
      collection = Settings::Collection.new(key: :email_settings)
      nested_collection = collection.create(key: :send_grid)

      expect(collection.send_grid).to eq nested_collection
    end
  end

  describe "#store" do
    context "when the setting does not exist" do
      it "sets the setting" do
        collection = Settings::Collection.new(key: 'key')

        collection.store(:foo, "bar")

        expect(collection.foo).to eq "bar"
      end
    end

    context "when the setting already exists" do
      it "raises an ExistingSetting error" do
        collection = Settings::Collection.new(key: 'key')
        collection.store(:foo, "bar")

        expect{ collection.store(:foo, "again") }.to(
          raise_error Settings::Collection::ExistingSetting
        )
      end
    end
  end

  describe "#store_at" do
    context "with a path" do
      it "sets the setting on the collection specified by the path" do
        root_collection = Settings::Collection.new(key: :root)
        root_collection.create(key: "namespace")

        root_collection.store_at(["namespace"], :foo, "bar")

        expect(root_collection.namespace.foo).to eq "bar"
      end
    end

    context "with an empty path" do
      it "sets the setting on the current collection" do
        root_collection = Settings::Collection.new(key: :root)

        root_collection.store_at([], :foo, "bar")

        expect(root_collection.foo).to eq "bar"
      end
    end
  end

  describe "#empty?" do
    it "is true when no settings have been stored" do
      collection = Settings::Collection.new(key: :email_settings)

      expect(collection.empty?).to be true
    end

    it "is false when a setting has been stored" do
      collection = Settings::Collection.new(key: :email_settings)

      collection.store("foo", "bar")

      expect(collection.empty?).to be false
    end
  end

  describe "#create" do
    it "allows adding a collection to the collection" do
      collection = Settings::Collection.new(key: :email_settings)

      nested_collection = collection.create(key: :send_grid)

      expect(collection.collection(:send_grid)).to eq nested_collection
    end
  end

  describe "#collection?" do
    it "is true when the nested collection exists" do
      collection = Settings::Collection.new(key: :root)
      collection.create(key: :foo)

      expect(collection.collection?(:foo)).to be true
    end

    it "is false when the nested collection does not exist" do
      collection = Settings::Collection.new(key: :root)

      expect(collection.collection?(:foo)).to be false
    end
  end

  describe "#collection" do
    it "returns the collection if it exists" do
      collection = Settings::Collection.new(key: :email_settings)
      nested_collection = collection.create(key: :send_grid)

      expect(collection.collection(:send_grid)).to eq nested_collection
    end

    it "raises a CollectionNotFound error if it doesn't exist" do
      collection = Settings::Collection.new(key: :email_settings)

      expect{ collection.collection(:send_grid) }.to(
        raise_error Settings::Collection::CollectionNotFound
      )
    end
  end

  describe "reset" do
    it "clears the collections" do
      collection = Settings::Collection.new(key: :root)
      nested_collection = collection.create(key: :nested)

      collection.reset

      expect(collection.collection?(:nested)).to be false
    end

    it "clears the settings" do
      collection = Settings::Collection.new(key: :root)
      collection.store(:foo, "bar")

      collection.reset

      expect{ collection.foo }.to(
        raise_error Settings::Collection::SettingNotFound
      )
    end
  end
end
