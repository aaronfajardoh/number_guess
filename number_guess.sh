#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo -e "\nEnter your username:"
read USERNAME

# Sanitize single quotes
USERNAME_ESCAPED=${USERNAME//\'/\'\'}

# Try to fetch user
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME_ESCAPED';")

if [[ -z $USER_ID ]]; then
  # First time
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
  $PSQL "INSERT INTO users(username) VALUES('$USERNAME_ESCAPED');"
  # Now fetch the new USER_ID, and set defaults
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME_ESCAPED';")
  GAMES_PLAYED=0
  BEST_GAME=null
else
  # Returning user: no extra quotes around $USERNAME!
  GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE user_id=$USER_ID;")
  BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE user_id=$USER_ID;")
  echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# --- play one game ---
RANDOM_NUMBER=$(( RANDOM % 1000 + 1 ))
echo -e "\nGuess the secret number between 1 and 1000:"
read GUESS
NUM_GUESSES=1

# keep guessing until correct
while ! [[ $GUESS =~ ^[0-9]+$ ]]; do
  echo -e "\nThat is not an integer, guess again:"
  read GUESS
done

while [[ $GUESS -ne $RANDOM_NUMBER ]]; do
  if [[ $GUESS -gt $RANDOM_NUMBER ]]; then
    echo -e "\nIt's lower than that, guess again:"
  else
    echo -e "\nIt's higher than that, guess again:"
  fi
  read GUESS
  ((NUM_GUESSES++))
done

# user guessed it
echo -e "\nYou guessed it in $NUM_GUESSES tries. The secret number was $RANDOM_NUMBER. Nice job!"

# update stats
$PSQL "UPDATE users SET games_played = games_played + 1 WHERE user_id = $USER_ID;"
$PSQL "UPDATE users SET best_game = $NUM_GUESSES
       WHERE user_id = $USER_ID
         AND (best_game IS NULL OR best_game > $NUM_GUESSES);"
