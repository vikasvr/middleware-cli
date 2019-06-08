# frozen_string_literal: true

require 'middleware-cli/app'

module MiddlewareCli
  class ExtractMiddleware
    class InvalidMiddlewarePath < StandardError; end
    extend App
    ACTION_DISPATCH_FLASH = "ActionDispatch::Flash"

    class << self
      def execute(requested_path, options)
        begin
          load_application
        rescue LoadError
          puts "Fail to load your application"
          return
        end
        if options["name"].blank?
          extract_all(requested_path)
        else
          extract_one(requested_path, options["name"], options["terminal"])
        end
      end

      def find(middleware)
        file_path, _ = begin
                        find_source(middleware)
                      rescue StandardError => error
                        [error.backtrace_locations.first.to_s.match(/:\d*:in/).pre_match, nil]
                      end
        raise InvalidMiddlewarePath if file_path.include?("lib/middleware/helper/extract_middleware")
        [file_path, namespace_to_path(middleware)]
      end

      def find_source(middleware_name)
        middleware = if is_route_middleware?(middleware_name)
                       constantize(middleware_name.match('.routes').pre_match).routes
                     else
                       constantize(middleware_name).send(*init_with(middleware_name))
                     end
        middleware.method(:call).source_location
      end

      def constantize(middleware)
         Object.const_get(middleware)
      end

      def init_with(middleware)
        middleware == ACTION_DISPATCH_FLASH ? ['new'] : ['new', OpenStruct.new]
      end

      def namespace_to_path(middleware)
        middleware.split(/\W+/).map(&:underscore).join("/")
      end

      def render_disclaimer(path)
        puts "Find your middlewares at '\\#{path}' :)"
      end

      def extract_all(path)
        middleware_list do | middleware, _|
          perform(middleware, path)
        end
        render_disclaimer(path)
      end

      def extract_one(path, middleware_name, terminal_output)
        if middleware_name.blank?
          puts "Please enter any middleware name"
        elsif filtered_list.find { |name| name == middleware_name}
          perform(middleware_name, path, terminal_output)
          render_disclaimer(path) unless terminal_output
        else
          puts "Middleware not found :("
        end
      end

      def perform(middleware, requested_path, terminal_output = false)
        begin
          path, folder = find(middleware)
          if terminal_output
            puts `cat #{path}`
          else
            copy_file(path, relative_app_path(requested_path, folder))
          end
        rescue StandardError => e
          return
        end
      end
    end
  end
end
