class Player

    attr_reader :name 
    
    def initialize(name)

        @name = name

    end

    def guess(fragment, dictionary, num_players)

        print "#{@name}, pick a character from the alphabet: "
        puts 
        gets.chomp

    end

    def alert_invalid_guess

        puts "#{name}, this character was invalid"

    end

end