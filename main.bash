#!/bin/bash

# Runs once at the beginning of the game
introduction () {
	echo
	echo "$WELCOME1"; sleep 1
	echo -n "$WELCOME2"; sleep 1
	echo -n "."; sleep 1
	echo -n "."; echo; sleep 1
	echo
	echo "$WELCOME3"; sleep 2
	echo "$WELCOME4"; sleep 2
	echo
}

# If the user selection is bad
badChoice () {
	echo
	echo "$GENERR"; sleep 1
	echo
}

# Buy chips
buyChips () {
	echo
	read -p "$BUYPROMPT"
	echo
	if [[ $REPLY =~ ^[0-9]+$ ]]; then
		MONEY+=$REPLY
		echo "You have \$$MONEY in chips."
	else
		echo "$ERRNOINT"; sleep 1
		buyChips
	fi
	sleep 1
	echo
}

playGame () {
shuffle
showDeck
promptBet
dealHand
until ((PSTAND || PBUST)); do
	showHand
	addPScore
	echo "[$PSCORE]"
	if [ $((PSCORE)) -le 21 ]; then
		promptChoice
	else
		echo; echo "$PSCORE too many!"; STAND=1; echo
	fi
done
echo
resetVars
}

# The player can choose whether to play, buy chips, or quit.
showMenu () {
	OPTIONS=("Quit" "Buy chips") # Reset options
	if [ "$MONEY" -ge "$MINBET" ]; then # If player has enough
		OPTIONS+=("Play blackjack") # Then they can play
	fi
	select opt in "${OPTIONS[@]}"; do
		case $opt in
			"Quit") PQUIT=1; break;;
			"Buy chips") buyChips; break;;
			"Play blackjack") playGame; break;;
			*) badChoice;;
		esac
		REPLY=
	done
}

# Cash out. Walk away from the table. Quit the game.
conclusion () {
	echo
	echo "You are leaving with \$$MONEY."; sleep 1
	echo "Goodbye."
	echo; sleep 1
}
