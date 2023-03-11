# Callout to the Google Translate API via Invocable Apex
Invocable Apex that can be called from a Flow to detect and translate text using the Google Translate API

## Overview
This is a simple Apex class that sends an HTTP request to the Google Cloud Translation API that can be found here: https://cloud.google.com/translate/docs/reference/rest/v2/translate

This was created to address a repeated problem I've seen in my time consulting in the public sector -- when serving a diverse user base, as is common in the public sector, often times data entered by external users is entered in a language that is not readable by the organization's internal users.

This bulk of this class is an invokable method that is designed to be called from an asynchronous path of a record triggered flow, for easy configuration and implementation by Salesforce admins. See the below image for a basic example. 

![Screen Shot 2023-03-10 at 6 59 58 PM](https://user-images.githubusercontent.com/43337733/224455647-05fd0840-006b-4536-802b-db3c78218bcc.png) 

Please note, if you do not want to call this method from an asynchronous path, you will need to add an @Future annotation to the translate method, and perform an update to your desired field within the method itself.

## Security
This class uses a Google API Service Account for authentication. Christian Szandor Knapp has an excellent tutorial here: https://www.salesforceben.com/google-api-and-service-accounts-get-up-and-running-in-30-minutes/

Please note that in TranslateCallout.cls there are some variables that should instead be stored in custom metadata for production use.
