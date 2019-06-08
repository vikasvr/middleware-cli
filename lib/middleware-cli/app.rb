# frozen_string_literal: true

module MiddlewareCli
  module App
    APPLICATION_ROUTE = "::Application.routes"
    def app_path
      path_array = Dir.getwd.split("/")
      while not path_array.empty?
        guess_path = path_array.join("/")
        unless Dir[guess_path + "/Gemfile"].empty?
          return guess_path
        end
        path_array.pop
      end
      Dir.getwd
    end

    def middleware_list
      filtered_list.each_with_index do |middleware, index|
        yield(middleware, index + 1)
      end
    end

    def filtered_list
      `rake middleware`.each_line.map do |middleware|
        if middleware.start_with?("use") || middleware.start_with?("run")
          middleware.split(" ").last
        end
      end.compact
    end

    def load_application
      require "#{app_path}/config/environment"
    end

    def copy_file(path, directory_path)
      FileUtils.mkdir_p directory_path unless Dir.exists?(directory_path)
      FileUtils.cp path, directory_path
    end

    def is_route_middleware?(middleware)
      middleware.include?(APPLICATION_ROUTE)
    end

    def relative_app_path(*paths)
      [app_path, paths].join('/')
    end
  end
end
