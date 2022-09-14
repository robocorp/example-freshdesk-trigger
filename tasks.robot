*** Settings ***
Documentation       Example that reads a work item payload from Freshdesk and updates the ticket.
Library       RPA.Robocorp.WorkItems
Library       FreshdeskLibrary
Library       RPA.Robocorp.Vault
Task Setup    Authorize Freshdesk


*** Tasks ***
Load and process Freshdesk payloads
    For Each Input Work Item    Read one Freshdesk payload

*** Keywords ***
Read one Freshdesk payload
    ${payload}=    Get Work Item Payload

    Log To Console    ${payload}

    # First update priority to Urgent
    ${ticket}=    FreshdeskLibrary.Update Ticket
    ...    ${payload}[freshdesk_webhook][ticket_id]
    ...    priority=${4}

    # Second, create a private note
    ${comment}=    Create Note
    ...    ${payload}[freshdesk_webhook][ticket_id]
    ...    Robocorp process has touched this ticket.
    ...    ${TRUE}

    # Third, create a public note that will trigger a reply to submitter
    ${comment}=    Create Note
    ...    ${payload}[freshdesk_webhook][ticket_id]
    ...    Robocorp process has done some create actions to your ticket and now updates you with all the fresh information.
    ...    ${FALSE}

Authorize Freshdesk
    Log To Console    Create Freshdesk Creds
    ${secrets}=    Get Secret    Freshdesk
    Auth With Apikey    ${secrets}[domain]    ${secrets}[apikey]