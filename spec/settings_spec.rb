RSpec.describe Settings do
  it "has a version number" do
    expect(Settings::VERSION).not_to be nil
  end

  describe "accessing a collection of settings" do
    it "makes settings available scoped by the group's class" do
      class Example
        include Settings::Configuration

        setting :api_key, "abc123"
      end

      expect(Settings.example.api_key).to eq "abc123"
    end

    describe "when namespaced" do
      it "nests the collection by the namespace" do
        module Namespace
          class ExampleSettings
            include Settings::Configuration

            setting :api_key, "abc123"
          end
        end

        expect(Settings.namespace.example_settings.api_key).to eq "abc123"
      end
    end
  end

  describe ".register_collection" do
    it "registers a new collection" do
      Settings.register_collection("foo")

      expect(Settings.collection?("foo")).to be true
    end

    it "registers an empty collection" do
      Settings.register_collection("foo")

      expect(Settings.collection("foo")).to be_empty
    end
  end

  describe ".collection?" do
    it "is true if a collection has been registered for the given key" do
      Settings.register_collection("foo")

      expect(Settings.collection?("foo")).to be true
    end

    it "is false if a collection has not been registered for the given key" do
      expect(Settings.collection?("foo")).to be false
    end
  end

  describe ".store" do
    describe "when the collection has been registered" do
      it "stores the value by the key for the collection" do
        Settings.register_collection(:example)

        Settings.store(:example, "secret", "abc123")

        expect(Settings.collection(:example).secret).to eq "abc123"
      end
    end

    describe "when the collection has not been registered" do
      it "raises a CollectionNotFound exception" do
        expect{ Settings.store(:example, "secret", "abc123") }.to(
          raise_error(Settings::CollectionNotFound)
        )
      end
    end
  end

  describe ".collection" do
    describe "when the collection has been registered" do
      it "returns the collection" do
        Settings.register_collection(:example)

        expect(Settings.collection(:example)).to_not be nil
      end
    end

    describe "when the collection has not been registered" do
      it "raises a CollectionNotFound exception" do
        expect{ Settings.collection(:example) }.to(
          raise_error(Settings::CollectionNotFound)
        )
      end
    end
  end

  describe "reset" do
    it "removes all collections" do
      Settings.register_collection(:foo)

      Settings.reset

      expect(Settings.collection?(:foo)).to be false
    end
  end
end
