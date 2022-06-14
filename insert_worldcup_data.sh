#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNERGOALS OPPONENTGOALS
do
  if [[ $YEAR != 'year' ]] && [[ $ROUND != 'round' ]] && [[ $WINNER != 'winner' ]] && [[ $OPPONENT != 'opponent' ]] && [[ $WINNERGOALS != 'winner_goals' ]] && [[ $OPPONENTGOALS != 'opponent_goals' ]]
    then
    # get team_id
    OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    # if not found
    if [[ -z $OPP_ID ]]
      then
      # insert team 
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
        then
        echo Inserted into teams: $OPPONENT
      fi
    fi
    # if not found
    if [[ -z $WIN_ID ]]
      then
      # insert team
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
        then
        echo Inserted into teams: $WINNER
      fi
    fi
  fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNERGOALS OPPONENTGOALS
do
  if [[ $YEAR != 'year' ]] && [[ $ROUND != 'round' ]] && [[ $WINNER != 'winner' ]] && [[ $OPPONENT != 'opponent' ]] && [[ $WINNERGOALS != 'winner_goals' ]] && [[ $OPPONENTGOALS != 'opponent_goals' ]]
    then
    # get winner id
    WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    # get opponent id
    OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # insert year, round, winner_id, opponent_id, winner_goals, opponent_goals
    INSERT_DATA_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WIN_ID, $OPP_ID, $WINNERGOALS, $OPPONENTGOALS)")
    if [[ $INSERT_DATA_RESULT == "INSERT 0 1" ]]
      then
      echo Inserted into games: $YEAR, $ROUND, $WINNER, $OPPONENT, $WINNERGOALS, $OPPONENTGOALS
    fi
  fi
done
