# CfnResponse

[![BoltOps Badge](https://img.boltops.com/boltops/badges/boltops-badge.png)](https://www.boltops.com)

CfnResponse helps with writing [Custom CloudFormation resources](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-custom-resources.html). It builds the response to send back to CloudFormation from the Lambda function.

## Usage

The block form with the `response` method will ensure a SUCCESS or FAILED status is sent to CloudFormation regardless. If there's an Exception in the code, FAILED status is automatically sent. Otherwise an implicit SUCCESS status is sent.

This prevents us from waiting for over an hour for the stack operation to timeout and rollback. A `sleep 10` is also called at the end to provide enough time for the Lambda function to send logs to CloudWatch.

```ruby
require "cfn_response"
require "json"

def lambda_handler(event:, context:)
  puts "event: #{JSON.pretty_generate(event)}"
  cfn = CfnResponse.new(event, context)

  # will call cfn.fail on Exceptions so CloudFormation can continue
  cfn.response do
    case event['RequestType']
    when "Create", "Update"
      # create or update logic
    when "Delete"
      # delete logic
    end
    # Note: cfn.success doesnt need to be called because it is called implicitly at the end
  end
end
```

If you always want to return a success, here's the simpliest form:

```ruby
require "cfn_response"
require "json"

def lambda_handler(event:, context:)
  puts "event: #{JSON.pretty_generate(event)}"
  cfn = CfnResponse.new(event, context)
  cfn.response
end
```

Reminder, `cfn.success` or `cfn.fail` is not called explicitly, a `cfn.success` is automatically called.

### Calling success or fail explicitly

You can also call `cfn.success` or `cfn.fail explicitly`, doing so gives you the ability to pass custom `Data`.

```ruby
require "cfn_response"
require "json"

def lambda_handler(event:, context:)
  puts "event: #{JSON.pretty_generate(event)}"
  cfn = CfnResponse.new(event, context)

  # will call cfn.fail on Exceptions so CloudFormation can continue
  cfn.response do
    case event['RequestType']
    when "Create", "Update"
      # create or update logic
      data = {a: 1, b: 2}
      cfn.success(Data: data)
      # or
      # cfn.failed
    when "Delete"
      # delete logic
      cfn.success # optional
    end
  end
end
```

### Non-block form

You can also call `success` and `failed` methods without wrapping the in a `response` block.  Just remember to handle Exceptions. Example:

```ruby
require "cfn_response"
require "json"

def lambda_handler(event:, context:)
  puts "event: #{JSON.pretty_generate(event)}"
  cfn = CfnResponse.new(event, context)

  data = {a: 1, b: 2}
  cfn.success(Data: data)
  # or
  # cfn.failed

  sleep 10 # a little time for logs to be sent to CloudWatch
# Rescue all exceptions and send FAIL to CloudFormation so we don't have to
# wait for over an hour for the stack operation to timeout and rollback.
rescue Exception => e
  puts e.message
  puts e.backtrace
  sleep 10 # a little time for logs to be sent to CloudWatch
  cfn.failed
end
```

### Custom Resource Provider Response Fields

Ultimately, CloudFormation expects a JSON body to be sent to it with these possible fields: Status, Reason, PhysicalResourceId, StackId, RequestId, LogicalResourceId, NoEcho, Data. Docs: [Custom Resource Response Objects](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/crpg-ref-responses.html).

The `success` and `failed` methods accept a Hash which is simply merged down to the final JSON body that is sent to CloudFormation. Most of the fields are prefilled conveniently by this library.  You may want to pass some values.  Example:

```ruby
cfn = CfnResponse.new(event, context)
cfn.success(Data: {a: 1, b: 2}, NoEcho: true)
```

### PhysicalResourceId

The default PhysicalResourceId is `PhysicalResourceId`. If your logic calls for a new physical resource and you want to tell CloudFormation to replace the resource. Then you can provide a value with the symbol `:new_id` and the library will add a counter value to end of the current physical id.

```ruby
cfn = CfnResponse.new(event, context)
cfn.success(PhysicalResourceId: :new_id)
# PhysicalResourceId => PhysicalResourceId1 => PhysicalResourceId2 => etc
```

Or you replace it with your own unique physical resource id value of course.

```ruby
cfn = CfnResponse.new(event, context)
cfn.success(PhysicalResourceId: "MyId")
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cfn_response'
```

And then execute:

    bundle install

Or install it yourself as:

    gem install cfn_response

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tongueroo/cfn_response

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
