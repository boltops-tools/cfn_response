# CfnResponse

[![BoltOps Badge](https://img.boltops.com/boltops/badges/boltops-badge.png)](https://www.boltops.com)

CfnResponse helps with writing [Custom CloudFormation resources](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-custom-resources.html). It builds the the response that is sent back to CloudFormation service from the Lambda function.

## Usage

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
# We rescue all exceptions and send an message to CloudFormation so we dont have to
# wait for over an hour for the stack operation to timeout and rollback.
rescue Exception => e
  puts e.message
  puts e.backtrace
  sleep 10 # a little time for logs to be sent to CloudWatch
  resp.failed
end
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
