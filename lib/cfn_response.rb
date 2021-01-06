require "cfn_response/version"
require "json"

class CfnResponse
  autoload :Base, "cfn_response/base"
  autoload :Builder, "cfn_response/builder"
  autoload :Sender, "cfn_response/sender"

  class Error < StandardError; end

  def initialize(event, context=nil)
    @event, @context = event, context
  end

  def response
    show_event if show_event?
    result = yield if block_given?
    success unless @finished
    pause_for_cloudwatch
    result
  rescue Exception => e
    puts "ERROR #{e.message}"
    puts "BACKTRACE:\n#{e.backtrace.join("\n")}"
    pause_for_cloudwatch
    failed
  end
  alias_method :respond, :response

  def show_event?
    ENV['CFN_RESPONSE_VERBOSE'].nil? ? true : ENV['CFN_RESPONSE_VERBOSE'] == '1'
  end

  def show_event
    puts("event['RequestType'] #{@event['RequestType']}")
    puts("event: #{JSON.dump(@event)}")
    puts("context: #{JSON.dump(@context)}")
    puts("context.log_stream_name #{@context.log_stream_name.inspect}")
  end

  def send_to_cloudformation(input={})
    builder = Builder.new(@event, @context)
    response_data = builder.call(input)
    sender = Sender.new(@event, @context)
    result = sender.call(response_data) unless ENV['CFN_RESPONSE_SEND'] == '0'
    @finished = true
    result
  end

  def success(input={})
    input[:Status] = "SUCCESS"
    send_to_cloudformation(input)
  end

  def failed(input={})
    input[:Status] = "FAILED"
    send_to_cloudformation(input)
  end

  def pause_for_cloudwatch
    return if ENV['CFN_RESPONSE_TEST'] || ENV['CFN_RESPONSE_SEND']
    sleep 10 # a little time for logs to be sent to CloudWatch
  end
end
