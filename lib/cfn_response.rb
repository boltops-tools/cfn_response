require "cfn_response/version"

class CfnResponse
  class Error < StandardError; end

  def initialize(event, context=nil)
    @event, @context = event, context
  end

  def success
  end

  def failed
  end
end
