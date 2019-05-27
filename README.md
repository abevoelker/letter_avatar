# LetterAvatarSimple

Forked from [`letter_avatar`](https://github.com/ksz2k/letter_avatar), which was
in turn was extracted from [Discourse](https://www.discourse.org/).

Compared to `letter_avatar`, this gem:
  * Outputs `StringIO` binary data by default instead of writing files to
    the `public` directory (but can write to temp files too) so you can use
    [shrine](https://github.com/shrinerb/shrine) or similar gems easier
  * Uses [minimagick](https://github.com/minimagick/minimagick) instead of
    homegrown ImageMagick shell execution
  * Doesn't come with model, view, or controller helpers
  * Doesn't do caching

## Examples

#### Google's Inbox Palette

<img src="https://cloud.githubusercontent.com/assets/5518/13031513/43eefa76-d30b-11e5-8f06-85f8eb2a4fb6.png" width="60" /> <img src="https://cloud.githubusercontent.com/assets/5518/13031514/43ef6d8a-d30b-11e5-9fbc-38ae526b56b3.png" width="60" /> <img src="https://cloud.githubusercontent.com/assets/5518/13031517/43f0da12-d30b-11e5-8fef-6c7daf235a54.png" width="60" /> <img src="https://cloud.githubusercontent.com/assets/5518/13031515/43f0568c-d30b-11e5-95c5-1653361d4443.png" width="60" /> <img src="https://cloud.githubusercontent.com/assets/5518/13031512/43eebcc8-d30b-11e5-9f95-0093bfadd182.png" width="60" /> <img src="https://cloud.githubusercontent.com/assets/5518/13031516/43f0d0bc-d30b-11e5-8822-f01a6a138ff8.png" width="60" /> <img src="https://cloud.githubusercontent.com/assets/5518/13031519/44382430-d30b-11e5-96e4-bcd7ce5eb155.png" width="60" /> <img src="https://cloud.githubusercontent.com/assets/5518/13031518/44378d04-d30b-11e5-9400-55ff46b94cbe.png" width="60" /> <img src="https://cloud.githubusercontent.com/assets/5518/13031521/443a03cc-d30b-11e5-8467-9592e9dbb2ae.png" width="60" /> <img src="https://cloud.githubusercontent.com/assets/5518/13031523/443badc6-d30b-11e5-9d72-45613018cab4.png" width="60" /> <img src="https://cloud.githubusercontent.com/assets/5518/13031520/44394e14-d30b-11e5-966c-2eada89295c9.png" width="60" /> <img src="https://cloud.githubusercontent.com/assets/5518/13031522/443a71fe-d30b-11e5-88f4-37d1fd220abb.png" width="60" /> <img src="https://cloud.githubusercontent.com/assets/5518/13031525/44752b1e-d30b-11e5-8290-ed8888055e64.png" width="60" /> <img src="https://cloud.githubusercontent.com/assets/5518/13031524/4471cef6-d30b-11e5-9f4c-004f993dd27b.png" width="60" /> <img src="https://cloud.githubusercontent.com/assets/5518/13031526/4475a990-d30b-11e5-8be3-c8f4482dee03.png" width="60" /> <img src="https://cloud.githubusercontent.com/assets/5518/13031527/44772482-d30b-11e5-92f0-b9190c312d70.png" width="60" /> <img src="https://cloud.githubusercontent.com/assets/5518/13031528/447804ce-d30b-11e5-8002-9424d5474ddb.png" width="60" />

## Usage

```ruby
# generates an "F" avatar:
LetterAvatarSimple.generate("foobar")
=> #<StringIO:0x000055b3804948a8>

# generates an "F" avatar to file:
LetterAvatarSimple.generate_file("foobar")
=> #<File:/tmp/x20190527-19344-79m629.png>

# generates a "JS" avatar to file:
LetterAvatarSimple.generate("John Smith")
=> #<StringIO:0x000055b380e6a058>

# generates a 256x256 "F" avatar to file:
# default size is 600x600; other options are config parameters (see below)
LetterAvatarSimple.generate_file("foobar", size: 256)
=> #<File:/tmp/x20190527-19344-1ng4mku.png>

# you can specify the letters yourself directly if necessary. the second
# param is hashed for use in certain color palettes to make color usage unique
i = LetterAvatarSimple::Identity.new("ZZ", "John Smith")
LetterAvatarSimple.generate(i)
```

## Installation

```ruby
gem "letter_avatar_simple"
```

## System requirements

ImageMagick or GraphicsMagick - see
[MiniMagick requirements](https://github.com/minimagick/minimagick#requirements)

## Configuration

```ruby
LetterAvatarSimple.config do |config|
  config.fill_color        = 'rgba(255, 255, 255, 1)' # default is 'rgba(255, 255, 255, 0.65)'
  config.colors_palette    = :iwanthue                # default is :google
  config.weight            = 500                      # default is 300
  config.annotate_position = '-0+10'                  # default is -0+5
  config.letters_count     = 2                        # default is 1
  config.pointsize         = 70                       # default is 140
end
```

#### Color palette

We have three color palettes implemented: `iwanthue`, `google` and `custom`.

Each of them have different colors, but the `iwanthue` also differently calculates the color for specified username.

The `google` selected will generate the same avatar for both, "Krzysiek" and "ksz2k" usernames given (both of them starts with letter "k"), but `iwanthue` will calculate it's md5 and then selects color, so there's huge chance that these usernames get different colors.

##### Custom palette definition

You can define your own `custom` palette:

```ruby
LetterAvatarSimple.config do |config|
  config.colors_palette = :custom
  config.custom_palette = [[120, 132, 205], [91, 149, 249], [72, 194, 249], [69, 208, 226]]
end
```
