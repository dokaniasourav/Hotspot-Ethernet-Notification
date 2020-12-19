# Hotspot-Ethernet-Notification

## The network setter will perform the following task:
1. Set network proxy in the evening 7 pm and morning 10 am (Only if required proxy is not set).
1. Eable / Disable Network proxy accordingly when the ethernet is connected/removed.
1. Start hosted network if not already started.
1. Display Notification for all the tasks performed.


## Required:
1. Go to task scheduler and on the RHS select import task.
1. Select the xml file provided here.
1. put the .ps1 files in the documents folder.
1. set other paths like for putty.
1. Enjoy :)

Updates are made constantly to better this application. This task runs at a very high priority(value = 3) as compared to normal scheduled tasks which run at the lowest prioriy(value = 7). Normal priority is 6 or 5.
