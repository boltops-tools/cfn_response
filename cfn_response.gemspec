require_relative 'lib/cfn_response/version'

Gem::Specification.new do |spec|
  spec.name          = "cfn_response"
  spec.version       = CfnResponse::VERSION
  spec.authors       = ["Tung Nguyen"]
  spec.email         = ["tongueroo@gmail.com"]

  spec.summary       = "CfnResponse makes it easier to build and send the CloudFormation Custom Resource response"
  spec.homepage      = "https://github.com/tongueroo/cfn_response"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/tongueroo/cfn_response/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  spec.files         = File.directory?('.git') ? `git ls-files`.split($/) : Dir.glob("**/*")
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
