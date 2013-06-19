#default test

include_recipe "github::default"

# add it
github_hook node[:gh_test][:test_repo] do
  action :create
  oauth_token node[:gh_test][:oauth_token]
  config node[:gh_test][:hook_config]
end

# update it 2 times one should act other shouldnt
2.times do |whee|
  github_hook node[:gh_test][:test_repo] do
    action :update
    oauth_token node[:gh_test][:oauth_token]
    config node[:gh_test][:hook_config]
    register_events %w{push pull_request}
  end
end

# create should do nothing here
github_hook node[:gh_test][:test_repo] do
  action :create
  oauth_token node[:gh_test][:oauth_token]
  config node[:gh_test][:hook_config]
end

# remove it
github_hook node[:gh_test][:test_repo] do
  action :remove
  oauth_token node[:gh_test][:oauth_token]
  config node[:gh_test][:hook_config]
  register_events %w{push pull_request}
end
