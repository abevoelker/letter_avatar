# frozen_string_literal: true
class LetterAvatarSimple
  class Identity
    attr_accessor :color, :letters

    def initialize(letters, id)
      @letters = letters
      @color = ::LetterAvatarSimple::Colors.for(id)
    end

    def self.from_username(username)
      letters = username.split(/\s+/).map{|word| word[0].upcase}.join('')
      new(letters, username)
    end
  end
end
