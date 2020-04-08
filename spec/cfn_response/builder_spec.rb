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
         "Reason"=>"See the details in CloudWatch Log Group: #[Double :null] Log Stream: #[Double :null]",
         "Status"=>"SUCCESS",
         "PhysicalResourceId"=>"PhysicalResourceId"}
      )
    end

    it "call failed" do
      resp = subject.call(Status: "FAILED")
      expect(resp).to eq(
        {"StackId"=>"stack-arn",
         "RequestId"=>"be4527eb-e348-4205-b4ff-9d61b0799488",
         "LogicalResourceId"=>"Invoker",
         "Reason"=>"See the details in CloudWatch Log Group: #[Double :null] Log Stream: #[Double :null]",
         "Status"=>"FAILED",
         "PhysicalResourceId"=>"PhysicalResourceId"}
      )
    end

    it "call with data" do
      resp = subject.call(Data: {a: 1, b: 2})
      expect(resp).to eq(
        {"StackId"=>"stack-arn",
         "RequestId"=>"be4527eb-e348-4205-b4ff-9d61b0799488",
         "LogicalResourceId"=>"Invoker",
         "Reason"=>"See the details in CloudWatch Log Group: #[Double :null] Log Stream: #[Double :null]",
         "Status"=>"SUCCESS",
         "PhysicalResourceId"=>"PhysicalResourceId",
         "Data"=>{:a=>1, :b=>2}}
      )
    end
  end

  context "update" do
    let(:event) { event_payload("update") }

    it "call success" do
      resp = subject.call
      expect(resp).to eq(
        {"StackId"=>"stack-arn",
         "RequestId"=>"a7994d98-f3ab-47a1-9b2f-e358abc132da",
         "LogicalResourceId"=>"Invoker",
         "Reason"=>"See the details in CloudWatch Log Group: #[Double :null] Log Stream: #[Double :null]",
         "Status"=>"SUCCESS",
         "PhysicalResourceId"=>"PhysicalResourceId"}
      )
    end

    it "call failed" do
      resp = subject.call(Status: "FAILED")
      expect(resp).to eq(
        {"StackId"=>"stack-arn",
         "RequestId"=>"a7994d98-f3ab-47a1-9b2f-e358abc132da",
         "LogicalResourceId"=>"Invoker",
         "Reason"=>"See the details in CloudWatch Log Group: #[Double :null] Log Stream: #[Double :null]",
         "Status"=>"FAILED",
         "PhysicalResourceId"=>"PhysicalResourceId"}
      )
    end

    it "call with data" do
      resp = subject.call(Data: {a: 1, b: 2})
      expect(resp).to eq(
        {"StackId"=>"stack-arn",
         "RequestId"=>"a7994d98-f3ab-47a1-9b2f-e358abc132da",
         "LogicalResourceId"=>"Invoker",
         "Reason"=>
          "See the details in CloudWatch Log Group: #[Double :null] Log Stream: #[Double :null]",
         "Status"=>"SUCCESS",
         "PhysicalResourceId"=>"PhysicalResourceId",
         "Data"=>{:a=>1, :b=>2}}
      )
    end
  end

  context "delete" do
    let(:event) { event_payload("delete") }

    it "call success" do
      resp = subject.call
      expect(resp).to eq(
        {"StackId"=>"stack-arn",
         "RequestId"=>"04da1f38-0577-4bfb-b46a-51ad9da3b11e",
         "LogicalResourceId"=>"Invoker",
         "Reason"=>"See the details in CloudWatch Log Group: #[Double :null] Log Stream: #[Double :null]",
         "Status"=>"SUCCESS",
         "PhysicalResourceId"=>"PhysicalResourceId"}
      )
    end

    it "call failed" do
      resp = subject.call(Status: "FAILED")
      expect(resp).to eq(
        {"StackId"=>"stack-arn",
         "RequestId"=>"04da1f38-0577-4bfb-b46a-51ad9da3b11e",
         "LogicalResourceId"=>"Invoker",
         "Reason"=>"See the details in CloudWatch Log Group: #[Double :null] Log Stream: #[Double :null]",
         "Status"=>"FAILED",
         "PhysicalResourceId"=>"PhysicalResourceId"}
      )
    end

    it "call with data" do
      resp = subject.call(Data: {a: 1, b: 2})
      expect(resp).to eq(
        {"StackId"=>"stack-arn",
         "RequestId"=>"04da1f38-0577-4bfb-b46a-51ad9da3b11e",
         "LogicalResourceId"=>"Invoker",
         "Reason"=>"See the details in CloudWatch Log Group: #[Double :null] Log Stream: #[Double :null]",
         "Status"=>"SUCCESS",
         "PhysicalResourceId"=>"PhysicalResourceId",
         "Data"=>{:a=>1, :b=>2}}
      )
    end
  end

  context "PhysicalResourceId with no number" do
    let(:event) { event_payload("update/id") }

    it "adds a number to physical_resource_id" do
      id = subject.physical_resource_id(:new_id)
      expect(id).to eq("PhysicalResourceId1")
    end

    it "maintains physical id when nil" do
      id = subject.physical_resource_id(nil)
      expect(id).to eq("PhysicalResourceId")
    end

    it "new physical when user replaces" do
      id = subject.physical_resource_id("BrandNew")
      expect(id).to eq("BrandNew")
    end
  end

  context "PhysicalResourceId with number 2" do
    let(:event) { event_payload("update/id2") }

    it "increments number to physical_resource_id" do
      id = subject.physical_resource_id(:new_id)
      expect(id).to eq("PhysicalResourceId3")
    end
  end
end
