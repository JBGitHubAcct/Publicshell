# Install the Azure PowerShell module if not already installed
# Install-Module -Name Az

# Connect to Azure
Connect-AzAccount

# Set the Azure subscription
$subscriptionId = "651739f1-25e4-499f-a393-6fe3a9692f38"
Set-AzContext -SubscriptionId $subscriptionId

# Get all DNS zones in the subscription
$dnsZones = Get-AzDnsZone

# Define the output CSV file path
$outputFile = "c:\temp\dns_zones.csv"

# Create an array to store DNS record objects
$recordObjects = @()

# Iterate through each DNS zone
foreach ($zone in $dnsZones) {
    $zoneName = $zone.Name

    # Get all DNS records for the current zone
    $records = Get-AzDnsRecordSet -ZoneName $zoneName -ResourceGroupName $zone.ResourceGroupName

    # Iterate through each DNS record
    foreach ($record in $records) {
        $recordObject = [PSCustomObject]@{
            ZoneName         = $zoneName
            RecordName       = $record.Name
            RecordType       = $record.RecordType
            TTL              = $record.TTL
            RecordData       = $record.Records -join ";"
            ResourceGroupName = $zone.ResourceGroupName
        }
        $recordObjects += $recordObject
    }
}

# Export the DNS records to a CSV file
$recordObjects | Export-Csv -Path $outputFile -NoTypeInformation

# Display a confirmation message
Write-Host "DNS zones exported to $outputFile."

# Disconnect from Azure
Disconnect-AzAccount