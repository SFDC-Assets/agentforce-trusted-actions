# Demo project to implement trusted Agentforce actions, aka Private Actions

This repository contains a sample project to show concepts of securing Agentforce Service Agents and sample implementations.

See https://help.salesforce.com/s/articleView?language=en_US&id=service.service_agentforce_trusted_private_actions.htm&type=5 for more details.

# Installation

### Requirements

#### Environment

Install [The Coral Cloud Resorts app](https://github.com/trailheadapps/coral-cloud) from Trailhead Apps.
It contains the required licenses and features:

- Data Cloud
- Agents
- Prompt Builder field generation templates
- Einstein for Sales (for Prompt Builder sales emails)

<div>
    <img src="https://res.cloudinary.com/hy4kyit2a/f_auto,fl_lossy,q_70,w_50/learn/projects/quick-start-explore-the-coral-cloud-sample-app/1a059541a60d078109227d8f3a83404a_badge.png" align="left" alt="Trailhead Badge"/>
    Obtain an Org with these features and learn more about the app with the <a href="https://trailhead.salesforce.com/content/learn/projects/quick-start-explore-the-coral-cloud-sample-app">Quick Start: Explore the Coral Cloud Sample App</a> Trailhead badge or by watching this <a href="https://www.youtube.com/watch?v=m1ZxPgwOHOs">short presentation video<a>.
    <br/>
    <br/>
</div>

> [!IMPORTANT]
> Start from a brand-new environment to avoid conflicts with previous work you may have done.

## Public Actions

Taking on behalf of anyone, regardless of identity, without authentication

Example:
Answer Questions with Knowledge action could be considered a public action if it’s grounded in public information such as return policies

## Private Actions

Require the requester’s identity to be confirmed
through authentication or through the sharing of identifying information in a messaging session

## Example Implementation

In this example the user is directed to a portal page where they will authenticate to the side. This will update the MessagingSession record for the Agentforce session with the user's identity. It will not however generate an event in the Agentforce session so is dependent on the user continuing the conversation in Agentforce, once authentication is complete.
![Example Implementation .](/images/service_agentforce_flow_chart.png)

# Example Implementation Using IDP

How to setup and configure secure Agentforce Service Agents

## Use Case

- Topic related to Case Management
- Answers “What is the status of my support case?”
- Custom Agent Actions using Flows
- Service Agent deployed via enhanced Messaging channels
- Deployed to an Experience site

## Topic Setup

Customize Standard Topic _CaseManagement_

Replace this instruction (or optionally remove):

`If the customer is not known, always ask for their email address and get their Contact record before running any other actions.`

With this:

`If the customer is not known, call the action 'Identify Customer by Messaging Session'.`

## Identify Customer By Messaging Session

Check Authentication Status using the Custom AuthSessionId on Messaging Session

The Messaging Session needs to be linked with an authorized session (AuthSession).
The custom action `Identify Customer By Email` is replaced with a new action named `Identify Customer By Messaging Session`.
It checks if the Messaging Session has an Auth Session linked and if yes, it returns the linked Contact.
If the Auth Session is missing, it updates the Messaging Session with the AuthRequestTime and returns an external link as URL to an authentication form - passing the current Session Key as URL parameter.

This repository contains a custom flow implementation that can be added as a new Agent Action.
