#!/bin/bash

source ./vars.bash
source ./cards.bash
source ./main.bash
source ./tet.bash

introduction
until ((PQUIT)); do # Until the player quits
	showMenu # Show the main menu
done
conclusion
