# LetterAvatarSimple

Forked from [letter_avatar][], which was
in turn was extracted from [Discourse][].

Compared to [letter_avatar][], this gem:
  * Outputs `StringIO` binary data by default instead of writing files to
    the `public` directory (but can write to temp files too) so you can use
    [shrine][] or similar gems easier
  * Uses [minimagick][] instead of
    homegrown ImageMagick shell execution
  * Supports keyword arguments for generating each image (don't need to edit
    global config or constants)
  * Simplifies custom palette loading and supports multiple custom palettes
  * Does **not** come with model, view, or controller helpers (you should
    be using [shrine][])
  * Does **not** do caching (you should be using
    [shrine][])

## Examples

#### Google's Inbox Palette

<img src="https://cloud.githubusercontent.com/assets/5518/13031513/43eefa76-d30b-11e5-8f06-85f8eb2a4fb6.png" width="60" /> <img src="https://cloud.githubusercontent.com/assets/5518/13031514/43ef6d8a-d30b-11e5-9fbc-38ae526b56b3.png" width="60" /> <img src="https://cloud.githubusercontent.com/assets/5518/13031517/43f0da12-d30b-11e5-8fef-6c7daf235a54.png" width="60" /> <img src="https://cloud.githubusercontent.com/assets/5518/13031515/43f0568c-d30b-11e5-95c5-1653361d4443.png" width="60" /> <img src="https://cloud.githubusercontent.com/assets/5518/13031512/43eebcc8-d30b-11e5-9f95-0093bfadd182.png" width="60" /> <img src="https://cloud.githubusercontent.com/assets/5518/13031516/43f0d0bc-d30b-11e5-8822-f01a6a138ff8.png" width="60" /> <img src="https://cloud.githubusercontent.com/assets/5518/13031519/44382430-d30b-11e5-96e4-bcd7ce5eb155.png" width="60" /> <img src="https://cloud.githubusercontent.com/assets/5518/13031518/44378d04-d30b-11e5-9400-55ff46b94cbe.png" width="60" /> <img src="https://cloud.githubusercontent.com/assets/5518/13031521/443a03cc-d30b-11e5-8467-9592e9dbb2ae.png" width="60" /> <img src="https://cloud.githubusercontent.com/assets/5518/13031523/443badc6-d30b-11e5-9d72-45613018cab4.png" width="60" /> <img src="https://cloud.githubusercontent.com/assets/5518/13031520/44394e14-d30b-11e5-966c-2eada89295c9.png" width="60" /> <img src="https://cloud.githubusercontent.com/assets/5518/13031522/443a71fe-d30b-11e5-88f4-37d1fd220abb.png" width="60" /> <img src="https://cloud.githubusercontent.com/assets/5518/13031525/44752b1e-d30b-11e5-8290-ed8888055e64.png" width="60" /> <img src="https://cloud.githubusercontent.com/assets/5518/13031524/4471cef6-d30b-11e5-9f4c-004f993dd27b.png" width="60" /> <img src="https://cloud.githubusercontent.com/assets/5518/13031526/4475a990-d30b-11e5-8be3-c8f4482dee03.png" width="60" /> <img src="https://cloud.githubusercontent.com/assets/5518/13031527/44772482-d30b-11e5-92f0-b9190c312d70.png" width="60" /> <img src="https://cloud.githubusercontent.com/assets/5518/13031528/447804ce-d30b-11e5-8002-9424d5474ddb.png" width="60" />

## Usage

```ruby
# Generates an "F" avatar:
LetterAvatarSimple.generate("foobar")
# => #<StringIO:0x000055b3804948a8>

# Generates a "JS" avatar:
LetterAvatarSimple.generate("John Smith")
# => #<StringIO:0x000055b380e6a058>

# Generates a "JS" avatar to file:
LetterAvatarSimple.generate_file("John Smith")
# => #<File:/tmp/x20190527-19344-79m629.png>

# You can specify the letters yourself directly if necessary by creating a
# LetterAvatarSimple::Identity. The username will be hashed by certain color
# palettes to make color choice different between users with the same initials
i = LetterAvatarSimple::Identity.new("ZZ", "John Smith")
LetterAvatarSimple.generate(i)

# Other options that can be provided:
LetterAvatarSimple.generate(
  "foobar",
  size: 256,                            # => default 600
  palette: :i_want_hue,                 # => default :google
  pointsize: 70,                        # => default 140
  font: "/tmp/path/to/font/file",       # => default is path to included Roboto font
  weight: 500,                          # => default 300
  fill_color: "rgba(255, 255, 255, 1)", # => default "rgba(255, 255, 255, 0.65)"
  annotate_position: "-0+10",           # => default "-0+5"
  filename: "/tmp/foo.png",             # => default is randomly generated tempfile path
)
```

## Installation

```ruby
gem "letter_avatar_simple"
```

## System requirements

ImageMagick or GraphicsMagick - see
[MiniMagick requirements](https://github.com/minimagick/minimagick#requirements)

## Configuration

The same options that can be passed to `generate` can be set as global defaults:

```ruby
LetterAvatarSimple.config do |config|
  config.size              = 256
  config.palette           = :i_want_hue
  config.pointsize         = 70
  config.font              = "/tmp/path/to/font/file"
  config.weight            = 500
  config.fill_color        = "rgba(255, 255, 255, 1)"
  config.annotate_position = "-0+10"
end
```

### Color palette

Two color palettes are provided by default: `:google` and `:i_want_hue`

Both palettes use an MD5 digest of the username to select the color, so it's
likely that two different usernames that share the same initial(s) will render
with different colors.

If you need the same initials to always render with the same color, simply
provide a custom palette using a customized `letter_color` method. See below
for an example.

### Custom palettes

You can add your own custom palette:

```ruby
LetterAvatarSimple.palettes[:my_palette] = LetterAvatarSimple::Palette.new([
  [120, 132, 205],
  [91, 149, 249],
  [72, 194, 249],
  [69, 208, 226],
])
# The default method of selecting the color is by MD5 digest of the username. You
# can change this behavior by providing a letter_color method.
LetterAvatarSimple.palettes[:my_palette].tap do |p|
  def p.letter_color(identity)
    if identity.id == "admin"
      [255, 0, 0] # red
    elsif identity.id == "bozo"
      @palette.sample # random
    else
      # same initials = same color
      digest = Digest::MD5.hexdigest(identity.letters.to_s)
      @palette[digest[0...15].to_i(16) % @palette.length]
    end
  end
end

LetterAvatarSimple.generate_file("foobar", palette: :my_palette)
```

[letter_avatar]: https://github.com/ksz2k/letter_avatar
[minimagick]: https://github.com/minimagick/minimagick
[shrine]: https://github.com/shrinerb/shrine
[Discourse]: https://www.discourse.org/
