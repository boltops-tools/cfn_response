require "cfn_response/version"

class CfnResponse
  autoload :Base, "cfn_response/base"
  autoload :Builder, "cfn_response/builder"
  autoload :Sender, "cfn_response/sender"

  class Error < StandardError; end

  def initialize(event, context=nil)
    @event, @context = event, context
  end

  def call(input={})
    builder = Builder.new(@event, @context)
    response_data = builder.call(input)
    sender = Sender.new(@event, @context)
    sender.call(response_data)
  end

  def success(input={})
    input[:Status] = "SUCCESS"
    call(input)
  end

  def failed(input={})
    input[:Status] = "FAILED"
    call(input)
  end

  def safely
    result = yield
    pause_for_cloudwatch
    result
  rescue Exception => e
    puts e.message
    puts e.backtrace
    pause_for_cloudwatch
    failed
  end

  def pause_for_cloudwatch
    return if ENV['CFN_RESPONSE_TEST']
    sleep 10 # a little time for logs to be sent to CloudWatch
  end
end
