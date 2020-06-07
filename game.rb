require_relative "player"
require_relative "ai_player"
require "open-uri"
require "set"

class Game

    attr_reader :current_player, :previous_player
    
    def initialize(players)

        @players = players.map { | player_name, ai | ai ? AiPlayer.new(player_name) : Player.new(player_name) }
        @current_player = @players.first
        @fragment = ""
        @losses = Hash.new(0)
        file = open("https://assets.aaonline.io/fullstack/ruby/projects/ghost/dictionary.txt")
        @dictionary = Set.new(file.readlines.map(&:chomp))
        file.close
        
    end

    def next_player!

        @players.rotate!
        @current_player = @players.first 
        @previous_player = @players.last

    end

    def take_turn(player)

        guess = player.guess(@fragment, @dictionary, @players.length).downcase
        until self.valid_play?(guess)

            player.alert_invalid_guess
            guess = player.guess(@fragment, @dictionary, @players.length).downcase

        end
        puts "#{player.name} chose the letter #{guess}"
        puts 
        @fragment += guess 
        @dictionary.include?(@fragment)

    end

    def valid_play?(guess)

        alphabet = ("a".."z").to_a
        return false if !alphabet.include?(guess) || guess.length != 1
        @dictionary.any? { | word | word.start_with?(@fragment + guess) }

    end

    def play_round

        while !self.take_turn(@current_player)

            puts "Word: #{@fragment}"
            puts 
            self.next_player!

        end
        @losses[@current_player] += 1
        puts "#{@current_player.name}, you lost this round!" if @losses[@current_player] != 5

    end

    def record(player)

        ghost_str = "GHOST"
    end_idx = @losses[player] - 1
    ghost_str[0..end_idx] 

    end

    def run 

        until @players.length == 1

            self.play_round
            if @losses[@current_player] == 5

                @players.shift
                @losses.delete(@current_player)
                puts "#{@current_player.name}, you lose!" if @players.length != 1
                @current_player = @players.first

            else

                self.next_player!

            end
            
            @fragment = ""
            self.display_standings if !@losses.empty? && @players.length != 1

        end
        puts "#{@players.first.name}, you win!"

    end

    def display_standings
        puts "-" * 30
        puts "#{"Losses".center(30)}"
        puts "-" * 30
        @losses.each do | player, loss_count |

            puts "#{player.name.ljust(20)}| #{self.record(player)}"

        end
        puts "-" * 30

    end

end