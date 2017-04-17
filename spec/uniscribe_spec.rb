require_relative "../lib/uniscribe/kernel_method"
require "minitest/autorun"

describe Uniscribe do
  def check(string_to_test, match_regex)
    uniscribe(string_to_test)
    assert_output(match_regex){ uniscribe(string_to_test) }
  end

  describe "displays codepoints" do
    it "LATIN CAPITAL LETTER" do
      check "AB", /0041.*0042/m
    end

    it "AERIAL TRAMWAY" do
      check "🚡", /1F6A1/
    end
  end

  describe "displays glyph itself" do
    it "LATIN CAPITAL LETTER" do
      check "AB", /A.*B/m
    end

    it "AERIAL TRAMWAY" do
      check "🚡", /🚡/
    end
  end

  describe "displays names" do
    it "LATIN CAPITAL LETTER" do
      check "AB", /LATIN CAPITAL LETTER A.*LATIN CAPITAL LETTER B/m
    end

    it "AERIAL TRAMWAY" do
      check "🚡", /AERIAL TRAMWAY/
    end
  end

  describe "supported encodings" do
    it "works with UTF-16" do
      check "🚡".encode("UTF-16LE"), /AERIAL TRAMWAY/
    end

    it "works with UTF-32" do
      check "🚡".encode("UTF-32BE"), /AERIAL TRAMWAY/
    end

    it "works with US-ASCII" do
      check "AB".force_encoding("US-ASCII"), /LATIN CAPITAL LETTER A.*LATIN CAPITAL LETTER B/m
    end

    it "works with ISO-8859-1" do
      check "AB\x81".force_encoding("ISO-8859-1"), /LATIN CAPITAL LETTER A.*LATIN CAPITAL LETTER B.*<control-0081> HIGH OCTET PRESET/m
    end
  end

  describe "example compositions" do
    describe "combining marks" do
      it "DIAERESIS" do
        check "g̈", /Composition.*LATIN SMALL LETTER G.*DIAERESIS/m
      end

      it "RING BELOW" do
        check "n̥", /Composition.*LATIN SMALL LETTER N.*COMBINING RING BELOW/m
      end

      it "ARABIC FATHA" do
        check "دَ", /Composition.*ARABIC LETTER DAL.*ARABIC FATHA/m
      end

      it "ACUTE ACCENT" do
        check "ά", /Composition.*GREEK SMALL LETTER ALPHA.*COMBINING ACUTE ACCENT/m
      end

      it "HEBREW POINT HIRIQ" do
        check "חִ", /Composition.*HEBREW LETTER HET.*HEBREW POINT HIRIQ/m
      end

      it "THAI CHARACTER SARA U" do
        check "จุ", /Composition.*THAI CHARACTER CHO CHAN.*THAI CHARACTER SARA U/m
      end
    end

    describe "misc scripts" do
      if RUBY_VERSION >= "2.4.0"
        it "HANGUL" do
          check "ᅘᆇᇈ", /Composition.*HANGUL CHOSEONG SSANGHIEUH.*HANGUL JUNGSEONG YO-O.*HANGUL JONGSEONG NIEUN-PANSIOS/m
        end

        it "HANGUL 2" do
          check "각", /Composition.*HANGUL CHOSEONG KIYEOK.*HANGUL JUNGSEONG A.*HANGUL JONGSEONG KIYEOK/m
        end

        it "HANGUL 3" do
          check "ᄇᄉᄐ", /Composition.*HANGUL CHOSEONG PIEUP.*HANGUL CHOSEONG SIOS.*HANGUL CHOSEONG THIEUTH/m
        end

        it "TAMIL" do
          check "நி", /Composition.*TAMIL SYLLABLE NI.*TAMIL LETTER NA.*TAMIL VOWEL SIGN I/m
        end

        it "DEVANAGARI" do
          check "षि", /Composition.*DEVANAGARI LETTER SSA.*DEVANAGARI VOWEL SIGN I/m
        end
      end
    end

    describe "zwj and zwnj" do
      if RUBY_VERSION >= "2.4.0"
        it "ZWJ" do
          check "क्‍", /Composition.*DEVANAGARI LETTER KA.*DEVANAGARI SIGN VIRAMA.*ZERO WIDTH JOINER/m
        end

        it "ZWNJ" do
          check "t‌", /Composition.*LATIN SMALL LETTER T.*ZERO WIDTH NON-JOINER/m
        end
      end
    end

    describe "misc variations" do
      it "TEXT STYLE" do
        check "‼︎", /Composition.*(text style).*DOUBLE EXCLAMATION MARK.*VARIATION SELECTOR-15/m
      end

      it "EMOJI STYLE" do
        check "‼️", /Composition.*(emoji style).*DOUBLE EXCLAMATION MARK.*VARIATION SELECTOR-16/m
      end

      it "DOTTED FORM" do
        check "င︀", /Composition.*(dotted form).*MYANMAR LETTER NGA.*VARIATION SELECTOR-1/m
      end

      it "MONGOLIAN SECOND FORM" do
        check "ᠠ᠋", /Composition.*(second form).*MONGOLIAN LETTER A.*MONGOLIAN FREE VARIATION SELECTOR ONE/m
      end

      it "CJK COMPATIBILITY IDEOGRAPH-2F81F" do
        check "㓟︀", /Composition.*CJK COMPATIBILITY IDEOGRAPH-2F81F.*CJK UNIFIED IDEOGRAPH-34DF.*VARIATION SELECTOR-1/m
      end

      it "CID+6238" do
        check "胥󠄀", /Composition.*CID\+6238.*CJK UNIFIED IDEOGRAPH-80E5.*VARIATION SELECTOR-17/m
      end
    end

    describe "misc other" do
      it "KEYCAP" do
        check "5⃣", /Composition.*DIGIT FIVE.*COMBINING ENCLOSING KEYCAP/m
      end

      if RUBY_VERSION >= "2.4.0"
        it "␍ + ␊" do
          check "\r\n", /Composition.*<control-000D> CARRIAGE RETURN.*<control-000A> LINE FEED/m
        end

        it "REGIONAL" do
          check "🇺🇳", /Composition.*UNITED NATIONS.*REGIONAL INDICATOR SYMBOL LETTER U.*REGIONAL INDICATOR SYMBOL LETTER N/m
        end

        it "TAG SEQUENCE" do
          check "🏴󠁧󠁢󠁳󠁣󠁴󠁿", /Composition.*SCOTLAND.*WAVING BLACK FLAG.*TAG LATIN SMALL LETTER G.*TAG LATIN SMALL LETTER B.*TAG LATIN SMALL LETTER S.*TAG LATIN SMALL LETTER C.*TAG LATIN SMALL LETTER T.*CANCEL TAG/m
        end

        it "EMOJI MODIFIER" do
          check "🙅🏿", /Composition.*PERSON GESTURING NO: DARK SKIN TONE.*FACE WITH NO GOOD GESTURE.*EMOJI MODIFIER FITZPATRICK TYPE-6/m
        end

        it "EMOJI ZWJ SEQUENCE" do
          check "👩‍👩‍👦‍👦", /Composition.*FAMILY.*WOMAN.*ZERO WIDTH JOINER.*WOMAN.*ZERO WIDTH JOINER.*BOY.*ZERO WIDTH JOINER.*BOY/m
        end
      end
    end
  end

  describe "unusual codepoints" do
    if RUBY_VERSION >= "2.4.0"
      it "safely prints and highlights unusual codepoints" do
        check "\0A\u{E01D7}\x7F\r\n\u{D0000}\u{81}\u{FFF9}B\u{FFFB}🏴\u{E0061}\u{E007F}\u{10FFFF}", /<control-0000> NULL.*Composition.*LATIN CAPITAL LETTER A.*VARIATION SELECTOR-232.*<control-007F> DELETE.*Composition.*<control-000D> CARRIAGE RETURN.*<control-000A> LINE FEED.*<reserved-D0000>.*<control-0081> HIGH OCTET PRESET.*INTERLINEAR ANNOTATION ANCHOR.*LATIN CAPITAL LETTER B.*INTERLINEAR ANNOTATION TERMINATOR.*Composition.*WAVING BLACK FLAG.*TAG LATIN SMALL LETTER A.*CANCEL TAG.*<noncharacter-10FFFF>/m
      end
    end

    it "safely prints and highlights various blanks" do
      check "­ᅠ ⁬﻿𝅸", /SOFT HYPHEN.*HANGUL JUNGSEONG FILLER.*EM QUAD.*INHIBIT ARABIC FORM SHAPING.*ZERO WIDTH NO-BREAK SPACE.*MUSICAL SYMBOL END SLUR/m
    end
  end
end
