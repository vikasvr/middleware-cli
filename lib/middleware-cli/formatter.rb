require 'middleware-cli/app'

module MiddlewareCli
  class Formatter
    DEFAULT_TEMPLATE_NAME = "MiddlewareTemplate".freeze
    extend App

    class << self
      def create_template(name, path)
        begin
          load_application
        rescue LoadError
          puts "Fail to load your application"
          return
        end
        FileUtils.mkdir_p namespaced_path(path) unless Dir.exists?(namespaced_path(path))
        File.open("#{namespaced_path(path, name.underscore)}.rb", 'w') do |file|
          file.write formatted_template(name.camelize)
        end
        puts disclaimer(name.camelize, path)
      end

      def namespaced_path(*paths)
        [app_path, paths].join('/')
      end

      def formatted_template(temp_name)
        template.sub!(DEFAULT_TEMPLATE_NAME, temp_name).gsub(' ' * 10, '')
      end

      def template
        %q(class MiddlewareTemplate
            def initialize(app)
              # app here is our rails app
              @app = app
            end

            def call(env)
              # env variable is a hash comprising of request parameters such as
              # headers, request url, request parameters etc.
              @app.call(env)
            end
          end)
      end

      def disclaimer(name, path)
        %Q(
          Find your Middleware #{name} at #{path}

          Now configure your middleware by adding:
            config.middleware.insert_before "Rails::Logger", #{name}
          in config/application.rb
        )
      end
    end
  end
end
