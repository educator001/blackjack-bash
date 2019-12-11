#!/bin/bash

# Construct the deck using a nested loop
buildDeck () {
	for i in "${SUITS[@]}"; do # for each suit
		for j in "${DENOMINATIONS[@]}"; do # for each denom
			DECK+=("$j of $i") # add a card to the deck
		done
	done
}

# Shuffle the deck
shuffle () {
	buildDeck
	while [ ${#DECK[@]} -gt 0 ]; do # While there are cards in the deck
		num=$RANDOM # pick a random number
		if [ $num -le 32760 ]; then # normalize
			pos=$((num%52)) # convert to a number from 0-51
			if test "${DECK["$pos"]+isset}"; then # if in deck
				SDECK+=("${DECK["$pos"]}") # then copy
				unset DECK["$pos"] # and remove
			fi
		fi
	done
	DECK=("${SDECK[@]}") # Copy cards back from the placeholder
	echo -n "Shuffling"; sleep 1; echo -n "."; sleep 1
	echo -n "."; sleep 1; echo -n "."; sleep 1; echo
}

# Ask the player for a valid bet
promptBet () {
	echo; sleep 1
	read -p "$BETPROMPT"
	echo
	if ! [[ $REPLY =~ ^[0-9]+$ ]]; then
		echo "$ERRNOINT"
		promptBet
	elif [ "$REPLY" -lt "$MINBET" ] || [ "$REPLY" -gt "$MAXBET" ]; then
		echo "Sorry. $WELCOME3"
		promptBet
	elif [ "$REPLY" -gt "$MONEY" ]; then
		echo "Sorry, you only have \$$MONEY in chips!"
		promptBet
	elif [ $((REPLY%2)) -eq 1 ]; then
		echo "$ERRODD"
		promptBet
	else
		BET=$REPLY
		MONEY=$((MONEY - BET))
		echo "Your bet is \$$BET."
		echo -n "You have \$$MONEY remaining in your stack."; sleep 1
		echo "Good luck!"; sleep 1
	fi
}

# Deal a card to the player
dealPlayer () {
	PHAND+=("${DECK[-1]}")
	unset DECK[-1]
}

# Deal a card to the dealer
dealDealer () {
	DHAND+=("${DECK[-1]}")
	unset DECK[-1]
}

# Deals the initial four cards to start a hand
dealHand () {
	dealPlayer
	dealDealer
	dealPlayer
	dealDealer
}

# Show the cards on the table
showHand () {
	echo
	echo "Dealer's hand:"
	for i in "${DHAND[@]}"; do
		echo $i
	done
	echo
	echo "Your hand:"
	for i in "${PHAND[@]}"; do
		echo $i
	done
}

# Calculate the player's score
addPScore () {
	PSCORE=0
	for i in "${PHAND[@]}"; do
		if [[ $i =~ ^2 ]]; then PSCORE+=2
		elif [[ $i =~ ^3 ]]; then PSCORE+=3
		elif [[ $i =~ ^4 ]]; then PSCORE+=4
		elif [[ $i =~ ^5 ]]; then PSCORE+=5
		elif [[ $i =~ ^6 ]]; then PSCORE+=6
		elif [[ $i =~ ^7 ]]; then PSCORE+=7
		elif [[ $i =~ ^8 ]]; then PSCORE+=8
		elif [[ $i =~ ^9 ]]; then PSCORE+=9
		elif [[ $i =~ ^[1JQK] ]]; then PSCORE+=10
		else PSCORE+=11
		fi
	done
}

# Calculate the dealer's score
addDScore () {
	DSCORE=0
	for i in "${DHAND[@]}"; do
		if [[ $i =~ ^2 ]]; then DSCORE+=2
		elif [[ $i =~ ^3 ]]; then DSCORE+=3
		elif [[ $i =~ ^4 ]]; then DSCORE+=4
		elif [[ $i =~ ^5 ]]; then DSCORE+=5
		elif [[ $i =~ ^6 ]]; then DSCORE+=6
		elif [[ $i =~ ^7 ]]; then DSCORE+=7
		elif [[ $i =~ ^8 ]]; then DSCORE+=8
		elif [[ $i =~ ^9 ]]; then DSCORE+=9
		elif [[ $i =~ ^[1JQK] ]]; then DSCORE+=10
		else DSCORE+=11
		fi
	done
}

playerStand () {
	echo
	echo "Player stands with $PSCORE."
	echo
	PSTAND=1
}

# Stand, hit, double down, or split
promptChoice () {
	OPTIONS=("Stand" "Hit")
	if [ ${#PHAND[@]} -eq 2 ]; then
		OPTIONS+=("Double down")
		# Add option to split if cards match
	fi
	select opt in "${OPTIONS[@]}"; do
		case $opt in
			"Stand") playerStand; break;;
			"Hit") break;;
			"Double down") break;;
			"Split") break;;
			*) badChoice;;
		esac
		REPLY=
	done
}

# Prepare variables for the next hand
resetVars () {
	unset PHAND
	unset DHAND
	unset SDECK
	unset DECK
	PSTAND=0
	DSTAND=0
	PBUST=0
	DBUST=0
	BET=0
}
