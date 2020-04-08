class CfnResponse
  class Builder < Base
    def call(input={})
      input.transform_keys! { |k| k.to_s }

      default = {
        "Reason" => default_reason,
        "Status" => "SUCCESS",
        "PhysicalResourceId" => "PhysicalId",
      }
      resp = default.merge(input)

      verbatim = @event.slice("StackId", "RequestId", "LogicalResourceId") # pass these through verbatim
      verbatim.merge(resp) # final resp
    end

    def default_reason
      "See the details in CloudWatch Log Group: #{@context.log_group_name} Log Stream: #{@context.log_stream_name}"
    end
  end
end
