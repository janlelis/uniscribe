# frozen_string_literal: true

module Uniscribe
  VERSION = "1.4.0"
  UNICODE_VERSION = "12.1.0"
  EMOJI_VERSION = "12.1"

  RUBY_UNICODE_VERSIONS = {
    2.6 => "12.1.0",
    "2.6.2" => "12.0.0",
    "2.6.1" => "11.0.0",
    "2.6.0" => "11.0.0",
    2.5 => "10.0.0",
    2.4 => "9.0.0",
    2.3 => "8.0.0",
    2.2 => "7.0.0",
    2.1 => "6.1.0",
  }.freeze

  UNICODE_VERSION_GLYPH_DETECTION = RUBY_ENGINE == "ruby" &&
  RUBY_UNICODE_VERSIONS[RUBY_VERSION] ||
  RUBY_UNICODE_VERSIONS[RUBY_VERSION.to_f]
end
