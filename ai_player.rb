class AiPlayer
    
    attr_reader :name 
    
    def initialize(name)

        @name = name

    end

    def guess(fragment, dictionary, num_players)

        alphabet = ("a".."z").to_a
        winning_guesses = []
        neutral_guesses = []
        losing_guesses = []
        other_players = num_players - 1
        alphabet.each do | char |

            
            if  dictionary.include?(fragment + char)

                losing_guesses << char 

            else

                neutral_words = []
                winning_words = []
                dictionary.each do | word | 
                    
                    winning_words << word if word.start_with?(fragment + char) && word.delete_prefix(fragment + char).length <= other_players
                    neutral_words << word if word.start_with?(fragment + char) && word.delete_prefix(fragment + char).length > other_players 
 
                end
                if neutral_words.empty? && !winning_words.empty?

                    winning_guesses << char

                elsif !neutral_words.empty?

                    neutral_guesses << char

                end

            end

        end
        if !winning_guesses.empty?

            winning_guesses.sample

        elsif !neutral_guesses.empty?

            neutral_guesses.sample 

        else

            losing_guesses.sample

        end

    end

end