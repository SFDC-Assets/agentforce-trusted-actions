# Demo project to implement trusted Agentforce actions, aka Private Actions

This repository contains an extension of [Coral Cloud Resorts from Trailhead](https://trailhead.salesforce.com/content/learn/projects/quick-start-build-your-first-agent-with-agentforce) to show concepts of securing Agentforce Service Agents and sample implementations.

See [Maintain Trust with Agentforce Actions](https://help.salesforce.com/s/articleView?language=en_US&id=service.service_agentforce_trusted_private_actions.htm&type=5) for more details.

# Installation

### Requirements

#### Environment

Complete [Quick Start: Build Your First Agent with Agentforce](https://trailhead.salesforce.com/content/learn/projects/quick-start-build-your-first-agent-with-agentforce) on Trailhead to create a Custom Agentforce Playground containing the Coral Cloud Resorts app including Agentforce Service Agent and Experience Cloud.

For more details about Coral Cloud Resorts. see [The Coral Cloud Resorts app](https://github.com/trailheadapps/coral-cloud) from Trailhead Apps.

#### Additional Setup Steps - reset external user credentials

After you have successfully completed your Quick Start project, additional setup steps are required to get Sofia Rodriguez login credentials.

1. To create or update community users with standard profiles like _Customer Community Login User_, go to **Setup > Digital Experiences > Settings** and select `Allow using standard external profiles for self-registration, user creation, and login.` (reminder: security best practices recommend creating a custom profile).

1. Change users email address of Sofia Rodriguez - open **Setup > Users > Users** and change the email address from _noreply@example.com_ (or similar) to your personal email

1. Reset password for Sofia - note her users credentials (username and password)

1. Make sure you have enabled **Allow guest users to access public APIs.** in **Workspaces > Administration > Preferences**

#### Additional Setup Steps - metadata deployment

1. Clone this repository:

   ```bash
   git clone https://github.com/SFDC-Assets/agentforce-trusted-actions
   cd agentforce-trusted-actions
   ```

1. Authorize your org with the Salesforce CLI, set it as the default org for this project and save an alias (`coral-cloud` in the command below).

   ```bash
   sf org login web -s -a coral-cloud
   ```

1. Deploy the metadata.

   ```bash
   sf project deploy start -d force-app
   ```

1. Assign the Trusted Agentforce Actions permission set to the default user.

   ```bash
   sf org assign permset -n Trusted_Agentforce_Actions
   ```

# Basic Concepts

### Public Actions

Taking on behalf of anyone, regardless of identity, without authentication

Example:
Answer Questions with Knowledge action could be considered a public action if it’s grounded in public information such as return policies

### Private Actions

Require the requester’s identity to be confirmed through authentication or through the sharing of identifying information in a messaging session

# Example Implementation using Experience Cloud as IDP

The Coral Cloud Resorts CC Service Agent identifies customers like _Sofia Rodriguez_ by her email address and membership number using the Flow action `Get Customer Details`.

This instruction shows how to change from user identification by email and membership number to identification by authenticated users.

In this example the user is directed to a portal page where they will authenticate as external user via a login screen. A screen flow _Agentforce Authenticator_ is shown and after completion it will update the MessagingSession record for the Agentforce session with the user's identity. It will not however generate an event in the Agentforce session so it is dependent on the user continuing the conversation in Agentforce, once authentication is complete.
![Example Implementation](/images/service_agentforce_flow_chart.png)

## Use Case

- Topic **Experience Management**
- Actions like **Generate Personalized Schedule** or **Create Experience Session Booking** require a Contact record as input - they can be classified as Private Actions
- Instead of retrieving a contact by email and membership number, get the contact related to an authenticated user

## Topic Setup

Customize topic **Experience Management** and replace the following two instructions:

| Old Action Instruction                                                                                                                                                                                                                                                                                                                                                                                           | New Action Instruction                                                                                                                                                                                                                                                                                                                                                                                               |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 2nd Instruction: `If the customer is not known, you must always ask for their email address and their membership number to get their Contact record by running the action 'Get Customer Details' before running any other actions.`                                                                                                                                                                              | `If the customer is not known, call the action 'Get Customer Details by Messaging Session' to retrieve a Salesforce Contact record. If the customer confirms that the authentication is done, retry the action to retrieve the Contact record.`                                                                                                                                                                      |
| 5th Instruction: `If asked to book, use the action 'Create Booking'. The Contact__c is the contact ID from the 'Get Customer Details'. The Session__c is the ID of the session from the action 'Get Sessions'. If multiple sessions are present, ask to select one of the sessions and use that Session as the ID for the Session__c. Prompt for the Number of Guests and use that for the Number_of_Guests__c.` | `If asked to book, use the action 'Create Booking'. The Contact__c is the contact ID from the 'Get Customer Details by Messaging Session'. The Session__c is the ID of the session from the action 'Get Sessions'. If multiple sessions are present, ask to select one of the sessions and use that Session as the ID for the Session__c. Prompt for the Number of Guests and use that for the Number_of_Guests__c.` |
| 6th Instruction: `If asked to recommend experiences that a user might be interested in, use the 'Generate Personalized Schedule' Action to generate a schedule based on a contacts interests. Use the contact record from 'Get Customer Details' and pass it into the Contact input.`                                                                                                                            | `If asked to recommend experiences that a user might be interested in, use the 'Generate Personalized Schedule' Action to generate a schedule based on a contacts interests. Use the contact record from 'Get Customer Details by Messaging Session' and pass it into the Contact input.`                                                                                                                            |

## Get Customer Details

The default implementation of **Get Customer Details** is a flow that retrieves a Contact record by email and membership number.
![Get Customer Details](/images/get_customer_details.png)

This project adds a new flow **Get Customer Details by Messaging Session** that retrieves the contact related to an authorized external user.
![Get Customer Details by Messaging Session](/images/get_customer_details_by_messaging_session.png)

#### Flow Details

The flow checks if the Messaging Session has an Auth Session linked and if yes, it returns the linked Contact.
If the Auth Session is missing, it updates the Messaging Session with the AuthRequestTime and returns an external link as URL to an authentication form - passing the current Session Key as URL parameter.

> [!IMPORTANT]
> Please modify the flow constant `SITE_URL` and set your URL from your org (like `https://orgfarm-60873dacf4-dev-ed.develop.my.site.com/coralcloud`)

#### Add new Agent Action

Deactivate your CC Service Agent and remove `Get Customer Details` from the topic.
(Hint: Use Activate button to confirm the removal of the action if you have trouble with the Save option).

Add a new flow action using `Get Customer Details by Messaging Session` with Input `messagingSessionId` marked as **Require Input** and Outputs `authenticationURL`, `contact` and `status` marked as **Show in conversation**

The new action will show a URL link to a login protected page on your Experience Cloud.
![Agent Authentication URL](/images/authenticate.png)

## Agentforce Authenticator

This project contains a new screen flow **Authenticate Agentforce Service Agent** that is used to retrieve contact details from an authorized user.
The flow will be added to your Experience Cloud using Builder with a new login-protected custom page and a screen flow component.

![Authenticate Agentforce Service Agent](/images/authenticate_agentforce_service_agent.png)

In **Experience Builder** add a new **Standard Page > New Blank Page** and name it `AgentAuthenticator`. Set **Page Access** to **Requires Login**.

Add a flow component to the new page and change the settings to Flow = `Authenticate Agentforce Service Agent` and sessionKey = `{!sessionKey}`

![AgentAuthenticator settings](/images/agent_authenticator.png)

Click Publish in the upper right corner.

# View the Agent as a Customer (Sofia Rodriguez)

- `Can you let me know about the Underground Cave Exploration?`
- `Show me available sessions for tomorrow`
- `Book two seats`

When the agent tries to call a Private Action (with a Contact record required), it shows the URL to the login protected Agent Authenticator page. Once the user (Sofia) has successfully authenticated, the agent conversation can continue. This time the Contact will be retrieved because the Messaging Session has been updated.

![View the Agent as a Customer](/images/view_agent_as_customer.png)
