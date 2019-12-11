#!/bin/bash

declare -i PQUIT=0 # The player has not quit.
declare -a OPTIONS # Player choices

declare -i PBUST=0 # The player has not busted.
declare -i DBUST=0 # The dealer has not busted.
declare -i PSTAND=0 # The player does not stand.
declare -i DSTAND=0 # The dealer does not stand.

declare -i BET=0 # The amount of the player's bet

declare -a DECK # The deck is now empty but will soon hold the cards
declare -a SDECK # A placeholder array to use when shuffling the deck
declare -a PHAND # The player's hand will contain his cards
declare -a DHAND # The dealer's hand will contain her cards

declare -i PSCORE # The player's score
declare -i DSCORE # The dealer's score

readonly SUITS=(DIAMONDS CLUBS HEARTS SPADES)
readonly DENOMINATIONS=(ACE 2 3 4 5 6 7 8 9 10 JACK QUEEN KING)

# Configuration
readonly MINBET=2 # The table minimum
readonly MAXBET=400 # The table maximum

readonly PS3=$'\nYour choice: ' # Prompts
readonly BUYPROMPT="How much are you buying in? "
readonly BETPROMPT="How much would you like to bet? "

readonly WELCOME1="Welcome to the table!"
readonly WELCOME2="Sit down anywhere you like."
readonly WELCOME3="The betting range is \$$MINBET-\$$MAXBET."
readonly WELCOME4="The dealer must hit on soft 17."

readonly GENERR="Invalid option! Please try again."
readonly ERRNOINT="Sorry, that's not a valid number."
readonly ERRODD="Sorry, you must bet an even number."

declare -i MONEY=0 # How much do you want to start with?
