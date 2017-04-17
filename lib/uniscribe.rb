# frozen_string_literal: true

require_relative "uniscribe/version"

require "unicode/name"
require "unicode/sequence_name"
require "symbolify"
require "characteristics"
require "paint"
require "unicode/display_width"
require "unicode/emoji"

module Uniscribe
  SUPPORTED_ENCODINGS = Encoding.name_list.grep(
    Regexp.union(
      /^UTF-8$/,
      /^UTF8-/,
      /^UTF-...E$/,
      /^US-ASCII$/,
      /^ISO-8859-1$/,
    )
  ).sort.freeze

  COLORS = {
    control: "#0000FF",
    blank: "#33AADD",
    format: "#FF00FF",
    mark: "#228822",
    unassigned: "#FF5500",
    ignorable: "#FFAA00",
  }

  def self.of(string, encoding: nil, wide_ambiguous: false)
    string = convert_to_encoding_or_raise(string, encoding)
    glyphs = string.encode("UTF-8").scan(/\X/)

    visualize(glyphs, wide_ambiguous: wide_ambiguous)
  end

  def self.convert_to_encoding_or_raise(string, encoding)
    raise ArgumentError, "no data given to uniscribe" if !string || string.empty?

    string.force_encoding(encoding) if encoding

    case string.encoding.name
    when *SUPPORTED_ENCODINGS
      unless string.valid_encoding?
        raise ArgumentError, "uniscribe can only describe strings with a valid encoding"
      end

      string
    when 'UTF-16', 'UTF-32'
      raise ArgumentError, "unibits only supports #{string.encoding.name} with specified endianess, please use #{string.encoding.name}LE or #{string.encoding.name}BE"
    else
      raise ArgumentError, "uniscribe can only describe Unicode strings (or US-ASCII or ISO-8859-1)"
    end
  end

  def self.visualize(glyphs, wide_ambiguous: false)
    puts
    ( glyphs[0..-2] || [] ).each{ |glyph|
      cps = glyph.codepoints
      if cps.size > 1
        puts_composition(cps, wide_ambiguous)
      else
        puts_codepoint(cps[0], false, false, wide_ambiguous)
      end
    }

    cps = glyphs[-1].codepoints
    if cps.size > 1
      puts_composition(cps, wide_ambiguous)
    else
      puts_codepoint(cps[0], false, true, wide_ambiguous)
    end
    puts
  end

  def self.puts_composition(cps, wide_ambiguous = false)
    char = cps.pack("U*")
    if sequence_name = Unicode::SequenceName.of(char)
      name = "Composition: #{sequence_name}"
    else
      name = "Composition"
    end
    char_color = random_color
    cp_hex = "----"
    symbolified_char = symbolify_composition(char)
    padding = determine_padding(symbolified_char, false, wide_ambiguous)

    puts "   %s ├┬ %s%s├┬ %s" % [
      Paint[cp_hex, char_color],
      Paint[symbolified_char, char_color],
      padding,
      Paint[name, char_color],
    ]
    ( cps[0..-2] || [] ).each{ |cp|
      puts_codepoint(cp, true, false, wide_ambiguous)
    }
    puts_codepoint(cps[-1], true, true, wide_ambiguous)
  end

  def self.puts_codepoint(cp, composed = false, last = false, wide_ambiguous = false)
    char = [cp].pack("U*")
    char_info = UnicodeCharacteristics.new(char)
    char_color = determine_codepoint_color(char_info)
    cp_hex = cp.to_s(16).rjust(4, "0").rjust(6).upcase
    symbolified_char = Symbolify.unicode(char, char_info)
    if composed && !last
      branch = "│├─"
    elsif composed && last
      branch = "│└─"
    else
      branch = "├─"
    end
    name = determine_codepoint_name(char)
    padding = determine_padding(symbolified_char, composed, wide_ambiguous)

    puts " %s %s %s%s%s %s" % [
      Paint[cp_hex, char_color],
      branch,
      Paint[symbolified_char, char_color],
      padding,
      branch,
      Paint[name, char_color],
    ]
  end

  def self.determine_codepoint_color(char_info)
    if !char_info.assigned?
      if char_info.ignorable?
        COLORS[:ignorable]
      else
        COLORS[:unassigned]
      end
    elsif char_info.blank?
      COLORS[:blank]
    elsif char_info.control?
      COLORS[:control]
    elsif char_info.format?
      COLORS[:format]
    elsif char_info.unicode? && char_info.category[0] == "M"
      COLORS[:mark]
    else
      random_color
    end
  end

  def self.random_color
    "%.2x%.2x%.2x" % [rand(90) + 60, rand(90) + 60, rand(90) + 60]
  end

  def self.determine_codepoint_name(char)
    name = Unicode::Name.correct(char)
    return name if name

    name = Unicode::Name.label(char)
    as = Unicode::Name.aliases(char)
    return name if !as

    alias_ = ( as[:control]      && as[:control][0]      ||
               as[:figment]      && as[:figment][0]      ||
               as[:alternate]    && as[:alternate][0]    ||
               as[:abbreviation] && as[:abbreviation][0] )
    return name if !alias_

    name + " " + alias_
  end

  def self.determine_padding(char, composed, wide_ambiguous)
    required_width = Unicode::DisplayWidth.of(char, wide_ambiguous ? 2 : 1, {}, emoji: true)
    required_width += 1 if composed
    required_width = 0 if required_width < 0

    case required_width
    when  0...5
      "\t\t"
    when 5...10
      "\t"
    else
      ""
    end
  end

  def self.symbolify_composition(char)
    char_infos = char.chars.map{ |c| UnicodeCharacteristics.new(c) }

    case
    when char_infos.any?{ |c| !c.assigned? }
      "n/a"
    when char_infos.all?{ |c| c.separator? }
      "⏎"
    when char_infos.all?{ |c| c.category == "Mn" || c.category == "Me" }
      if char_infos.any?{ |c| c.category == "Mn" }
        "◌" + char
      else
        " " + char
      end
    when char_infos.all?{ |c| c.blank? }
      "]" + char + "["
    else
      char
    end
  end
end

