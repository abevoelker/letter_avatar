# frozen_string_literal: true
require "letter_avatar_simple/configuration"
require "letter_avatar_simple/identity"
require "letter_avatar_simple/palette"
require "letter_avatar_simple/version"
require "fileutils"
require "mini_magick"
require "tmpdir"

class LetterAvatarSimple
  extend Configuration

  def self.config(&blk)
    yield(self)
  end

  def self.palettes
    @palettes
  end

  def self.palettes=(h)
    @palettes = h
  end

  def self.generate(identity, output: :string, **kwargs)
    if identity.is_a?(String)
      identity = Identity.from_username(identity)
    end

    opts = {
      palette: kwargs[:palette] || LetterAvatarSimple.palette,
      size: kwargs[:size] || LetterAvatarSimple.size,
      pointsize: kwargs[:pointsize] || LetterAvatarSimple.pointsize,
      font: kwargs[:font] || LetterAvatarSimple.font,
      weight: kwargs[:weight] || LetterAvatarSimple.weight,
      fill_color: kwargs[:fill_color] || LetterAvatarSimple.fill_color,
      annotate_position: kwargs[:annotate_position] || LetterAvatarSimple.annotate_position,
    }

    filename = kwargs[:filename] || generate_temp_filename
    color = LetterAvatarSimple.palettes.fetch(opts.fetch(:palette)).letter_color(identity)
    MiniMagick::Tool::Convert.new do |x|
      x.size "#{opts.fetch(:size)}x#{opts.fetch(:size)}"
      x << "xc:#{to_rgb(color)}"
      x.pointsize opts.fetch(:pointsize)
      x.font opts.fetch(:font)
      x.weight opts.fetch(:weight)
      x.fill opts.fetch(:fill_color)
      x.gravity "Center"
      x.annotate(opts.fetch(:annotate_position), identity.letters)
      x << filename
    end

    if output == :file
      File.open(filename, "rb")
    else
      StringIO.new(File.binread(filename), "rb").tap do
        FileUtils.rm_f(filename)
      end
    end
  end

  def self.generate_file(*args, **kwargs)
    kwargs[:output] = :file
    self.generate(*args, **kwargs)
  end

  def self.to_rgb(color)
    r, g, b = color
    "rgb(#{r},#{g},#{b})"
  end

  def self.generate_temp_filename(ext=".png")
    filename = begin
      Dir::Tmpname.make_tmpname(["x", ext], nil)
    rescue NoMethodError
      require "securerandom"
      "#{SecureRandom.urlsafe_base64}#{ext}"
    end
    File.join(Dir.tmpdir, filename)
  end
end

require "letter_avatar_simple/palettes/google"
require "letter_avatar_simple/palettes/i_want_hue"
LetterAvatarSimple.palettes = {
  google: LetterAvatarSimple::Palettes::Google.new,
  i_want_hue: LetterAvatarSimple::Palettes::IWantHue.new,
}
