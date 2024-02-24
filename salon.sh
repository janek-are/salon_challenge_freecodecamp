#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ Salon appointment scheduler ~~~~~\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo "What kind of service do you want to schedule?" 
  MENU_ITEMS=$($PSQL "select service_id, name from services order by service_id")
  echo  "$MENU_ITEMS" | while read SERVICE_ID BAR SERVICE_NAME
  do 
  echo "$SERVICE_ID) $SERVICE_NAME"
  done
  
  echo -e "Which service do you require?"
  read SERVICE_ID_SELECTED

  if [[ ! $SERVICE_ID_SELECTED =~ [0-5] ]]
    then
      MAIN_MENU "That is not a valid service number."
	else 
	SCHEDULE
	fi
}

SCHEDULE() {
#get client number
echo -e "\nWhat is your phone number?"
read CUSTOMER_PHONE 
CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")
#if client doesn't exist
if [[ -z $CUSTOMER_NAME ]]
then 
# get new client's name
echo -e "\n What's your name?"
read CUSTOMER_NAME 
#insert new client
INSERT_CUSTOMER_RESULT=$($PSQL "insert into customers(name, phone) values ('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
fi 

# get customer ID
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

#insert service type and time
SERVICE_NAME=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED")
echo -e "\nWhen do you want to schedule your $SERVICE_NAME?"
read SERVICE_TIME

INSERT_APPOINTMENT_RESULT=$($PSQL "insert into appointments(customer_id, service_id, time) values($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')") 

echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU