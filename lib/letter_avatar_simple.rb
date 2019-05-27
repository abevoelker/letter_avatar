# frozen_string_literal: true
require "letter_avatar_simple/version"
require "letter_avatar_simple/configuration"
require "letter_avatar_simple/colors"
require "letter_avatar_simple/identity"
require "fileutils"
require "mini_magick"
require "tmpdir"

class LetterAvatarSimple
  extend Configuration
  DEFAULT_SIZE = 600

  def self.config(&blk)
    yield(self)
  end

  def self.generate(identity, size: DEFAULT_SIZE, output: :string)
    if identity.is_a?(String)
      identity = Identity.from_username(identity)
    end

    filename = generate_temp_filename
    MiniMagick::Tool::Convert.new do |x|
      x.size "#{size.to_i}x#{size.to_i}"
      x << "xc:#{to_rgb(identity.color)}"
      x.pointsize LetterAvatarSimple.pointsize
      x.font LetterAvatarSimple.font
      x.weight LetterAvatarSimple.weight
      x.fill LetterAvatarSimple.fill_color
      x.gravity "Center"
      x.annotate(LetterAvatarSimple.annotate_position, identity.letters)
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
