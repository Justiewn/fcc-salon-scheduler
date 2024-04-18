#!/bin/bash

PSQL='psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c'


SERVICES_RESULT=$($PSQL "SELECT service_id, name FROM services")
echo Please select a service below by entering a number:
echo "$SERVICES_RESULT" | sed 's/|/) /'

read SERVICE_ID_SELECTED
while [[ $SERVICE_ID_SELECTED > 3 ]]
do 
  echo "$SERVICES_RESULT" | sed 's/|/) /'
  read SERVICE_ID_SELECTED
done

echo Please enter your phone number:
read CUSTOMER_PHONE
PHONE_RESULT=$($PSQL "SELECT * FROM customers WHERE phone = '$CUSTOMER_PHONE'")
if [[ -z $PHONE_RESULT ]]
then
  echo Hello new customer, please enter your name:
  read CUSTOMER_NAME

  INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers ( phone, name ) 
                                  VALUES ( '$CUSTOMER_PHONE', '$CUSTOMER_NAME' ) ")

  echo Hi $CUSTOMER_NAME, welcome to the family! Please enter a time for your appointment:
else

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  echo Hi $CUSTOMER_NAME, please enter a time for your appointment:
fi

CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

read SERVICE_TIME
INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) 
                                    VALUES ( $CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME' )")

echo I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME.


