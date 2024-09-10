#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi
#clear tables for new data
echo $($PSQL "TRUNCATE games,teams")

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
     #Get winner name
     WINNER_NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER';")
     #If winner name does not exist
     if [[ -z $WINNER_NAME ]]
     then
        #Insert winner name
        INSERT_WINNER_NAME_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")
        #If team name inserted successful
        if [[ $INSERT_WINNER_NAME_RESULT=='insert 0 1' ]]
        then
          #display message including team name
          echo "Inserted $WINNER into the teams table successfully"
        fi
      fi

      #Get the opponent name
      OPPONENT_NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT';")
      #If opponent name does not exist
      if [[ -z $OPPONENT_NAME ]]
      then
        #Insert opponent name
        INSERT_OPPONENT_NAME_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")
        #if entry was successful;
        if [[ $INSERT_OPPONENT_NAME_RESULT=='insert 0 1' ]]
        then 
          #display message containing the name of the entry
          echo "Inserted $OPPONENT successfully into the teams table"
        fi
      fi
      #GET the winner id
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
      #GET the opponent id
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';" )

      #Insert game into games table
      GAME_RESULT=$($PSQL "INSERT INTO games(year,round,winner_id,
      opponent_id,winner_goals,opponent_goals) 
      VALUES($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS);")
    #if game successful display appropriate message
    if [[ $GAME_RESULT=='insert 0 1' ]]
    then
      echo "$WINNER VS $OPPONENT game inserted sucessfully"
    fi

  fi

done
