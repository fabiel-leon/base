require_relative "lib/ansible_helper"
require_relative "bootstrap"
require_relative "shared/ruby"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.playbook "playbooks/ruby.yml"
  end
end

describe "ruby" do
  rubyCmd = if os[:release] == "14.04" then "ruby2.0" else "ruby" end

  include_examples("ruby::ruby", rubyCmd)
end

describe "gem" do
  gemCmd = if os[:release] == "14.04" then "gem2.0" else "gem" end
  include_examples("ruby::gem", gemCmd)

  describe command("#{gemCmd} install bundler") do
    let(:disable_sudo) { false }

    it "should install gems" do
      expect(subject.stdout).to match /^1 gem installed$/
    end

    it "should install documentation" do
      expect(subject.stdout).to match /^Parsing documentation/
    end

    include_examples "no errors"
  end
end
