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
  end

  describe "accessing a namedspaced collection of settings" do
    it "makes settings available under a namespace" do
      module EmailSettings
        class SendGrid
          include Settings::Configuration

          setting :api_key, "def456"
        end
      end

      expect(Settings.email_settings.send_grid.api_key).to eq "def456"
    end
  end

  describe "accessing a required setting that is nil" do
    it "raises an error" do
      class RequiredTest
        include Settings::Configuration

        setting :api_key, nil, required: true
      end

      expect { Settings.required_test.api_key }.to raise_error StandardError
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

  describe ".store_at" do
    describe "when the collection has been registered" do
      it "stores the value by the key for the collection" do
        Settings.register_collection(:example)

        Settings.store_at([:example], "secret", "abc123")

        expect(Settings.collection(:example).secret).to eq "abc123"
      end
    end

    describe "when the collection has not been registered" do
      it "raises a CollectionNotFound exception" do
        expect{ Settings.store(:example, "secret", "abc123") }.to(
          raise_error(Settings::Collection::CollectionNotFound)
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
          raise_error(Settings::Collection::CollectionNotFound)
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
