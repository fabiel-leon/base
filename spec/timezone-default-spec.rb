require_relative "lib/ansible_helper"
require_relative "bootstrap"
require_relative "shared/timezone"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.playbook "playbooks/timezone.yml"
  end

  config.before :all do
    skip "Cannot get a working dbus connection in Docker" if AnsibleHelper[ENV["TARGET_HOST"]].is_a? DockerEnv
  end
end

describe "Timezone" do
  include_examples("timezone", "Etc/UTC")
end
