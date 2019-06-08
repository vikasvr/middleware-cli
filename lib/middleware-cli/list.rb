# frozen_string_literal: true

require 'terminal-table'
require 'middleware-cli/app'

module MiddlewareCli
  class List
    extend App
    class << self
      def display
        table = Terminal::Table.new do |t|
          t << ['S/n', 'Middleware Name']
          t << :separator
          middleware_list do |middleware, index|
            t.add_row [index , middleware]
          end
          t << :separator
          t << ['Total', "#{filtered_list.count} Middlewares"]
        end
        puts table
      end
    end
  end
end
