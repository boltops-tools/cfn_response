class CfnResponse
  class Builder < Base
    def call(input={})
      input.transform_keys! { |k| k.to_s }

      default = {
        "Reason" => default_reason,
        "Status" => "SUCCESS",
        "PhysicalResourceId" => physical_resource_id(input["PhysicalResourceId"])
      }
      resp = default.merge(input)

      verbatim = @event.slice("StackId", "RequestId", "LogicalResourceId") # pass these through verbatim
      verbatim.merge(resp) # final resp
    end

    def physical_resource_id(id)
      if id.nil?
        current_physical_resource_id
      elsif id == :new_physical_resource_id or id == :new_id
        new_physical_resource_id
      else
        id
      end
    end

    def new_physical_resource_id
      regexp = /(\d+$)/
      md = current_physical_resource_id.match(regexp) # capture trailing number
      n = md ? md[1].to_i + 1 : 1
      basename = current_physical_resource_id.sub(regexp,'') # remove trailing number
      "#{basename}#{n}"
    end

    def current_physical_resource_id
      @event["PhysicalResourceId"] || "PhysicalResourceId"
    end

    def default_reason
      "See the details in CloudWatch Log Group: #{@context.log_group_name} Log Stream: #{@context.log_stream_name}"
    end
  end
end
