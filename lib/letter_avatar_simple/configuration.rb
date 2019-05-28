# frozen_string_literal: true
class LetterAvatarSimple
  module Configuration
    attr_writer :size, :fill_color, :font, :palette, :weight,
      :annotate_position, :pointsize

    def size
      @size || 600
    end

    def fill_color
      @fill_color || "rgba(255, 255, 255, 0.65)"
    end

    def font
      @font || File.join(File.expand_path("../../", File.dirname(__FILE__)), "Roboto-Medium")
    end

    def palette
      @palette || :google
    end

    def weight
      @weight ||= 300
    end

    def annotate_position
      @annotate_position ||= "-0+5"
    end

    def pointsize
      @pointsize ||= 140
    end
  end
end
