require_relative "game"

puts "Enter player names separated by space in the following format 'name:yes'(yes for computer, no for human player):"
input = gets.chomp.split(" ")
players = {}
input.each do | player |

    player_name, ai = player.split(":")
    ai == "yes" ? ai = true : ai = false
    players[player_name] = ai

end

game = Game.new(players)
game.run