#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo -e "\nEnter your username:"

read USERNAME

USER_ID=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME';")

#check if username exists in db
if [[ -z $USER_ID ]]
then
#if it doesn't exist print welcome msg
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
  echo $($PSQL "INSERT INTO users(username) VALUES ('$USERNAME');")
#if it does exist print welcome msg with datapoints
else
  GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE user_id = $USER_ID")
  BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE user_id = $USER_ID")
  echo -e "\nWelcome back, '$USERNAME'! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
#generate random number
  RANDOM_NUMBER=
#print "guess the secret number"
#read user input 
#add to number of tries in table 
#if number is higher or lower print number
fi


