=begin
#<
This manages github hooks via github api with octokit

@action create  Create a hook
@action remove  Remove a hook if it exists
@action update  Update a hook if the params aren't the same
@action enable  Enable the hook actions
@action disable Disbable it


@section Examples

    # heres an example that would trigger on push and pull requests
    # the resourcce name is parsed into org, repo, hook_name
    #   org  = spheromak
    #   user = spheromak
    #   repo = rawr_cook
    #
    # here I use oauth token, but you could use password if you wish
    #
    # register_events is documented more in the github api, but its
    # pretty straight forward
    github_hook "spheromak/rawr_cook/web" do
      config { :url => "http://google.com/dosomething" }
      oauth_token "123x098190y283901283"
      register_events %w{ push pull_request }
    end
#>
=end

# dip into init so we can parse_name. Might as well setup the resource
# old fasioned style
def initialize(name, run_context=nil)
  super
  @action = :create
  @allowed_actions = [
    :create, :update, :remove, :enable, :disable, :nothing
  ]

  parse_name
end

#
# magic up some values from the resource name
# we fill values from a name like: "org/repo/hook"
#
def parse_name
  if name.match("(.*)/(.*)/(.*)")
    org       $1 unless org
    user      $1 unless user
    repo      $2 unless repo
    hook_name $3 unless hook_name
  end
end

#<> @attribute oauth_token Github api authentication token
attribute :oauth_token, :kind_of => String

#<> @attribute hook_name  the name of the service hook: "web", "irc" etc
# parsed from the resource name when it is "org/repo/hook_name"
attribute :hook_name, :kind_of => String

#<> @attribute register_events The github hook api events to register too defait
attribute :register_events, :kind_of => Array, :default => ["push"]

#<> @attribute config a hash of config options for this service hook
attribute :config, :kind_of => Hash

#<> @attribute org the github org name to use on api calls
# parsed from the resource name if it is "org/repo/hook_name"
attribute :org, :kind_of => String

#<> @attribute repo the repo name
# parsed from the resource name if it is "org/repo/hook_name"
attribute :repo, :kind_of => String

#<> @attribute user The github user to use for api calls
# If not specified it will be  parsed from the resource name when it
# looks like "org/repo/hook_name". The `user` will be set by `org`
attribute :user, :kind_of => String

#<> @attribute password Github users password.
attribute :password, :kind_of => String

#<> @attribute active enable/disable the hook exspects true/false
attribute :active, :kind_of =>  [TrueClass, FalseClass], :default => true
