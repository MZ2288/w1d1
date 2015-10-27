require 'byebug'
class Game
  attr_reader :players, :fragment, :losses

  def self.load
    p1 = Player.new("Marek")
    p2 = Player.new("Haris")
    p3 = Player.new("Haseeb")
    Game.new(p1, p2, p3).run
  end

  def initialize(*players)
    @players = players
    @fragment = ""
    @dictionary ||= File.readlines("ghost-dictionary.txt").map(&:chomp)
    @losses = {}
    players.each { |player| losses[player] = 0 }
  end

  def run
    until losses.count { |k, v| v < 5 } == 1
      play_round

      scoreboard
    end
  end

  def scoreboard
    players.each do |player|
      puts "#{player.name}, you have #{@losses[player]} losses"
    end
  end

  def play_round
    puts "#{@fragment}"
    puts "#{current_player.name} Please enter a character"
    good_guess = false
    until good_guess
      guess = take_turn(current_player)
      good_guess = valid_play?(guess)
      puts "NOT A VALID GUESS, SORRY" unless good_guess
    end
    if @dictionary.select{ |word| word == (@fragment + guess)}.size == 1
      puts "YOU LOSE"
      @losses[current_player] += 1
      @fragment = ""
    end
    @fragment += guess
    next_player!
  end

  def current_player
    @players.first
  end

  def previous_player
    @players.last
  end

  def next_player!
    @players.rotate!
    until losses[current_player] < 5
      @players.rotate!
    end
  end

  def take_turn(player)
    player.guess
  end

  def valid_play?(str)
    valid_char = ('a'..'z').include?(str)
    valid_prefix = @dictionary.any? {|word| word.start_with?(@fragment + str) }
    valid_char && valid_prefix
  end

end



class Player
  attr_reader :name, :score

  def initialize(name)
    @name = name
    @score = 0
  end

  def guess
    gets.chomp.downcase
  end



end
