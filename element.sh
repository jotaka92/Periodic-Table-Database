#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

ELEMENT() {

  if [[ -z $1 ]]
  then   
    echo "Please provide an element as an argument."
  else
    RESULT=$($PSQL "SELECT elements.atomic_number, elements.symbol, elements.name,
    types.type, properties.atomic_mass, properties.melting_point_celsius,
    properties.boiling_point_celsius FROM elements INNER JOIN properties ON elements.atomic_number
    = properties.atomic_number INNER JOIN types ON properties.type_id = types.type_id
    WHERE elements.atomic_number::text = '$1' OR elements.symbol = '$1' 
    OR elements.name = '$1'")

    if [[ -z $RESULT ]]
    then
      echo "I could not find that element in the database." 
    else
      echo "$RESULT" | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING BOILING
      do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      done
    fi
  fi
}

ELEMENT $1

