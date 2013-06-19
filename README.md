# Description

This is a Library cookbook that provides github_hook provider. 

Github hook provider can manage any service hook that is available via the 
github api. 

# Requirements

## Platform:
Should work on all platforms that omni chef works on. The only dep is the octokit Gem

# Attributes
`node[:github][:api][:gem][:version]` - controll the version of octokit gem to install

# Recipes
there is only a blank `default` recipe that does nothing

# Resources

* [github_hook](#github_hook)

## github_hook

This manages github hooks via github api with octokit


### Attribute Parameters

- oauth_token: Github api authentication token
- hook_name: the name of the service hook: "web", "irc" etc
- register_events: The github hook api events to register too defait Defaults to <code>["push"]</code>.
- config: a hash of config options for this service hook
- org: the github org name to use on api calls
- repo: the repo name
- user: The github user to use for api calls
- password: Github users password.
- active: enable/disable the hook exspects true/false Defaults to <code>true</code>.

### Examples

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

# License and Maintainer

Maintainer:: Jesse Nelson (<spheromak@gmail.com>)

License:: APL2
