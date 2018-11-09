# Settings

Rails Application settings.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'settings'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install settings

## Usage

### Basic

```ruby
class Api
  include Settings::Configuration

  setting :username, "admin"
  setting :password, ENV["API_PASSWORD"]
end
```

These settings are then available from the `Settings` module, namespaced
by the class.

```ruby
Settings.api.username #=> "admin"
Settings.api.password #=> Whatever API_PASSWORD was set to
```

### Namespaced

You can also nest the configuration classes within a module to namespace the
settings.

```ruby
module Email
  class Api
    include Settings::Configuration

    setting :username, "admin"
    setting :password, ENV["API_PASSWORD"]
  end
end
```

Access to the setting is namespaced by the class's namespace.

```ruby
Settings.email.api.username #=> "admin"
Settings.email.api.password #=> Whatever API_PASSWORD was set to
```

This is just the first step! Hopefully more features will follow, such
as:

* Required/optional settings. A required setting would not allow the app
  to boot if it was not present.
* Environment based settings. Different settings depending on if the app
  is in development or production mode
* Types/type checking. Settings like `EMAIL_ENABLED` are hard to set
  from the environment, due to lack of real booleans.
* Validation. Some configuration may have explicitly allowed values.
  Being able to validate that the configuration matches one of those
  values might be useful.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/eebs/settings.
