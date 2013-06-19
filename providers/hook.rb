#
# github_hook provider
#
#

attr :github

def load_gem
  begin
    require 'octokit'
  rescue LoadError
    Chef::Log.info "octokit gem not found. Attempting to install "
    # we do this cause there are some pacakges and sysstem things that
    # may need to get installed as well as this gem
    chef_gem "octokit" do
      version node[:github][:api][:gem][:version]
    end
  end
end

def initialize(new_resource, run_context=nil)
  super
  load_gem
  github
end

def whyrun_supported?
  false
end

def github
  @github ||= Octokit::Client.new(
    :oauth_token => new_resource.oauth_token,
    :password    => new_resource.password,
    :login       => new_resource.user
  )
end

def repo_path
  path = "#{new_resource.user}/#{new_resource.repo}"
  if new_resource.org
    path = "#{new_resource.org}/#{new_resource.repo}"
  end
end

def hook
  if @hook == nil
    github.hooks(repo_path).each do |hook|
      @hook = hook if hook.name == new_resource.hook_name
    end
  end
  @hook
end

def exists?
  hook ?  true : false
end

def options
  {
    :events  => new_resource.register_events,
    :active  => new_resource.active
  }
end

def load_current_resource
  @current = Chef::Resource::GithubHook.new(new_resource.name)
  @current.org    new_resource.org
  @current.repo   new_resource.repo
  @current.user   new_resource.user
  @current.password     new_resource.password
  @current.oauth_token  new_resource.oauth_token
  if hook
    @current.config hook.config
    @current.active hook.active
    @current.register_events hook.events
  end
  @current
end

# by default create enabled hook
def action_create
  unless exists?
    github.create_hook(
      repo_path,
      new_resource.hook_name,
      new_resource.config,
      options
    )
    new_resource.updated_by_last_action true
  end
end

def action_update
  if exists? and
    new_resource.config != @current.config and
    new_resource.action != @current.action and
    new_resource.register_events != @current.register_events

    github.edit_hook(
      repo_path,
      new_resource.hook_name,
      new_resource.config,
      options
    )
    new_resource.updated_by_last_action true
  else
    action_create
  end
end

def action_enable
  new_resource.active true
  action_update
end

def action_disable
  new_resource.active false
  action_update
end

def action_remove
  if exists?
    github.remove_hook(repo_path, hook.id)
    new_resource.updated_by_last_action true
  end
end
