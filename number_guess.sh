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
  RANDOM_NUMBER=$(( RANDOM % 1000 + 1 ))
#print "guess the secret number"
  echo -e "\nGuess the secret number between 1 and 1000:"
  #read user input 
  read GUESS
  if ! [[ $GUESS =~ ^[0-9]+$ ]]
  then
    echo -e "\nThat is not an integer, guess again:"
  else
    while [[ $GUESS -ne $RANDOM_NUMBER ]]
    do
      if [[ $GUESS -gt $RANDOM_NUMBER ]]
      then
        echo -e "\nIt's lower than that, guess again:"
      #if it's inferior print something and viceversa
        read GUESS
      elif [[ $GUESS -lt $RANDOM_NUMBER ]]
      then
        echo -e "\nIt's higher than that, guess again:"
      #add to number of tries in table 
        read GUESS
      fi
    done
      #congratulate
      echo "woohoo"
      #conclude game
      #calculate best_game
    fi
  fi
fi


