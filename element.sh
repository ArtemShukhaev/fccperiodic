#!/bin/bash

PSQL="psql -X -U freecodecamp -d periodic_table --tuples-only -c"

ELEMENT() {
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    DATA=$($PSQL "select * from properties left join elements as e using(atomic_number) left join types using(type_id) where e.atomic_number=$1")
    echo "$DATA" | while read ID BAR NUMBER BAR MASS BAR MELT BAR BOIL BAR SYMBOL BAR NAME BAR TYPE
    do
      echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    done
  else
    DATA=$($PSQL "select * from properties left join elements as e using(atomic_number) left join types using(type_id) where e.symbol='$1' or e.name='$1'")
    echo "$DATA" | while read ID BAR NUMBER BAR MASS BAR MELT BAR BOIL BAR SYMBOL BAR NAME BAR TYPE
    do
      echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    done
  fi
}

if [[ $1 ]]
then 
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    RES=$($PSQL "select * from elements where atomic_number=$1")
    if [[ -z $RES ]]
    then
      echo "I could not find that element in the database."
    else
      ELEMENT $1
    fi
  else
    RES=$($PSQL "select * from elements where symbol='$1' or name='$1'")
    if [[ -z $RES ]]
    then
      echo "I could not find that element in the database."
    else
      ELEMENT $1
    fi
  fi
else
  echo "Please provide an element as an argument."
fi
