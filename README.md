# Demo project to implement trusted Agentforce actions, aka Private Actions

This repository contains an extension of [Coral Cloud Resorts from Trailhead](https://trailhead.salesforce.com/content/learn/projects/quick-start-build-your-first-agent-with-agentforce) to show concepts of securing Agentforce Service Agents and sample implementations.

See [Maintain Trust with Agentforce Actions](https://help.salesforce.com/s/articleView?language=en_US&id=service.service_agentforce_trusted_private_actions.htm&type=5) for more details.

# Installation

### Requirements

#### Environment

Complete [Quick Start: Build Your First Agent with Agentforce](https://trailhead.salesforce.com/content/learn/projects/quick-start-build-your-first-agent-with-agentforce) on Trailhead to create a Custom Agentforce Playground containing the Coral Cloud Resorts app including a Agentforce Service Agent and Experience Cloud.

For more details about Coral Cloud Resorts. see [The Coral Cloud Resorts app](https://github.com/trailheadapps/coral-cloud) from Trailhead Apps.

#### Additional Setup Steps

After you have successfully completed your Quick Start project, additional setup steps are required to get Sofia Rodriguez login credentials.

1. To create or update community users with standard profiles like _Customer Community Login User_, go to **Setup > Digital Experiences > Settings** and select `Allow using standard external profiles for self-registration, user creation, and login.` (reminder: security best practices recommend creating a custom profile).

1. Change users email address of Sofia Rodriguez - open **Setup > Users > Users** and change the email address from _noreply@example.com_ (or similar) to your personal email

1. Reset password for Sofia - note her users credentials (username and password)

# Basic Concepts

### Public Actions

Taking on behalf of anyone, regardless of identity, without authentication

Example:
Answer Questions with Knowledge action could be considered a public action if it’s grounded in public information such as return policies

### Private Actions

Require the requester’s identity to be confirmed through authentication or through the sharing of identifying information in a messaging session

# Example Implementation using Experience Cloud as IDP

The Coral Cloud Resorts CC Service Agent identifies customers like Sofia Rodriguez by her email address and membership number using the Flow action `Get Customer Details`.

This instruction shows how to change from user identification by email and membership number to identification by authenticated users.

In this example the user is directed to a portal page where they will authenticate as external user via a login screen. A screen flow _Agentforce Authenticator_ is shown and after completion it will update the MessagingSession record for the Agentforce session with the user's identity. It will not however generate an event in the Agentforce session so it is dependent on the user continuing the conversation in Agentforce, once authentication is complete.
![Example Implementation .](/images/service_agentforce_flow_chart.png)

## Use Case

- Topic **Experience Management**
- Actions like **Generate Personalized Schedule** or **Create Experience Session Booking** require a Contact record as input - they can be classified as Private Actions
- Instead of retrieving a contact by email and membership number, get the contact related to an authenticated user

## Topic Setup

Customize topic **Experience Management**

Replace this instruction (or optionally remove):

```
If the customer is not known, always ask for their email address and get their Contact record before running any other actions.`
```

With this:

```
If the customer is not known, call the action 'Identify Customer by Messaging Session'.`
```

## Get Customer Details

The default implementation of **Get Customer Details** is a flow that retrieves a Contact record by email and membership number.
![Get Customer Details V1](/images/get_customer_details_v1.png)

Replace this flow with a new version that retrieves the contact related to an authorized external user.

Check Authentication Status using the Custom AuthSessionId on Messaging Session

The Messaging Session needs to be linked with an authorized session (AuthSession).
The custom action `Identify Customer By Email` is replaced with a new action named `Identify Customer By Messaging Session`.
It checks if the Messaging Session has an Auth Session linked and if yes, it returns the linked Contact.
If the Auth Session is missing, it updates the Messaging Session with the AuthRequestTime and returns an external link as URL to an authentication form - passing the current Session Key as URL parameter.

This repository contains a custom flow implementation that can be added as a new Agent Action.
