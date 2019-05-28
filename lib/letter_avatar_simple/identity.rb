# frozen_string_literal: true
class LetterAvatarSimple
  class Identity
    attr_accessor :letters, :id

    def initialize(letters, id)
      @letters = letters
      @id = id
    end

    def self.from_username(username)
      # "john smith" => "JS"
      letters = username.split(/\s+/).map{|word| word[0].upcase}.join('')
      new(letters, username)
    end
  end
end
