# frozen_string_literal: true

# Creating a class to make n players for some game
class Player
  attr_reader :name
  def initialize(name)
    @name = name
  end
end
