RSpec.describe Settings::Configuration do
  describe "#included" do
    context "in a simple class" do
      it "registers the group" do
        class Example
          include Settings::Configuration
        end

        expect(Settings.collection?(:example)).to be true
      end
    end

    context "in a namespaced class" do
      it "registers the module" do
        module EmailSettings
          class SendGrid
            include Settings::Configuration
          end
        end

        expect(Settings.collection?(:email_settings)).to be true
      end
    end
  end
end
