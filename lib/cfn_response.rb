require "cfn_response/version"

class CfnResponse
  autoload :Base, "cfn_response/base"
  autoload :Builder, "cfn_response/builder"
  autoload :Sender, "cfn_response/sender"

  class Error < StandardError; end

  def initialize(event, context=nil)
    @event, @context = event, context
  end

  def success
  end

  def failed
  end
end

