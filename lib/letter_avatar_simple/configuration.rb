# frozen_string_literal: true
class LetterAvatarSimple
  module Configuration
    def fill_color
      @fill_color || "rgba(255, 255, 255, 0.65)"
    end

    def fill_color=(v)
      @fill_color = v
    end

    def font
      @font || File.join(File.expand_path("../../", File.dirname(__FILE__)), "Roboto-Medium")
    end

    def font=(v)
      @font = v
    end

    def colors_palette
      @colors_palette ||= :google
    end

    def colors_palette=(v)
      @colors_palette = v if Colors::PALETTES.include?(v)
    end

    def custom_palette
      @custom_palette ||= nil
    end

    def custom_palette=(v)
      @custom_palette = v
      raise "Missing Custom Palette, please set config.custom_palette if using :custom" if @custom_palette.nil? && @colors_palette == :custom
      raise "Invalid Custom Palette, please update config.custom_palette" unless Colors::valid_custom_palette?(@custom_palette)
    end

    def weight
      @weight ||= 300
    end

    def weight=(v)
      @weight = v
    end

    def annotate_position
      @annotate_position ||= "-0+5"
    end

    def annotate_position=(v)
      @annotate_position = v
    end
    
    def letters_count
      @letters_count ||= 1
    end

    def letters_count=(v)
      @letters_count = v
    end

    def pointsize
      @pointsize ||= 140
    end

    def pointsize=(v)
      @pointsize = v
    end
  end
end
