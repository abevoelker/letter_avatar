# frozen_string_literal: true
require "digest"

class LetterAvatarSimple
  class Palette
    def initialize(palette)
      @palette = palette
    end

    def letter_color(identity)
      digest = Digest::MD5.hexdigest(identity.id.to_s)
      @palette[digest[0...15].to_i(16) % @palette.length]
    end
  end
end
