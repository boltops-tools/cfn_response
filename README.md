# CfnResponse

[![BoltOps Badge](https://img.boltops.com/boltops/badges/boltops-badge.png)](https://www.boltops.com)

CfnResponse helps with writing [Custom CloudFormation resources](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-custom-resources.html). It builds the response to send back to CloudFormation from the Lambda function.

## Usage

The block form with the `safely` method will ensure a FAILED status is sent to CloudFormation in the event of an Exception in the code. This prevents us from waiting for over an hour for the stack operation to timeout and rollback. It also will call sleep 10 to provide enough time to send logs to CloudWatch.

```ruby
require "cfn_response"
require "json"

def lambda_handler(event:, context:)
  puts "event: #{JSON.pretty_generate(event)}"
  resp = CfnResponse.new(event, context)

  # will call resp.fail on Exceptions so CloudFormation can continue
  resp.safely do
    case event['RequestType']
    when "Create", "Update"
      # create or update logic
      data = {a: 1, b: 2}
      resp.success(Data: data)
      # or
      # resp.failed
    when "Delete"
      # delete logic
      resp.success
    end
  end
end
```

You can also call `success` and `failed` methods without wrapping the in a `safely` block.  Just remember to handle Exceptions. Example:

```ruby
require "cfn_response"
require "json"

def lambda_handler(event:, context:)
  puts "event: #{JSON.pretty_generate(event)}"
  resp = CfnResponse.new(event, context)

  data = {a: 1, b: 2}
  resp.success(Data: data)
  # or
  # resp.failed

  sleep 10 # a little time for logs to be sent to CloudWatch
# Rescue all exceptions and send FAIL to CloudFormation so we don't have to
# wait for over an hour for the stack operation to timeout and rollback.
rescue Exception => e
  puts e.message
  puts e.backtrace
  sleep 10 # a little time for logs to be sent to CloudWatch
  resp.failed
end
```

### Custom Resource Provider Response Fields

Ultimately, CloudFormation expects a JSON body to be sent to it with these possible fields: Status, Reason, PhysicalResourceId, StackId, RequestId, LogicalResourceId, NoEcho, Data. Docs: [Custom Resource Response Objects](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/crpg-ref-responses.html).

The `success` and `failed` methods accept a Hash which is simply merged down to the final JSON body that is sent to CloudFormation. Most of the fields are prefilled conveniently by this library.  You may want to pass some values.  Example:

```ruby
resp = CfnResponse.new(event, context)
resp.success(Data: {a: 1, b: 2}, NoEcho: true)
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
