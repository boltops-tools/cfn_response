RSpec.describe CfnResponse::Builder do
  subject { described_class.new(event, context) }
  let(:context) { null }

  context "create" do
    let(:event) { event_payload("create") }

    it "call success" do
      resp = subject.call
      expect(resp).to eq(
        {"StackId"=>"stack-arn",
         "RequestId"=>"be4527eb-e348-4205-b4ff-9d61b0799488",
         "LogicalResourceId"=>"Invoker",
         "Reason"=>
          "See the details in CloudWatch Log Group: #[Double :null] Log Stream: #[Double :null]",
         "Status"=>"SUCCESS",
         "PhysicalResourceId"=>"PhysicalId"}
      )
    end

    it "call failed" do
      resp = subject.call(Status: "FAILED")
      expect(resp).to eq(
        {"StackId"=>"stack-arn",
         "RequestId"=>"be4527eb-e348-4205-b4ff-9d61b0799488",
         "LogicalResourceId"=>"Invoker",
         "Reason"=>
          "See the details in CloudWatch Log Group: #[Double :null] Log Stream: #[Double :null]",
         "Status"=>"FAILED",
         "PhysicalResourceId"=>"PhysicalId"}
      )
    end

    it "call with data" do
      resp = subject.call(Data: {a: 1, b: 2})
      expect(resp).to eq(
        {"StackId"=>"stack-arn",
         "RequestId"=>"be4527eb-e348-4205-b4ff-9d61b0799488",
         "LogicalResourceId"=>"Invoker",
         "Reason"=>
          "See the details in CloudWatch Log Group: #[Double :null] Log Stream: #[Double :null]",
         "Status"=>"SUCCESS",
         "PhysicalResourceId"=>"PhysicalId",
         "Data"=>{:a=>1, :b=>2}}
      )
    end
  end
end
