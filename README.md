# Demo project to implement trusted Agentforce actions, aka Private Actions

This repository contains a sample project to show concepts of securing Agentforce Service Agents and sample implementations.

See https://help.salesforce.com/s/articleView?language=en_US&id=service.service_agentforce_trusted_private_actions.htm&type=5 for more details.

## Public Actions

Taking on behalf of anyone, regardless of identity, without authentication

Example:
Answer Questions with Knowledge action could be considered a public action if it’s grounded in public information such as return policies

## Private Actions

Require the requester’s identity to be confirmed
through authentication or through the sharing of identifying information in a messaging session

## Exsample Implementation

In this example the user is directed to a portal page where they will authenticate to the side. This will update the MessagingSession record for the Agentforce session with the user's identity. It will not however generate an event in the Agentforce session so is dependent on the user continuing the conversation in Agentforce, once authentication is complete.
![Exsample Implementation .](/images/service_agentforce_flow_chart.png)

# Sample Implementation Using IDP

How to setup and configure secure Agentforce Service Agents

## Use Case

- Topic related to Case Management
- Answers “What is the status of my support case?”
- Custom Agent Actions using Flows
- Service Agent deployed via enhanced Messaging channels
- Deployed to an Experience site

## Topic Setup

Customize Standard Topic _CaseManagement_
