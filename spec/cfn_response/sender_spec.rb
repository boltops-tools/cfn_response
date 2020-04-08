RSpec.describe CfnResponse::Sender do
  subject { described_class.new(event, context) }
  let(:context) { null }

  context "create" do
    let(:event) { event_payload("create") }
    let(:response_data) do
      builder = CfnResponse::Builder.new(event, context)
      builder.call
    end

    before(:each) do
      allow(Net::HTTP).to receive(:new).and_return(null)
      allow(Net::HTTP::Put).to receive(:new).and_return(null)
    end

    it "call success" do
      resp = subject.call(response_data)
      expect(resp.to_s).to eq(null.to_s) # due to stub
    end
  end
end
