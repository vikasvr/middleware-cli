# Middleware CLI

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'middleware-cli', group: :development
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install middleware-cli

## Usage

  To get all the options type:
  ```ruby
    $ bundle exec middleware-cli
  ```

  To list all your middlewares type:
  ```ruby
    $ bundle exec middleware-cli list
  ```
  which will list all your middlewares:
  ```
    +-------+--------------------------------------------------------+
    | S/n   | Middleware Name                                        |
    +-------+--------------------------------------------------------+
    | 1     | Rack::Sendfile                                         |
    | 2     | ActionDispatch::Static                                 |
    | 3     | ActionDispatch::Executor                               |
    | 4     | ActiveSupport::Cache::Strategy::LocalCache::Middleware |
    | 5     | Rack::Runtime                                          |
    | 6     | Rack::MethodOverride                                   |
    | 7     | ActionDispatch::RequestId                              |
    | 8     | ActionDispatch::RemoteIp                               |
    | 9     | Sprockets::Rails::QuietAssets                          |
    | 10    | Rails::Rack::Logger                                    |
    | 11    | ActionDispatch::ShowExceptions                         |
    | 12    | WebConsole::Middleware                                 |
    | 13    | ActionDispatch::DebugExceptions                        |
    | 14    | Airbrake::Rack::Middleware                             |
    | 15    | ActionDispatch::Reloader                               |
    | 16    | ActionDispatch::Callbacks                              |
    | 17    | ActiveRecord::Migration::CheckPending                  |
    | 18    | ActionDispatch::Cookies                                |
    | 19    | ActionDispatch::Session::CookieStore                   |
    | 20    | ActionDispatch::Flash                                  |
    | 21    | ActionDispatch::ContentSecurityPolicy::Middleware      |
    | 22    | Rack::Head                                             |
    | 23    | Rack::ConditionalGet                                   |
    | 24    | Rack::ETag                                             |
    | 25    | Rack::TempfileReaper                                   |
    | 26    | MyRailsApp::Application.routes                         |
    +-------+--------------------------------------------------------+
    | Total | 26 Middlewares                                         |
    +-------+--------------------------------------------------------+
  ```

  To create new middleware type:

  ```ruby
    $ bundle exec middleware-cli create MyMiddleware
  ```
  which will create your middleware at 'app/middlewares' which is the default.
  ```
    class MyMiddleware
      def initialize(app)
        # app here is our rails app
        @app = app
      end

      def call(env)
        # env variable is a hash comprising of request parameters such as
        # headers, request url, request parameters etc.
        @app.call(env)
      end
    end
  ```
  You can set your path by passing your path as second parameter:
  ```ruby
    $ bundle exec middleware-cli create MyMiddleware app/services
  ```

  To view all your middleware, you can simple use:
  ```ruby
    $ bundle exec middleware-cli view
  ```
  This will generate the code for all your middlewares of the application at middleware folder, which is the default.
  You can set the folder for all your generated middleware code by:
  ```ruby
    $ bundle exec middleware-cli view app/middlewares
  ```

  For generating code for any particular middleware, use the name option:
  ```ruby
    $ bundle exec middleware-cli view app/middlewares --name Rack::Sendfile
  ```

  To view the middleware code in terminal itself use terminal option:
  ```ruby
    $ bundle exec middleware-cli view app/middlewares --name Rack::Sendfile --terminal
  ```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/vikasvr/middleware-cli. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Middleware::Cli project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/vikasvr/middleware-cli/blob/master/CODE_OF_CONDUCT.md).
