RSpec.describe CfnResponse do
  subject { described_class.new(event, context) }
  let(:context) { null }

  context "create" do
    let(:event) { event_payload("create") }

    before(:each) do
      allow(CfnResponse::Sender).to receive(:new).and_return(null)
    end

    it "success" do
      resp = subject.success
      expect(resp.to_s).to eq(null.to_s) # due to stub

      resp = subject.success(Data: {a: 1})
      expect(resp["Data"].to_s).to eq(null.to_s)
    end

    it "failed" do
      resp = subject.failed
      expect(resp.to_s).to eq(null.to_s) # due to stub
    end

    it "send_to_cloudformation" do
      resp = subject.send_to_cloudformation
      expect(resp.to_s).to eq(null.to_s) # due to stub
    end

    it "response" do
      resp = subject.response do
        subject.success
      end
      expect(resp.to_s).to eq(null.to_s) # due to stub
    end

    it "respond" do
      resp = subject.respond do
        subject.success
      end
      expect(resp.to_s).to eq(null.to_s) # due to stub
    end
  end
end
