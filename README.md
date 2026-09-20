# uniscribe | Describe the Unicode [![[version]](https://badge.fury.io/rb/uniscribe.svg)](https://badge.fury.io/rb/uniscribe)  [![[ci]](https://github.com/janlelis/uniscribe/workflows/Test/badge.svg)](https://github.com/janlelis/uniscribe/actions?query=workflow%3ATest)

Describes Unicode characters with their name and shows compositions. **UNICODE 18.0**\* (September 2026)

- Helps you understand how glyphs and codepoints are structured within the data
- Gives you the names of glyphs and codepoints, which can be used for further research
- Highlights invalid/special/blank codepoints

Uses a similar color coding like its lower-level companion tool [unibits](https://github.com/janlelis/unibits).

## Setup

Make sure you have Ruby installed and installing gems works properly. Then do:

```
$ gem install uniscribe
```

## Usage

Pass the string to debug to uniscribe:

### From CLI

```
$ uniscribe "test strı̈ng"
```

### From Ruby

```ruby
require "uniscribe/kernel_method"
uniscribe "test strı̈ng"
```

### Output

```

0074 ├─ t		├─ LATIN SMALL LETTER T
0065 ├─ e		├─ LATIN SMALL LETTER E
0073 ├─ s		├─ LATIN SMALL LETTER S
0074 ├─ t		├─ LATIN SMALL LETTER T
0020 ├─ ] [		├─ SPACE
0073 ├─ s		├─ LATIN SMALL LETTER S
0074 ├─ t		├─ LATIN SMALL LETTER T
0072 ├─ r		├─ LATIN SMALL LETTER R
---- ├┬ ı̈		├┬ Composition
0131 │├─ ı		│├─ LATIN SMALL LETTER DOTLESS I
0308 │└─ ◌̈		│└─ COMBINING DIAERESIS
006E ├─ n		├─ LATIN SMALL LETTER N
0067 ├─ g		├─ LATIN SMALL LETTER G

```

## Examples

### Tamil

`>> uniscribe "நகரத்தில்"`

![Screenshot Tamil](/screenshots/tamil.png?raw=true "Tamil")

### Thai

`>> uniscribe "ม้าลายหกตัว"`

![Screenshot Thai](/screenshots/thai.png?raw=true "Thai")

### Ideographic Variations

`>> uniscribe "辻󠄀㚑󠄁"`

![Screenshot Ideographic Variations](/screenshots/ideographic_variations.png?raw=true "Ideographic Variations")

(the variation is not visible in the screenshot, because my system does not render it correctly)

### Emoji Sequences

`>> uniscribe "3️⃣🤸‍♀"`

![Screenshot Emoji](/screenshots/emoji.png?raw=true "Emoji")

### Lots of Combining Marks

`>> uniscribe "̶̧̨̱̹̭̯ͧ̾ͬC̷̙̲̝͖ͭ̏ͥͮ͟Oͮ͏̮̪̝͍"`

![Screenshot Marks](/screenshots/marks.png?raw=true "Marks")

### Random Sequences of some Special Unicode Codepoints

`>> uniscribe "\0A\u{E01D7}\x7F\r\n\u{D0000}\u{81}\u{FFF9}B\u{FFFB}🏴\u{E0061}\u{E007F}\u{10FFFF}"`

![Screenshot Strange](/screenshots/strange.png?raw=true "Strange")

### Some Blanks

`>> uniscribe "­ᅠ ⁬﻿𝅸"`

![Screenshot Blanks](/screenshots/blanks.png?raw=true "Blanks")

## \*Notes

Although the gem is generally up to date with latest Unicode data, the proper detection of compositions / graphemes / combined characters [depends on your Ruby version](https://idiosyncratic-ruby.com/73-unicode-version-mapping.html):

You can run `uniscribe -v` to check for the Unicode level of your uniscribe version.

Also see

- CLI: [unibits](https://github.com/janlelis/unibits) - visualizes Unicode encodings
- CLI: [unicopy](https://github.com/janlelis/unicopy) - copy codepoints to clipboard
- Website: [character.construction](https://character.construction) - lists notable codepoints
- Ruby Library: [symbolify](https://github.com/janlelis/symbolify) - used for safely printing individual codepoints
- Ruby Library: [characteristics](https://github.com/janlelis/characteristics) - used for detecting blanks and similar
- Unicode® Standard Annex #29: [Unicode Text Segmentation](https://unicode.org/reports/tr29/)
- Talk: [Ten Unicode Characters You Should Know About as a Programmer](https://www.youtube.com/watch?v=hlryzsdGtZo)

Copyright (C) 2017-2026 Jan Lelis <https://janlelis.com>. Released under the MIT license.
