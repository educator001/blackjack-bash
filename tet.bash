#!/bin/bash

# Show all the cards in the deck
showDeck () {
	position=1
	echo
	for i in "${DECK[@]}"; do
		echo -n "[$position] "
		echo $i
		((position++))
	done
}

# This is just a test function
flipCoin () {
	echo
	if [ $((RANDOM%2)) -eq 1 ]; then
		echo "Congratulations, you won the bet!"
		MONEY+=$((BET*2))
		echo "You now have \$$MONEY in chips."
	else
		echo "Sorry, you lost your bet."
	fi
}
