# frozen_string_literal: true

module Uniscribe
  VERSION = "1.1.0"
  UNICODE_VERSION = "11.0.0"

  RUBY_UNICODE_VERSIONS = {
    2.6 => "11.0.0",
    2.5 => "10.0.0",
    2.4 => "9.0.0",
    2.3 => "8.0.0",
    2.2 => "7.0.0",
    2.1 => "6.1.0",
  }.freeze

  UNICODE_VERSION_GLYPH_DETECTION = RUBY_ENGINE == "ruby" && RUBY_UNICODE_VERSIONS[RUBY_VERSION.to_f]
end

