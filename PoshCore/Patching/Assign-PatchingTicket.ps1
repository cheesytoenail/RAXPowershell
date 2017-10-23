function Assign-PatchingTicket {
    #Gather function parameters
    $TicketNumber = Read-Host -Prompt "Enter Ticket Number"
    $RackerName = Read-Host -Prompt "Enter Your Signature Name"
    Read-Host -Prompt "Add the patching instructions to your clipboard then press Enter"
    [array]$PatchingInstructions = (Get-Clipboard) -Replace "`"|\[|\]|`{|`}"
    $PatchingInstructions = $PatchingInstructions -join "\n"
$TicketUpdate = @"
Hi Team,

I will assign this ticket to our global maintenance team who will be in touch with you to arrange scheduling this maintenance work, please standby for a further update.

$RackerName
Windows Systems Administrator
Rackspace - The #1 managed cloud company
UK: 0800 032 1667 | Int +44 20 8734 4324
US: 1800 961 4454 | Int +1 210 312 4000
"@
    #Private Patching Instructions
    Add-CoreTicketUpdate -TicketNumber $TicketNumber -PrivateUpdate "$PatchingInstructions"
    #Public Update
    Add-CoreTicketUpdate -TicketNumber $TicketNumber -Text $TicketUpdate
    #Assign to Maintenance Queue
    Set-CoreTicket -Tickets $TicketNumber -SetQueueName "ER SysAd Maintenance Prep"
}