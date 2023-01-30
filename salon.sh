#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t -c"

echo -e "\n~~ Arsenal Match Day Salon ~~\n"

SALON_HOME() {

  DISPLAY_SERVICES() {

  SERVICES=$($PSQL "SELECT service_id, name FROM services")
  echo "$SERVICES" | while read SERVICE_ID BAR NAME
      do
        echo "$SERVICE_ID) $NAME"
      done



  }
  DISPLAY_SERVICES

  echo -e "\nHow would you like to show your support for the team?\n"
  read SERVICE_ID_SELECTED

  if [[ ! $SERVICE_ID_SELECTED =~ ^[1-6]+$ ]]
    then
      DISPLAY_SERVICES
    else
        SERVICE_CHOSEN=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
        echo -e "\nThank you for picking $SERVICE_ID_SELECTED"
        #Check whether a person is an existing customer
        echo -e "\nPlease confirm your telephone number?\n"
        read CUSTOMER_PHONE

        #Retreive customer information
        CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE' ")
        echo $CUSTOMER_NAME

        if [[ -z $CUSTOMER_NAME ]]
          then
            #Create a new account for that phone number
            echo -e "\nWhat is your name?\n"
            read CUSTOMER_NAME

            #Create a new customer record
            NEW_CUSTOMER_RECORD=$($PSQL "INSERT INTO customers(phone,name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
            echo $NEW_CUSTOMER_RECORD 

        fi

        #Prompt for the time of the appointment?
        echo -e "\nWhat time today would you like your appointment\n"
        read SERVICE_TIME

        #Get customer ID
        CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

        #Create the new appointment
        NEW_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id,time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

        echo -e "I have put you down for a $SERVICE_CHOSEN at $SERVICE_TIME, $CUSTOMER_NAME." 

  fi

}

SALON_HOME


