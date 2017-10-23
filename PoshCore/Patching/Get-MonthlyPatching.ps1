function Get-MonthlyPatching {
    ######################################################
    #MODULE CHECK BEGIN
    ######################################################
    ##Test for PoshCore Module
    Clear-Host
    $ModuleCheck = Get-Module -Name "PoshCore"
    if (!$ModuleCheck) {
        Write-Output "PoshCore Not Installed - See https://rax.io/PoshCore"
        break
    }
    ######################################################
    #MODULE CHECK END
    ######################################################

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
            Write-Output "Failed Subject Entry See Error Below"
            throw $_
        } ##End Catch
    } until (($Subject -ne $null) -and $sTest)
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
    ##Do Loop
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
                Write-Output "Failed Queue Selection See Error Below"
                throw $_
            } ##End Catch
        } until (($Queue -ge 1 -and $Queue -le 3) -and $qTest) ##End Nested Do
        ##Filter Queue
        switch ($Queue) {
            1 {
                $QueueID = 683
            }
            2 {
                $QueueID = 26
            }
            3 {
                $QueueID = 389
            }
        } ## End Switch
        ##Results
        $Result = $Tickets | Where-Object {$_.queue_id -eq $QueueID} | Select-Object    @{Name = "Ticket Number"; Expression = {$_."number"}},
                                                                                        @{Name = "Ticket Owner"; Expression = {$_."assignee_name"}},
                                                                                        @{Name = "Status"; Expression = {$_."status_name"}},
                                                                                        @{Name = "Team"; Expression = {$_."support_team"}}
        ##Output
        Clear-Host
        $Selections = $Result | Out-GridView -Title "Tickets Found" -PassThru
        $Selections
        #Assign Tickets
        Clear-Host
        $SSOs = @()
        $Assign = Read-Host -Prompt "Assign Selected Tickets? (Y/N)"
        if ($Assign = "Y") {
            do {
                try {
                    $SSOs += (Read-Host -Prompt "Enter Racker SSOs").Split(',').Trim()
                }
                catch {
                    Write-Output "Failed to assign rackers"
                }
            }
            foreach ($Selection in $Selections) {
                $RandomSSO = $SSOs | Get-Random
                Set-CoreTicket -Tickets $Selection."Ticket Number" -SetAsigneeSso $RandomSSO
            }
        }

        ##Repeat
        $Repeat = Read-Host -Prompt "Select a different queue? (Y/N)"

        ##Repeat Switch if required
    } while ($Repeat -notlike "N") ##End Do Loop
    ######################################################
    #QUEUE END
    ######################################################
}