#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

ARG=$1

print_element() {
    PE_TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number='$1'")
    PE_TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$PE_TYPE_ID")
    PE_ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number='$1'")
    PE_MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number='$1'")
    PE_BOIL_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number='$1'")
    echo "The element with atomic number $1 is $2 ($3). It's a $PE_TYPE, with a mass of $PE_ATOMIC_MASS amu. $2 has a melting point of $PE_MELTING_POINT celsius and a boiling point of $PE_BOIL_POINT celsius."
}

  if [[ $ARG ]]
  then
    if [[ $ARG =~ [0-9] ]]
    then
      # arg = atomic number
      ATOMIC_NR=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number='$ARG'")
      if [[ -z $ATOMIC_NR ]]
      then
        echo I could not find that element in the database.
      else
        AN_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number='$ARG'")
        AN_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number='$ARG'")
        print_element $ATOMIC_NR $AN_NAME $AN_SYMBOL
      fi
    else
      # check if arg = symbol
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol='$ARG'")
      # arg is not symbol
      if [[ -z $SYMBOL ]]
      then 
        # check if arg = name
        NAME=$($PSQL "SELECT name FROM elements WHERE name='$ARG'")
        # arg is not name
        if [[ -z $NAME ]]
        then
          echo I could not find that element in the database.
        else
          # arg = name
          NAME_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name='$ARG'")
          NAME_ATOMIC_NR=$($PSQL "SELECT atomic_number FROM elements WHERE name='$ARG'")
          print_element $NAME_ATOMIC_NR $NAME $NAME_SYMBOL
        fi
      else
      # arg = symbol
        SYMBOL_ATOMIC_NR=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$ARG'")
        SYMBOL_NAME=$($PSQL "SELECT name FROM elements WHERE symbol='$ARG'")
        print_element $SYMBOL_ATOMIC_NR $SYMBOL_NAME $SYMBOL
      fi
    fi

  else
    # no argument
    echo Please provide an element as an argument.
  fi

