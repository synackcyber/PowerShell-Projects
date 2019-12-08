$choices = [System.Management.Automation.Host.ChoiceDescription[]] @("&Yes","&No")
while ( $true ) {

Write-Host "Let's Begin!"

Start-Sleep -Seconds 1

#Specify the internal subdomain for DNS alias
$alias = Read-Host -Prompt "Input subdomain ('xxxx' part only) DNS name for internal clients to resolve  ('xxxx'.company_domain.com)"

Start-Sleep -Seconds 1

#Specify the target DNS host
$targethost = Read-Host -Prompt "Input target DNS server  (external CNAME)"

Start-Sleep -Seconds 1

#cmdlet with funtions
Add-DnsServerResourceRecordCName -Name $alias -HostNameAlias $targethost -ZoneName "company_domain.com"

Start-Sleep -Seconds 1

$choice = $Host.UI.PromptForChoice("Repeat the script?","",$choices,0)
 if ( $choice -ne 0 )

 {
Write-Host "Request is being processed please wait!"

   #Set replication funtion
function Replicate-AllDomainController {
(Get-ADDomainController -Filter *).Name | Foreach-Object {repadmin /syncall $_ (Get-ADDomain).DistinguishedName /e /A | Out-Null}; Start-Sleep 10; Get-ADReplicationPartnerMetadata -Target "$env:userdnsdomain" -Scope Domain | Select-Object Server, LastReplicationSuccess
}

#Begin site wide replication process of DNS
Replicate-AllDomainController

Start-Sleep -Seconds 1

#Inform user
Write-Host "Your changes are being processed. Please allow up to 5 minutes for full replication across all sites."

Start-Sleep -Seconds 1

Write-Host "Thanks for playing! Run this script again to add additonal CNAME entries into the Your Comapny Name internal DNS"

Start-Sleep -Seconds 1

break
 }
}
