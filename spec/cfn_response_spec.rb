RSpec.describe CfnResponse do
  subject { described_class.new(event, context) }
  let(:context) { null }
  let(:null) { double(:null).as_null_object }

  context "create" do
    let(:event) { event_payload("create") }

    it "success" do
      subject.success
    end
  end
end
