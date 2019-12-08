#Run this script on AzureAD Connect sync server only.

echo "You are currently logged into"
Write-Host $env:COMPUTERNAME -ForegroundColor green
#
Start-Sleep -Seconds 5
#
echo "Starting replication to ALL domain controllers. This can take up to 3 minutes..."
#
function Replicate-AllDomainController {
(Get-ADDomainController -Filter *).Name | Foreach-Object {repadmin /syncall $_ (Get-ADDomain).DistinguishedName /e /A | Out-Null}; Start-Sleep 10; Get-ADReplicationPartnerMetadata -Target "$env:userdnsdomain" -Scope Domain | Select-Object Server, LastReplicationSuccess
}
#
Start-Sleep -Seconds 5
#
Replicate-AllDomainController
#
echo "okay great! Now we will delta sync all changes to Azure..Please wait..."
#
Start-ADSyncSyncCycle -PolicyType Delta
#
Start-Sleep -Seconds 5
#
echo "Awesome! Sync is complete! Please allow up to 5 minutes for changes to reflect in Office365 Admin Portal"
