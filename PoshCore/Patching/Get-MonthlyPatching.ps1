######################################################
#SUBJECT BEGIN
######################################################
##Subject Prompt
Clear-Host
Write-Output "Enter the ticket subject to search"
Write-Output "e.g. Proactive Patching - June 2017 (Manual)"
##Subject Input/Validation
do {
    try {
        $sTest = $true
        $Subject = Read-Host -Prompt "Enter Search Criteria"
    } ##End Try
    catch {
        $stest = $false
    } ##End Catch
} until (($Subject -ne $null) -and $stest)
##Search Warning
Write-Output "Searching..."
######################################################
#SUBJECT END
######################################################

######################################################
#TICKET SEARCH BEGIN
######################################################
##Ticket Search
$Tickets = Find-CoreTicket -Subjects "$Subject" -Attributes Misc -State All
######################################################
#TICKET SEARCH END
######################################################

######################################################
#QUEUE BEGIN
######################################################
##While Loop
do {
    ##Queue Prompt
    Clear-Host
    Write-Output "1. INTL Windows"
    Write-Output "2. Intensive All Teams"
    Write-Output "3. Account Management - Enterprise"
    ##Queue Input/Validation
    do {
        try {
            $qTest = $true
            $Queue = Read-Host -Prompt "Select the queue to pick from"
        } ##End Try
        catch {
            $qTest = $false
        } ##End Catch
    } until (($Queue -ge 1 -and $Queue -le 3) -and $qTest)
    ##Filter Queue
    switch ($Queue) {
        1 {$Result = $Tickets | Where-Object {$_.queue_id -eq 683} | Select-Object  @{Name = "Ticket Number"; Expression = {$_."number"}},
                                                                                    @{Name = "Ticket Owner"; Expression = {$_."assignee_name"}},
                                                                                    @{Name = "Status"; Expression = {$_."status_name"}},
                                                                                    @{Name = "Team"; Expression = {$_."support_team"}}
        }
        2 {$Result = $Tickets | Where-Object {$_.queue_id -eq 26} | Select-Object   @{Name = "Ticket Number"; Expression = {$_."number"}},
                                                                                    @{Name = "Ticket Owner"; Expression = {$_."assignee_name"}},
                                                                                    @{Name = "Status"; Expression = {$_."status_name"}},
                                                                                    @{Name = "Team"; Expression = {$_."support_team"}}
        }
        3 {$Result = $Tickets | Where-Object {$_.queue_id -eq 389} | Select-Object  @{Name = "Ticket Number"; Expression = {$_."number"}},
                                                                                    @{Name = "Ticket Owner"; Expression = {$_."assignee_name"}},
                                                                                    @{Name = "Status"; Expression = {$_."status_name"}},
                                                                                    @{Name = "Team"; Expression = {$_."support_team"}}
        }
        Default {}
    }
    ##Output
    Clear-Host
    $Result | Out-GridView -Title "Tickets Found"
    ##Repeat
    $Repeat = Read-Host -Prompt "Select a different queue? (Y/N)"
    ##Repeat Switch if required
} while ($Repeat -notlike "N")
######################################################
#QUEUE END
######################################################