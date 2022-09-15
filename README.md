# Triggering Robocorp processes from Freshdesk

[Freshdesk's](https://freshdesk.com/) hugely popular customer service platform can be easily extended with the use of RPA robots. Robocorp's [Control Room API](https://robocorp.com/docs/control-room/apis-and-webhooks) allows triggering of the automated processes in various scenarios. This example demonstrates the required configuration in the [Control Room](https://cloud.robocorp.com/) and in Freshdesk to trigger a process based on various Freshdesk ticket actions. Example also includes a small robot that takes in the payload from Freshdesk, and demonstrates how to update priority and add notes to the ticket.

## What you'll learn with this reference architecture

- Configuring Freshdesk automation to trigger a process execution in Robocorp
- Using [python-freshdesk](https://pypi.org/project/python-freshdesk/) package to manipulate Freshdesk tickets in the robot

## Set up the API key in Control Room

First create an API key in Control Room (unless you have one already made). It's found under API tab in your workspace. To trigger a process, you only need one checkbox selected as shown.

![image](https://user-images.githubusercontent.com/40179958/189671765-52fa1d20-d753-4d3a-b9d9-42c57ae6675d.png)

After that, the easiest way to find the rest of the details is by navigating to your process that should be triggered, and click `API Helper` from the top right corner of the page. It will open a sidebar that shows you all the relevant details you'll need to set things up in Freshdesk. Choose "Start process with a single work item payload" from the first dropdown, and then make sure you have the correct process and API key chosen. Leave this page open, and continue with Freshdesk.

![FireShot Capture 181 - Solution Demos (STABLE) · Process - cloud robocorp com](https://user-images.githubusercontent.com/40179958/189673841-dc635abd-e32d-4dc4-8855-4b07a6a1608b.png)

## Configuring the automation in Freshdesk

If you don't have your Freshdesk instance, you can create a free demo [here](https://freshdesk.com/signup) that is valid for 21 days.

To create automation rules, navigate to `Admin` > `Workflows` > `Automations` and hit "Create a rule".

![image](https://user-images.githubusercontent.com/40179958/189669353-6ab75adc-936e-416a-9b9b-813a53df35cd.png)

First you'll choose how the triggering happens, having three options:
- *Ticket creation* - When a new ticket is created in Freshdesk
- *Time triggers* - Scheduled triggers e.g. once every day. Can be used for various maintenance tasks
- *Ticket updates* - When details like priority or status of a ticket changes

![image](https://user-images.githubusercontent.com/40179958/189669714-6752f6b4-0c19-454f-b692-a73c794c50eb.png)

Next create the necessary filters under which conditions the triggering will happen. As an example in the screenshot, we have chosen the triggering to happen only when the ticket is created with a status `Open`.

![image](https://user-images.githubusercontent.com/40179958/189670138-40cbd13a-5496-4b6f-9bc0-56fccc6f83fc.png)

Now it's time to set up the connection to Robocorp Control Room. Choose `Trigger webhook` from the first dropdown. Then choose POST as the Request Type.

For the URL, jump back to the Control Room API Helper, and copy paste the full URL all the way to the last question mark, but without quotes. It will look something like this (with Workspace ID and Process ID replaced with real values):

```
https://api.eu1.robocorp.com/process-v1/workspaces/WORKSPACE_ID/processes/PROCESS_ID/runs?
```

Then choose `Add custom headers` and configure the Authorization string. You can copy paste it mostly from the API Helper, but notice that you'll need to add curly braces and quotes to make it valid JSON. An example of a correctly formed header is here (worry not, I have already deleted the API key used in the example):

```json
{"Authorization": "RC-WSKEY 2IC7rM9blWpfP85YHgnBOyWpGm5YsWOT9YknpZPbGXhTV4v5gNhyx1RXKFYI0d9zXeSvP3WNtgUn2cHrNAObuyewxOAgiajjq0gSBgmszra7djX8ohyCZTVlA4O9fnVO"}
```

Then choose JSON for Encoding, and Simple for Content type. Last, you can choose the ticket values you want the process to receive as inputs. The values chosen here will end up in your input work item and will look like this:

```json
{
  "freshdesk_webhook": {
    "ticket_id": 4,
    "ticket_subject": "adsdas asdasd asd asd",
    "ticket_contact_email": "tommi@leoppi.com"
  }
}
```

![image](https://user-images.githubusercontent.com/40179958/189670922-a5f7a342-5027-4f59-aed0-8ff7a9dd7dde.png)

After saving you are all done!

## Writing data back to Freshdesk

The robot example included will take the payload sent by Freshdesk automation and write data back to the ticket. In real life, you would naturally have more tasks in the robot code. For example you could perform NLP tasks to the ticket content using [Google API](https://robocorp.com/docs/libraries/rpa-framework/rpa-cloud-google/keywords#analyze-sentiment), or fetch additional data from legacy systems using [web](https://robocorp.com/docs/development-guide/browser) or [desktop](https://robocorp.com/docs/development-guide/desktop) automation.

In order to use the robot, you'll need to configure a Vault called `Freshdesk` that contains two items: `apikey` that is found under your Freshdesk profile and `domain` that looks like `yourownsubdomain.freshdesk.com`.

![image](https://user-images.githubusercontent.com/40179958/190337555-599ced77-1b2a-4ac5-b81f-752cfc25f2ca.png)

> NOTE! Api key determines in who's name robot is manipulating the tickets. The best practise is to create a separate user for the robot.

Then add the robot to control room, create a process and use that process in your Freshdesk automation. Voila, Robocorp RPA and Freshdesk now talks two ways!
