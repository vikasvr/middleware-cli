require "middleware-cli/version"
require "middleware-cli/list"
require "middleware-cli/formatter"
require "middleware-cli/extract_middleware"
require 'thor'

module MiddlewareCli
  class Interface < Thor

    desc "list", "List your project's middleware"

    def list
      List.display
    end

    desc "view [middleware path]", "Generate view for your middlewares"

    option :name
    option :terminal, type: :boolean
    def view(middlware_path = 'middlewares')
      ExtractMiddleware.execute(middlware_path, options)
    end

    desc "create [Name] [Path]", "Generate Middleware"

    def create(name, path = 'app/middlewares')
      Formatter.create_template(name, path)
    end
  end
end
