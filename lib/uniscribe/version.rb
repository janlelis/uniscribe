# frozen_string_literal: true

module Uniscribe
  VERSION = "1.0.0".freeze
  UNICODE_VERSION = "9.0.0".freeze

  RUBY_UNICODE_VERSIONS = {
    2.4 => "9.0.0".freeze,
    2.3 => "8.0.0".freeze,
    2.2 => "7.0.0".freeze,
    2.1 => "6.1.0".freeze,
  }.freeze

  UNICODE_VERSION_GLYPH_DETECTION = RUBY_ENGINE == "ruby" && RUBY_UNICODE_VERSIONS[RUBY_VERSION.to_f]
end

