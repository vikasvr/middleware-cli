require "test_helper"

class Middleware::CliTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Middleware::Helper::VERSION
  end
end
