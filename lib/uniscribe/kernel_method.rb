# frozen_string_literal: true

require_relative '../uniscribe'

module Kernel
  private

  def uniscribe(string, **kwargs)
    Uniscribe.of(string, **kwargs)
  end
end
