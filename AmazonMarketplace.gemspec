# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{AmazonMarketplace}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Charlie White"]
  #s.cert_chain = ["/Users/nathan/.gem/gem-public_cert.pem"]
  s.date = %q{2009-06-07}
  s.description = %q{Rails ready gem for Marketplace Transactions using Amazon Simple Pay.}
  s.email = ["charlie@fluidtickets.com"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.rdoc"]
  s.files = ["History.txt", "Manifest.txt", "README.rdoc", "Rakefile", "lib/AmazonMarketplace.rb", "lib/AmazonMarketplace/helpers/form_helper.rb", "lib/AmazonMarketplace/helpers/notification_helper.rb", "lib/AmazonMarketplace/helpers/rails_helper.rb", "lib/AmazonMarketplace/rails.rb", "lib/AmazonMarketplace/service.rb", "lib/AmazonMarketplace/services/marketplace.rb", "lib/AmazonMarketplace/services/marketplacePolicy.rb", "lib/AmazonMarketplace/signature_utils.rb", "lib/AmazonMarketplace/Yml.rb", "script/console", "script/destroy", "script/generate", "AmazonMarketplace.gemspec"]
  s.has_rdoc = true
  s.homepage = %q{http://AmazonMarketplace.rubyforge.org}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{AmazonMarketplace}
  s.rubygems_version = %q{1.3.2}
  #s.signing_key = %q{/Users/nathan/.gem/gem-private_key.pem}
  s.summary = %q{This gem provides a Rails interface to the Amazon Simple Pay payment service.}
  

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 2.0.2"])
      s.add_development_dependency(%q<newgem>, [">= 1.3.0"])
      s.add_development_dependency(%q<hoe>, [">= 1.8.0"])
    else
      s.add_dependency(%q<activesupport>, [">= 2.0.2"])
      s.add_dependency(%q<newgem>, [">= 1.3.0"])
      s.add_dependency(%q<hoe>, [">= 1.8.0"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 2.0.2"])
    s.add_dependency(%q<newgem>, [">= 1.3.0"])
    s.add_dependency(%q<hoe>, [">= 1.8.0"])
  end
end
