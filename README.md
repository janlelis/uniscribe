# uniscribe | Describe the Unicode [![[version]](https://badge.fury.io/rb/uniscribe.svg)](http://badge.fury.io/rb/uniscribe)  [![[travis]](https://travis-ci.org/janlelis/uniscribe.svg)](https://travis-ci.org/janlelis/uniscribe)

Describes Unicode characters with their name and shows compositions.

- Helps you understand how glyphs and codepoints are structered within the data
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

### Emoji Sequences

`>> uniscribe "3️⃣🤸‍♀"`

![Screenshot Emoji](/screenshots/emoji.png?raw=true "Emoji")

### Lots of Combining Marks

`>> uniscribe "̶̧̨̱̹̭̯ͧ̾ͬC̷̙̲̝͖ͭ̏ͥͮ͟Oͮ͏̮̪̝͍"`

![Screenshot Marks](/screenshots/marks.png?raw=true "Marks")

### Some Strange Unicode Characters

`>> uniscribe "\0A\u{E01D7}\x7F\r\n\u{D0000}\u{81}\u{FFF9}B\u{FFFB}🏴\u{E0061}\u{E007F}\u{10FFFF}"`

![Screenshot Strange](/screenshots/strange.png?raw=true "Strange")

### Some Blanks

`>> uniscribe "­ᅠ ⁬﻿𝅸"`

![Screenshot Blanks](/screenshots/blanks.png?raw=true "Blanks")

## Notes

The proper detetion of compositions / graphemes / combined characters depends on your Ruby version:

Ruby | Unicode Version
-----|----------------
2.4  | 9.0.0
2.3  | 8.0.0
2.2  | 7.0.0
2.1  | 6.1.0

Also see

- [unibits](https://github.com/janlelis/unibits) - visualizes Unicode encodings
- [symbolify](https://github.com/janlelis/symbolify) - used for safely printing individual codepoints
- [characteristics](https://github.com/janlelis/characteristics) - used for detecting blanks and similar
- [unicopy](https://github.com/janlelis/unicopy) - copy codepoints to clipboard
- [Unicode® Standard Annex #29: Unicode Text Segmentation](http://unicode.org/reports/tr29/)

Copyright (C) 2017 Jan Lelis <http://janlelis.com>. Released under the MIT license.
