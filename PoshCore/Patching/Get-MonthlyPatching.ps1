##Subject Prompt
Clear-Host
Write-Output "Enter the ticket subject to search"
Write-Output "e.g. Proactive Patching - June 2017 (Manual)"
$Subject = Read-Host -Prompt "Enter Search Criteria"
##Search Warning
Write-Output "Searching..."
##Ticket Search
$Tickets = Find-CoreTicket -Subjects "$Subject" -Attributes Misc -State All
##While Loop
do {
    ##Queue Prompt
    Clear-Host
    Write-Output "1. INTL Windows"
    Write-Output "2. Intensive All Teams"
    Write-Output "3. Account Management - Enterprise"
    $Queue = Read-Host -Prompt "Select the queue to pick from"

    ##Filter Queue
    switch ($Queue) {
        1 {$Result = $Tickets | Where-Object {$_.queue_id -eq 683} | Select-Object number, assignee_name, status_name, support_team}
        2 {$Result = $Tickets | Where-Object {$_.queue_id -eq 26} | Select-Object number, assignee_name, status_name, support_team}
        3 {$Result = $Tickets | Where-Object {$_.queue_id -eq 389} | Select-Object number, assignee_name, status_name, support_team}
        Default {}
    }
    ##Output
    Clear-Host
    $Result | Out-GridView
    ##Repeat
    $Repeat = Read-Host -Prompt "Select a different queue? (Y/N)"
##Repeat Switch if required
} while ($Repeat -notlike "N")