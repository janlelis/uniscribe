# frozen_string_literal: true

require "unicode/version"

module Uniscribe
  VERSION = "1.4.0"

  UNICODE_VERSION = "12.1.0"
  EMOJI_VERSION = "12.1"

  UNICODE_VERSION_GLYPH_DETECTION = RUBY_ENGINE == "ruby" &&
  Unicode::Version.unicode_version
end
